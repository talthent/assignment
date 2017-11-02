//
//  ChatManager.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import Foundation

protocol ChatManagerDelegate : class {
    func messageAdded(_ message : Message, at indexPath: IndexPath)
}

class ChatManager {
    
    public var chatLog = [Message]()
    
    var lastMessage : Message! {
        get {
            return chatLog.last
        }
    }
    
    private weak var delegate : ChatManagerDelegate!
    private var messages = [
        TextFieldMessage(id: "message1",
                         sender: .bot,
                         input: .text,
                         text: "Hello, what is your name?",
                         followingMessageId: "message2"),
        
        TextFieldMessage(id: "message2",
                         sender: .bot,
                         input: .number,
                         text: "What is your phone number?",
                         followingMessageId: "message3"),
        
        SelectionMessage(id: "message3",
                         sender: .bot,
                         text: "Do you agree to our terms of service?",
            leftButton: MessageButtonData(text: "Yes", followingMessageId: "message4"),
            rightButton: MessageButtonData(text: "No", followingMessageId: "message5")),
        
        
        SelectionMessage(id: "message4",
                         sender: .bot,
                         text: "Thanks! Thats it! Would you like to exit or restart?",
            leftButton: MessageButtonData(text: "Exit", followingMessageId: "message5"),
            rightButton: MessageButtonData(text: "Restart", followingMessageId: "message1")),
        
        Message(id: "message5",
                sender: .bot,
                input: .none,
                text: "Bye bye! 👋")
    ]
    
    init(delegate: ChatManagerDelegate, firstMessageId: String) {
        self.delegate = delegate
        
        self.receiveNextMessage(by: firstMessageId) { [weak self] (message) in
            guard let message = message else { return }
            self?.addMessage(message)
        }
    }
    
    fileprivate func addMessage(_ message: Message) {
        self.chatLog.append(message)
        let lastIndexPath = IndexPath(row: self.chatLog.count - 1, section: 0)
        self.delegate.messageAdded(message, at: lastIndexPath)
    }
    
    //MARK: - PUBLIC FUNCTIONS
    public func receiveNextMessage(by id: String, completion: ((Message?)->())?) {
        guard let messageIndex = self.messages.index (where: { $0.id == id }) else {
            self.fireErrorMessage(text: "Next message not found!")
            completion?(nil)
            return
        }
        let message = self.messages[messageIndex]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion?(message)
        }
    }
    
    public func fireErrorMessage(text: String) {
        let message = Message(id: "error", sender: .bot, input: .none, text: text)
        self.addMessage(message)
    }
    
    public func sendMessage(text: String) {
        guard let lastMessage = self.lastMessage as? TextFieldMessage else {
            self.fireErrorMessage(text: "Error: last message must be a TextFieldMessage")
            return
        }
        let message = Message(id: UUID().uuidString, sender: .me, input: .none, text: text)
        self.addMessage(message)
        
        self.receiveNextMessage(by: lastMessage.followingMessageId) { [weak self] nextMessage in
            guard let nextMessage = nextMessage else { return }
            self?.addMessage(nextMessage)
            
        }

    }
    
    public func selectButton(side: ButtonSide) {
        guard let lastMessage = self.lastMessage as? SelectionMessage else {
            self.fireErrorMessage(text: "Error: last message must be a SelectionMessage")
            return
        }
        let lastMessageButtonData = side == .left ? lastMessage.leftButton : lastMessage.rightButton
        self.addMessage(Message(id: UUID().uuidString,
                                sender: .me,
                                input: .none,
                                text: lastMessageButtonData.text))
        self.receiveNextMessage(by: lastMessageButtonData.followingMessageId) { [weak self] (nextMessage) in
            guard let nextMessage = nextMessage else { return }
            self?.addMessage(nextMessage)
        }
    }
}
