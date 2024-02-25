//
//  CustomTextFieldView.swift
//  Crosp
//
//  Created by Joshua Koshy on 1/18/24.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import SwiftUI

struct CustomTextFieldView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    @Binding var showPasswordField: Bool
    @ObservedObject var viewModel: LoginViewModel
    var secure: Bool
    var toolbarButtonText: String // Add this line
    
    func makeUIView(context: Context) -> CustomTextField {
        let customTextField = CustomTextField(toolbarButtonText: toolbarButtonText) // Modify this line
        customTextField.becomeFirstResponder()
        customTextField.actionDelegate = context.coordinator
        customTextField.delegate = context.coordinator
        customTextField.placeholder = placeholder
        customTextField.autocorrectionType = .no
        customTextField.inlinePredictionType = .no
        customTextField.autocapitalizationType = .none
        customTextField.returnKeyType = .next
        customTextField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        customTextField.textAlignment = .center
        if self.secure {
            customTextField.isSecureTextEntry = true
            customTextField.keyboardType = .default
        } else {
            customTextField.keyboardType = .emailAddress
        }
        
        customTextField.onSignInTapped = {
            
            // Update the SwiftUI state here
            if (self.toolbarButtonText == "Sign-In") {
                print("Sign-In Attempt Recorded")
                customTextField.resignFirstResponder()
                viewModel.login(noHaptic: false)
            }
            if (self.toolbarButtonText == "Sign-Up") {
                customTextField.resignFirstResponder()
                viewModel.createUser()
            }
            if !self.text.isEmpty {
                DispatchQueue.main.async {
                    withAnimation {
                        context.coordinator.parent.showPasswordField = true
                    }
                }
            }
        }
        return customTextField
    }
    
    func updateUIView(_ uiView: CustomTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextFieldView
        
        init(_ parent: CustomTextFieldView) {
            self.parent = parent
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            DispatchQueue.main.async {
                withAnimation {
                    self.parent.showPasswordField = true // Toggle the visibility of the password field
                    if (self.parent.toolbarButtonText == "Sign-In") {
                        textField.resignFirstResponder()
                        self.parent.viewModel.login()
                    }
                    if (self.parent.toolbarButtonText == "Sign-Up") {
                        textField.resignFirstResponder()
                        self.parent.viewModel.createUser()
                    }
                }
            }
            
            return true
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

