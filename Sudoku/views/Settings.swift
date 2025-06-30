//
//  Settings.swift
//  Sudoku
//
//  Created by Tomi Scattini on 29/06/2025.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack {
            Text("Settings screen")
        }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundStyle(Color("TextColor"))
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
