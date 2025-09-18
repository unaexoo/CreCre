//
//  GeckoImageView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import SwiftUI
import CoreData

struct GeckoImageView: View {
    let gecko: Gecko

    /// gecko.imagePath를 기반으로 불러온 최종 이미지
    private var loadedImage: Image? {
        // 1. imagePath가 비어있는지 확인
        guard let imageName = gecko.imagePath, !imageName.isEmpty else {
            return nil
        }

        // 2. 앱의 Documents 디렉토리 경로 찾기
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        // 3. 전체 파일 경로 생성 (Documents 경로 + 파일 이름)
        let fileURL = documentsDirectory.appendingPathComponent(imageName)

        // 4. 해당 경로에서 이미지 데이터 불러오기
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }

        // 5. 이미지 데이터를 UIImage로 변환 후 SwiftUI Image로 최종 반환
        guard let uiImage = UIImage(data: imageData) else {
            return nil
        }

        return Image(uiImage: uiImage)
    }

    var body: some View {
        // loadedImage가 있으면 해당 이미지를 보여주고,
        // 없으면 (imagePath가 nil이거나, 파일이 없는 경우) 기본 아이콘을 보여줌
        if let image = loadedImage {
            image
                .resizable() // 프레임에 맞게 크기 조절 가능하도록 설정
                .scaledToFill() // 프레임을 꽉 채우도록 비율 유지하며 확대/축소
        } else {
            // 이미지가 없을 때 보여줄 플레이스홀더
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray.opacity(0.3))
                .padding() // 아이콘이 너무 꽉 차지 않도록 약간의 여백 추가
        }
    }
}

#Preview("상태별 보기") {
    // 미리보기용 Core Data 컨텍스트
    let context = PersistenceController.preview.container.viewContext

    // --- 1. 이미지가 없을 때 ---
    let geckoWithoutImage = Gecko(context: context)
    geckoWithoutImage.name = "대추"
    geckoWithoutImage.imagePath = nil

    // --- 2. 이미지가 있을 때 ---
    let geckoWithImage = Gecko(context: context)
    geckoWithImage.name = "나무"
    geckoWithImage.imagePath = savePreviewImage(name: "sample-gecko")

    return VStack(spacing: 20) {
        Text("이미지가 없을 때")
        GeckoImageView(gecko: geckoWithoutImage)
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))

        Text("이미지가 있을 때")
        GeckoImageView(gecko: geckoWithImage)
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


/// 프리뷰 전용: Assets 이미지를 파일로 저장하고 파일 이름을 반환하는 헬퍼 함수
fileprivate func savePreviewImage(name: String) -> String? {
    guard let uiImage = UIImage(named: name),
          let data = uiImage.jpegData(compressionQuality: 0.8),
          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }

    let fileName = "\(UUID().uuidString).jpg"
    let fileURL = documentsDirectory.appendingPathComponent(fileName)

    try? data.write(to: fileURL)

    return fileName
}
