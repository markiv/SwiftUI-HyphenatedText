import Foundation
@testable import HyphenatedText
import Testing

private let arguments = [
    (
        "de_CH",
        "Obligatorische Kraftfahrzeughaftpflichtversicherung übersteigen",
        "Ob-li-ga-to-ri-sche Kraft-fahr-zeug-haft-pflicht-ver-si-che-rung über-stei-gen"
    ),
    (
        "fr_CH",
        "Dévérouiller anticonstitutionnellement la hippopotomonstrosesquipédaliophobie",
        "Dé-vé-rouiller an-ti-cons-ti-tu-tion-nel-le-ment la hip-po-po-to-mons-tro-ses-qui-pé-da-lio-pho-bie"
    ),
    (
        "it_CH",
        "Professionalizzazione anticostituzionalissimamente gravissima",
        "Pro-fes-sio-na-liz-za-zio-ne an-ti-co-sti-tu-zio-na-lis-si-ma-men-te gra-vis-si-ma"
    ),
    (
        "es_ES",
        "Profesionalización anticonstitucionalmente gravísima",
        "Pro-fe-sio-na-li-za-ción an-ti-cons-ti-tu-cio-nal-men-te gra-ví-si-ma"
    )
]

@Test(arguments: arguments)
func testHyphenation(localeId: String, text: String, result: String) {
    #expect(text.hyphenated(with: "-", locale: Locale(identifier: localeId)) == result)
}

@Test(arguments: arguments)
func testHyphenationWithSoftHyphen(localeId: String, text: String, result: String) {
    #expect(
        text.hyphenated(locale: Locale(identifier: localeId))
            == result.replacingOccurrences(of: "-", with: String.softHyphen)
    )
}
