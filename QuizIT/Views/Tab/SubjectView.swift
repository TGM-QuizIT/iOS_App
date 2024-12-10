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
    
    private var subjects: [Subject] = [
        Subject(id: 1, name: "Angewandte Mathematik",  imageAddress: "https://firebasestorage.googleapis.com/v0/b/website-projekteserver.appspot.com/o/imagesForApp%2Fmaths.png?alt=media&token=b7d6b8e7-31b1-4f25-a6f9-29d3cb92be32"),
        Subject(id: 2, name: "SEW",  imageAddress: "https://cdn.sanity.io/images/tlr8oxjg/production/9f15109746df254c5a030a7ba9239f8a4bb5dadb-1456x816.png?w=3840&q=100&fit=clip&auto=format"),
        Subject(id: 3, name: "GGP",  imageAddress: "https://images.unsplash.com/photo-1461360370896-922624d12aa1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8aGlzdG9yeXxlbnwwfHwwfHx8MA%3D%3D")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                yourSubjectsSection()
                    .padding(.top)
                
                
                ScrollView {
                    VStack(spacing: 1) {
                        ForEach(subjects, id: \.self) { subject in
                            NavigationLink(destination: FocusView(
                                subjectName: subject.name,
                                questionNumberSubject: 100, // Beispielwert, anpassen je nach Bedarf
                                focusList: dummyFocuses                            )) {
                                SubjectCard(subject: subject)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                Spacer()
            }
        }
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
                            .frame(width: 347, height: 117)
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
