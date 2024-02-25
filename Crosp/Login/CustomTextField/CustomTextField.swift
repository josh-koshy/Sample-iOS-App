//
//  CustomTextField.swift
//  Crosp
//
//  Created by Joshua Koshy on 1/18/24.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    weak var actionDelegate: UITextFieldDelegate?
    var toolbarButtonText: String
    
    // Convenience initializer
    convenience init(frame: CGRect = .zero, toolbarButtonText: String) {
        self.init(frame: frame) // Call the designated initializer
        self.toolbarButtonText = toolbarButtonText
        self.setupToolbar()
        self.configureTextField()
    }
    
    // Designated initializer
    override init(frame: CGRect) {
        self.toolbarButtonText = "Default" // Provide a default value
        super.init(frame: frame)
        self.setupToolbar()
        self.configureTextField()
    }
    
    required init?(coder: NSCoder) {
        self.toolbarButtonText = "Default" // Provide a default value
        super.init(coder: coder)
        self.setupToolbar()
        self.configureTextField()
    }
    
    private func configureTextField() {
        // Set the font to black weight
        self.font = UIFont.init(name: "Inter-Black", size: 16)
        // Add any other configuration here
    }
    
    let padding = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 10)
    
    // Override these methods to modify the drawing area of the text field
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let signInButton = UIBarButtonItem(title: toolbarButtonText, style: .done, target: self, action: #selector(signInTapped))
        
        // Use 'UIFont.Weight.black' for the black weight
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Inter-Black", size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.inverseWhite
        ]
        
        signInButton.setTitleTextAttributes(attributes, for: .normal)
        toolbar.setItems([flexSpace, signInButton, flexSpace], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    var onSignInTapped: (() -> Void)?
    
    @objc private func signInTapped() {
        // Handle the sign-in action
        onSignInTapped?()
        print("Pressed")
    }
}

