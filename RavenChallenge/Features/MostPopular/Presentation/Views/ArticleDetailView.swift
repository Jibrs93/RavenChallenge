//
//  ArticleDetailView.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import SwiftUI
import SafariServices

// MARK: - Article Detail View

struct ArticleDetailView: View {
    let viewModel: ArticleDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSafari = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // ── Main scrollable content ───────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Hero image
                    NewsImageView(urlString: viewModel.article.imageURL)
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()

                    // Body card
                    VStack(alignment: .leading, spacing: 16) {

                        // Date · Source
                        Text(
                            "\(viewModel.article.formattedDate)  ·  \(viewModel.article.source)"
                        )
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(AppTheme.secondaryText)

                        // Section badge
                        Text(viewModel.article.sectionUppercased)
                            .font(.system(.caption, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 3))

                        // Title
                        Text(viewModel.article.title)
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(AppTheme.primaryText)
                            .lineSpacing(4)

                        // Divider
                        Rectangle()
                            .fill(AppTheme.divider)
                            .frame(height: 1)

                        // Author row
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill(AppTheme.surfaceElevated)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.secondaryText)
                            }
                            .frame(width: 36, height: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                if !viewModel.article.cleanByline.isEmpty {
                                    Text(viewModel.article.cleanByline)
                                        .font(.system(.subheadline, weight: .semibold))
                                        .foregroundColor(AppTheme.primaryText)
                                }
                                Text("New York Times")
                                    .font(.system(.caption))
                                    .foregroundColor(AppTheme.secondaryText)
                            }
                            Spacer()
                        }

                        // Divider
                        Rectangle()
                            .fill(AppTheme.divider)
                            .frame(height: 1)

                        // Abstract body
                        Text(viewModel.article.abstract)
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(AppTheme.primaryText)
                            .lineSpacing(7)

                        // Read full article
                        if viewModel.articleURL != nil {
                            Button { showSafari = true } label: {
                                HStack(spacing: 8) {
                                    Text("Leer artículo completo")
                                        .font(.system(.subheadline, weight: .semibold))
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(.footnote, weight: .semibold))
                                }
                                .foregroundColor(AppTheme.background)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppTheme.primaryText)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 48)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.background)
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(AppTheme.background)

            // ── Floating back button ──────────────────────────────────────
            /*Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(.top, 0)
            .padding(.leading, 16)*/
        }
        .navigationBarHidden(false)
        .sheet(isPresented: $showSafari) {
            if let url = viewModel.articleURL {
                SafariView(url: url).ignoresSafeArea()
            }
        }
    }
}

// MARK: - Safari wrapper

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.preferredBarTintColor = UIColor(AppTheme.background)
        vc.preferredControlTintColor = UIColor(AppTheme.primaryText)
        return vc
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - Previews

#Preview("Detalle — con imagen") {
    ArticleDetailView(viewModel: ArticleDetailViewModel(article: .previewMock(
        title: "White House Tried to 'Lock Down' Ukraine Call Records, Whistle-Blower Says",
        abstract: "WASHINGTON — After hearing that President Trump tried to persuade Ukraine to investigate a 2020 campaign rival, senior officials at the White House scrambled to \"lock down\" records of the call, a whistle-blower alleged in an explosive complaint released Thursday.",
        byline: "By Eileen Sullivan",
        section: "Politics",
        url: "https://www.nytimes.com",
        imageURL: "https://static01.nyt.com/images/2024/04/01/multimedia/01CLI-TOPSTORIES/01CLI-TOPSTORIES-mediumThreeByTwo440.jpg"
    )))
    .preferredColorScheme(.dark)
}

#Preview("Detalle — sin imagen") {
    ArticleDetailView(viewModel: ArticleDetailViewModel(article: .previewMock(
        title: "The Hidden Costs of Remote Work on Urban Economies",
        abstract: "Cities that once thrived on a steady stream of office workers are now grappling with the long-term consequences of a remote-work revolution that shows no signs of reversing.",
        byline: "By Maria García",
        section: "Business",
        imageURL: nil
    )))
    .preferredColorScheme(.dark)
}
