//
//  Validator.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import Foundation

class Validator {
    
    static func validateText(_ text: String) -> Bool {
        if text.isEmpty {
            return false
        }
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        let textContainOnlyLetters = text.trimmingCharacters(in: set).isEmpty
        return textContainOnlyLetters
    }
    
    static func validateNumber(_ text: String) -> Bool {
        if text.isEmpty {
            return false
        }
        let textContainOnlyDigits = text.trimmingCharacters(in: .decimalDigits).isEmpty
        return textContainOnlyDigits
    }
    
}
