//
//  CameraViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-08-06.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate {


    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBAction func captureBtnPressed(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        cameraView.image = image
        takePictureButton.setTitle("Retake Picture", for: .normal)
        store(image:image, forKey: NSUUID().uuidString)
        
    }
    

    func saveAsync(image: UIImage, forKey key: String) {
        DispatchQueue.global(qos: .background).async {
                    self.store(image: image,
                                forKey: key)
        }
    }


    func store(image: UIImage,
                        forKey key: String) {
        if let pngRepresentation = image.pngData() {
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                        print("Write to path ", filePath)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
        }
    }
    
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

