//
//  dummyData.swift
//  QuizIT
//
//  Created by Marius on 09.12.24.
//

import Foundation

// Dummy Daten Focus
let dummyFocuses: [Focus] = [
    Focus(
        id: 1,
        name: "2. Weltkrieg",
        year: 4,
        questionCount: 50,
        imageAddress:
            "https://firebasestorage.googleapis.com/v0/b/website-projekteserver.appspot.com/o/imagesForApp%2Fmaths.png?alt=media&token=b7d6b8e7-31b1-4f25-a6f9-29d3cb92be32"
    ),
    Focus(
        id: 2,
        name: "Zwischenkriegszeit",
        year: 4,
        questionCount: 45,
        imageAddress: "https://firebasestorage.googleapis.com/v0/b/website-projekteserver.appspot.com/o/imagesForApp%2Fmaths.png?alt=media&token=b7d6b8e7-31b1-4f25-a6f9-29d3cb92be32"
    ),
    Focus(
        id: 3,
        name: "Kalter Krieg",
        year: 4,
        questionCount: 40,
        imageAddress: "https://firebasestorage.googleapis.com/v0/b/website-projekteserver.appspot.com/o/imagesForApp%2Fmaths.png?alt=media&token=b7d6b8e7-31b1-4f25-a6f9-29d3cb92be32"
    ),
]

let dummyResults: [Result] = [
    Result(
        id: 1,
        score: 45.5,
        userId: 101,
        focus: dummyFocuses[0],
        date: Date(timeIntervalSince1970: 1_701_667_200)  // 04.12.2023
    ),
    Result(
        id: 2,
        score: 92.0,
        userId: 102,
        focus: dummyFocuses[1],
        date: Date(timeIntervalSince1970: 1_704_259_200)  // 03.01.2024
    ),
    Result(
        id: 3,
        score: 74.3,
        userId: 103,
        focus: dummyFocuses[2],
        date: Date(timeIntervalSince1970: 1_706_847_600)  // 03.02.2024
    ),
    Result(
        id: 4,
        score: 88.8,
        userId: 104,
        focus: dummyFocuses[1],
        date: Date(timeIntervalSince1970: 1_709_526_000)  // 03.03.2024
    ),
    Result(
        id: 5,
        score: 60.5,
        userId: 105,
        focus: dummyFocuses[1],
        date: Date(timeIntervalSince1970: 1_712_204_400)  // 03.04.2024
    ),
]

let dummyFriendships: [Friendship] = [
    Friendship(
        id: 1,
        user2: dummyUser[0],
        pending: 2,
        since: Date(timeIntervalSince1970: 1_676_000_000) // 2023-02-19
    ),
    Friendship(
        id: 2,
        user2: dummyUser[1],
        pending: 1,
        since: Date(timeIntervalSince1970: 1_580_000_000) // 2020-01-01
    ),
    Friendship(
        id: 3,
        user2: dummyUser[2],
        pending: 1,
        since: Date(timeIntervalSince1970: 1_600_000_000) // 2020-09-13
    ),
    Friendship(
        id: 4,
        user2: dummyUser[3],
        pending: 2,
        since: Date(timeIntervalSince1970: 1_700_000_000) // 2023-12-03
    ),
    Friendship(
        id: 5,
        user2: dummyUser[4],
        pending: 2,
        since: Date()
    )
]
let dummyQuiz: Quiz = Quiz(questions: [
    Question(
        id: 1,
        text: "What is the capital of France?",
        options: [
            Option(id: 1, text: "Paris", correct: true),
            Option(id: 2, text: "Berlin", correct: true),
            Option(id: 3, text: "Madrid", correct: false),
            Option(id: 4, text: "Rome", correct: false),
        ],
        mChoice: true
    ),
    Question(
        id: 2,
        text: "Which planet is known as the Red Planet?",
        options: [
            Option(id: 1, text: "Mars", correct: true),
            Option(id: 2, text: "Earth", correct: false),
            Option(id: 3, text: "Venus", correct: false),
            Option(id: 4, text: "Jupiter", correct: false),
        ],
        mChoice: false
    ),
    Question(
        id: 3,
        text: "Who wrote 'Romeo and Juliet'?",
        options: [
            Option(id: 1, text: "William Shakespeare", correct: true),
            Option(id: 2, text: "Charles Dickens", correct: false),
            Option(id: 3, text: "Mark Twain", correct: false),
            Option(id: 4, text: "J.K. Rowling", correct: false),
        ],
        mChoice: false
    ),
    Question(
        id: 4,
        text: "What is the chemical symbol for water?",
        options: [
            Option(id: 1, text: "H2O", correct: true),
            Option(id: 2, text: "O2", correct: false),
            Option(id: 3, text: "CO2", correct: false),
            Option(id: 4, text: "NaCl", correct: false),
        ],
        mChoice: false
    ),
    Question(
        id: 5,
        text: "In which year did the Titanic sink?",
        options: [
            Option(id: 1, text: "1912", correct: true),
            Option(id: 2, text: "1905", correct: false),
            Option(id: 3, text: "1920", correct: false),
            Option(id: 4, text: "1918", correct: false),
        ],
        mChoice: false
    ),
])

let dummyUser = [
    User(id: 1, name: "mthaler", fullName: "Marius Thaler", year: 5, uClass: "5AHIT", role: "Schüler"),
    User(id: 2, name: "rtarnoczi", fullName: "Raphael Tarnoczi", year: 4, uClass: "4BHIT", role: "Schüler"),
    User(id: 3, name: "tenzi", fullName: "Timo Enzi", year: 1, uClass: "1CHIT", role: "Schüler"),
    User(id: 4, name: "nredl", fullName: "Nikolaus Redl", year: 2, uClass: "2BHIT", role: "Schüler"),
    User(id: 4, name: "mturetschek", fullName: "Marcel Turetschek", year: 2, uClass: "2BHIT", role: "Schüler")
]

