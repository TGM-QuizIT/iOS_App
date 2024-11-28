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
                PerfomQuizView(focus: Focus(id: 1, name: "2.Weltkrieg", year: 4, questionNumber: 125), subject: Subject(subjectId: 1, subjectName: "GGP", subjectImageAddress: ""), quiz: QuizData.shared.quiz)
        }
        
        }
        
        
    }
}

#Preview {
    StartQuizView()
}
