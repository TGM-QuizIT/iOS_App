//
//  FocusView.swift
//  QuizIT
//
//  Created by Marius on 01.11.24.
//

import SwiftUI
import URLImage

struct FocusView: View {
    
    var subject: Subject
    
    @EnvironmentObject var network: Network
    @State private var focusList: [Focus] = []
    @State private var loading = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else {
                VStack(alignment: .center) {
                    Text("Schwerpunkte\n" + subject.name)
                        .font(Font.custom("Poppins-SemiBold", size: 20))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    
                    AllFocusCard(subject: subject)
                    
                    
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
        .onAppear() {
            fetchFocus()
        }
    }
    
    private func fetchFocus() {
        self.loading = true
        network.fetchFocus(id: self.subject.id) { focus in
            if let focus = focus {
                self.focusList = focus
            }
            else {
                self.focusList = []
            }
            for focus in self.focusList {
                print(focus.imageAddress)
            }
        }
        self.loading = false
    }
}

extension FocusView {
    private func AllFocusCard(subject: Subject) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightGrey)
                            .frame(width: 347, height: 110)
                            .padding(6)
            Button(action: {
                
            }) {
                Text("Quiz starten").font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 110,height: 30)
                    .background(Color.white)
                    .cornerRadius(40)
            }
            .padding(.top,50)
            .padding(.trailing,200)
            
            URLImage(URL(string: subject.imageAddress)!) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 75)
                    .clipped()
                    .padding(.leading, 190)
            }

            HStack {
                    VStack(alignment: .leading) {
                        Text(subject.name)
                            .font(Font.custom("Poppins-SemiBold", size: 16))
                            .padding(.leading, 50)

                        
                        Text("147 Fragen im Pool")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .padding(.leading, 50)
                            .padding(.bottom,35)
                    }
                
                Spacer()
                


                
            }
        }
    }
    
    private func FocusCard(focus: Focus) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightGrey)
                            .frame(width: 347, height: 110)
                            .padding(6)
            Button(action: {
                
            }) {
                Text("Quiz starten").font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 110,height: 30)
                    .background(Color.white)
                    .cornerRadius(40)
            }
            .padding(.top,50)
            .padding(.trailing,200)
            
            URLImage(URL(string: focus.imageAddress)!) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 75)
                    .clipped()
                    .padding(.leading, 190)
            }

            HStack {
                    VStack(alignment: .leading) {
                        Text(focus.name)
                            .font(Font.custom("Poppins-SemiBold", size: 16))
                            .padding(.leading, 50)

                        
                        Text(focus.questionCount.codingKey.stringValue + " Fragen im Pool")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .padding(.leading, 50)
                            .padding(.bottom,35)
                    }
                
                Spacer()
                


                
            }
        }
    }
}

#Preview {
    //FocusView(subject: dummySubjects[2])
}
