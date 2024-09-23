//
//  HyphenatedText.swift
//  SwiftUI-HyphenatedText
//
//  Created by Vikram Kriplaney on 22.09.2024.
//

import SwiftUI

/// Presents a `Text` view that hyphenates its contents according to the current locale.
/// It responds to changes in the SwiftUI environment's `locale`.
public struct HyphenatedText: View {
    let key: String
    @Environment(\.locale) private var locale
    @State private var localizedString: String

    public init(_ key: String) {
        self.key = key
        self.localizedString = key
    }

    public var body: some View {
        Text(verbatim: localizedString)
            .onAppear {
                localizedString = locale.localized(key: key).hyphenated(locale: locale)
            }
            .id(locale) // cause an update if locale changes
    }
}

/// A short alias of ``HyphenatedText`` to facilitate replacing ``SwiftUICore/Text``.
public typealias HText = HyphenatedText

public extension Text {
    /// Initializes a `Text` view with a localized and hyphenated string.
    /// - Note: The passed key will be localized during initialization according to the app's current locale, but will
    /// *not* change dynamically with the SwiftUI environment's `locale`.
    /// - Note: Hyphenation data is not available for all locales. You can use
    /// ``Foundation/Locale/isHyphenationAvailable`` to test for availability of hyphenation data.
    /// - Parameters:
    ///   - key: The text (or localization key).
    ///   - locale: An optional locale that specifies which language's hyphenation conventions to use. Default is the
    /// current, auto-updating locale.
    init(hyphenated key: String, locale: Locale = .autoupdatingCurrent) {
        self.init(verbatim: String(localized: String.LocalizationValue(key)).hyphenated(locale: locale))
    }
}

#if DEBUG
struct HyphenatedText_Previews: PreviewProvider {
    struct Demo: View {
        let text: String
        @Environment(\.locale) private var locale
        @State private var width = 160.0

        var body: some View {
            VStack {
                Text(locale.identifier).font(.largeTitle.bold())
                Text("Auto-Hyphenation available? ")
                    + Text(locale.isHyphenationAvailable ? "Yes!" : "No").bold()
                Divider()

                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Text(text)").foregroundStyle(.secondary)
                        Text(text).border(.red)
                        Divider()
                        Text("Text(hyphenated: text)").foregroundStyle(.secondary)
                        Text(hyphenated: text, locale: locale).border(.red)
                        Divider()
                        Text("HyphenatedText(text)").foregroundStyle(.secondary)
                        HyphenatedText(text).border(.red)
                    }
                    .frame(width: width)
                    .border(Color(white: 0.5, opacity: 0.5))
                }
                #if !os(tvOS)
                Spacer()
                Slider(value: $width, in: 20...280)
                #endif
            }
            .padding()
        }
    }

    static var previews: some View {
        let samples = [
            "de_CH": "Obligatorische Kraftfahrzeughaftpflichtversicherung übersteigen",
            "fr_CH": "Dévérouiller anticonstitutionnellement la hippopotomonstrosesquipédaliophobie",
            "it_CH": "Professionalizzazione anticostituzionalissimamente gravissima",
            "es_ES": "Profesionalización anticonstitucionalmente gravísima"
        ]
        ForEach(Array(samples.keys).sorted(), id: \.self) { key in
            Demo(text: samples[key] ?? "?")
                .environment(\.locale, Locale(identifier: key))
                .previewDisplayName(key)
        }
    }
}
#endif
