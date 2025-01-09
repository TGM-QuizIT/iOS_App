//
//  QuizView.swift
//  QuizIT
//
//  Created by Marius on 02.10.24.
//

import SwiftUI
import URLImage

struct SubjectView: View {
    
    let isFavoriteSelected: Bool = true
    @EnvironmentObject var network: Network
    
    @State private var subjects: [Subject] = []
    @State private var loading = true
    
    
    var body: some View {
        VStack {
            if loading {
                ProgressView()
            }
            else {
                NavigationStack {
                    VStack(spacing: 1) {
                        yourSubjectsSection()
                            .padding(.top)
                        
                        if self.subjects != [] {
                            ScrollView {
                                VStack(spacing: 1) {
                                    ForEach(subjects, id: \.self) { subject in
                                        NavigationLink(destination: FocusView(subject: subject)) {
                                            SubjectCard(subject: subject)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                            }
                        }
                        else {
                            Text("Keine Schwerpunkte verfügbar").font(Font.custom("Poppins-Semibold", size: 15))
                                .padding(.leading)
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear() {
            fetchSubjects()
        }
    }
    
    private func fetchSubjects() {
        self.loading = true
        network.fetchSubjects() { text in
            if let t = text {
                //TODO: Fehlerbehandlung, wenn Fächer nicht abrufbar waren
            }
            else {
                self.subjects = network.subjects ?? []
            }
        }
        self.loading = false
    }
}



extension SubjectView {
    private func yourSubjectsSection() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 340, height: 60)
                .shadow(radius: 10)
            
            HStack {
                Text("Deine Fächer")
                    .font(Font.custom("Poppins-SemiBold", size: 18))
                    .padding(.leading, 40)
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.trailing, 40)
            }
        }
    }
    
    private func SubjectCard(subject: Subject) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 347, height: 234)
                .shadow(radius: 5)
                .padding()
            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.lightBlue)
                        .frame(width: 347, height: 117)
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
                        .padding()
                        .padding(.top, -43)
                    
                    URLImage(URL(string: subject.imageAddress)!) { image in
                        image
                            .resizable()
                            .aspectRatio(24/9, contentMode: .fit)
                            .frame(width: 347)
                            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
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
                            .frame(minWidth: 316)
                            .frame(height: 39)
                            .background(Color.white)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 1.47)
                            )
                    .padding(.top, 5)
                }
            }
            Spacer()
        }
    }
}

struct CustomCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#Preview {
    SubjectView()
}
