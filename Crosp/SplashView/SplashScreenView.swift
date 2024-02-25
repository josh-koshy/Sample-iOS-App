//
//  SplashScreenView.swift
//  Crosp
//
//  Created by Joshua Koshy on 1/24/24.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct SplashScreenView: View {
    @State private var isActive = false // Used to control view transition
    @State private var showMainView = false // State to control the view transition
    @State private var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @StateObject private var userAuthManager = UserAuthManager()
    var body: some View {
        ZStack {
            if showMainView {
                
                // Choose the view based on the user's signed-in status
                if userAuthManager.isUserSignedIn {
                    MainView()
                        .transition(.blurReplace)
                } else {
                    LoginView()
                        .transition(.blurReplace)
                }
            } else {
                splashScreenContent
                    .transition(.opacity)
            }
        }
        .onReceive(timer) { _ in
            counter += 1
            if counter == 1 {
                withAnimation {
                    showMainView = true
                }
            }
        }
    }
    
    var splashScreenContent: some View {
        VStack {
            Spacer()
            Image("splashicon", bundle: .none).overlay(alignment: .bottom) {
                ProgressView(value: 1)
                    .progressViewStyle(.circular)
                    .scaleEffect(CGSize(width: 1.6, height: 1.6))
                    .padding(.bottom, 40.0)
            }
            .padding(.bottom, 25.0)
            Spacer()
        }.onAppear(perform: {
            if userAuthManager.isUserSignedIn && userAuthManager.userUUID != nil {
                let db = Firestore.firestore()
                db.collection("users").document(userAuthManager.userUUID!).setData(["FCMToken": firebasetoken.token], merge: true) { error in
                    if let error = error {
                        print("Error updating FCM token: \(error)")
                    } else {
                        print("FCM token updated successfully on App Launch!")
                    }
                }
            }
        })
    }
    
}

#Preview {
    SplashScreenView()
}
