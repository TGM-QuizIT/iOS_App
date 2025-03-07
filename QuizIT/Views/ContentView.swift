//
//  ContentView.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var network: Network
    @EnvironmentObject var quizData: QuizData

    @State private var user: User?
    @State private var showSignInView = false
    @State private var startingApp = true
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                if startingApp {
                    ZStack {
                        Image("AppIcon")
                    }
                    .onAppear {
                        if let loadedUser = UserManager.shared.loadUser() {
                            withAnimation {
                                print("Benutzer geladen: \(loadedUser.name)")
                                self.user = loadedUser
                                self.startingApp = false
                            }
                        } else {
                            self.showSignInView = true
                            print(
                                "Kein Benutzer gefunden. Zeige Anmeldeansicht.")
                            self.startingApp = false
                        }
                    }
                }
                
                if self.showSignInView {
                    SignInView(showSignInView: self.$showSignInView)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                    
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
            .navigationDestination(isPresented: Binding(projectedValue: $quizData.showQuiz)) {
                PerformQuizView(
                    focus: quizData.focus ?? dummyFocuses[0],
                    subject: quizData.subject,
                    quiz: Quiz(questions: quizData.questions), quizType: quizData.quizType)
            }
        }
        

    }
}

#Preview {
    ContentView()
}
