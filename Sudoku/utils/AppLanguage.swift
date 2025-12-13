//
//  AppLanguage.swift
//  Sudoku
//
//  Created by Tomi Scattini on 13/12/2025.
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case spanish = "es"
    case english = "en"

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .spanish: return "language.spanish"
        case .english: return "language.english"
        }
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }
}
