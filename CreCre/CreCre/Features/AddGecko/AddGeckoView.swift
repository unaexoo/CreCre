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

    private enum Field: Hashable {
        case name
        case morph
        case sire
        case dam
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .defaultSpacing) {
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

                        Spacer()

                        FormField(title: "모프", placeholder: "ex) 할리퀸", text: $morph)
                            .focused($focusedField, equals: .morph)
                            .onSubmit {
                                focusedField = nil
                            }
                    }

                    Spacer()

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

                    Spacer()

                    // 생일, 입양일
                    HStack(spacing: .defaultSpacing){
                        DateFieldView(title: "생일", date: $birthDate)

                        Spacer()

                        DateFieldView(title: "입양일", date: $adoptionDate)
                    }

                    Spacer()
                    // 부모 정보
                    VStack(alignment: .leading, spacing: .smallSpacing) {
                        HStack {
                            Text("부모 정보")
                                .font(.headline)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Text("부모 정보를 모르는 경우 생략 가능")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        HStack(spacing: .defaultSpacing) {
                            FormField(title: "아빠 마뱀",placeholder: "아빠 마뱀이 이름" ,text: $sireName)
                                .focused($focusedField, equals: .sire)
                                .onSubmit {
                                    focusedField = .dam
                                }

                            Spacer()

                            FormField(title: "엄마 마뱀", placeholder: "엄마 마뱀이 이름" ,text: $damName)
                                .focused($focusedField, equals: .dam)
                                .onSubmit {
                                    focusedField = nil
                                }
                        }
                    }

                    Spacer()

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
                    Text("도마뱀 프로필 등록하기")
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

        if let photoData = selectedPhotoData {
            imagePath = saveImageToDocuments(data: photoData)
        }

        GeckoService.shared.addGecko(
            name: name,
            sex: selectedSex,
            birthDate: birthDate,
            adoptedDate: adoptionDate,
            morph: morph.isEmpty ? nil : morph,
            imagePath: imagePath
        )

        dismiss()
    }
}
#Preview {
    AddGeckoView()
}
