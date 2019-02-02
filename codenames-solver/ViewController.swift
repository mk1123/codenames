//
//  ViewController.swift
//  codenames-solver
//
//  Created by Manan Khattar on 1/7/19.
//  Copyright © 2019 Manan Khattar. All rights reserved.
//

import UIKit
import FirebaseMLVision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vision = Vision.vision()
        imagePicked.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBOutlet weak var imagePicked: UIImageView!
    var imagePicker = UIImagePickerController()
    var vision: Vision!
    

    @IBAction func openCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    

    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicked.image = pickedImage
            imagePicker.dismiss(animated: true)
        } else {
            print("oh no")
        }
    }
    
    
    @IBAction func processButtonPressed(_ sender: UIButton) {
        var xCoordDict: [CGFloat:String] = [:]
        var yCoordDict: [CGFloat:String] = [:]
        var wordsDict: [String:CGPoint] = [:]
        var yValues : Array<CGFloat> = []
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: imagePicked.image!)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                // ...
                print(error!)
                return
            }
            
            let resultText = result.text
            for block in result.blocks {
//                let blockText = block.text
//                let blockConfidence = block.confidence
//                let blockLanguages = block.recognizedLanguages
//                let blockCornerPoints = block.cornerPoints
//                let blockFrame = block.frame
                for line in block.lines {
//                    let lineText = line.text
//                    let lineConfidence = line.confidence
//                    let lineLanguages = line.recognizedLanguages
//                    let lineCornerPoints = line.cornerPoints
//                    let lineFrame = line.frame
                    for element in line.elements {
                        let elementText = element.text
                        let elementConfidence = element.confidence
                        let elementLanguages = element.recognizedLanguages
                        let elementCornerPoints = element.cornerPoints
                        let elementFrame = element.frame
                        xCoordDict[elementCornerPoints![0].cgPointValue.x] = elementText
                        yCoordDict[elementCornerPoints![0].cgPointValue.y] = elementText
                        yValues.append(elementCornerPoints![0].cgPointValue.y)
                        wordsDict[elementText] = elementCornerPoints![0].cgPointValue
                        
                    }
                }
            }
//            var xCoords = Array(xCoordDict.keys)
//            var yCoords = Array(yCoordDict.keys)
//
//            xCoords = xCoords.sorted()
//            yCoords = yCoords.sorted()
            
//            var xRows = [Array(xCoords[0...4]), Array(xCoords[5...9]), Array(xCoords[10...14]), Array(xCoords[15...19]), Array(xCoords[20...25])]
//            var yRows: Array<Array<CGFloat>> = []
//
//            for i in 0...9 {
//                let multiplied = 5*i
//                yRows.append(Array(yCoords[multiplied...multiplied+4]))
//            }
            
            
            
            yValues = yValues.sorted()
            var yRows: Array<Array<CGFloat>> = [[yValues[0], yValues[1]]]
            
            for i in 2..<yValues.count {
                if ((yValues[i] - yValues[i-1] ) >= (4.0 * (yValues[i-1] - yValues[i-2]) + 1.0)) {
                    yRows.append([])
                }
                
                yRows[yRows.count-1].append(yValues[i])
            }
            
            print(yRows)
            
            
        }
    }
}
