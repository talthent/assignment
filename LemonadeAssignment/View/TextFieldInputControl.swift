//
//  TextFieldInputControl.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import UIKit

protocol TextFieldInputControlDelegate : class {
    func sendButtonTapped(text: String)
}

class TextFieldInputControl: UIView, UITextFieldDelegate {

    weak var delegate : TextFieldInputControlDelegate?
    var message : TextFieldMessage!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        self.send()
    }
    
    public func configureControl(delegate: TextFieldInputControlDelegate, message: TextFieldMessage) {
        self.delegate = delegate
        self.message = message
    }
    
    private func send() {
        let text = self.textField.text ?? ""
        if message.input == .number {
            guard Validator.validateNumber(text) else {
                return
            }
        }
        
        if message.input == .text {
            guard Validator.validateText(text) else {
                return
            }
        }
        
        self.delegate?.sendButtonTapped(text: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.send()
        return true
    }
    
}
