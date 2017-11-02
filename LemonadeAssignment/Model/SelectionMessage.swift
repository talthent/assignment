//
//  SelectionMessage.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import Foundation

enum ButtonSide {
    case left
    case right
}

class SelectionMessage : Message {
    
    let rightButton : MessageButtonData
    let leftButton : MessageButtonData
    
    init(id: String, sender: Sender, text: String, leftButton: MessageButtonData, rightButton: MessageButtonData) {
        self.leftButton = leftButton
        self.rightButton = rightButton
        super.init(id: id, sender: sender, input: .selection, text: text)
    }
}

struct MessageButtonData {
    var text : String
    var followingMessageId : String
}
