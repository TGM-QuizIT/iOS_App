//
//  ResultView.swift
//  QuizIT
//
//  Created by Marius on 19.11.24.
//

import SwiftUI

struct ResultView: View {
    
    @Environment(\.dismiss) private var dismiss

    
    var quiz: Quiz
    var result: Result
    var focus: Focus
    var subject: Subject
    
    var body: some View {
        VStack {
            
            ZStack {
                Text(focus.name)
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text(subject.name)
                        .font(Font.custom("Roboto-Regular", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(32)
                    Spacer()
                    
                    Button {
                        dismiss()
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.black)
                            .padding(32)
                    }
                    
                    
                }
            }
            ScrollView {
            HStack {
                
                Text("Dein Resultat").font(.custom("Poppins-SemiBold", size: 16))
                    .padding(.leading,22)
                
                Spacer()

            }
            HStack {
                // Kreis
                ZStack {
                            Circle()
                                .stroke(lineWidth: 15)
                                .opacity(0.2)
                                .foregroundColor(.blue)

                            Circle()
                        .trim(from: 0.0, to: CGFloat(self.result.score/100))
                                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(-90))

                    Text("\(Int(self.result.score))%")
                        .font(.title2)
                                .bold()
                        }
                        .frame(width: 85, height: 85)
                Spacer()
                
            }
            .padding(.leading,22)
            
                ForEach(Array(quiz.questions.enumerated()), id: \.1) { index, question in
                    QuestionCard(question: question, qIndex: index)
                }
            }
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)

        Spacer()
    }
}

extension ResultView {
    func QuestionCard(question: Question, qIndex: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                )
                .frame(width: 350, height: 270)
            VStack {
                HStack {
                    Text("Frage \(qIndex+1)").font(.custom("Roboto-Bold", size: 15))
                        .padding(.leading,32)
                    Spacer()
                }
                HStack {
                    Text(question.text).font(.custom("Roboto-Regular", size: 12))
                        .padding(.leading,32)
                        .padding(.top,1)
                    Spacer()
                }
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(getOptionColor(option: question.options[0]))
                            )
                            .frame(width: 310, height: 34)
                        HStack {
                            Text(question.options[0].text).font(.custom("Roboto-Regular", size: 12))
                            Spacer()
                            Image(getOptionIcon(option: question.options[0]))
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing,46)
                        }
                        .padding(.leading,48)
                    }
                    .padding(.top,6)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(getOptionColor(option: question.options[1]))
                            )
                            .frame(width: 310, height: 34)
                        HStack {
                            Text(question.options[1].text).font(.custom("Roboto-Regular", size: 12))
                            Spacer()
                            Image(getOptionIcon(option: question.options[1]))
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing,46)
                        }
                        .padding(.leading,48)
                    }
                    .padding(.top,6)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(getOptionColor(option: question.options[2]))
                            )
                            .frame(width: 310, height: 34)
                        HStack {
                            Text(question.options[2].text).font(.custom("Roboto-Regular", size: 12))
                            Spacer()
                            Image(getOptionIcon(option: question.options[2]))
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing,46)
                        }
                        .padding(.leading,48)
                    }
                    .padding(.top,6)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(getOptionColor(option: question.options[3]))
                            )
                            .frame(width: 310, height: 34)
                        HStack {
                            Text(question.options[3].text).font(.custom("Roboto-Regular", size: 12))
                            Spacer()
                            Image(getOptionIcon(option: question.options[3]))
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing,46)
                        }
                        .padding(.leading,48)
                    }
                    .padding(.top,6)

                    


                    
                }

                
                Spacer()
                
                
                
            }
            .frame(height: 200)

            
        }
        .padding()
    }
    func getOptionColor(option: Option) -> Color {
        if option.selected && option.correct {
            // Option ausgewählt und richtig
            return Color.correctGreen
        } else if option.selected && !option.correct {
            // Option ausgewählt und und falsch
            return Color.wrongRed
        } else if !option.selected && option.correct {
            // Option nicht ausgewählt und und richtig
            return Color.lightBlue
        } else {
            // Option nicht ausgewählt und nicht richtig
            return Color.white
        }
    }
    func getOptionIcon(option: Option) -> String {
        if option.selected && option.correct {
            // Option ausgewählt und richtig
            return "check_custom"
        } else if option.selected && !option.correct {
            // Option ausgewählt und und falsch
            return "xmark"
        } else if !option.selected && option.correct {
            // Option nicht ausgewählt und und richtig
            return "check_custom"
        } else {
            // Option nicht ausgewählt und nicht richtig
            return ""
        }
    }
}

#Preview {
    ResultView(quiz: QuizData.shared.quiz, result: dummyResults[0], focus: dummyFocuses[0], subject: Subject(id: 1, name: "GGP", imageAddress: ""))
}
