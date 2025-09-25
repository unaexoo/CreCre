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

    // @State 대신 @StateObject로 ViewModel을 소유하고 관찰
    @StateObject private var viewModel: AddGeckoViewModel

    private enum Field: Hashable {
        case name, morph, sire, dam
    }
    @FocusState private var focusedField: Field?

    enum Mode {
        case add
        case edit
    }

    // ViewModel을 주입받는 초기화 메서드
    init(type: Mode, gecko: Gecko? = nil) {
        _viewModel = StateObject(wrappedValue: AddGeckoViewModel(type: type, gecko: gecko))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .largeSpacing) {
                    // 이미지 피커
                    PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                        VStack(spacing: .smallSpacing) {
                            if let selectedImage = viewModel.selectedImage {
                                selectedImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
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

                    // 이름, 모프 (ViewModel의 @Published 프로퍼티와 바인딩)
                    HStack(spacing: .defaultSpacing) {
                        FormField(title: "이름", placeholder: "ex) 마뱀이", text: $viewModel.name)
                            .focused($focusedField, equals: .name)
                            .onSubmit { focusedField = .morph }

                        FormField(title: "모프", placeholder: "ex) 할리퀸", text: $viewModel.morph)
                            .focused($focusedField, equals: .morph)
                            .onSubmit { focusedField = nil }
                    }

                    // 성별
                    VStack(alignment: .leading, spacing: .smallSpacing) {
                        Text("성별").font(.headline).foregroundStyle(.accent)
                        HStack(spacing: .smallSpacing) {
                            ForEach(Sex.allCases) { sex in
                                Button {
                                    viewModel.selectedSex = sex
                                } label: {
                                    Text(sex.description)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, .smallSpacing)
                                        .foregroundStyle(viewModel.selectedSex == sex ? .white : .secondary)
                                        .background {
                                            if viewModel.selectedSex == sex {
                                                RoundedRectangle(cornerRadius: .defaultRadius).fill(.accent)
                                            } else {
                                                RoundedRectangle(cornerRadius: .defaultRadius).stroke(.secondary.opacity(0.8), lineWidth: 1)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // 생일, 입양일
                    HStack(spacing: .defaultSpacing) {
                        VStack(alignment: .leading) {
                            Text("생일")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.accent)

                            DateFieldView(date: $viewModel.birthDate)
                        }

                        Spacer()
                        VStack(alignment: .leading) {
                            Text("입양일")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.accent)
                            
                            DateFieldView(date: $viewModel.adoptionDate)
                        }
                    }

                    // 부모 정보
                    VStack(alignment: .leading) {
                        Text("부모 정보")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)

                        Text("부모 정보를 모르는 경우 생략할 수 있습니다.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        HStack(spacing: .defaultSpacing) {
                            FormField(title: "아빠 마뱀", placeholder: "아빠 마뱀이 이름", text: $viewModel.sireName)
                                .focused($focusedField, equals: .sire)
                                .onSubmit { focusedField = .dam }

                            Spacer()

                            FormField(title: "엄마 마뱀", placeholder: "엄마 마뱀이 이름", text: $viewModel.damName)
                                .focused($focusedField, equals: .dam)
                                .onSubmit { focusedField = nil }
                        }
                    }
                }
                .padding(.defaultSpacing)
            }
            .safeAreaInset(edge: .bottom) {
                SaveButton(color: .main, action: {
                    focusedField = nil
                    viewModel.saveGecko()
                })
                .padding(.horizontal, .defaultSpacing)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.navigationTitle)
                        .font(.title2)
                        .foregroundColor(.accent)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onChange(of: viewModel.shouldDismiss) { _, newValue in
                if newValue {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddGeckoView(type: .add)
}
