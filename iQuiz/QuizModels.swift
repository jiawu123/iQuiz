//
//  QuizModels.swift
//  iQuiz
//
//  Created by Jia Wu on 5/12/25.
//

import Foundation
struct QuizQuestion {
    let question: String
    let choices: [String]
    let correctIndex: Int
}

struct Quiz {
    let title: String
    let description: String
    let iconName: String
    let questions: [QuizQuestion]
}
