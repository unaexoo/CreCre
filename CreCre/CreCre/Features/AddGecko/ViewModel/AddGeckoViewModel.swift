//
//  AddGeckoViewModel.swift
//  CreCre
//
//  Created by 윤혜주 on 9/25/25.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine

class AddGeckoViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var morph: String = ""

    @Published var selectedSex: Sex = .unknown
    @Published var birthDate: Date = Date()
    @Published var adoptionDate: Date = Date()

    @Published var sireName: String = ""
    @Published var damName: String = ""

    // 이미지 피커 관련
    @Published var selectedPhotoItem: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(from: selectedPhotoItem)
            }
        }
    }
    @Published var selectedImage: Image?
    private var selectedPhotoData: Data?

    @Published var shouldDismiss: Bool = false

    let navigationTitle: String

    private let type: AddGeckoView.Mode
    private var gecko: Gecko? // 수정할 개체

    init(type: AddGeckoView.Mode, gecko: Gecko? = nil) {
        self.type = type
        self.gecko = gecko
        self.navigationTitle = (type == .add) ? "도마뱀 프로필 등록하기" : "도마뱀 프로필 수정하기"

        // 수정 모드일 경우, 전달받은 gecko 데이터로 프로퍼티 초기화
        if let gecko = gecko {
            self.name = gecko.name ?? ""
            self.morph = gecko.morph ?? ""
            self.selectedSex = Sex(rawValue: gecko.sex) ?? .unknown
            self.birthDate = gecko.birthDate ?? Date()
            self.adoptionDate = gecko.adoptedDate ?? Date()
            self.sireName = gecko.sire?.name ?? ""
            self.damName = gecko.dam?.name ?? ""

            // 기존 이미지 로드
            loadImageFromPath(gecko.imagePath)
        }
    }

    /// PhotosPickerItem으로부터 이미지를 비동기적으로 로드
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                self.selectedPhotoData = data
                if let uiImage = UIImage(data: data) {
                    self.selectedImage = Image(uiImage: uiImage)
                }
            }
        } catch {
            print("Error: 이미지 데이터를 로드하는 데 실패했습니다. \(error)")
        }
    }

    /// 파일 경로로부터 기존 이미지를 로드
    private func loadImageFromPath(_ imagePath: String?) {
        guard let imagePath = imagePath, !imagePath.isEmpty else { return }
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = documentsDirectory.appendingPathComponent(imagePath)

        do {
            let imageData = try Data(contentsOf: fileURL)
            if let uiImage = UIImage(data: imageData) {
                self.selectedImage = Image(uiImage: uiImage)
            }
        } catch {
            print("Error: 파일 경로에서 이미지를 로드하는 데 실패했습니다. \(error)")
        }
    }

    /// 선택된 이미지를 Documents 디렉토리에 저장하고 파일 경로를 반환
    private func saveImageToDocuments(data: Data) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Documents 디렉토리를 찾을 수 없습니다.")
            return nil
        }

        let fileName = UUID().uuidString + ".jpeg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error: 이미지를 저장하는 데 실패했습니다. \(error)")
            return nil
        }
    }

    /// 입력된 데이터를 GeckoService를 통해 저장 (추가 또는 업데이트)
    func saveGecko() {
        var imagePath: String? = gecko?.imagePath // 기본값은 기존 이미지 경로

        // 새로운 이미지가 선택되었다면 저장하고 경로를 업데이트
        if let photoData = selectedPhotoData {
            imagePath = saveImageToDocuments(data: photoData)
        }

        // 부모 개체 찾기
        let sire = sireName.isEmpty ? nil : GeckoService.shared.findGecko(byName: sireName)
        let dam = damName.isEmpty ? nil : GeckoService.shared.findGecko(byName: damName)

        if type == .add {
            GeckoService.shared.addGecko(
                name: name,
                sex: selectedSex,
                birthDate: birthDate,
                adoptedDate: adoptionDate,
                morph: morph.isEmpty ? nil : morph,
                imagePath: imagePath,
                sire: sire,
                dam: dam
            )
        } else if let geckoToUpdate = gecko {
            GeckoService.shared.updateGecko(
                geckoToUpdate,
                name: name,
                sex: selectedSex,
                birthDate: birthDate,
                adoptedDate: adoptionDate,
                morph: morph.isEmpty ? nil : morph,
                imagePath: imagePath,
                sire: sire,
                dam: dam
            )
        }

        // 저장이 완료되었음을 View에 알림
        shouldDismiss = true
    }
}
