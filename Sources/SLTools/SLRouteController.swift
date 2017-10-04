//
//  SLRouteController.swift
//  SLTools
//
//  Created by Shial on 24/8/17.
//
//

import Foundation
import Kitura

public protocol SLRouteController: class {
    var router: Router { get }
    init(with main: Router)
}

extension SLRouteController {
    
}
