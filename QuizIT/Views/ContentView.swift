//
//  ContentView.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var network: Network

    @State private var user: User?

    @State private var showSignInView = true

    @State private var selectedTab: Int = 0

    var body: some View {

        ZStack {
            if self.showSignInView {
                SignInView(showSignInView: self.$showSignInView)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .onAppear {
                        if let loadedUser = UserManager.shared.loadUser() {
                            withAnimation {
                                print("Benutzer geladen: \(loadedUser.name)")
                                self.user = loadedUser
                                self.showSignInView = false
                            }
                        } else {
                            print(
                                "Kein Benutzer gefunden. Zeige Anmeldeansicht.")
                        }
                    }
            } else {
                ZStack {
                    TabView(selection: $selectedTab) {
                        MainMenu()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                            .tag(0)  // Home-Tab

                        SubjectView()
                            .tabItem {
                                Label("Quiz", systemImage: "book.closed")
                            }
                            .tag(1)  // Quiz-Tab

                        SocialView()
                            .tabItem {
                                Label(
                                    NSLocalizedString("friends", comment: ""),
                                    systemImage: "person.2")
                            }
                            .tag(2)  // Freunde-Tab

                        SettingsView(
                            showSignInView: $showSignInView,
                            selectedTab: $selectedTab
                        )
                        .tabItem {
                            Label(
                                NSLocalizedString("profile", comment: ""),
                                systemImage: "gear")
                        }
                        .tag(3)
                    }
                }
                .onAppear {
                    // TODO: Raphael User/Subject/Fächer-Req
                }
                .zIndex(0)
            }
        }
        .animation(.easeInOut, value: showSignInView)
    }
}

#Preview {
    ContentView()
}
