//
//  ContentView.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var network: Network


    
    @State private var showSignInView = true
    
    
    var body: some View {
        
        if self.showSignInView {
            SignInView(showSignInView: self.$showSignInView)
        } else {
            ZStack {
                TabView {
                    MainMenu()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    SubjectView()
                        .tabItem {
                            Label("Quiz", systemImage: "book.closed")
                        }
                    SocialView()
                        .tabItem {
                            Label(NSLocalizedString("friends", comment: ""), systemImage: "person.2")
                        }
                    SettingsView()
                        .tabItem {
                            Label(NSLocalizedString("profile", comment: ""), systemImage: "gear")
                        }
                    
                }
            }
            .onAppear {
                // TODO: Raphael User/Subject/Fächer-Req
            }
        }
        
    }
}

#Preview {
    ContentView()
}
