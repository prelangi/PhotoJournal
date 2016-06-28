//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Prasanthi Relangi on 6/26/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var names = ["Prasanthi","John","Douglas"]
    
    var entries = [PhotoNotes]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return (UIApplication.shared().delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchNewData()
        
        NotificationCenter.default().addObserver(self, selector: #selector(ViewController.coreDataChanged(_ :)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    func coreDataChanged(_ note: Notification) {
        // Note This is not the ideal way to perform this action.
        // should be examining the notification to find out what changed. Where
        // items inserted, or deleted, or changed in some other way.
        // we should be able to then perform more targeted changes on our table view
        // (Any time you are just calling `tableView.reloadData()` you are probably doing it wrong
        fetchNewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNewData() {
        let fetchRequest:NSFetchRequest<PhotoNotes>  = PhotoNotes.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        if let results = try? managedObjectContext.fetch(fetchRequest) {
                entries = results
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        cell.textLabel?.text = entries[indexPath.row].timestamp?.description ?? "new"
        cell.imageView?.image = entries[indexPath.row].image
        return cell
        
    }

    @IBAction func addItem(_ sender: AnyObject) {
        //Open the camera or the photoroll
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let entry = NSEntityDescription.insertNewObject(forEntityName:"PhotoNotes", into: managedObjectContext) as! PhotoNotes
            entry.image = image
            entry.timestamp = Date()
            _ = try? managedObjectContext.save()
        }
        self.dismiss(animated: true, completion: nil)
    }

}

