//
//  SubredditSearchView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI

struct SubredditSearchView: View {
    @State private var subreddit: String = ""
    @ObservedObject var appState: AppState
    @FocusState private var isTextFieldFocused: Bool

    @State private var suggestions: [SubredditSuggestion] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    TextField("Enter subreddit", text: $subreddit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .focused($isTextFieldFocused)
                        .onChange(of: subreddit) { newValue in
                            fetchSuggestions(for: newValue)
                        }

                    Button("Go") {
                        guard !subreddit.isEmpty else { return }
                        appState.selectedSubreddit = subreddit
                        appState.selectedTab = 0
                        isTextFieldFocused = false
                        subreddit = ""
                        suggestions = []
                    }
                    .disabled(subreddit.isEmpty)
                }
                .padding()

                List(suggestions) { suggestion in
                    Button {
                        subreddit = suggestion.display_name
                        appState.selectedSubreddit = suggestion.display_name
                        appState.selectedTab = 0
                        isTextFieldFocused = false
                        suggestions = []
                    } label: {
                        VStack(alignment: .leading) {
                            Text("r/\(suggestion.display_name)")
                                .font(.headline)
                            if let title = suggestion.title {
                                Text(title)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())

                Spacer()
            }
            .navigationTitle("Search")
        }
    }

    func fetchSuggestions(for query: String) {
        guard !query.isEmpty,
              let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.reddit.com/api/subreddit_autocomplete_v2.json?query=\(encoded)&limit=10") else {
            suggestions = []
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ios:Artemis:0.1 (by /u/yourusername)", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(SubredditAutocompleteResponse.self, from: data)
                DispatchQueue.main.async {
                    suggestions = decoded.data.children.map { $0.data }
                }
            } catch {
                print("Autocomplete decode error:", error)
            }
        }.resume()
    }
}
