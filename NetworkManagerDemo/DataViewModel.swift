//
//  DataViewModel.swift
//  NetworkManagerDemo
//
//  Created by Eric on 13/03/2026.
//

import SwiftUI

@Observable
class DataViewModel<T: Decodable> {
    var data: T?
    private let manager = NetworkManager.shared
    var networkError: NetworkError? = nil
    var isLoading = false
    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    func fetchData() async {
        isLoading = true
        networkError = nil

        defer { isLoading = false }

        #if DEBUG
        try? await Task.sleep(for: .seconds(2))
        #endif
        
        do {
            data = try await manager.fetchAndDecodeJSON(from: urlString)
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
