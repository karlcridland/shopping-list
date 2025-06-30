//
//  ShopperButton.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import SwiftUI

struct ShopperButton: View {

    @StateObject private var viewModel: ShopperButtonViewModel
    @StateObject private var imageLoader = ProfileImageLoader()
    
    private let buttonSize: CGFloat = 32
    private let padding: CGFloat = 8
    private let pictureVariance: CGFloat = 3

    var onAlert: (String) -> Void

    init(shopper: Shopper, onAlert: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: ShopperButtonViewModel(shopper))
        self.onAlert = onAlert
    }

    var body: some View {
        HStack(spacing: 10) {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .frame(width: buttonSize + (2 * pictureVariance), height: buttonSize + (2 * pictureVariance))
                    .background(Color(.systemGroupedBackground))
                    .clipShape(.circle)
                    .padding([.vertical, .trailing], padding - pictureVariance)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: buttonSize + (2 * pictureVariance), height: buttonSize + (2 * pictureVariance))
                    .background(Color(.systemGroupedBackground))
                    .foregroundStyle(Color(.charcoal))
                    .clipShape(.circle)
                    .padding([.vertical, .trailing], padding - pictureVariance)
            }
            VStack(alignment: .leading) {
                Text(viewModel.shopper.name.full)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(viewModel.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .italic()
                    .foregroundStyle(.charcoal.opacity(0.6))
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            if viewModel.status == .requestReceived {
                FriendRequestButtons(onAccept: viewModel.accept, onReject: viewModel.reject)
            }
            else if !(viewModel.shopper.uid?.isMyUid ?? false) && viewModel.status == nil && viewModel.hasLoaded {
                Button {
                    if let uid = viewModel.shopper.uid {
                        viewModel.quickAdd(uid, onAlert: onAlert)
                    }
                } label: {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(.systemBlue))
                        .frame(width: buttonSize, height: buttonSize)
                        .padding(padding)
                }
            }
        }
        .frame(minHeight: buttonSize + (2 * padding))
        .task {
            await viewModel.getSubtitle()
        }
    }
    
    struct FriendRequestButtons: View {
        
        var onAccept: () -> Void
        var onReject: () -> Void

        var body: some View {
            HStack(spacing: 5) {
                MarkButton(systemName: "checkmark", color: Color(.grannySmith), handle: onAccept)
                MarkButton(systemName: "xmark", color: Color(.bramley), handle: onReject)
            }
        }
        
    }
    
    private struct MarkButton: View {
        
        var systemName: String
        var color: Color
        var handle: () -> Void
        
        var body: some View {
            Button(action: {
               handle()
           }) {
               Image(systemName: systemName)
                   .font(.system(size: 18, weight: .bold))
                   .foregroundStyle(.frost)
                   .frame(width: 42, height: 42)
                   .background(color)
                   .clipShape(Circle())
           }
           .buttonStyle(.plain)
        }
        
    }
    
}
