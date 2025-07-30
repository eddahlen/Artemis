//
//  SubredditSuggestion.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//

import Foundation

struct SubredditAutocompleteResponse: Decodable {
    let data: SubredditSuggestionData
}

struct SubredditSuggestionData: Decodable {
    let children: [SubredditChild]
}

struct SubredditChild: Decodable {
    let data: SubredditSuggestion
}

struct SubredditSuggestion: Decodable, Identifiable {
    let id = UUID() // Reddit doesn’t return an ID
    let display_name: String
    let title: String?
}

