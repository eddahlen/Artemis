//
//  AppState.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import Foundation

class AppState: ObservableObject {
    @Published var selectedSubreddit: String = "popular"
    @Published var selectedTab: Int = 0 // 0 = Posts tab
}

