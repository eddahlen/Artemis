//
//  RedditViewModel.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import Foundation

// MARK: - Sort Options

enum RedditSort: String, CaseIterable {
    case best, hot, top, new, rising, controversial

    var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - Post Model

struct RedditPost: Identifiable, Decodable {
    let id: String
    let title: String
    let author: String
    let thumbnail: String?
    let url: String?
}

// MARK: - ViewModel

class RedditViewModel: ObservableObject {
    @Published var posts: [RedditPost] = []

    func fetchPosts(from subreddit: String = "popular", sort: RedditSort = .best) {
        let endpoint = "https://www.reddit.com/r/\(subreddit)/\(sort.rawValue).json"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ios:Artemis:0.1 (by /u/yourusername)", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(RedditResponse.self, from: data)
                DispatchQueue.main.async {
                    self.posts = decoded.data.children.map { $0.data }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}

// MARK: - Reddit API Response Models

struct RedditResponse: Decodable {
    let data: RedditListingData
}

struct RedditListingData: Decodable {
    let children: [RedditListingChild]
}

struct RedditListingChild: Decodable {
    let data: RedditPost
}
