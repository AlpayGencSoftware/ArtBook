//
//  ViewController.swift
//  ArtBook
//
//  Created by Alpay Genc on 12.07.2018.
//  Copyright © 2018 Liberty App Team. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var yearArray = [Int]()
    var artistArray = [String]()
    var imageArray = [UIImage]()
    
    var selectedPainting = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getInfo), name: NSNotification.Name(rawValue: "newPainting"), object: nil)
    }
    
    
  @objc func getInfo()
    {
        
        nameArray.removeAll(keepingCapacity: false)
        artistArray.removeAll(keepingCapacity: false)
        yearArray.removeAll(keepingCapacity: false)
        imageArray.removeAll(keepingCapacity: false)
        
        
        let appDetegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDetegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
             let results =  try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let name =  result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    
                    if let year =  result.value(forKey: "year") as? Int{
                        self.yearArray.append(year)
                    }
                    
                    if let artist = result.value(forKey: "artist") as? String {
                        self.artistArray.append(artist)
                    }
                    if let imageData = result.value(forKey: "image") as? Data {
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    self.tableView.reloadData()
                }
            }
            
        } catch  {
            print("Error")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            let destinationVC = segue.destination as! detailsVC
            destinationVC.chosenPainting = selectedPainting
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPainting = nameArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
         selectedPainting = ""  
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
}

