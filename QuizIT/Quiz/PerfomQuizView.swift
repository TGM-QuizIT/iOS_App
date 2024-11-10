//
//  PerfomQuizView.swift
//  QuizIT
//
//  Created by Marius on 05.11.24.
//

import SwiftUI

struct PerfomQuizView: View {
    
    @State private var selectedAnswerIndices: Set<Int> = []
    @State private var selectedAnswerScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("2. Weltkrieg")
                        .font(Font.custom("Poppins-Regular", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("1/5")
                            .font(Font.custom("Roboto-Regular", size: 20))
                            .foregroundStyle(.darkGrey)
                            .multilineTextAlignment(.center)
                            .padding(32)
                        Spacer()
                        
                        
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.black)
                            .padding(32)
                        
                    }
                }
                ZStack {
                    // Hintergrund der ProgressBar mit abgerundeten Ecken
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 15)
                    
                    ProgressView(value: 0.7)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 15)
                        .scaleEffect(x: 1, y: 3, anchor: .center)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                .padding(.top,-20)
            }
            
            //                HStack(spacing:0) {
            //                    LeftRoundedRectangle(cornerRadius: 20)
            //                            .foregroundStyle(.blue)
            //                            .frame(width: 100, height: 15)
            //
            //                    Rectangle()
            //                    .cornerRadius(20)
            //                    .foregroundStyle(.lightGrey)
            //                    .frame(width: 100,height: 15)
            //                }
            
            //                ProgressView(value: 0.7) // 70% Fortschritt
            //                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            //                    .frame(height: 15) // Höhe des Balkens
            //                    .scaleEffect(x: 1, y: 3, anchor: .center) // Höhe des blauen Balkens anpassen
            //                    .padding(.horizontal)
            //                    .background(
            //                        Capsule() // Verwenden von Capsule für abgerundete Ecken
            //                            .fill(Color.white) // Hintergrundfarbe
            //                    )
            //                    .clipShape(Capsule()) // Ecken mit Capsule rund machen
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.lightGrey)
                    .frame(width: 350, height: 210)
                    .padding(20)
                
                Text("Welche Ereignisse führten zum Ausbruch des Zweiten Weltkriegs im Jahr 1939?")
                    .font(Font.custom("Poppins-SemiBold", size: 15))
                    .frame(maxWidth: 320)
                    .multilineTextAlignment(.center)
                
                
            }
            
            
            
            
            ForEach(0..<4, id: \.self) { index in
                            answerCard(questionAnswerText: "Antwort \(index + 1)",
                                       isSelected: selectedAnswerIndices.contains(index),
                                       scale: selectedAnswerIndices.contains(index) ? 1.1 : 1.0) // Change scale for selected answers
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedAnswerIndices.contains(index) {
                                            selectedAnswerIndices.remove(index)
                                        } else {
                                            selectedAnswerIndices.insert(index)
                                        }
                                    }
                                }
                        }
            
            
            Spacer()
            Button(action: {
                // Aktion des Buttons
            }) {
                Text("Weiter")
                    .foregroundColor(Color.darkBlue)
                    .padding()
                    .frame(minWidth: 350)
                    .frame(height: 50)
                    .background(Color.white)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 1.7)
                        
                    )
            }
            .padding(.bottom,35)
        }
            
            
        
    }
}

extension PerfomQuizView {
    func answerCard(questionAnswerText: String, isSelected: Bool, scale: CGFloat) -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.lightGrey, lineWidth: 1.7)
                .background(isSelected ? Color.lightBlue : Color.white).cornerRadius(12)
                .frame(width: 330, height: isSelected ? 55 : 50)
                .scaleEffect(CGSize(width: 1, height: scale))

            
            HStack {
                Text(questionAnswerText)
                    .font(Font.custom("Roboto-Regular", size: 15))
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(maxWidth: 340)
                    .frame(height: isSelected ? 55 : 50)
                    .cornerRadius(12)
                    .padding(5)
                
                
                

            }
            
            if isSelected {
                Image("check_custom")
                    .resizable()
                    .frame(width: 15,height: 15)
                    .padding(.leading,250)
            }
        }
        
        
            
        }
}

struct LeftRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius), style: .continuous)
        return path
    }
}

#Preview {
    PerfomQuizView()
}
