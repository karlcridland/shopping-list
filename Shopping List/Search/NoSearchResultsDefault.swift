//
//  NoSearchResultsDefault.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import SwiftUI

struct NoSearchResultsDefault: View {
    
    private let iconColor: Color = Color(.charcoal).opacity(0.6)
    
    @Binding var query: String
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(text)
                    .frame(maxWidth: 300)
                    .foregroundStyle(iconColor)
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var defaultText: String {
        query == "" ? "Type in the search bar to\nstart finding friends." : "No results found for \"\(query)\"."
    }
    
    private var loadingText: String {
        "Loading..."
    }
    
    private var text: String {
        isLoading ? loadingText : defaultText
    }
    
}
