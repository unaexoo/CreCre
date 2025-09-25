//
//  CustomSegmentedControl.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import Foundation
import SwiftUI

protocol SegmentedControlOption: CaseIterable, Identifiable, Hashable {
    var title: String { get }
}

struct CustomSegmentedControl<Option: SegmentedControlOption>: View {
    @Binding var selection: Option
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(Option.allCases), id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selection = option
                    }
                } label: {
                    Text(option.title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(selection == option ? Color.accent : Color.white)
                        .padding(.vertical, .smallSpacing/2)
                        .frame(maxWidth: .infinity)
                        .background {
                            if selection == option {
                                RoundedRectangle(cornerRadius: .defaultRadius)
                                    .fill(Color.white)
                                    .matchedGeometryEffect(id: "selectedSegment", in: namespace)
                            }
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(option.title))
                .accessibilityAddTraits(selection == option ? .isSelected : [])
            }
        }
        .padding(.smallSpacing/2)
        .background(
            RoundedRectangle(cornerRadius: .defaultRadius + 5)
                .fill(.accent)
        )
    }
}

#Preview {
    struct CustomSegmentedControlPreview: View {
        // 테스트를 위한 enum 정의
        enum ExampleSection: String, SegmentedControlOption {
            case today = "오늘 케어"
            case log = "기록"
            case routine = "루틴"

            var id: String { self.rawValue }
            var title: String { self.rawValue } 
        }

        @State private var selectedSection: ExampleSection = .today

        var body: some View {
            VStack {
                CustomSegmentedControl(selection: $selectedSection)
                Text("선택된 섹션: \(selectedSection.title)")
            }
            .padding()
        }
    }
    return CustomSegmentedControlPreview()
}
