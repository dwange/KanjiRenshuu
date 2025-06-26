//
//  KanjiObject.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation

struct KanjiObject: Decodable {
    let kanji: KanjiDetails
    let grade: Int?
    let examples: [KanjiExamples]
}

struct KanjiDetails: Decodable {
    let character: String
    let meaning: KanjiMeaning
    let strokes: KanjiStrokes
    let onyomi: Reading
    let kunyomi: Reading
    let video: KanjiVideo
}

struct KanjiMeaning: Decodable {
    let english: String
}

struct KanjiStrokes: Decodable {
    let count: Int
    let timings: [Double]?
    let images: [String]
}

struct Reading: Decodable {
    let romaji: String
    let katakana: String?
    let hiragana: String?
}

struct KanjiVideo: Decodable {
    let poster: String?
    let mp4: String?
    let webm: String?
}

struct KanjiExamples: Decodable {
    let japanese: String
    let meaning: ExampleMeaning
    let audio: ExampleAudio
}

struct ExampleMeaning: Decodable {
    let english: String
}

struct ExampleAudio: Decodable {
    let mp3: String
}
