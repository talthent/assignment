//
//  ChatViewController.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    var chatManager : ChatManager!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomSpacing: NSLayoutConstraint!
    
    weak var inputControl: UIView?
    weak var inputControlBottomSpacing: NSLayoutConstraint?
    
    init() {
        super.init(nibName: "ChatViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardAppearanceObservers()
        self.setupTableView()
        
        self.chatManager = ChatManager(delegate: self, firstMessageId: "message1")
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "MyMessageTableViewCell", bundle: nil),
                                forCellReuseIdentifier: MyMessageTableViewCell.identifier)
        self.tableView.register(UINib(nibName: "BotMessageTableViewCell", bundle: nil),
                                forCellReuseIdentifier: BotMessageTableViewCell.identifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    public func presentInputControl(_ input: Message.Input, message: Message) {
        switch input {
        case .none:
            break
        case .number, .text:
            self.presentTextFieldInputControl(message: message as! TextFieldMessage)
        case .selection:
            self.presentSelectionInputControl(message: message as! SelectionMessage)
        }
    }
    
    fileprivate func presentTextFieldInputControl(message: TextFieldMessage) {
        guard let control = Bundle.main.loadNibNamed("TextFieldInputControl", owner: self, options: nil)?.first as? TextFieldInputControl else { return }
        control.configureControl(delegate: self, message: message)
        self.addInputControl(control)
    }
    
    fileprivate func presentSelectionInputControl(message: SelectionMessage) {
        guard let control = Bundle.main.loadNibNamed("SelectionInputControl", owner: self, options: nil)?.first as? SelectionInputControl else { return }
        control.configureControl(delegate: self,
                                 leftButton: message.leftButton, rightButton: message.rightButton)
        self.addInputControl(control)
    }
    
    fileprivate func addInputControl(_ inputControl: UIView) {
        inputControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(inputControl)
        self.inputControl = inputControl
        self.inputControlBottomSpacing = inputControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([
            self.inputControlBottomSpacing!,
            inputControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            inputControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            inputControl.heightAnchor.constraint(equalToConstant: 60)
            ])
        inputControl.transform = CGAffineTransform(translationX: 0, y: 60)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            inputControl.transform = .identity
        }
        
    }
    
    fileprivate func removeInputControl(completion: (()->())?) {
        guard let inputControl = self.inputControl else { return }
        self.inputControl = nil
        self.inputControlBottomSpacing = nil
        UIView.animate(withDuration: 0.3, animations: {
            inputControl.transform = CGAffineTransform(translationX: 0, y: 60)
        }) { _ in
            inputControl.removeFromSuperview()
            completion?()
        }
    }
    
    override func keyboardWillShow(beginFrame: CGRect, endFrame: CGRect, animationDuration: Double) {
        self.inputControlBottomSpacing?.constant = -endFrame.height
        self.tableViewBottomSpacing.constant = -endFrame.height - (self.inputControl?.frame.height ?? 0)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillHide(beginFrame: CGRect, endFrame: CGRect, animationDuration: Double) {
        self.inputControlBottomSpacing?.constant = 0
        self.tableViewBottomSpacing.constant = 0
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatManager?.chatLog.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatManager.chatLog[indexPath.row]
        var cell : UITableViewCell
        switch message.sender {
        case .me:
            let myCell = tableView.dequeueReusableCell(withIdentifier: MyMessageTableViewCell.identifier, for: indexPath) as! MyMessageTableViewCell
            myCell.configureCell(text: message.text)
            cell = myCell
        case .bot:
            let botCell = tableView.dequeueReusableCell(withIdentifier: BotMessageTableViewCell.identifier, for: indexPath) as! BotMessageTableViewCell
            botCell.configureCell(text: message.text)
            cell = botCell
        }
        return cell
    }
    
}

extension ChatViewController : ChatManagerDelegate {
    func messageAdded(_ message: Message, at indexPath: IndexPath) {
        print("Message added -> \(message.id): \(message.text)")
        let animation : UITableViewRowAnimation = message.sender == .me ? .right : .left
        self.tableView.insertRows(at: [indexPath], with: animation)
        self.presentInputControl(message.input, message: message)
    }
}

extension ChatViewController : TextFieldInputControlDelegate {
    func sendButtonTapped(text: String) {
        self.removeInputControl(completion: nil)
        self.chatManager.sendMessage(text: text)
    }
}

extension ChatViewController : SelectionInputControlDelegate {
    func leftButtonTapped() {
        self.removeInputControl(completion: nil)
        self.chatManager.selectButton(side: .left)
    }
    
    func rightButtonTapped() {
        self.removeInputControl(completion: nil)
        self.chatManager.selectButton(side: .right)
    }
}
