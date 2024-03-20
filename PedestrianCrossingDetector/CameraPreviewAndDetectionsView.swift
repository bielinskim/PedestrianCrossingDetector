//
//  CameraAndDetectionsView.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 20/03/2024.
//

import SwiftUI
import AVFoundation
import Vision

struct CameraPreviewAndDetectionsView: View {
    
    var body: some View {
        CameraPreviewControllerWrapper()
    }
}

struct CameraPreviewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraPreview {
        return CameraPreview()
    }
    
    func updateUIViewController(_ uiViewController: CameraPreview, context: Context) {
        
    }
}

class CameraPreview: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var previewView = UIImageView(frame: UIScreen.main.bounds)
    
    var captureSession = AVCaptureSession()
    
    var yoloRequest: VNRequest?
    
    var classes:[String] = []
    let color = UIColor(red: 0.30, green: 0.96, blue: 0.08, alpha: 1.0)
    let ciContext = CIContext()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(previewView)
        
        setupModel()
        
        setupVideoCapture()
        
    }
    
    func setupModel() {
        do {
            
            let model = try yolov8s().model
            classes = model.modelDescription.classLabels as! [String]
            let vnModel = try VNCoreMLModel(for: model)
            yoloRequest = VNCoreMLRequest(model: vnModel)
            
        } catch let error {
            fatalError("mlmodel error.")
        }
    }
    
    func setupVideoCapture() {
        captureSession.beginConfiguration()
        
        let device = AVCaptureDevice.default(for: .video)
        let deviceInput = try! AVCaptureDeviceInput(device: device!)
        captureSession.addInput(deviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "handlerQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        
        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let drawImage = detection(sampleBuffer: sampleBuffer)
        
        DispatchQueue.main.async {
            self.previewView.image = drawImage
        }
    }
    
    
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        
        let cgContext = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 4 * Int(size.width),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        for detection in detections {
            let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
            
            cgContext.textMatrix = .identity
            
            let text = "\(round(detection.confidence*100))"
            
            let textRect  = CGRect(x: invertedBox.minX + size.width * 0.01, y: invertedBox.minY - size.width * 0.01, width: invertedBox.width, height: invertedBox.height)
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
            let textFontAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: textRect.width * 0.1, weight: .bold),
                NSAttributedString.Key.foregroundColor: detection.color,
                NSAttributedString.Key.paragraphStyle: textStyle
            ]
            
            cgContext.saveGState()
            defer { cgContext.restoreGState() }
            
            let astr = NSAttributedString(string: text, attributes: textFontAttributes)
            let setter = CTFramesetterCreateWithAttributedString(astr)
            let path = CGPath(rect: textRect, transform: nil)
            
            let frame = CTFramesetterCreateFrame(setter, CFRange(), path, nil)
            cgContext.textMatrix = CGAffineTransform.identity
            CTFrameDraw(frame, cgContext)
            
            cgContext.setStrokeColor(detection.color.cgColor)
            cgContext.setLineWidth(9)
            cgContext.stroke(invertedBox)
            
        }
        
        let newImage = cgContext.makeImage()!
        
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }
    
    func detection(sampleBuffer: CMSampleBuffer) -> UIImage? {
        do {
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([yoloRequest!])
            
            let results = yoloRequest!.results as! [VNRecognizedObjectObservation]
            
            var detections:[Detection] = []
            for result in results {
                let flippedBox = CGRect(x: result.boundingBox.minX, y: 1 - result.boundingBox.maxY, width: result.boundingBox.width, height: result.boundingBox.height)
                let box = VNImageRectForNormalizedRect(flippedBox, Int(sampleBuffer.formatDescription!.dimensions.width), Int(sampleBuffer.formatDescription!.dimensions.height))
                
                let label = result.labels.first?.identifier
                let detection = Detection(box: box, confidence: result.confidence, label: label, color: color)
                detections.append(detection)
            }
            let drawImage = drawRectsOnImage(detections, pixelBuffer)
            
            return drawImage
        } catch let error {
            return nil
            print(error)
        }
    }
    
}

struct Detection {
    let box:CGRect
    let confidence:Float
    let label:String?
    let color:UIColor
}
