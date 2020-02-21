//
//  detailsVC.swift
//  ArtBook
//
//  Created by Alpay Genc on 12.07.2018.
//  Copyright © 2018 Liberty App Team. All rights reserved.
//

import UIKit
import CoreData



class detailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate


{

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nametext: UITextField!
    
    @IBOutlet weak var artistText: UITextField!
    
    @IBOutlet weak var yerarText: UITextField!
    
    var chosenPainting = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if chosenPainting != ""{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            fetchReguest.predicate = NSPredicate(format: "name =%@", self.chosenPainting)
            fetchReguest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchReguest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String
                        {
                            nametext.text = name
                        }
                        
                        if let year = result.value(forKey: "year") as? Int
                        {
                            yerarText.text = String(year)
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String
                        {
                            artistText.text = artist
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data
                        {
                            let image = UIImage(data: imageData)
                            self.imageView.image = image
                        }
                    }
                }
            }
           catch {
                  print("Error")
                }
          }
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsVC.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectImage()  {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savebuttonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //attributes
        newArt.setValue(nametext.text, forKey: "name")
        newArt.setValue(artistText.text, forKey: "artist")
        
        if let year = Int(yerarText.text!) {
            newArt.setValue(year, forKey: "year")
        }
        
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        newArt.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("succesful")
        } catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPainting"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
