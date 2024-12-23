//
//  QuizITApp.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI

@main
struct QuizITApp: App {
    var network: Network
    
    var body: some Scene {
        WindowGroup {
            SignInView()
                .environmentObject(network)
//            PerfomQuizView(
//                focusName: "2. Weltkrieg",
//                quiz: QuizData.shared.quiz
//            )
       //     StartQuizView()
//            SocialView()
        }
    }
    
    init() {
        self.network = Network()
    }
}
