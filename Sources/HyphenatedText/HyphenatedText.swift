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
    let content: String
    let verbatim: Bool
    @Environment(\.locale) private var locale
    @State private var localizedContent: String
    
    /// Initializes a `HyphenatedText` view with an optionally localized string.
    /// - Note: Hyphenation data is not available for all locales. You can use
    /// ``Foundation/Locale/isHyphenationAvailable`` to test for availability of hyphenation data.
    /// - Parameters:
    ///   - content: The verbatim text string or localization key.
    ///   - verbatim: If true, the content is *not* localized. Default is false.
    public init(_ content: String, verbatim: Bool = false) {
        self.content = content
        self.localizedContent = content
        self.verbatim = verbatim
    }

    public var body: some View {
        Text(verbatim: localizedContent)
            .onAppear {
                let content = verbatim ? content : locale.localized(key: content)
                localizedContent = content.hyphenated(locale: locale)
            }
            .id(locale) // cause an update if the locale changes
    }
}

/// A short alias of ``HyphenatedText`` to facilitate replacing ``SwiftUICore/Text``.
public typealias HText = HyphenatedText

public extension Text {
    /// Initializes a `Text` view with a hyphenated (and optionally localized) string.
    /// - Note: The passed key will be localized during initialization according to the given locale, but will
    /// *not* change dynamically with the SwiftUI environment's `locale`.
    /// - Note: Hyphenation data is not available for all locales. You can use
    /// ``Foundation/Locale/isHyphenationAvailable`` to test for availability of hyphenation data.
    /// - Parameters:
    ///   - content: The verbatim text string or localization key.
    ///   - verbatim: If true, the content is *not* localized. Default is false.
    ///   - locale: An optional locale that specifies which language's hyphenation conventions to use. Default is the
    /// current, auto-updating locale.
    init(hyphenated content: String, verbatim: Bool = false, locale: Locale = .autoupdatingCurrent) {
        let content = verbatim ? content : String(localized: String.LocalizationValue(content))
        self.init(verbatim: content.hyphenated(locale: locale))
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
            .task {}
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
