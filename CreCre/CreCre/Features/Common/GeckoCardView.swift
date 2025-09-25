//
//  GeckoCardView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import SwiftUI

struct GeckoCardView: View {
    let gecko: Gecko

    init(gecko: Gecko) {
        self.gecko = gecko
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

                homeStyleInfo
            }
            Spacer()
        }
        .padding(.defaultSpacing)
        .clipShape(RoundedRectangle(cornerRadius: .defaultRadius))
        .overlay(
            RoundedRectangle(cornerRadius: .defaultRadius)
                .stroke(.main, lineWidth: 0.5)
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
}

