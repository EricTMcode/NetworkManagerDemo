//
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

import SwiftUI

struct Joke2:Identifiable, Codable {
    let id: Int
    let setup: String
    let punchline: String
    let entryDate: Date
}

struct JokesView2: View {
    @State private var jokes: [Joke2] = []
    let manager = NetworkManager.shared
    @State private var networkError: NetworkError? = nil

    var body: some View {
        Group {
            if !jokes.isEmpty {
                List(jokes.shuffled()) { joke in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(joke.setup)
                            .font(.headline)
                        Text(joke.punchline)
                        Text(joke.entryDate, format: .dateTime.month().day().year())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            } else {
                ContentUnavailableView("No Jokes available", systemImage: "hand.thumbsdown.fill")
            }
        }
        .task {
//            jokes = await manager.fetchAndDecodeJSON(from: TestURL.jokesURL)
            do {
                jokes = try await manager.fetchAndDecodeJSON(from: TestURL.jokesURL) { decoder in
                    decoder.dateDecodingStrategy = .iso8601
            }
            }  catch let error as NetworkError {
                networkError = error
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        JokesView2()
            .navigationTitle(ViewOption.fourth.title)
            .toolbarTitleDisplayMode(.inlineLarge)
    }
}
