//
//  StartQuizView.swift
//  QuizIT
//
//  Created by Marius on 26.11.24.
//

import SwiftUI

struct StartQuizView: View {
    
    @State private var showQuiz = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                Button {
                    showQuiz.toggle()
                } label: {
                    Text("Quiz starten")
                }
            }
            .navigationDestination(isPresented: $showQuiz) {
                PerfomQuizView(focus: dummyFocuses[0], subject: Subject(id: 1, name: "GGP", imageAddress: ""), quiz: QuizData.shared.quiz)
        }
        
        }
        
        
    }
}

#Preview {
    StartQuizView()
}