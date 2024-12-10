//
//  NavigationHeader.swift
//  QuizIT
//
//  Created by Marius on 10.12.24.
//

import SwiftUI

struct NavigationHeader: View {
    let title: String
    let onBackButtonTap: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Back Button
            HStack {
                if let onBackButtonTap = onBackButtonTap {
                    Button(action: {
                        onBackButtonTap()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(.leading)
                }
                
                Spacer() // Platzhalter
            }
            
            // Title in der Mitte
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundColor(.black)
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(Color.white)
    }
}

