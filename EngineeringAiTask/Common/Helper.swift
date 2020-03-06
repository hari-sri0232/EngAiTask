//
//  Helper.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    // Disaply Alerts
    class func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Okaction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alertController.addAction(Okaction)
        UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
    }
    // Get required date format 
    class func getReuiredFomat(createdDateStr: String?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        var reqFomatStr:String? = nil
        if let date = formatter.date(from: createdDateStr ?? "") {
            formatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
            reqFomatStr = formatter.string(from: date)
        }
        return reqFomatStr ?? ""
    }
}
