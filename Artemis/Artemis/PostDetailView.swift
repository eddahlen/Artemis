//
//  PostDetailView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI

struct PostDetailView: View {
    let post: RedditPost
    @State private var comments: [RedditComment] = []
    @State private var isShowingFullscreenImage = false

    var body: some View {
        List {
            if let urlString = post.url,
               let url = URL(string: urlString) {

                // ✅ Show animated GIFs with WebView
                if urlString.hasSuffix(".gif") {
                    GIFWebView(url: url)
                        .frame(height: 300)
                        .cornerRadius(8)
                        .onTapGesture {
                            isShowingFullscreenImage = true
                        }

                // ✅ Show static images
                } else if urlString.hasSuffix(".jpg") || urlString.hasSuffix(".png") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                isShowingFullscreenImage = true
                            }
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.vertical, 8)
                }
            }

            // ✅ Post title
            Section(header: Text(post.title).font(.headline)) {}

            // ✅ Comments
            ForEach(comments) { comment in
                CommentView(comment: comment, depth: 0)
            }
        }
        .navigationTitle("Comments")
        .onAppear {
            fetchComments()
        }

        // ✅ Fullscreen image or GIF viewer
        .fullScreenCover(isPresented: $isShowingFullscreenImage) {
            if let urlString = post.url,
               let url = URL(string: urlString) {
                ZStack {
                    Color.black.ignoresSafeArea()

                    if urlString.hasSuffix(".gif") {
                        GIFWebView(url: url)
                            .onTapGesture {
                                isShowingFullscreenImage = false
                            }
                    } else {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    isShowingFullscreenImage = false
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }
    }

    func fetchComments() {
        let urlString = "https://www.reddit.com/comments/\(post.id).json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let json = try JSONDecoder().decode([RedditCommentResponse].self, from: data)
                let children = json.last?.data.children ?? []

                DispatchQueue.main.async {
                    self.comments = children.map { $0.data }
                }
            } catch {
                print("Comment decoding error: \(error)")
            }
        }.resume()
    }
}
