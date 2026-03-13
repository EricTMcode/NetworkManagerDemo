//
//----------------------------------------------
// Original project: NetworkManagerDemo
// by  Stewart Lynch on 2026-01-08
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
// Copyright © 2026 CreaTECH Solutions. All rights reserved.


import SwiftUI

struct QuotePlus: Decodable {
    let lastUpdated: Date
    let quotes: [Quote]
}

struct Quotes2View: View {
    @State private var viewModel = DataViewModel<QuotePlus>(urlString: TestURL.quotes2URL)

    var body: some View {
        Group {
            if let quotePlus = viewModel.data {
                Text(quotePlus.lastUpdated, format: .dateTime.month().day().year())
                List(quotePlus.quotes.shuffled()) { quote in
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
        .withLoader(isLoading: viewModel.isLoading, title: "quotes")
        .refreshable { Task { await viewModel.fetchData() } }
        .task { await viewModel.fetchData() }
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
        Quotes2View()
            .navigationTitle(ViewOption.third.title)
            .toolbarTitleDisplayMode(.inlineLarge)
    }
}
