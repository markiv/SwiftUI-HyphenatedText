//
//  String+Hyphenation.swift
//  SwiftUI-HyphenatedText
//
//  Created by Vikram Kriplaney on 22.09.2024.
//

import Foundation

public extension String {
    static let softHyphen = "\u{00AD}"

    /// Applies hyphenation to a given text.
    /// - Parameters:
    ///   - hyphen: The string to use as a hyphenation separator. Default is a single soft hyphen character (Unicode
    /// U+00AD).
    ///   - locale: A valid locale that specifies which language's hyphenation conventions to use. Default is the
    /// current, auto-updating locale.
    /// - Note:  Hyphenation data is not available for all locales. You can use
    /// ``Foundation/Locale/isHyphenationAvailable`` to test for availability of hyphenation data.
    /// - Returns: A string hyphenated according to the given locale.
    func hyphenated(with hyphen: String = Self.softHyphen, locale: Locale = .autoupdatingCurrent) -> String {
        guard locale.isHyphenationAvailable else { return self }
        return split(separator: " ")
            .map { String($0).hyphenatedWord(with: hyphen, locale: locale) }
            .joined(separator: " ")
    }

    /// Applies hyphenation to a single word. See ``Swift/String/hyphenated(with:locale:)`` for a complete description.
    private func hyphenatedWord(with hyphen: String, locale: Locale) -> String {
        let copy = NSMutableString(string: self)
        var index = count
        while true {
            let range = CFRangeMake(0, index)
            index = CFStringGetHyphenationLocationBeforeIndex(
                self as NSString, index, range, .zero, locale as CFLocale, nil
            )
            if index > 0 {
                copy.insert(hyphen, at: index)
            } else {
                break
            }
        }
        return copy as String
    }
}
