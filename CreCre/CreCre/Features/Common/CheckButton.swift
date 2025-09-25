//
//  CheckButton.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//


import SwiftUI


struct CheckButton: View {
    let title: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: { isSelected.toggle() }) {
            HStack(spacing: .smallSpacing) {
                Text(title)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            }
            .foregroundStyle(isSelected ? .accent : .secondary)
        }
        .buttonStyle(.plain)
    }
}
