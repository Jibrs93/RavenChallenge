//
//  RavenChallengeApp.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import SwiftUI

@main
struct RavenChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleListView(viewModel: MostPopularAssembly.makeArticleListViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
