//
//  LoginViewModel.swift
//  Crosp
//
//  Created by Joshua Koshy on 12/29/23.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//
import SwiftUI
import Firebase
import AuthenticationServices

class LoginViewModel: ObservableObject {
    @Published var name = ""
    @Published var username = ""
    @Published var password = ""
    @Published var isSigningIn = false
    @Published var authStatus = false
    @Published var authFailed = false
    @Published var ageOkay = true
    @Published var birthDate = Date(timeIntervalSince1970: Date.now.timeIntervalSince1970 - 410227200)
    @Published var showMainView = false
    @Published var showPasswordField = false
    @Published var loginMode = true
    
    
    func login(noHaptic: Bool = false) {
        DispatchQueue.main.async {
            self.isSigningIn = true
        }
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] (result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    HapticManagement().errorHaptic()
                    print(error.localizedDescription)
                    self?.isSigningIn = false
                    self?.authFailed = true
                } else if let result = result {
                    // ... handle successful login ...
                    print("success")
                    if !noHaptic {
                        HapticManagement().heavyHaptic()
                    }
                    self?.authStatus = true
                    self?.authFailed = false
                    self?.isSigningIn = false
                    
                    // Update FCM token in Firestore for the signed-in user
                    let db = Firestore.firestore()
                    db.collection("users").document(result.user.uid).setData(["FCMToken": firebasetoken.token], merge: true) { error in
                        if let error = error {
                            print("Error updating FCM token: \(error)")
                        } else {
                            print("FCM token updated successfully")
                        }
                    }
                }

            }
        }
    }
    
    func signOut() {
        DispatchQueue.main.async {
            self.isSigningIn = true
        }
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isSigningIn = false
                self.authStatus = false
                self.username = ""
                self.password = ""
                HapticManagement().heavyHaptic()
            }
        } catch let signOutError as NSError {
            DispatchQueue.main.async {
                HapticManagement().errorHaptic()
                self.isSigningIn = false
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
    func resetViewState() {
        self.name = ""
        self.username = ""
        self.password = ""
        self.isSigningIn = false
        self.authStatus = false
        self.authFailed = false
        self.ageOkay = true
        self.birthDate = Date.now
    }
    
    func createUser() { // Assuming you have the user's name as 'userName'
        if !(Date.now.timeIntervalSince1970 - self.birthDate.timeIntervalSince1970 > 410227200) {
            self.authFailed = true
            self.ageOkay = false
            self.isSigningIn = false
            return
        }
        print(Date.now.timeIntervalSince1970 - self.birthDate.timeIntervalSince1970 > 410227200 ? "over 18" : "under 18")
        Auth.auth().createUser(withEmail: username, password: password) { [weak self] (result, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    HapticManagement().errorHaptic()
                    print(error.localizedDescription)
                    self.authFailed = true
                    self.isSigningIn = false
                } else if let result = result {
                    let userData = [
                        "uid": result.user.uid,
                        "name": self.name,
                        "username": self.username,
                        "userCreationTime": Timestamp(date: Date.now),
                        "birthday": Timestamp(date: self.birthDate),
                        "FCMToken": firebasetoken.token
                    ]
                    let db = Firestore.firestore()
                    db.collection("users").document(result.user.uid).setData(userData) { error in
                        if let error = error {
                            // Handle the error of data setting
                            print("Error writing document: \(error)")
                        } else {
                            // Data was successfully written
                            self.login(noHaptic: true)
                            HapticManagement().heavyHaptic()
                        }
                    }
                }
            }
        }
    }
    
    
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        
        self.isSigningIn = true
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data")
                    return
                }
                
                // Create a Firebase credential
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nil) // Use nonce if you have one
                
                // Sign in with Firebase
                Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.isSigningIn = false
                    }
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    // Check if it's a new user
                    if let result = result, result.additionalUserInfo?.isNewUser == true {
                        let userData = [
                            "uid": result.user.uid,
                            "name": appleIDCredential.fullName?.givenName ?? "", // Adjust according to your needs
                            "username": appleIDCredential.email ?? "", // Adjust according to your needs
                            "userCreationTime": Timestamp(date: Date.now),
                            "birthday": Timestamp(date: self.birthDate),
                            "FCMToken": firebasetoken.token
                        ]
                        let db = Firestore.firestore()
                        db.collection("users").document(result.user.uid).setData(userData) { error in
                            if let error = error {
                                print("Error writing document: \(error)")
                            } else {
                                // Data was successfully written
                                // Proceed with the app flow after successful sign-in and user data update
                                HapticManagement().heavyHaptic()
                            }
                        }
                    } else if let result = result {
                        let db = Firestore.firestore()
                        db.collection("users").document(result.user.uid).setData(["FCMToken": firebasetoken.token], merge: true) { error in
                            if let error = error {
                                print("Error writing document: \(error)")
                            } else {
                                // Data was successfully written
                                // Proceed with the app flow after successful sign-in and user data update
                                HapticManagement().heavyHaptic()
                            }
                        }
                        
                        // Existing user, proceed with the app flow
                        HapticManagement().heavyHaptic()
                    }
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.isSigningIn = false
            }
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
}
