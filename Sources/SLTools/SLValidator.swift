//
//  SLValidator.swift
//  SLTools
//
//  Created by Shial on 24/8/17.
//
//

import Foundation

public enum SLValidationError: Error {
    case notValid
}

public enum SLValidators {
    case AlphaOrNumeric(Int, Int?)
    case AlphaNumeric(Int, Int?)
    case AlphaNumericSpecial(Int, Int?)
    case UpperAlphaLowerAlphaNumeric(Int, Int?)
    case UpperAlphaLowerAlphaNumericSpecial(Int, Int?)
    
    fileprivate func regex() -> String {
        switch self {
        case .AlphaOrNumeric(let min, let max) where min > 2 && max != nil:
            return "^([a-zA-Z0-9]+\\s?){\(min),\(max ?? (min + 2))}$"
        case .AlphaOrNumeric(let min, _) where min > 2:
            return "^([a-zA-Z0-9]+\\s?){\(min),}$"
        case .AlphaOrNumeric(_, _):
            return "^([a-zA-Z0-9]+\\s?){5,}$"
        case .AlphaNumeric(let min, let max) where min > 2 && max != nil:
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),\(max ?? (min + 2))}$"
        case .AlphaNumeric(let min, _) where min > 2:
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),}$"
        case .AlphaNumeric(_, _):
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        case .AlphaNumericSpecial(let min, let max) where min > 3 && max != nil:
            return "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{\(min),\(max ?? (min + 2))}$"
        case .AlphaNumericSpecial(let min, _) where min > 3:
            return "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{\(min),}$"
        case .AlphaNumericSpecial(_, _):
            return "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        case .UpperAlphaLowerAlphaNumeric(let min, let max) where min > 3 && max != nil:
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{\(min),\(max ?? (min + 2))}$"
        case .UpperAlphaLowerAlphaNumeric(let min, _) where min > 3:
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{\(min),}$"
        case .UpperAlphaLowerAlphaNumeric(_, _):
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        case .UpperAlphaLowerAlphaNumericSpecial(let min, let max) where min > 4 && max != nil:
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{\(min),\(max ?? (min + 2))}"
        case .UpperAlphaLowerAlphaNumericSpecial(let min, _) where min > 4:
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{\(min),}"
        case .UpperAlphaLowerAlphaNumericSpecial(_, _):
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        }
    }
}

extension String {
    public func valid(_ validator: SLValidators) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", validator.regex())
        return test.evaluate(with: self)
    }
    
    public func validPassword(_ validator: SLValidators = .UpperAlphaLowerAlphaNumericSpecial(8, 32)) -> Bool {
        return self.valid(validator)
    }
    
    public func validName(_ validator: SLValidators = .AlphaOrNumeric(5, nil)) -> Bool {
        return self.valid(validator)
    }
}
