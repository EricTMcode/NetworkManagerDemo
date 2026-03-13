//
//----------------------------------------------
// Original project: PickersDeepDive
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

enum ViewOption: CaseIterable, Identifiable, View {
    case first, second, third, fourth
    var id: Self { self }
    
    var title: String {
        switch self {
        case .first:
            "Quotes Array"
        case .second:
            "Jokes Array"
        case .third:
            "Quotes Dictionary"
        case .fourth:
            "Joke + EntryDate"
        
        }
    }
    
    var picker: String {
        switch self {
        case .first:
            "Quotes Array"
        case .second:
            "Jokes Array"
        case .third:
            "Quotes Dictionary"
        case .fourth:
            "Configurable Decoder"
       
        }
    }
    
    var body: some View {
        switch self {
        case .first:
            QuotesView()
        case .second:
            JokesView()
        case .third:
            Quotes2View()
        case .fourth:
            JokesView2()
        }
    }
    
}
