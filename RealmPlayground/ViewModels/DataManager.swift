//
//  DataManager.swift
//  RealmPlayground
//
//  Created by Tony Chen on 15/5/2023.
//

import Foundation
import RealmSwift

class DataManager {
    
    //var data = [ToDoListItem]()
    var data: [ToDoListItem] = []
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            _ = try Realm()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkSchema() {
        let configCheck = Realm.Configuration();
        do {
             let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
            print("schema version \(fileUrlIs)")
        } catch  {
            print(error)
        }
    }
    
    // MARK: Fetch data from Realm
    func readData() {
        do {
            let realm = try Realm()
            let results = realm.objects(ToDoListItem.self).map({ $0 })
            data = results.sorted(by: { $0.item > $1.item } )

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Save data to Realm
    func writeData(title: String, date: Date) {
        let taskObject = ToDoListItem(value: [
            "item": title,
            "date": date
        ])
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(taskObject)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Delete data on Realm
    func deleteData(item: Object) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(item)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Modify and save data on Realm
//    func updateData() {
//        do {
//            let realm = try Realm()
//
//
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
}
