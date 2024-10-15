//
//  MainMenu.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct MainMenu: View {
    
    private var subjects: [Subject] = [Subject(subjectId: 1, subjectName: "Angewandte Mathematik", subjectActive: true),Subject(subjectId: 2, subjectName: "SEW", subjectActive: true),
                                       Subject(subjectId: 3, subjectName: "GGP", subjectActive: true)]
                
    

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Deine Fächer".uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading,30)
                    .foregroundStyle(Color.TC)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(subjects, id: \.self) { subject in
                            SubjectCard(subject: subject)
                        }
                }
            
            }
            
           
            
            
            Spacer()
        }
    }
}

extension MainMenu {
    private func SubjectCard(subject: Subject) -> some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lightBlue)
                            .frame(width: 250, height: 225)
                            .shadow(radius: 5)
                            .padding()
                            .padding(.top, 20)
            
            VStack {
                Image("Maths")
                            .resizable()
                            .frame(width: 250, height: 120)
                            .cornerRadius(20)
                
                VStack(alignment: .leading) {
                    Text(subject.subjectName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.leading, 15)
                                
                
                Button(action: {
                            // Aktion des Buttons
                        }) {
                            Text("Fortschritt")
                                .foregroundColor(Color.darkBlue)
                                .padding()
                                .frame(minWidth: 218)
                                .frame(height: 40)
                                .background(Color.white)
                                .font(.headline)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 1)
                                      
                                )
                        }
                        .padding(12)
                }
                  
                

            }

            Spacer()
            
            
        }
    }
}

#Preview {
    MainMenu()
}
