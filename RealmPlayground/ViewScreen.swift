//
//  File.swift
//  RealmPlayground
//
//  Created by Tony Chen on 12/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class ViewScreen: UIViewController {
    public var item: ToDoListItem?
    
    public var deletionHandler: (() -> Void)?
    
    private let realmFunc = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        //let format = "MMM d, h:mm a"
        let format = "EEEE, MMM d, yyyy, h:mm a"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = format
        return dateFormatter
    }()
    
    static let dateFormatterNew: DateFormatter = {
        //let format = "MMM d, h:mm a"
        let format = "h:mm a"
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = format
        return dateFormatter
    }()
    
    lazy var itemLabel: UILabel = {
        var itemLabel = UILabel()
        itemLabel.font = .systemFont(ofSize: 15, weight: .bold)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemLabel
    }()
    
    lazy var dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 15)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(itemLabel)
        view.addSubview(dateLabel)
        
        guard let toDoItem = item else {
            return
        }
        
        itemLabel.text = "To do name: \(toDoItem.item)"
        
        let date = toDoItem.date
        let dateValue = ViewScreen.dateFormatter.string(from: toDoItem.date)
        let dateValueNew = ViewScreen.dateFormatterNew.string(from: toDoItem.date)
        
        if Calendar.current.isDateInToday(date) {
            print("It is today")
            dateLabel.text = "Today, \(dateValueNew)"
        } else if Calendar.current.isDateInYesterday(date) {
            print("It is Yesterday")
            dateLabel.text = "Yesterday, \(dateValueNew)"
        } else if Calendar.current.isDateInTomorrow(date) {
            print("It is tomorrow")
            dateLabel.text = "Tomorrow, \(dateValueNew)"
        } else {
            dateLabel.text = dateValue
        }

        
        
        
        NSLayoutConstraint.activate([
            itemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -320),
            itemLabel.heightAnchor.constraint(equalToConstant: 30),
            itemLabel.widthAnchor.constraint(equalToConstant: 200),
            
            dateLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.widthAnchor.constraint(equalToConstant: 200)

        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                            target: self,
                                                            action: #selector(deleteItem))
        
    }
    
    @objc func deleteItem() {
        guard let myItem = self.item else {
            return
        }
        
//        realmFunc.beginWrite()
//        realmFunc.delete(myItem)
//        try! realmFunc.commitWrite()
        
        let dataManager = DataManager()
        dataManager.deleteData(item: myItem)
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    
}

extension ViewScreen {
    
    
}
