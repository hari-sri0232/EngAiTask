//
//  RefreshControl.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class RefreshControl: UIRefreshControl {

     static let sharedInstance: RefreshControl? = {
           let shared = RefreshControl()
           return shared
       }()
    func addToView(baseView:UIView) {
        baseView.addSubview(self)
    }

}
