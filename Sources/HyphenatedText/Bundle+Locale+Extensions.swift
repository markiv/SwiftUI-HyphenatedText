//
//  File.swift
//  SwiftUI-HyphenatedText
//
//  Created by Vikram Kriplaney on 22.09.2024.
//

import Foundation

public extension Bundle {
    /// Finds and returns the localization bundle for the given locale, if present, else returns this bundle.
    /// The returned localized bundle should preferably be cached to avoid calling this method repeatedly.
    func localizedBundle(for locale: Locale) -> Bundle {
        guard let languageCode = locale.languageCode,
              let preferredLocalization = Bundle.preferredLocalizations(
                from: localizations, forPreferences: [languageCode]
              ).first,
              let path = path(forResource: preferredLocalization, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else { return self }
        return bundle
    }
}

public extension Locale {
    /// Returns a Boolean value that indicates whether hyphenation data is available for this locale.
    var isHyphenationAvailable: Bool {
        CFStringIsHyphenationAvailableForLocale(self as CFLocale)
    }

    /// Returns a localized string by looking in the localization bundle corresponding to this locale if necessary.
    /// - Parameter key: the key to localize.
    /// - Returns: the localized string.
    func localized(key: String) -> String {
        if languageCode == Locale.preferredLanguages.first {
            String(localized: String.LocalizationValue(key))
        } else {
            NSLocalizedString(key, bundle: Bundle.main.localizedBundle(for: self), comment: "")
        }
    }
}
