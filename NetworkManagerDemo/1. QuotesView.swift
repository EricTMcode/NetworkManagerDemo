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
    static let quotesURLStatusError = "https://httpbin.org/status/500"
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
    @State private var quotes: [Quote] = []
    let manager = NetworkManager.shared
    @State private var networkError: NetworkError? = nil

    var body: some View {
        Group {
            if !quotes.isEmpty {
                List(quotes.shuffled()) { quote in
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
            } else {
                ContentUnavailableView("No Quotes available", systemImage: "quote.closing")
            }
        }
        .task {
//            quotes = await fetchAndDecodeQuotes(from: TestURL.quotesURLBadJSON)
            do {
                quotes = try await manager.fetchAndDecodeJSON(from: TestURL.quotesURL)
            } catch let error as NetworkError {
                networkError = error
            } catch {
                print(error.localizedDescription)
            }
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
