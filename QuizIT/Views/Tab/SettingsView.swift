//
//  SettingsView.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Button("Ausloggen") {
                UserManager.shared.deleteUser()
                showSignInView = true
            }
        }
    }
}

//#Preview {
//    SettingsView()
//}
