//
//  ContentView.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

// ContentView.swift is kept for SwiftUI previews.
// The app entry point uses ArticleListView directly via RavenChallengeApp.swift.

import SwiftUI

struct ContentView: View {
    var body: some View {
        ArticleListView(viewModel: MostPopularAssembly.makeArticleListViewModel())
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
