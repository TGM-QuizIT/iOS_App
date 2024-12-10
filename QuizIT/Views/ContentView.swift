//
//  ContentView.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
        
    }
}

#Preview {
    ContentView()
}
