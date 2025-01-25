//
//  MainMenu.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI
import URLImage
import URLImageStore



struct MainMenu: View {
    @EnvironmentObject var network: Network
    
    @State private var subjects: [Subject] = []
    @State private var stats: Statistic? = nil
    @State private var loading = true
    
    var body: some View {
        VStack {
            if loading {
                CustomLoading()
            }
            else {
                NavigationStack {
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
                            
                            if self.subjects != [] {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(subjects, id: \.self) { subject in
                                            NavigationLink(destination: FocusView(subject: subject)) {
                                                SubjectCard(subject: subject)
                                            }
                                        }
                                    }
                                    
                                }
                                .scrollIndicators(.hidden)
                            }
                            
                            else {
                                Text("Keine Fächer verfügbar").font(Font.custom("Poppins-Semibold", size: 15))
                                    .padding(.leading)
                            }
                            
                            HStack {
                                Text("Deine Statistiken").font(Font.custom("Poppins-SemiBold", size: 25))
                                    .padding(.leading)
                                Spacer()
                                Text("mehr anzeigen").font(Font.custom("Poppins-SemiBold", size: 15))
                                    .padding(.trailing)
                            }
                            .padding(.top)
                            if let stats = self.stats {
                                StatisticCard(stats: stats)
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            handleRequests()
        }
    }
    
    private func handleRequests() {
        self.loading = true
        network.fetchSubjects() { error in
            if let error = error {
                //TODO: Fehlerbehandlung, wenn Fächer nicht abrufbar waren
            }
            else {
                self.subjects = network.subjects ?? []
            }
        }
        network.fetchUserStats() { stats, error in
            if let stats = stats {
                self.stats = stats
            } else if let error = error {
             //TODO: Fehlerbehandlung
            }
        }
        self.loading = false
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

                    URLImage(URL(string: subject.imageAddress)!) {
                        // This view is displayed before download starts
                        EmptyView()
                    } inProgress: { progress in
                        // Display progress
                        CustomLoading()
                    } failure: { error, retry in
                        // Display error and retry button
                        VStack {
                            Text(error.localizedDescription)
                            Button("Retry", action: retry)
                        }
                    } content: { image in
                        // Downloaded image
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
                        .foregroundStyle(.black)
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
    
    private func StatisticCard(stats: Statistic) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentColor)
                .frame(width: 370, height: 110)
                .shadow(radius: 5)
                .padding()
            HStack {
                VStack {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    
                    Text("Challenges")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("\(Int(stats.winRate)) %")
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
                    
                    Text("TGM-Level")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("#\(stats.rank)")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()
                
                Divider()
                    .frame(width: 10,height: 60)
                    .foregroundStyle(.black)
                
                VStack {
                    Image(systemName: "flag.pattern.checkered")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    
                    Text("Score")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("\(Int(stats.average)) %")
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


