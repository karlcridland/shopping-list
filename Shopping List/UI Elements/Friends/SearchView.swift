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
    @FocusState private var isFocused: Bool
    
    init(context: NSManagedObjectContext) {
        self.viewModel = SearchViewModel(context)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Add spacing above
            Spacer(minLength: 16)

            withAnimation {
                TextField("Search e.g. John Appleseed", text: $viewModel.query)
                    .contentMargins(.trailing, isFocused ? 100 : 0)
                    .padding(16)
                    .background(.frost)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .medium))
                    .focused($isFocused)
                    .submitLabel(.done)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                    .shadow(color: Color(.charcoal).opacity(0.05), radius: 6)
            }

            if viewModel.results.isEmpty {
                NoSearchResultsDefault(query: $viewModel.searchedString, isLoading: $viewModel.isLoading)
            } else {
                ResultsView(results: viewModel.results, showDuplicateRequestAlert: $viewModel.showDuplicateRequestAlert)
            }

            Spacer(minLength: 0) // Optional: fills bottom space if no results
        }
        .onAppear {
            self.isFocused = true
        }
    }
    
    struct ResultsView: View {
        
        @State var results: [Shopper]
        @Binding var showDuplicateRequestAlert: Bool
        
        var body: some View {
            List(results, id: \.uid) { shopper in
                ShopperButton(shopper: shopper, onAlert: { message in
                    showDuplicateRequestAlert = true
                })
            }
            .contentMargins(12)
            .listStyle(.insetGrouped)
            .listRowSpacing(12)
            .alert("Friend Request Already Sent", isPresented: $showDuplicateRequestAlert) {
                Button {
                    
                } label: {
                    Text("Continue")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(.systemBlue))
                }
            } message: {
                Text("You’ve already sent a friend request to this user.")
            }
        }
        
    }
}
