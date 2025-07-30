//
//  MainTabView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI

struct MainTabView: View {
    @StateObject var appState = AppState()

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ContentView(subreddit: appState.selectedSubreddit)
                .tabItem {
                    Label("Posts", systemImage: "newspaper")
                }
                .tag(0)

            SubredditSearchView(appState: appState)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)

            PlaceholderView(name: "Inbox").tabItem {
                Label("Inbox", systemImage: "envelope")
            }.tag(2)

            PlaceholderView(name: "User").tabItem {
                Label("User", systemImage: "person.circle")
            }.tag(3)

            PlaceholderView(name: "Settings").tabItem {
                Label("Settings", systemImage: "gear")
            }.tag(4)
        }
    }
}
