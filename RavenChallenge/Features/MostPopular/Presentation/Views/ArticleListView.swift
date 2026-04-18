//
//  ArticleListView.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel: ArticleListViewModel

    init(viewModel: ArticleListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    masthead
                    periodPicker
                    dividerLine

                    switch viewModel.state {
                    case .idle:
                        Spacer()
                    case .loading:
                        loadingView
                    case .loaded:
                        articleList
                    case .error(let message):
                        errorView(message: message)
                    }
                }
            }
            .navigationBarHidden(true)
            .task { await viewModel.loadArticles() }
        }
    }

    // MARK: - Masthead

    private var masthead: some View {
        VStack(spacing: 2) {
            Text("THE NEW YORK TIMES")
                .font(.system(.caption2, design: .serif, weight: .bold))
                .kerning(2)
                .foregroundColor(AppTheme.secondaryText)

            Text("Most Popular")
                .font(AppTheme.serif(.largeTitle))
                .foregroundColor(AppTheme.primaryText)

            dividerLine
                .padding(.top, 6)
        }
        .padding(.top, 12)
        .padding(.horizontal, AppTheme.pagePadding)
    }

    // MARK: - Period picker

    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.periodOptions, id: \.self) { period in
                Button {
                    viewModel.selectedPeriod = period
                } label: {
                    Text(periodLabel(period))
                        .font(.system(.footnote, weight: viewModel.selectedPeriod == period ? .bold : .regular))
                        .foregroundColor(
                            viewModel.selectedPeriod == period ? AppTheme.primaryText : AppTheme.secondaryText
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(AppTheme.accent)
                                .opacity(viewModel.selectedPeriod == period ? 1 : 0),
                            alignment: .bottom
                        )
                }
            }
        }
        .background(AppTheme.background)
        .padding(.horizontal, AppTheme.pagePadding)
    }

    private func periodLabel(_ days: Int) -> String {
        switch days {
        case 1:  return "LAST 24 H"
        case 7:  return "THIS WEEK"
        case 30: return "THIS MONTH"
        default: return "\(days) days"
        }
    }

    // MARK: - Offline banner

    @ViewBuilder
    private var offlineBanner: some View {
        if viewModel.isShowingCached {
            HStack(spacing: 6) {
                Image(systemName: "wifi.slash")
                Text("Sin conexión — artículos guardados")
            }
            .font(.system(.caption, weight: .medium))
            .foregroundColor(AppTheme.background)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(AppTheme.offlineYellow)
        }
    }

    // MARK: - Article list

    private var articleList: some View {
        ScrollView {
            offlineBanner

            LazyVStack(spacing: 0) {
                ForEach(viewModel.articles) { article in
                    
                    NavigationLink(destination: ArticleDetailView(
                        viewModel: ArticleDetailViewModel(article: article)
                    )) {
                        ArticleRowView(article: article)
                    }
                    .buttonStyle(.plain)

                    dividerLine
                }
            }
        }
        .scrollIndicators(.hidden)
        .background(AppTheme.background)
        .refreshable { await viewModel.loadArticles() }
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(AppTheme.primaryText)
                .scaleEffect(1.3)
            Text("Cargando artículos…")
                .font(AppTheme.bylineFont)
                .foregroundColor(AppTheme.secondaryText)
            Spacer()
        }
    }

    // MARK: - Error

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundColor(AppTheme.accent)
            Text(message)
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button {
                viewModel.retry()
            } label: {
                Text("Reintentar")
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundColor(AppTheme.background)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(AppTheme.primaryText)
                    .clipShape(Capsule())
            }
            Spacer()
        }
    }

    // MARK: - Helpers

    private var dividerLine: some View {
        Rectangle()
            .fill(AppTheme.divider)
            .frame(height: 1)
    }
}

// MARK: - Previews

#Preview("Lista cargada") {
    let repo = PreviewArticleRepository()
    let vm = ArticleListViewModel(useCase: PreviewFetchUseCase(), repository: repo)
    return ArticleListView(viewModel: vm)
        .preferredColorScheme(.dark)
}

#Preview("Estado de carga") {
    // Use case that never resolves (simulates loading)
    final class NeverResolvingUseCase: FetchMostPopularArticlesUseCaseProtocol {
        func execute(period: Int) async throws -> [Article] {
            try await Task.sleep(nanoseconds: .max)
            return []
        }
    }
    let vm = ArticleListViewModel(
        useCase: NeverResolvingUseCase(),
        repository: PreviewArticleRepository(articles: [])
    )
    return ArticleListView(viewModel: vm)
        .preferredColorScheme(.dark)
}

#Preview("Estado de error") {
    final class ErrorUseCase: FetchMostPopularArticlesUseCaseProtocol {
        func execute(period: Int) async throws -> [Article] {
            throw NetworkError.serverError(503)
        }
    }
    let vm = ArticleListViewModel(
        useCase: ErrorUseCase(),
        repository: PreviewArticleRepository(articles: [])
    )
    return ArticleListView(viewModel: vm)
        .preferredColorScheme(.dark)
}

#Preview("Sin conexión — con caché") {
    final class OfflineUseCase: FetchMostPopularArticlesUseCaseProtocol {
        func execute(period: Int) async throws -> [Article] {
            throw NetworkError.noInternet
        }
    }
    let repo = PreviewArticleRepository()
    let vm = ArticleListViewModel(useCase: OfflineUseCase(), repository: repo)
    return ArticleListView(viewModel: vm)
        .preferredColorScheme(.dark)
}
