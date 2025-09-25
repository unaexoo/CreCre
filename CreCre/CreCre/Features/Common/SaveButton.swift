//
//  SaveButton.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI

struct SaveButton: View {
    let title: String
    let action: () -> Void
    let color: Color

    init(title: String = "저장", color: Color = .accent, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.defaultSpacing)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: .defaultRadius))
        }
    }
}

#Preview {
    SaveButton(action: {
        print("Preview Save Tapped!")
    })
    .padding()
}
