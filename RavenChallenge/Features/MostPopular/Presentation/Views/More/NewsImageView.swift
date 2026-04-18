//
//  NewsImageView.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import SwiftUI

struct NewsImageView: View {
    let urlString: String?
    let aspectRatio: CGFloat

    init(urlString: String?, aspectRatio: CGFloat = 1) {
        self.urlString = urlString
        self.aspectRatio = aspectRatio
    }

    var body: some View {
        if let urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    placeholder
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(AppTheme.surfaceElevated)
            .overlay(
                Image(systemName: "newspaper")
                    .font(.system(size: 22))
                    .foregroundColor(AppTheme.secondaryText)
            )
    }
}

// MARK: - Previews

#Preview("Con imagen") {
    NewsImageView(urlString: "https://static01.nyt.com/images/2024/04/01/multimedia/01CLI-TOPSTORIES/01CLI-TOPSTORIES-mediumThreeByTwo440.jpg")
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
}

#Preview("Sin imagen (placeholder)") {
    NewsImageView(urlString: nil)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
}
