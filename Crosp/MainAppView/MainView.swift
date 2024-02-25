//
//  MainView.swift
//  Crosp
//
//  Created by Joshua Koshy on 12/31/23.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import SwiftUI
import Firebase


struct MainView: View {
    @StateObject private var userAuthManager = UserAuthManager()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var viewModel = MainViewModel()
    
    
    var body: some View {
        
        NavigationView {
            // Outer VStack for overall alignment
            VStack {
                if (userAuthManager.userName != nil && userAuthManager.birthday != nil && userAuthManager.userUUID != nil) {
                    
                    Text("Welcome, \(userAuthManager.userName ?? "")")
                        .font(Font.custom("Inter-Black", size: 16.0))
                        .multilineTextAlignment(.leading)
                    
                    VStack {
                        
                        
                        // Spacer at the top to push content to the middle
                        Spacer()
                        
                        // Inner VStack for the main content
                        VStack {
                            if let email = userAuthManager.userEmail {
                                Text("You are signed in as: \(email)")
                                    .padding()
                                    .font(Font.custom("Inter-Medium", size: 16.0))
                                
                                
                                Text("Your Birthday is \(viewModel.formatDate(dateObject: Date(timeIntervalSince1970: TimeInterval(userAuthManager.birthday?.seconds ?? 0))))").padding()
                                    .font(Font.custom("Inter-Medium", size: 16.0))
                                
                                
                            }
                            
                            Button(action: {
                                loginViewModel.signOut()
                            }, label: {
                                Text("Press to Log Out")
                                    .font(Font.custom("Inter-Medium", size: 16.0))
                                    .foregroundStyle(Color.red)
                            })
                            
                        }
                        
                        // Spacer to push UUID to the bottom
                        Spacer()
                        
                        // UUID Text at the bottom
                        Text("UUID: \(userAuthManager.userUUID?.uppercased() ?? "NOT SIGNED IN")").font(.custom("Inter-Regular", size: 10.0))
                        
                    }
                }
                else {
                    ProgressView(value: 1)
                        .progressViewStyle(.circular)
                }
            }
            // Align content in the center of the VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

#Preview {
    MainView()
}

