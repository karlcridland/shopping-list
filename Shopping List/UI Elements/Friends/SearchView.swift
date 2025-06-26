//
//  SearchView.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import SwiftUI
import CoreData

struct SearchView: View {
    
    @ObservedObject private var viewModel: SearchViewModel
    
    init(context: NSManagedObjectContext) {
        self.viewModel = SearchViewModel(context)
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Search users", text: $viewModel.query)
                .padding(20)
                .background(.frost)
                .textFieldStyle(.plain)
                .font(.system(size: 16, weight: .medium))
            
            if viewModel.results.isEmpty {
                NoSearchResultsDefault(query: $viewModel.searchedString, isLoading: $viewModel.isLoading)
            } else {
                ResultsView(results: viewModel.results)
            }
            
        }
    }
    
    struct ResultsView: View {
        
        @State var results: [Shopper]
        
        var body: some View {
            List(results, id: \.uid) { shopper in
                ShopperButton(shopper: shopper)
            }
            .contentMargins(12)
            .listStyle(.insetGrouped)
            .listRowSpacing(12)
        }
        
    }
}
