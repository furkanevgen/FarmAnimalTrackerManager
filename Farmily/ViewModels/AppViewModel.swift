import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var showLanguageSelection = false
    @Published var showFarmScreen = false
    @Published var isLoading = false
    @Published var farmLink: String?
    
    private let storageService = StorageService.shared
    private let apiService = APIService.shared
    
    init() {
        checkInitialState()
    }
    
    private func checkInitialState() {
        if storageService.hasToken() {
            if let link = storageService.getLink() {
                farmLink = link
                showFarmScreen = true
            } else {
                fetchServerData()
            }
        } else {
            fetchServerData()
            if !storageService.hasSeenLanguageSelection() {
                showLanguageSelection = true
            }
        }
    }
    
    func languageSelected() {
        storageService.setHasSeenLanguageSelection(true)
        showLanguageSelection = false
        if farmLink != nil {
            showFarmScreen = true
        }
    }
    
    func fetchServerData() {
        Task { @MainActor in
            do {
                let result = try await withTimeout(seconds: 15) {
                    try await self.apiService.fetchServerData()
                }
                storageService.saveToken(result.token)
                storageService.saveLink(result.link)
                farmLink = result.link
                
                showFarmScreen = true
            } catch {
            }
        }
    }
    
    private func withTimeout<T>(seconds: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                throw NSError(domain: "TimeoutError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Request timeout"])
            }
            
            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }
}

