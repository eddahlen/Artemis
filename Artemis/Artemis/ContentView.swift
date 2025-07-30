//
//  ContentView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI

struct ContentView: View {
    var subreddit: String
    @StateObject private var viewModel = RedditViewModel()
    @State private var sort: RedditSort = .best
    @State private var showSortSheet = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom top bar
                HStack {
                    Text("r/\(subreddit)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Button {
                        showSortSheet = true
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .font(.title3)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)

                // Post list
                List(viewModel.posts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        HStack(alignment: .top, spacing: 10) {
                            if let thumbnailURL = post.thumbnail,
                               !["self", "default", "nsfw", "image", "spoiler"].contains(thumbnailURL),
                               thumbnailURL.hasPrefix("http"),
                               let url = URL(string: thumbnailURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(6)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(post.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("u/\(post.author)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .onAppear {
                viewModel.fetchPosts(from: subreddit, sort: sort)
            }
            .actionSheet(isPresented: $showSortSheet) {
                ActionSheet(
                    title: Text("Sort by..."),
                    buttons: RedditSort.allCases.map { option in
                        .default(Text(option.displayName)) {
                            sort = option
                            viewModel.fetchPosts(from: subreddit, sort: option)
                        }
                    } + [.cancel()]
                )
            }
            .navigationBarHidden(true)
        }
    }
}
