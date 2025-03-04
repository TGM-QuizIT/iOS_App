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
    var focus: Focus?
    var subject: Subject?
    var quizType: Int
    
    var body: some View {
        VStack {
            
            ZStack {
                if quizType == 0 {
                    Text(subject?.name ?? "Fehler")
                        .font(Font.custom("Poppins-Regular", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                if quizType == 1 {
                    Text(focus?.name ?? "Fehler")
                        .font(Font.custom("Poppins-Regular", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    if quizType == 1 {
                        Text(subject?.name ?? "Fehler")
                            .font(Font.custom("Roboto-Regular", size: 20))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.vertical,10)
                    }
                    Spacer()
                    
                    Button {
                        dismiss()
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.black)
                            .padding(.horizontal, 32)
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
                    
                    VStack {
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.lightBlue)
                                    .frame(width: 185,height: 40)
                                HStack {
                                    Image("add_friend")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                        .padding(.leading,10)
                                    
                                    Spacer()
                                    Text("Herausfordern").font(.custom("Poppins-SemiBold", size: 12))
                                        .foregroundStyle(.black)
                                        .padding(.trailing, 35)
                                }
                            }
                            .padding(.trailing,20)
                        }
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.lightBlue)
                                    .frame(width: 185,height: 40)
                                HStack {
                                    Image("history")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                        .padding(.leading,5)

                                    
                                    Spacer()
                                    Text("Verlauf").font(.custom("Poppins-SemiBold", size: 12))
                                        .foregroundStyle(.black)
                                        .padding(.trailing, 65)
                                }
                            }
                            .padding(.trailing,20)
                        }
                    }
                }
            
            
            
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
                    if question.options.count > 2 {
                        
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
                    }
                    if question.options.count > 3 {
                        
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
    ResultView(quiz: QuizData.shared.quiz, result: dummyResults[0], focus: dummyFocuses[0], subject: Subject(id: 1, name: "GGP", imageAddress: ""), quizType: 0)
}
