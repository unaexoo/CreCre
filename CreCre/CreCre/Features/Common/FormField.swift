//
//  FormField.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//
import SwiftUI

struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: .smallSpacing) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.accent)

            TextField(placeholder, text: $text)
                .padding(.smallSpacing)
                .overlay(
                    RoundedRectangle(cornerRadius: .smallRadius)
                        .stroke(.secondary.opacity(0.8), lineWidth: 1)
                )
        }
    }
}
