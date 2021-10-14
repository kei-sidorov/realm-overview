//
//  CodeGenerator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 24.08.2021.
//

enum CodeGenerator {
    static func generate() -> String {
        let codeCharacters = "1234567890"
        return String((0...8).compactMap { _ in codeCharacters.randomElement() })
    }
}
