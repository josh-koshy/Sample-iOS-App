//
//  UserAuthManager.swift
//  Crosp
//
//  Created by Joshua Koshy on 12/31/23.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserAuthManager: ObservableObject {
    @Published var userEmail: String?
    @Published var userUUID: String?
    @Published var userName: String?
    @Published var userCreationTime: Timestamp?
    @Published var birthday: Timestamp?
    
    init() {
        updateCurrentUser()
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.updateCurrentUser()
        }
    }
    
    private func updateCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.userEmail = user.email
            self.userUUID = user.uid
            self.userName = user.displayName
            fetchFirestoreUserData(uid: user.uid)
        } else {
            self.userEmail = nil
            self.userUUID = nil
            self.userName = nil
            self.userCreationTime = nil
            self.birthday = nil
        }
    }
    
    private func fetchFirestoreUserData(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self?.userCreationTime = data?["userCreationTime"] as? Timestamp
                self?.birthday = data?["birthday"] as? Timestamp
                self?.userName = data?["name"] as? String
                // Update other properties as needed
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    var isUserSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
