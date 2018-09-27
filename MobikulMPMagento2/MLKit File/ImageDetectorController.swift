//
//  ImageDetectorController.swift
//  Alnazi
//
//  Created by Webkul on 25/05/18.
//  Copyright © 2018 himanshu. All rights reserved.
//

import UIKit
import UIKit
import AVFoundation
import Firebase

class ImageDetectorController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate ,UITableViewDelegate, UITableViewDataSource{

@IBOutlet var captureView: UIImageView!
let captureSession = AVCaptureSession()
var previewLayer: CALayer!

var captureDevice: AVCaptureDevice!
var shouldTakePhoto = false

    @IBOutlet weak var flashLightBtn: UIButton!
    var textDetector: VisionLabelDetector!
var frameCount = 0
lazy var vision = Vision.vision()
static let labelConfidenceThreshold: Float = 0.75
var delegate: SuggestionDataHandlerDelegate!
@IBOutlet var tableView: UITableView!
var textString  = [VisionLabel]()
var totalTextString  = [String]()
var flag = Bool()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.separatorColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.tableView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let options = VisionLabelDetectorOptions(
            confidenceThreshold: ImageDetectorController.labelConfidenceThreshold
        )
        textDetector = vision.labelDetector(options: options)
        self.tableView.alpha = 0
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
         prepareCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.toggleTorch(on: false)
         captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
//         captureSession.re
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        prepareCamera()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        if #available(iOS 10.0, *) {
            captureDevice = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: AVMediaType.video, position:
                AVCaptureDevice.Position.back
                ).devices.first
        } else {
            // Fallback on earlier versions
        }
        beginSession()
    }
    
    @IBAction func stopCapturing(_ sender: Any) {
    }
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
 
        previewLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: SCREEN_WIDTH, height: CGFloat(SCREEN_HEIGHT))
        previewLayer.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: SCREEN_WIDTH, height: CGFloat(SCREEN_HEIGHT))
        self.view.bringSubview(toFront: self.tableView)
        self.view.bringSubview(toFront: self.flashLightBtn)
        
        captureSession.startRunning()
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [
            ((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    // Process frames only at a specific duration. This skips redundant frames and
    // avoids memory issues.
    func proccess(every: Int, callback: () -> Void) {
        frameCount = frameCount + 1
        // Process every nth frame
        if(frameCount % every == 0) {
            callback()
        }
    }
    
    // Combine all VisionText into one String
    private func flattenVisionText(visionText: [VisionLabel]?) -> String {
        var text = ""
        visionText?.forEach(){ vText in
            text += " " + vText.label
        }
        textString = visionText!
        
        if let vision = visionText{
            for i in 0..<vision.count{
                if totalTextString.contains(vision[i].label) == false && totalTextString.count<=9{
                    print(totalTextString)
                    totalTextString.append(vision[i].label.trimmingCharacters(in: .whitespacesAndNewlines))
                    self.tableView.alpha = 1
                    self.tableView.reloadData()
                }
            }
        }

        return text
    }
    
    // Detect text in a CMSampleBuffer by converting to a UIImage to determine orientation
    func detectText(in buffer: CMSampleBuffer, completion: @escaping (_ text: String, _ image: UIImage) -> Void) {
        if let image = buffer.toUIImage() {
            let viImage = image.toVisionImage()
            textDetector.detect(in: viImage) { (visionText, error) in
                completion(self.flattenVisionText(visionText: visionText), image)
            }
        }
    }
    
    
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Detect text every 10 frames
        proccess(every: 10) {
            self.detectText(in: sampleBuffer) { text, image in
                
                
                print("sss",text)
                
            }
        }
        
        
        
    }
    
    
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    @IBAction func flashLightAction(_ sender: Any) {
        flag = !flag
        self.flashLightBtn.isSelected = !self.flashLightBtn.isSelected
        self.toggleTorch(on: flag)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalTextString.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LabelCell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! LabelCell
        cell.name.text = totalTextString[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.suggestedData(data: totalTextString[indexPath.row], signalToMove: 2)
        self.navigationController?.popViewController(animated: true)
    }
    

}








extension CMSampleBuffer {
    
    // Converts a CMSampleBuffer to a UIImage
    //
    // Return: UIImage from CMSampleBuffer
    func toUIImage() -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(self) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
            
        }
        return nil
    }
    
}
