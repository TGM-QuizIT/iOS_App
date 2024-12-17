//
//  MainMenu.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI
import URLImage


struct MainMenu: View {
    
    private var subjects: [Subject] = dummySubjects
                
    

    
    var body: some View {
        VStack {
            HStack {
                
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 80)
                    .cornerRadius(20)
                    .padding(.leading)
                
                
                
                Spacer()
            }
            .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    Text("Deine Fächer").font(Font.custom("Poppins-SemiBold", size: 25))
                        .padding(.leading)
                    Spacer()
                    Text("mehr anzeigen").font(Font.custom("Poppins-SemiBold", size: 15))
                        .padding(.trailing)
                }
                
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(subjects, id: \.self) { subject in
                                SubjectCard(subject: subject)
                            }
                    }
                
                }
                .scrollIndicators(.hidden)
                
                HStack {
                    Text("Deine Statistiken").font(Font.custom("Poppins-SemiBold", size: 25))
                        .padding(.leading)
                    Spacer()
                    Text("mehr anzeigen").font(Font.custom("Poppins-SemiBold", size: 15))
                        .padding(.trailing)
                }
                .padding(.top)
                
                StatisticCard()
                
                
            }
            
            
           
            
            
            Spacer()
        }
        .onAppear {
            //    TODO: @Raphael
            
        }
    }
}

extension MainMenu {
    private func SubjectCard(subject: Subject) -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                            .frame(width: 270, height: 212)
                            .shadow(radius: 5)
                            .padding()

            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.base)
                        .frame(width: 270, height: 107)
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))  // Apply corner radius only to top corners
                        .padding()
                        .padding(.top, -43)

                    
                    URLImage(URL(string: subject.imageAddress)!) { image in
                        image
                            .resizable()
                            .frame(width: 270, height: 107)
                            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))  // Apply corner radius only to top corners
                            .padding(.top, -43)
                    }
                }
                
                
                VStack(alignment: .center) {
                    Text(subject.name)
                        .font(Font.custom("Poppins-SemiBold", size: 19))
                        .padding(.top, -10)
                                
                
                
                            Text("Schwerpunkte")
                                .foregroundColor(Color.darkBlue)
                                .padding()
                                .frame(minWidth: 218)
                                .frame(height: 40)
                                .background(Color.white)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 1.7)
                                      
                                )
                        .padding(.top,5)
                }
               
                  
                

            }

            Spacer()
            
            
        }

    }
    
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

}

#Preview {
    MainMenu()
}


