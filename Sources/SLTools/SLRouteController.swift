import Foundation
import Kitura

public protocol SLRouteController: class {
    var router: Router { get }
    init(with main: Router)
}

extension SLRouteController {
    
}
