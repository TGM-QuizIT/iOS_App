//
//  StatisticView.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//

import SwiftUI
import URLImage
import Charts

struct StatisticView: View {
    
    var lastResults: [Result]
    
    var body: some View {
        ScrollView {
            VStack {
                StatisticCard()
                
                HStack {
                    Text("Quiz Verlauf").font(.custom("Poppins-SemiBold", size: 16))
                        .padding(.leading,20)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack(spacing:-20) {
                        ForEach(lastResults, id: \.self) { result in
                            ResultCard(result: result)
                            
                        }
                    }
                }
                .scrollIndicators(.hidden)

                // StatisticChartView(lastResults: lastResults)
                
                
            }
            .onAppear {
                // TODO: Raphael Statistik laden
            }
        }
        
        
    }
}

extension StatisticView {
    private func StatisticCard() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentColor)
                .frame(width: 370, height: 110)
                .shadow(radius: 5)
                .padding()
            HStack {
                VStack {
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    
                    Text("Punkte")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("540")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                    
                    
                }
                .padding()
                
                Divider()
                    .frame(width: 10, height: 60)
                    .foregroundStyle(.black)
                
                VStack {
                    Image(systemName: "graduationcap.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    
                    Text("Platz")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("#1540")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()
                
                Divider()
                    .frame(width: 10,height: 60)
                    .foregroundStyle(.black)
                
                VStack {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    
                    Text("Score")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("79%")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()
            }
            .padding(10)
        }
    }
    private func ResultCard(result: Result) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.base)
                    .frame(width: 169, height: 129)
                   // .shadow(radius: 5)
                    .padding()
                
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.lightBlue)
                            .frame(width: 169, height: 65)
                            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
                            .padding()
                            .padding(.top, -43)
                        
                        URLImage(URL(string:result.focus?.imageAddress ?? "")!) { image in
                            image
                                .resizable()
                                .frame(width: 169, height: 65)
                                .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
                                .padding(.top, -43)
                        }
                    }
                    
                    VStack(alignment: .center) {
                        Text(result.focus?.name ?? "")
                            .font(Font.custom("Poppins-SemiBold", size: 11))
                            .padding(.top, -10)
                        // Fortschrittsanzeige
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.lightBlue)
                                .frame(width: 143.28, height: 16) // Erhöhte Höhe
                            
                            ProgressView(value: result.score / 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: result.score>=40 ? .blue : .red))
                                .frame(width: 143.28, height: 50)
                                .scaleEffect(x: 1, y: 4, anchor: .center)
                                .cornerRadius(20)
                                .animation(.easeInOut(duration: 0.5), value: 0.2 / 100)
                            

                            Text(result.score.description + "%")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(result.score>=40 ? .white : .black)
                        }
                        .padding(.top,-15)



                        
                    }
                }
                Spacer()
            }
    }
    
}

#Preview {
    StatisticView(lastResults: dummyResults)
}



import SwiftUI
import Charts

struct StatisticChartView: View {
    var lastResults: [Result]
    
    var body: some View {
        VStack {
            Text("Ergebnisse im Überblick")
                .font(.custom("Poppins-SemiBold", size: 16))
                .padding(.leading)
            
            Chart(lastResults) { result in
                BarMark(
                    x: .value("Fokus", result.focus?.name ?? ""),
                    y: .value("Punkte", result.score)
                )
                .foregroundStyle(result.score >= 50 ? Color.blue : Color.red)  // Farbliche Unterscheidung basierend auf dem Score
                .cornerRadius(8)  // Abrunden der Ecken des Balkens
                .annotation(position: .top) {
                    Text("\(Int(result.score))")  // Zeigt die Punktzahl oberhalb des Balkens an
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(height: 300)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))  // Hintergrundfarbe für das Diagramm
            .cornerRadius(12)
            .shadow(radius: 5)  // Schattierung für das Diagramm
            .padding(.top, 16)
            
        }
    }
}


