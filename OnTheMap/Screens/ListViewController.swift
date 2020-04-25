//
//  ListViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/22/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ListViewController: DataLoadingViewController {
    
    var students: [StudentInformation] = []
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentTableView.removeExcessCells()
        
        getStudents()
    }
        
    @IBAction func reloadTapped(_ sender: Any) {
        print("reload button tapped to load students data")
        reloadStudents()
    }
    
    func reloadStudents() {
        // remove from local 
        self.students.removeAll()
        self.studentTableView.reloadData()
        
        // remove from NetworkManager cache
        NetworkManager.shared.studentArray.removeAll()

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
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: "No student data", message: message, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    
                } else {
                    self.students.append(contentsOf: students)
                    DispatchQueue.main.async {
                        self.studentTableView.isHidden = false
                        self.studentTableView.reloadData()
                        self.view.bringSubviewToFront(self.studentTableView)
                    }
                }
                                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "No student data", message: error.rawValue, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                }
            
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
//        cell.textLabel?.text = student.firstName + " " + student.lastName
//        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = self.students[indexPath.row]
        
        guard let url = URL(string: student.mediaURL), (url.scheme != nil) else {
            print("media url is not valid \(student.mediaURL)")
            
            let message = "Student \(student.firstName) \(student.lastName) has invalid media url."
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: "Invalid URL", message: message, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
            
            return
        }
                
        // show media url using Safari VC
        presentSafariVC(with: url)
    }
}
