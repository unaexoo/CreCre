//
//  DateFieldView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/19/25.
//

import SwiftUI

struct DateFieldView: View {
    let title: String
    @Binding var date: Date

    @State private var isPresented: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)

            Button {
                isPresented = true
            } label: {
                HStack(spacing: .smallSpacing) {
                    Text(DateFormatter.dateFormatter.string(from: date))
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Image(systemName: "chevron.down")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, .smallSpacing)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $isPresented) {
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
