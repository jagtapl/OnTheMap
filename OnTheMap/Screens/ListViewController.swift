//
//  ListViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/22/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ListViewController: DataLoadingViewController {
    
    var students: [StudentInformation] {
        return NetworkManager.shared.studentArray
    }
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentTableView.removeExcessCells()
        
        getStudents()
    }
        
    @IBAction func reloadTapped(_ sender: Any) {
        reloadStudents()
    }
    
    func reloadStudents() {
        // remove from NetworkManager cache
        NetworkManager.shared.studentArray.removeAll()

        // remove from local 
        self.studentTableView.reloadData()
        
        getStudents()
    }
    
    func getStudents() {
        showLoadingView()
        
        NetworkManager.shared.getLatestStudents() { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch (result) {
            case .success(let students):
                
                if students.isEmpty {
                    self.studentTableView.isHidden = true
                    let message = "No student locations data found. Something is wrong."
                    self.presentAlertOnMainThread(title: "No student data", message: message)
        
                } else {
                    DispatchQueue.main.async {
                        self.studentTableView.isHidden = false
                        self.studentTableView.reloadData()
                        self.view.bringSubviewToFront(self.studentTableView)
                    }
                }
                                
            case .failure(let error):
                
                self.presentAlertOnMainThread(title: "No student data", message: error.rawValue)
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.studentTableView.dequeueReusableCell(withIdentifier: "studentTableCell", for: indexPath) as! ListTableViewCell
        
        let student = self.students[indexPath.row]
        cell.config(student)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = self.students[indexPath.row]
        
        guard let url = URL(string: student.mediaURL), (url.scheme != nil) else {
            let message = "Student \(student.firstName) \(student.lastName) has invalid media url."
            self.presentAlertOnMainThread(title: "Invalid URL", message: message)
            return
        }
             
        // show media url using Safari VC
        presentSafariVC(with: url)
    }
}
