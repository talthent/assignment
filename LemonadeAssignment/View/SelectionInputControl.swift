//
//  SelectionInputControl.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import UIKit

protocol SelectionInputControlDelegate : class {
    func leftButtonTapped()
    func rightButtonTapped()
}

class SelectionInputControl: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    weak var delegate: SelectionInputControlDelegate?
    
    public func configureControl(delegate: SelectionInputControlDelegate, leftButton: MessageButtonData, rightButton: MessageButtonData) {
        self.delegate = delegate
        self.leftButton.setTitle(leftButton.text, for: .normal)
        self.rightButton.setTitle(rightButton.text, for: .normal)
    }
    
    @IBAction func leftButtonTapped() {
        self.delegate?.leftButtonTapped()
    }
    
    @IBAction func rightButtonTapped() {
        self.delegate?.rightButtonTapped()
    }
}
