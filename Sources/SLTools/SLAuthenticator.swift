import Kitura
import KituraNet

public typealias Token = String

public enum SLAuthenticationError: Swift.Error {
    case credentialExist
}

public struct Credentials {
    public var login: String
    public var password: String
    
    public init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}

public protocol SLAuthentication {
    static func authorise(_ token: Token) throws -> Self?
    static func register(_ credentials: Credentials) throws -> Self?
    static func authenticate(_ credentials: Credentials) throws -> Self?
}

public class SLAuthenticator<T: SLAuthentication>: RouterMiddleware {
    public init() {}
    
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let auth = request.headers["Authorization"]?.components(separatedBy: " "),
            auth.count == 2, let type = auth.first else {
                try response.status(HTTPStatusCode.unauthorized).send(json: ["error":"unauthorized"]).end()
                return
        }
        switch type {
        case "Basic":
            guard let token = auth.last, let client = try T.authorise(token) else {
                try response.status(HTTPStatusCode.unauthorized).send(json: ["error":"unauthorized"]).end()
                return
            }
            request.userInfo["SLAuthenticationTokenKey"] = token
            request.userInfo["SLAuthenticationClientKey"] = client
            next()
        default:
            try response.status(HTTPStatusCode.unauthorized).send(json: ["error":"unauthorized"]).end()
        }
    }
}

extension RouterRequest {
    public func token() -> String? {
        return userInfo["SLAuthenticationTokenKey"] as? String
    }
    public func client<T:SLAuthentication>() -> T? {
        return userInfo["SLAuthenticationClientKey"] as? T
    }
}
