//
//  MainMenu.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct MainMenu: View {
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
            
            Spacer()
        }
    }
}

#Preview {
    MainMenu()
}
