//
//  PlaceholderView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI

struct PlaceholderView: View {
    let name: String

    var body: some View {
        VStack {
            Spacer()
            Text("\(name) screen coming soon!")
                .font(.title2)
                .foregroundColor(.gray)
            Spacer()
        }
        .navigationTitle(name)
    }
}

