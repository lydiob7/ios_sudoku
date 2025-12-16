//
//  LanguageSelectionView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 16/12/2025.
//

import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage(APP_LANGUAGE_KEY) private var appLanguage = DEFAULT_LANGUAGE_KEY

    var body: some View {
        Form {
            Section {
                ForEach(AppLanguage.allCases) { language in
                    Button {
                        appLanguage = language.rawValue
                    } label: {
                        HStack {
                            Text(language.title)
                                .foregroundStyle(Color("TextColor"))

                            Spacer()

                            if appLanguage == language.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color("AccentColor"))
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("AppBackground"))
        .navigationTitle("settings.language")
        .navigationBarTitleDisplayMode(.inline)
    }
}
