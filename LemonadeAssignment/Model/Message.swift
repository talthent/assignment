//
//  Message.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import Foundation

class Message {
    
    enum Sender {
        case bot
        case me
    }
    
    enum Input {
        case none
        case number
        case text
        case selection
    }
    
    var id: String
    var sender: Sender
    var input : Input
    var text : String
    
    init(id: String, sender: Sender, input: Input, text: String) {
        self.id = id
        self.sender = sender
        self.input = input
        self.text = text
    }
}
