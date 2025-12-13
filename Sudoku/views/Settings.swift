//
//  Settings.swift
//  Sudoku
//
//  Created by Tomi Scattini on 29/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(APP_LANGUAGE_KEY) private var appLanguage = DEFAULT_LANGUAGE_KEY
    
    var body: some View {
        Form {
            Section {
                Picker("settings.language", selection: $appLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.title)
                            .tag(language.rawValue)
                    }
                }
            }
        }
        .navigationTitle("settings_title")
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
