//
//  UIViewControllerExtension.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 03/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - Keyboard Observation
    func addKeyboardAppearanceObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificationHandler(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotificationHandler(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShowNotificationHandler(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let beginFrame = userInfo["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
        let endFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        let animationDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        self.keyboardWillShow(beginFrame: beginFrame, endFrame: endFrame, animationDuration: animationDuration)
    }
    
    @objc func keyboardWillHideNotificationHandler(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let beginFrame = userInfo["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
        let endFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        let animationDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        self.keyboardWillHide(beginFrame: beginFrame, endFrame: endFrame, animationDuration: animationDuration)
    }
    
    @objc func keyboardWillShow(beginFrame: CGRect, endFrame: CGRect, animationDuration: Double) {
        
    }
    
    @objc func keyboardWillHide(beginFrame: CGRect, endFrame: CGRect, animationDuration: Double) {
        
    }
}
