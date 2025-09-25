//
//  GeckoCardView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI

struct GeckoCardView: View {
    enum DisplayStyle {
        case home
        case careLog
    }

    let gecko: Gecko
    let style: DisplayStyle

    init(gecko: Gecko, style: DisplayStyle = .home) {
        self.gecko = gecko
        self.style = style
    }

    var body: some View {
        HStack(spacing: .defaultSpacing) {
            GeckoImageView(gecko: gecko)

            VStack(alignment: .leading, spacing: .defaultSpacing) {
                HStack(spacing: .smallSpacing) {
                    Text(gecko.name ?? "이름 없음")
                        .font(.title)
                        .foregroundStyle(.accent)

                    if let sex = Sex(rawValue: gecko.sex) {
                        sex.icon
                    }

                    Spacer()

                    if let weight = gecko.lastWeight {
                        Text(String(format: "%.1fg", weight))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(gecko.morph ?? "모프 정보 없음")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                switch style {
                case .home:
                    homeStyleInfo
                case .careLog:
                    careLogStyleInfo
                }
            }
            Spacer()
        }
        .padding(.defaultSpacing)
        .clipShape(RoundedRectangle(cornerRadius: .defaultRadius))
        .overlay(
            RoundedRectangle(cornerRadius: .defaultRadius)
                .stroke(.main, lineWidth: 2)
        )
    }

    private var homeStyleInfo: some View {
        VStack(alignment: .leading) {
             HStack {
                Text("분무")
                    .foregroundStyle(.accent)
                Group {
                    Text("아침").foregroundStyle(.secondary)
                    Circle().frame(width: 15, height: 15).foregroundColor(.white).overlay(Circle().stroke(.main, lineWidth: 1))
                    Text("저녁").foregroundStyle(.secondary)
                    Circle().frame(width: 15, height: 15).foregroundColor(.white).overlay(Circle().stroke(.main, lineWidth: 1))
                }
            }
            HStack {
                Text("피딩")
                    .foregroundStyle(.accent)
                Text("내일 밥 먹는 날")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, .smallSpacing)
            }
        }
    }

    private var careLogStyleInfo: some View {
        VStack(alignment: .leading, spacing: .smallSpacing) {
            InfoRow(title: "생일", content: gecko.birthDate?.formattedDate() ?? "정보 없음")
            InfoRow(title: "입양일", content: gecko.adoptedDate?.formattedDate() ?? "정보 없음")
        }
    }
}

// 정보 행을 위한 보조 뷰
struct InfoRow: View {
    let title: String
    let content: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.accent)
                .frame(width: 50, alignment: .leading)

            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
    }
}

// Date를 "yyyy.MM.dd" 형식의 문자열로 변환하는 Helper
fileprivate extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: self)
    }
}
