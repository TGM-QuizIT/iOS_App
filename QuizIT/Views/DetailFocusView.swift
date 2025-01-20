//
//  FocusDetailView.swift
//  QuizIT
//
//  Created by Marius on 20.01.25.
//

import SwiftUI

struct DetailFocusView: View {
    @Environment(\.dismiss) private var dismiss

    var focus: Focus
    
    var quizHistroy: [Result]

    var body: some View {
        VStack {
            NavigationHeader(title: focus.name) {
                dismiss()
            }
            HStack {
                Text("Dein Quiz-Verlauf").font(.custom("Roboto-Bold", size: 24))
                    .padding(.leading, 20)
                Spacer()
            }
            
            ScrollView {
                ForEach(Array(self.quizHistroy.enumerated()), id: \.1) { index, result in
                    QuizHistory(result: result, place: index+1)
                }
            }
            .frame(height: 310)
            .scrollIndicators(.hidden)
            

            Spacer()
        }
    }
}

extension DetailFocusView {
    func QuizHistory(result: Result, place: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lightBlue)
                .frame(width: 350, height: 70)
                .padding(.horizontal, 20)

            HStack {
                if place == 1 {
                    Image("trophy_gold")
                        .resizable()
                        .frame(width: 45,height: 45)
                        .padding(.leading, 44)

                } else if place == 2 {
                    Image("trophy_silver")
                        .resizable()
                        .frame(width: 45,height: 45)
                        .padding(.leading, 44)
                } else if place == 3 {
                    Image("trophy_bronze")
                        .resizable()
                        .frame(width: 45,height: 45)
                        .padding(.leading, 44)
                } else {
                    Text("#" + place.description).font(
                        .custom("Roboto-Bold", size: 20))
                    .padding(.leading, 44)
                }
                
                Spacer()
                Text(result.dateToString()).font(
                    .custom("Roboto-Bold", size: 20))
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 7)
                        .opacity(0.2)
                        .foregroundColor(.blue)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(result.score / 100))
                        .stroke(
                            style: StrokeStyle(lineWidth: 7, lineCap: .round)
                        )
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(result.score))%")
                        .font(.subheadline)
                        .bold()
                }
                .frame(width: 50, height: 50)
                .padding(.trailing, 44)


            }

        }
    }
}

#Preview {
    DetailFocusView(focus: dummyFocuses[0], quizHistroy: dummyResults)
}
