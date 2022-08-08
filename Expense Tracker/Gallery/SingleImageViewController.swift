//
//  SingleImageViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-08-07.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var imageUrl:URL? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(
               title: "Confirmation", message: "Are you sure you want to delete", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { (action: UIAlertAction!) in
            self.imageView.image = nil
            self.clearTempFolder()
        
        }))
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
        
    }
    
    func clearTempFolder() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: imageUrl!)
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = retrieveImage(url: imageUrl!)
    }
    
    func retrieveImage(url:URL) -> UIImage? {
            if let fileData = FileManager.default.contents(atPath: url.path),
                let image = UIImage(data: fileData) {
                var imageToDisplay: UIImage? = nil
                if let anImage = image.cgImage {
                    imageToDisplay = UIImage(cgImage: anImage, scale: image.scale, orientation: .right)}
                return imageToDisplay
            }
        return nil
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
