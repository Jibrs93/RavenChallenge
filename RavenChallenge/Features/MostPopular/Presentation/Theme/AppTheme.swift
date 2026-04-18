//
//  AppTheme.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let background     = Color(hex: "0A0A0A")
    static let surface        = Color(hex: "161616")
    static let surfaceElevated = Color(hex: "1E1E1E")
    static let primaryText    = Color(hex: "F0EDE6")   // warm white / newsprint
    static let secondaryText  = Color(hex: "8A8A8A")
    static let accent         = Color(hex: "C41E3A")   // NYT red
    static let divider        = Color(hex: "2A2A2A")
    static let offlineYellow  = Color(hex: "F5A623")

    // MARK: - Typography
    static func serif(_ style: Font.TextStyle = .title2, weight: Font.Weight = .bold) -> Font {
        .system(style, design: .serif, weight: weight)
    }

    static let sectionLabel: Font = .system(.caption, design: .default, weight: .bold)
    static let bylineFont: Font   = .system(.footnote, design: .default, weight: .regular)
    static let bodyFont: Font     = .system(.subheadline, design: .default)
    static let dateFont: Font     = .system(.caption2, design: .monospaced)

    // MARK: - Spacing
    static let pagePadding: CGFloat = 16
    static let rowSpacing: CGFloat  = 12
}
