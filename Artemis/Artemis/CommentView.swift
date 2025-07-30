//
//  CommentView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI

struct CommentView: View {
    let comment: RedditComment
    let depth: Int

    @State private var isCollapsed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 2)
                    .padding(.leading, CGFloat(depth) * 12)

                VStack(alignment: .leading, spacing: 4) {
                    // Tappable summary (author + collapse toggle)
                    HStack {
                        Text(comment.author ?? "[deleted]")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text(isCollapsed ? "[+]" : "[–]")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .onTapGesture {
                        withAnimation {
                            isCollapsed.toggle()
                        }
                    }

                    // Only show comment body if expanded
                    if !isCollapsed {
                        Text(comment.body ?? "")
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Only show replies if expanded
            if !isCollapsed, let replies = comment.replies {
                ForEach(replies) { reply in
                    CommentView(comment: reply, depth: depth + 1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
