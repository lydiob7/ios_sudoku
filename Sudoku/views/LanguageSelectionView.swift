// This file is part of Sudoku b7.
//
// Copyright (C) 2024 Tomás Scattini
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
