//
//  SearchViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import Foundation
import Combine
import CoreData
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published private(set) var results: [Shopper] = []
    @Published var isLoading: Bool = false
    @Published var searchedString: String = ""
    
    @Published var showDuplicateRequestAlert: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(_ context: NSManagedObjectContext) {
        $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self = self else { return }

                self.searchTask?.cancel()
                self.searchTask = Task {
                    let fetchedResults = await Database.users.shoppers.search(query: value, context: context)
                    self.isLoading = true
                    await MainActor.run {
                        self.results = fetchedResults
                        self.isLoading = false
                        self.searchedString = self.query
                    }
                }
            }
            .store(in: &cancellables)
    }
}
