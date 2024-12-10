//
//  FocusView.swift
//  QuizIT
//
//  Created by Marius on 01.11.24.
//

import SwiftUI

struct FocusView: View {
    
    var subjectName: String
    var questionNumberSubject: Int
    
    var focusList: [Focus]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Schwerpunkte\n" + subjectName)
                .font(Font.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            AllFocusCard()
            
            
            ForEach(focusList, id: \.self) { focus in
                
                    FocusCard(focus: focus)
                
                    
                }
            
            
            Spacer()
        }
        .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss() // Zurücknavigieren
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                                Spacer()
                                
                                
                                
                                Spacer()
                            }
                        }
                    }
                }
        .navigationBarBackButtonHidden(true)
    }
}

extension FocusView {
    private func AllFocusCard() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightGrey)
                            .frame(width: 345, height: 75)
                            .shadow(radius: 10)
                            .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text(subjectName)
                        .font(Font.custom("Poppins-SemiBold", size: 16))
                        .padding(.leading, 50)

                    
                    Text(questionNumberSubject.codingKey.stringValue + " Fragen insgesamt im Pool")
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .padding(.leading, 50)

                }
                Spacer()
                Image(systemName: "chevron.right")
                    .padding(.trailing,50)

                
            }
        }
    }
    
    private func FocusCard(focus: Focus) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightGrey)
                            .frame(width: 345, height: 75)
                            .padding(6)
            HStack {
                VStack(alignment: .leading) {
                    Text(focus.name)
                        .font(Font.custom("Poppins-SemiBold", size: 16))
                        .padding(.leading, 50)

                    
                    Text(focus.questionCount.codingKey.stringValue + " Fragen im Pool")
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .padding(.leading, 50)

                }
                Spacer()
                Image(systemName: "chevron.right")
                    .padding(.trailing,50)

                
            }
        }
    }
}

#Preview {
    FocusView(subjectName: "GGP", questionNumberSubject: 147, focusList: dummyFocuses)
}
