//
//  ViewController.swift
//  RealmPlayground
//
//  Created by Tony Chen on 11/5/2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //private let realm = try! Realm()
    private let dataManager = DataManager()
    
    private var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My To Do List"
        
        //data = realm.objects(ToDoListItem.self).map({ $0 })
        dataManager.openRealm()
        dataManager.readData()
        dataManager.checkSchema()
        
        notificationPermission()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        UNUserNotificationCenter.current().delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(createToDo))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test",
//                                                           style: .plain,
//                                                            target: self,
//                                                            action: #selector(test))
        print(dataManager.data)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    
    @objc func createToDo() {
        let enterViewController = EnterViewController()
        enterViewController.completionHandler = { [weak self] in
            //self?.refresh()
            self?.dataManager.readData()
            self?.tableView.reloadData()
        }
        
        enterViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(enterViewController, animated: true)
    }
    
//    func refresh() {
//        data = realm.objects(ToDoListItem.self).map({ $0 })
//        tableView.reloadData()
//    }
    
    // MARK: Notification Permission
    func notificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Permission granted")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    
    // MARK: Notification schedule
    func notificationTest(date: Date) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Task Reminder"
                    content.sound = .default
                    content.badge =  NSNumber(value: UIApplication.shared.applicationIconBadgeNumber)
                    let fromDate = date.addingTimeInterval(10)
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate)

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

                    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                        content: content,
                                                        trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if error != nil {
                            print("Error:" + error.debugDescription)
                            return
                        }
                    }
                    
                } else {
                    print("Permission Denied")
                }
            }
        }
    }
    

    
    
//    func scheduleTest(date: Date) {
//        // Create Content
//        let content = UNMutableNotificationContent()
//        content.title = "Hello Hello"
//        content.sound = .default
//        content.body = "Hello message. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque"
//
//        // Trigger
//        //let targetDate = Date().addingTimeInterval(10)
//        let targetDate = date.addingTimeInterval(10)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
//                                                                                                  from: targetDate),
//                                                    repeats: false)
//
//        let request = UNNotificationRequest(identifier: "SomeId", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
//
//    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataManager.data[indexPath.row]
        
        let viewScreen = ViewScreen()
        viewScreen.item = item
        viewScreen.deletionHandler = { [weak self] in
            self?.dataManager.readData()
            self?.tableView.reloadData()
        }
        
        viewScreen.navigationItem.largeTitleDisplayMode = .never
        viewScreen.title = item.item
        
        navigationController?.pushViewController(viewScreen, animated: true)
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let text = dataManager.data[indexPath.row]
        cell.textLabel?.text = text.item
        return cell
    }
    
    
}
