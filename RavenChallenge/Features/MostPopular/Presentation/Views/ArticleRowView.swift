//
//  ArticleRowView.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left: metadata + title
            VStack(alignment: .leading, spacing: 6) {

                // Section badge
                Text(article.sectionUppercased)
                    .font(AppTheme.sectionLabel)
                    .foregroundColor(AppTheme.accent)
                    .kerning(0.8)

                // Title
                Text(article.title)
                    .font(AppTheme.serif(.subheadline, weight: .bold))
                    .foregroundColor(AppTheme.primaryText)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 4)

                // Byline + date
                HStack(spacing: 6) {
                    if !article.cleanByline.isEmpty {
                        Text(article.cleanByline)
                            .font(AppTheme.bylineFont)
                            .foregroundColor(AppTheme.secondaryText)
                            .lineLimit(1)
                    }
                    Spacer()
                    Text(article.formattedDate)
                        .font(AppTheme.dateFont)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }

            // Right: thumbnail
            NewsImageView(urlString: article.thumbnailURL)
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, AppTheme.pagePadding)
        .background(AppTheme.background)
    }
}

// MARK: - Previews

#Preview("Row — con byline") {
    VStack(spacing: 0) {
        ArticleRowView(article: .previewMock(
            title: "Can AI Fix America's Broken Political Conversation?",
            byline: "By Jonathan López",
            section: "Technology"
        ))
        Rectangle().fill(AppTheme.divider).frame(height: 1)
        ArticleRowView(article: .previewMock(
            id: 2,
            title: "The Hidden Costs of Remote Work on Urban Economies",
            byline: "By Maria García",
            section: "Business"
        ))
        Rectangle().fill(AppTheme.divider).frame(height: 1)
    }
    .background(AppTheme.background)
    .preferredColorScheme(.dark)
}

#Preview("Row — sin byline") {
    ArticleRowView(article: .previewMock(byline: "", section: "U.S."))
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}
