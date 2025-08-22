//
//  PackModel.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 22/08/25.
//

import Foundation

struct PackModel: Decodable {
    let id: String
    let title: String
    let kanji: [String]
}
