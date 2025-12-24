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
