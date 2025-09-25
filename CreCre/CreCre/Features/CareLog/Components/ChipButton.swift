//
//  ChipButton.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//


import SwiftUI

struct ChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.horizontal, .defaultSpacing)
                .padding(.vertical, .smallSpacing)
                .background(isSelected ? .accent : .clear)
                .foregroundStyle(isSelected ? .white : .accent)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(.accent, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
