//
//  GalleryViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-08-06.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    struct  ImageData {
        var image: UIImage
        var filePath: URL
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageList:[ImageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateImages()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        print("apear called")
        populateImages()
    
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        print ("unwind called")
        populateImages()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageList.count
        
    }
    
    
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
            cell.configure(with: imageList[indexPath.row].image, imagePath: imageList[indexPath.row].filePath)
            return cell
        }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            var Width: CGFloat = collectionView.frame.width/4
            return CGSize(width: Width, height: Width)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("selected")
        }
    
       func populateImages(){
           imageList = []
           let fileManager = FileManager.default
           guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                   in: FileManager.SearchPathDomainMask.userDomainMask).first else { return }
            do {
               let fileURLs = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
                for filePath in fileURLs{
                    if filePath.absoluteString.range(of: "png") != nil {
                        print("contains png ", filePath)
                        let image = retrieveImage(url:filePath)
                        if (image != nil){
                            let imageData = ImageData(image: image!, filePath: filePath)
                            imageList.append(imageData)
                        }
                     }
                }
                
               } catch {
               print("Error while enumerating files \(documentURL.path): \(error.localizedDescription)")
               }
           
           collectionView.reloadData()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let vc = segue.destination as? SingleImageViewController
        if let collection  = sender as? GalleryCollectionViewCell{
            vc?.imageUrl = collection.imageUrl
            print (collection.imageUrl)
        }

    }
            
}
