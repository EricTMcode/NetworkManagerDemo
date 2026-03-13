//z
//----------------------------------------------
// Original project: NetworkManagerDemo
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.

enum TestURL {
    static let quotesURL = "https://stewartlynch.github.io/Samples/quotes.json"
    static let quotesURLRequestError = "https://invalid.stewartlynch.github.io/Samples/quotes.json"
    static let quotesURLResponseError = "data:text/plain,hello"
    static let quotesURLStatusError = "https://httpbin.org/status/403"
    static let quotesURLBadJSON = "https://stewartlynch.github.io/Samples/errorQuotes.json"

    static let jokesURL = "https://stewartlynch.github.io/Samples/jokes.json"

    static let quotes2URL = "https://stewartlynch.github.io/Samples/quotes2.json"
}

struct Quote: Decodable, Identifiable {
    let id: Int
    let text: String
    let author: String
    let entryDate: Date
}

import SwiftUI

struct QuotesView: View {
    @State private var viewModel = DataViewModel()

    var body: some View {
        Group {
            if !viewModel.quotes.isEmpty {
                List(viewModel.quotes.shuffled()) { quote in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(quote.text)
                            .font(.headline)
                        HStack {
                            Text(quote.author)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(quote.entryDate, format: .dateTime.month().day().year())
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
                .refreshable { Task { await viewModel.fetchData() } }
            } else {
                ContentUnavailableView("No Quotes available", systemImage: "quote.closing")
            }
        }
        .withLoader(isLoading: viewModel.isLoading, title: "quotes")
        .task {
            await viewModel.fetchData()

        }
        .alert(
            "Unable to load quotes",
            isPresented: Binding(get: {
                viewModel.networkError != nil
            }, set: { value in
                if !value { viewModel.networkError = nil }
            }),
            presenting: viewModel.networkError) { _ in
                Button("OK") { }
            } message: { networkError in
                Text(networkError.userMessage)
            }
    }
}

#Preview {
    NavigationStack {
        QuotesView()
            .navigationTitle(ViewOption.first.title)
            .toolbarTitleDisplayMode(.inlineLarge)
    }
}

@Observable
class DataViewModel {
    var quotes: [Quote] = []
    private let manager = NetworkManager.shared
    var networkError: NetworkError? = nil
    var isLoading = false

    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        try? await Task.sleep(for: .seconds(2))
        do {
            quotes = try await manager.fetchAndDecodeJSON(from: TestURL.quotesURL)
        } catch let error {
            networkError = error
        }
    }
}

struct Loader: ViewModifier {
    let isLoading: Bool
    let title: String

    func body(content: Content) -> some View {
        if isLoading {
            ProgressView("Loading \(title)")
        } else {
            content
        }
    }
}

extension View {
    func withLoader(isLoading: Bool, title: String) -> some View {
        modifier(Loader(isLoading: isLoading, title: title))
    }
}
