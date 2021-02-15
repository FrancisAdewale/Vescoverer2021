//
//  VeScanViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 13/02/2021.
//

import UIKit
import CoreML
import Vision
import Social


class VeScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pickedImage: CIImage?
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var verdict: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ve-Scan"
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let userPickedImage = info[.originalImage] as? UIImage {

            imageView.image = UIImage(image: userPickedImage, scaledTo: CGSize())
            createClassification(for: userPickedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: VeganImageClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: {   [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }}()
    
    func createClassification(for image: UIImage) {
        
        do {
            let model = try VNCoreMLModel(for: VeganImageClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        verdict.text = "Ve-Scanning...."
        
        let ciImage = CIImage(image: image)
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage!, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results
            else {
                self.verdict.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.verdict.text = "Nothing recognized."
            } else {
                let topClassifications = classifications
                let descriptions = topClassifications.map { classification in
                    return String(format: "%.0f %@", classification.confidence, classification.identifier)
                }
                
                let firstVerdict = descriptions.first
                let splitVerdict = firstVerdict?.split(separator: " ")
                
                if splitVerdict![0] != "1"{
                    self.verdict.text = "Not sure"
                } else {
                    self.verdict.text = "Vegan"
                }
                
                if splitVerdict![1] == "N/A" && splitVerdict![0] == "1" {
                    self.verdict.text = "Nope"
                }

            }
        }
    }

    @IBAction func cameraTapped(_ sender: Any) {
        
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
}
