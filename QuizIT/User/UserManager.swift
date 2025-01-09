//
//  UserManager.swift
//  QuizIT
//
//  Created by Marius on 23.12.24.
//

import Foundation

class UserManager {
    static let shared = UserManager() // Singleton-Instanz
    private let userDefaultsKey = "savedUser" // Schlüssel für UserDefaults

    private init() {}

    // Benutzer speichern
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("User gespeichert!")
        } else {
            print("Fehler beim Kodieren des Benutzers.")
        }
    }

    // Benutzer laden
    func loadUser() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: savedUserData) {
                return user
            } else {
                print("Fehler beim Dekodieren des Benutzers.")
            }
        } else {
            print("Kein Benutzer gefunden.")
        }
        return nil
    }

    // Benutzer löschen
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        print("User wurde erfolgreich gelöscht!")
    }
}
