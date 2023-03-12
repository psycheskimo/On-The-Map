//
//  ListViewController.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import Foundation
import UIKit

class ListViewController : UIViewController {
    
    
    @IBOutlet weak var tableView : UITableView!
    
    
    
    var students : [StudentInformation] = []
    
    
    override func viewDidLoad() {
        
        OTMClient.getStudentLocation(completion: handleGetStudentLocation(students:error:))

        self.tabBarController?.tabBar.barTintColor = .black
        
        
    }
    
    func handleGetStudentLocation(students: [StudentInformation], error: Error?) {
        
        self.students = students
        self.tableView.reloadData()
  
    }
    
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let name = students[indexPath.row]
        
        cell.textLabel?.text = "\(name.firstName) \(name.lastName)"
        cell.detailTextLabel?.text = name.mapString ?? ""

        return cell
    }
    
}
