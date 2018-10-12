//
//  ViewController.swift
//  MLModule
//
//  Created by Eslam Moemen on 10/12/18.
//  Copyright © 2018 Eslam Moemen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageOutlet: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageOutlet.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("not converted")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    func detect (image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("MLModel error")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("third error")
            }
            //print(results)
            if let  firstResult = results.first{
                
                if firstResult.identifier.contains("cellphone"){
                    self.navigationItem.title = "it's a Phone !"
                }else{
                    self.navigationItem.title = "not a phone"
                }
            }
            
            
        }
        
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
        try handler.perform([request])
        }catch{
            print(error)
            
        }
        
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

