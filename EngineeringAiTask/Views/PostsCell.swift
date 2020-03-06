//
//  PostsCell.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postCreatedDate: UILabel!
    @IBOutlet weak var postSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupDataFromModel(with model:PostsModel) {
        self.postTitle.text = model.postTitle
        self.postCreatedDate.text = Helper.getReuiredFomat(createdDateStr: model.postDate)
        if let selected = model.postSelected {
            if selected {
                self.postSwitch.isOn = true
                self.backgroundColor = CELL_SELECTION_COLOR
            }else {
                self.postSwitch.isOn = false
                self.backgroundColor = CELL_DEFAULT_COLOR
            }
        }
    }
}
