//
//  QuizITApp.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI
import URLImage
import URLImageStore

@main
struct QuizITApp: App {
    var network: Network
    
    var body: some Scene {
        
        let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                                  inMemoryStore: URLImageInMemoryStore())
        
        WindowGroup {
//            SignInView()
//                .environmentObject(network)
            ContentView()
                .environmentObject(network)
                .environment(\.urlImageService, urlImageService)
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
