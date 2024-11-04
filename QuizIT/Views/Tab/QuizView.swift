//
//  QuizView.swift
//  QuizIT
//
//  Created by Marius on 02.10.24.
//

import SwiftUI
import URLImage

struct QuizView: View {
    
    let isFavoriteSelected: Bool = true
    
    
    private var subjects: [Subject] = [Subject(subjectId: 1, subjectName: "Angewandte Mathematik", subjectActive: true, subjectImageAddress: "https://firebasestorage.googleapis.com/v0/b/website-projekteserver.appspot.com/o/imagesForApp%2Fmaths.png?alt=media&token=b7d6b8e7-31b1-4f25-a6f9-29d3cb92be32"),Subject(subjectId: 2, subjectName: "SEW", subjectActive: true, subjectImageAddress: "https://cdn.sanity.io/images/tlr8oxjg/production/9f15109746df254c5a030a7ba9239f8a4bb5dadb-1456x816.png?w=3840&q=100&fit=clip&auto=format"),
                                       Subject(subjectId: 3, subjectName: "GGP", subjectActive: true, subjectImageAddress: "https://images.unsplash.com/photo-1461360370896-922624d12aa1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8aGlzdG9yeXxlbnwwfHwwfHx8MA%3D%3D")]
    
    var body: some View {
        VStack(spacing: 1) {
            yourSubjectsSection()
                .padding(.top)
            ScrollView {
                VStack(spacing: 1) {
                    ForEach(subjects, id: \.self) { subject in
                            SubjectCard(subject: subject)
                        }
                }
                .padding(.top,20)
                
                
            }
            Spacer()

        }
    }
}

extension QuizView {
    private func yourSubjectsSection() -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                            .frame(width: 340, height: 60)
                            .shadow(radius: 10)
            
            HStack {
                
                Text("Deine Fächer").font(Font.custom("Poppins-SemiBold", size: 18))
                    .padding(.leading,40)
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.trailing,40)
            }
        }
        
        
    }
    
    private func yourFavoriteSubjects() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                            .frame(width: 340, height: 44)
                            .shadow(radius: 10)
                            .padding()
            
            HStack {
                
                Text(isFavoriteSelected ? "Deine Fächer" : "Deine Favoriten").font(Font.custom("Poppins-Regular", size: 16))
                    .padding(.leading,40)
                Spacer()
        
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
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))  // Apply corner radius only to top corners
                        .padding()
                        .padding(.top, -43)

                    
                    URLImage(URL(string: subject.subjectImageAddress)!) { image in
                        image
                            .resizable()
                            .frame(width: 347, height: 117)
                            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))  // Apply corner radius only to top corners
                            .padding(.top, -43)
                    }
                }
                
                
                VStack(alignment: .center) {
                    Text(subject.subjectName)
                        .font(Font.custom("Poppins-SemiBold", size: 19))
                        .padding(.top, -10)
                                
                
                Button(action: {
                            // Aktion des Buttons
                        }) {
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
                        }
                        .padding(.top,5)
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
    QuizView()
}
