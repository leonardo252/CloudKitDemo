//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Leonardo Gomes on 16/10/20.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    let privateDataBase = CKContainer.init(identifier: "iCloud.DemoContainer.ADA.CloudKit").privateCloudDatabase
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func createButton(_ sender: Any) {
        
        let title = textField.text!
        
        let record = CKRecord(recordType: "CRUD")
        
        record.setValue(title, forKey: "title")
        
        privateDataBase.save(record) {
            (savedRecord, error) in
            
            if error == nil {
                print("Record saved")
            } else {
                print("Record not saved")
                print(error)
            }
        }
    }
    
    @IBAction func readButton(_ sender: Any) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "CRUD", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        
        titles.removeAll()
        recordsID.removeAll()
        
        operation.recordFetchedBlock = { record in
            
            titles.append(record["title"]!)
            recordsID.append(record.recordID)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            
            DispatchQueue.main.async {
                print("Titles: \(titles)")
                print("RecordIDs: \(recordsID)")
            }
        }
        
        privateDataBase.add(operation)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        
        let newTitle = "Anything But The Old TItle"
        
        let recordID = recordsID.first!
        
        privateDataBase.fetch(withRecordID: recordID) { (record, error) in
            
            if error == nil {
                
                record?.setValue(newTitle, forKey: "title")
                
                self.privateDataBase.save(record!, completionHandler: { (newRecord, error) in
                    
                    if error == nil {
                        print("Record Saved")
                    } else {
                        print("Record Not Saved")
                    }
                })
            } else {
                print("Could not fetch record")
            }
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let recordID = recordsID.first!
        
        privateDataBase.delete(withRecordID: recordID, completionHandler: { (deletedRecordID, error) in
            if error == nil {
                print("Record Deleted")
            } else {
                print("Record Not Deleted")
            }
        })
    }
}

