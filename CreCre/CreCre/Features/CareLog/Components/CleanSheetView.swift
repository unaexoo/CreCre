//
//  CleanSheetView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI
import CoreData

struct CleanSheetView: View {
    let gecko: Gecko
    @Environment(\.dismiss) private var dismiss

    @State private var date: Date = Date()
    @State private var selectedCleanType: CleanType = .spot

    init(gecko: Gecko) {
        self.gecko = gecko
    }

    var body: some View {
        VStack(spacing: .largeSpacing) {
            Text("청소 기록 추가")
                .font(.title)
                .foregroundStyle(.accent)
                .bold()
            
            HStack {
                Text("날짜")
                    .font(.headline)
                    .foregroundStyle(.accent)
                Spacer()
                DateFieldView(date: $date)
            }

            VStack(alignment: .leading, spacing: .defaultSpacing) {
                Text("청소 정도")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack (spacing: .defaultSpacing){
                    ForEach(CleanType.allCases, id: \.self) { clean in
                        ChipButton(title: clean.description, isSelected: selectedCleanType == clean) {
                            selectedCleanType = clean
                        }

                    }
                }
            }

            Spacer()
            
            SaveButton(title: "저장", color: .accent) {
                RecordService.shared.addClean(
                    to: gecko,
                    date: date,
                    type: selectedCleanType
                )
                dismiss()
            }
        }
        .padding(.defaultSpacing)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleGecko = Gecko(context: context)
    sampleGecko.name = "미리보기 개체"

   return CleanSheetView(gecko: sampleGecko)
}
