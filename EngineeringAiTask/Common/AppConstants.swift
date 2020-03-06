//
//  AppConstants.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit

let POST_CELL_IDENTIFIER = "PostsCell"
let CELL_DEFAULT_COLOR = UIColor.white
let CELL_SELECTION_COLOR = UIColor.darkGray.withAlphaComponent(0.3)

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
public enum StatusMessage {
    case success
    case failure
    case error
}
public enum IndicatorPosition {
    case top
    case center
    case bottom
}
