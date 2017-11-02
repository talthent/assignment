//
//  TextFieldMessage.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import Foundation

class TextFieldMessage : Message {
    
    var followingMessageId: String
    
    init(id: String, sender: Sender, input: Input, text: String, followingMessageId: String) {
        self.followingMessageId = followingMessageId
        super.init(id: id, sender: sender, input: input, text: text)
    }
    
}
