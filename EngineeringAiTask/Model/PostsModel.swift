//
//  PostsModel.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation

struct PostsModel {
    
    var postTitle:String?
    var postDate:String?
    var postSelected:Bool?
    
    init(pName: String?, pDate: String?, selected: Bool?) {
        self.postTitle = pName
        self.postDate = pDate
        self.postSelected = selected
    }
    init(with postDataDic: [String:Any]?) {
        self.postTitle = postDataDic?["title"] as? String
        self.postDate = postDataDic?["created_at"] as? String
        self.postSelected = postDataDic?["isSelected"] as? Bool
    }
}
