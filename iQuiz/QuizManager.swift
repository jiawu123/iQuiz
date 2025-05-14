//
//  QuizManager.swift
//  iQuiz
//
//  Created by Jia Wu on 5/14/25.
//

import Foundation
class QuizManager {
    static let shared = QuizManager()
    var quizzes: [Quiz]? = nil

    private init() {} // Prevent external init
}
