//
//  QuizModels.swift
//  iQuiz
//
//  Created by Jia Wu on 5/12/25.
//

import Foundation
struct QuizQuestion: Decodable {
    let question: String
    let choices: [String]
    let correctIndex: Int

    enum CodingKeys: String, CodingKey {
        case question = "text"
        case choices = "answers"
        case correctIndex = "answer"
    }

    // Convert string index to int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.question = try container.decode(String.self, forKey: .question)
        self.choices = try container.decode([String].self, forKey: .choices)

        let answerString = try container.decode(String.self, forKey: .correctIndex)
        guard let answerInt = Int(answerString) else {
            throw DecodingError.dataCorruptedError(forKey: .correctIndex, in: container, debugDescription: "Answer is not a valid integer string")
        }
        self.correctIndex = answerInt
    }
}


struct Quiz: Decodable {
    let title: String
    let description: String
    let questions: [QuizQuestion]

    enum CodingKeys: String, CodingKey {
        case title
        case description = "desc"
        case questions
    }
}
