//
//  AddGeckoView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/19/25.
//

import SwiftUI
import PhotosUI


struct AddGeckoView: View {
    @Environment(\.dismiss) var dismiss

    private enum Field: Hashable {
        case name
        case morph
        case sire
        case dam
    }

    enum Mode {
        case add
        case edit
    }
    // 이미지 피커 관련
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedPhotoData: Data?

    // 텍스트 필드
    @State private var name: String = ""
    @State private var morph: String = ""

    // 성별 피커
    @State private var selectedSex: Sex = .unknown

    // 날짜 피커
    @State private var birthDate: Date = Date()
    @State private var adoptionDate: Date = Date()

    @State private var sireName: String = ""
    @State private var damName: String = ""

    @FocusState private var focusedField: Field?

    var type: Mode
    var gecko: Gecko?

    init(type: Mode = .add, gecko: Gecko? = nil) {
        self.type = type
        self.gecko = gecko

        _name = State(initialValue: gecko?.name ?? "")
        _morph = State(initialValue: gecko?.morph ?? "")
        _selectedSex = State(initialValue: Sex(rawValue: gecko?.sex ?? 0) ?? .unknown)
        _birthDate = State(initialValue: gecko?.birthDate ?? Date())
        _adoptionDate = State(initialValue: gecko?.adoptedDate ?? Date())
        _sireName = State(initialValue: gecko?.sire?.name ?? "")
        _damName = State(initialValue: gecko?.dam?.name ?? "")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .largeSpacing) {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        VStack(spacing: .smallSpacing) {
                            if let selectedImage {
                                selectedImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle()
                                        .stroke(.accent.opacity(0.5), lineWidth: 1))
                            } else {
                                Image(systemName: "lizard.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .foregroundStyle(.main)
                            }
                            Text("사진 추가")
                                .foregroundStyle(.accent)
                        }
                    }
                    .onChange(of: selectedPhotoItem) { newItem, _  in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }

                    // 이름, 모프
                    HStack(spacing: .defaultSpacing) {
                        FormField(title: "이름", placeholder: "ex) 마뱀이", text: $name)
                            .focused($focusedField, equals: .name)
                            .onSubmit {
                                focusedField = .morph
                            }


                        FormField(title: "모프", placeholder: "ex) 할리퀸", text: $morph)
                            .focused($focusedField, equals: .morph)
                            .onSubmit {
                                focusedField = nil
                            }
                    }


                    // 성별
                    VStack(alignment: .leading, spacing: .smallSpacing) {
                        Text("성별")
                            .font(.headline)
                            .foregroundStyle(.accent)

                        HStack(spacing: .smallSpacing) {
                            ForEach(Sex.allCases) { sex in
                                Button {
                                    selectedSex = sex
                                } label: {
                                    Text(sex.description)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, .smallSpacing)
                                        .foregroundStyle(selectedSex == sex ? .white : .secondary)
                                        .background {
                                            if selectedSex == sex {
                                                RoundedRectangle(cornerRadius: .defaultRadius)
                                                    .fill(.accent)
                                            } else {
                                                RoundedRectangle(cornerRadius: .defaultRadius)
                                                    .stroke(.secondary.opacity(0.8), lineWidth: 1)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // 생일, 입양일
                    HStack(spacing: .defaultSpacing){
                        DateFieldView(title: "생일", date: $birthDate)

                        Spacer()

                        DateFieldView(title: "입양일", date: $adoptionDate)
                    }

                    // 부모 정보
                    VStack(alignment: .leading, spacing: .smallSpacing) {
                        Section {
                            HStack(spacing: .defaultSpacing) {
                                FormField(title: "아빠 마뱀", placeholder: "아빠 마뱀이 이름", text: $sireName)
                                    .focused($focusedField, equals: .sire)
                                    .onSubmit {
                                        focusedField = .dam
                                    }

                                Spacer()

                                FormField(title: "엄마 마뱀", placeholder: "엄마 마뱀이 이름", text: $damName)
                                    .focused($focusedField, equals: .dam)
                                    .onSubmit {
                                        focusedField = nil
                                    }
                            }
                        } header: {
                            Text("부모 정보")
                        } footer: {
                            Text("부모 정보를 모르는 경우 생략할 수 있습니다.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .textCase(nil)
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    focusedField = nil
                    saveGecko()
                } label: {
                    Text("저장")
                        .font(.title3).fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.main)
                        .clipShape(RoundedRectangle(cornerRadius: .defaultRadius))
                }
                .padding(.horizontal, .defaultSpacing)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(type == .add ? "도마뱀 프로필 등록하기" : "도마뱀 프로필 수정하기")
                        .font(.title2)
                        .foregroundColor(.accent)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

// 이름, 모프 입력을 위한 뷰
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

private extension AddGeckoView {
    func loadImageEditMode() {
        guard type == .edit, let imagePath = gecko?.imagePath, !imagePath.isEmpty else {
            return
        }

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent(imagePath)

        do {
            let imageData = try Data(contentsOf: fileURL)
            if let uiImage = UIImage(data: imageData) {
                self.selectedImage = Image(uiImage: uiImage)
            }
        } catch {
            print("Error: 이미지를 로드하는 데 실패했습니다.: \(error)")
        }
    }
    func saveImageToDocuments(data: Data) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Documents 디렉토리를 찾을 수 없습니다.")
            return nil
        }

        let fileName = UUID().uuidString + ".jpeg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error: 이미지를 저장하는 데 실패했습니다. \(error)")
            return nil
        }
    }

    func saveGecko() {
        var imagePath: String? = nil

        if type == .edit {
            imagePath = gecko?.imagePath
        }

        if let photoData = selectedPhotoData {
            imagePath = saveImageToDocuments(data: photoData)
        }

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

        dismiss()
    }
}
#Preview {
    AddGeckoView()
}
