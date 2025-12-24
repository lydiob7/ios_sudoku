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
//  Settings.swift
//  Sudoku
//
//  Created by Tomi Scattini on 29/06/2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage(APP_LANGUAGE_KEY) private var appLanguage = DEFAULT_LANGUAGE_KEY
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            
            Form {
                Section {
                    NavigationLink {
                        LanguageSelectionView()
                    } label: {
                        HStack {
                            Text("settings.language")
                                .foregroundStyle(Color("TextColor"))

                            Spacer()

                            Text(currentLanguageTitle)
                                .foregroundStyle(.secondary)

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    Button {
                        requestReview()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            
                            Text("settings.rate_app")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("AppBackground"))
            .foregroundStyle(Color("TextColor"))
            .navigationTitle("settings_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Center title (controls color explicitly)
                ToolbarItem(placement: .principal) {
                    Text("settings_title")
                        .foregroundStyle(Color("TextColor"))
                        .font(.headline)
                }
            }

            
            Text("v1.0.1")
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private var currentLanguageTitle: LocalizedStringKey {
        AppLanguage(rawValue: appLanguage)?.title ?? ""
    }
}


#Preview {
    ZStack {
        Color("AppBackground")
            .ignoresSafeArea()
        
        SettingsView()
            .foregroundStyle(Color("TextColor"))
    }
}
