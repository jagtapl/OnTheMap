//
//  ListTableViewCell.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/23/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentMediaUrlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ student: StudentInformation) {
        studentNameLabel.text = student.firstName + " " + student.lastName
        studentMediaUrlLabel.text = student.mediaURL
    }
    

}
