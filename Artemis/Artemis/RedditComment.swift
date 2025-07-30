//
//  RedditComment.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import Foundation

// Response is an array of two items, so we decode [RedditCommentResponse]
struct RedditCommentResponse: Decodable {
    let data: RedditCommentData
}

struct RedditCommentData: Decodable {
    let children: [RedditCommentChild]
}

struct RedditCommentChild: Decodable {
    let data: RedditComment
}

struct RedditComment: Identifiable, Decodable {
    let id: String
    let author: String?
    let body: String?
    var replies: [RedditComment]? = nil

    enum CodingKeys: String, CodingKey {
        case id, author, body, replies
    }

    struct RepliesWrapper: Decodable {
        let data: RedditCommentData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        author = try? container.decode(String.self, forKey: .author)
        body = try? container.decode(String.self, forKey: .body)

        // Try to decode replies as an object, fallback if it's a string
        if let replies = try? container.decode(RepliesWrapper.self, forKey: .replies) {
            self.replies = replies.data.children.map { $0.data }
        } else {
            self.replies = nil
        }
    }
}
