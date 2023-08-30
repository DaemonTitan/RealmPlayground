//
//  EnterViewController.swift
//  RealmPlayground
//
//  Created by Tony Chen on 12/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class EnterViewController: UIViewController, UITextFieldDelegate {
    public var completionHandler: (() -> Void)?
    
    var vc = ViewController()
    
    lazy var toDoTitile: UITextField = {
        var toDoTitile = UITextField()
        toDoTitile.layer.cornerRadius = 5.0
        toDoTitile.placeholder = "Enter titile"
        toDoTitile.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toDoTitile.translatesAutoresizingMaskIntoConstraints = false
        return toDoTitile
    }()
    
    lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(toDoTitile)
        view.addSubview(datePicker)
        title = "New To Do"
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        toDoTitile.delegate = self
        toDoTitile.becomeFirstResponder()
        //datePicker.setDate(Date(), animated: true)
        
        NSLayoutConstraint.activate([
            toDoTitile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toDoTitile.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -320),
            toDoTitile.heightAnchor.constraint(equalToConstant: 30),
            toDoTitile.widthAnchor.constraint(equalToConstant: 350),
            
            datePicker.topAnchor.constraint(equalTo: toDoTitile.bottomAnchor, constant: 10),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 600),
            datePicker.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveToDo))
    }
    
    @objc func saveToDo() {
        if let textFeild = toDoTitile.text, !textFeild.isEmpty {
            let date = datePicker.date
            let dataManager = DataManager()
            dataManager.writeData(title: textFeild, date: date)
            print(date)
            
            //vc.scheduleTest(date: date)
            
            vc.notificationTest(date: date)
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
