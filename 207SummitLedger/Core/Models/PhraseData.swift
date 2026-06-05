import Foundation

struct PhraseCategory: Identifiable {
    let id: String
    let title: String
    let phrases: [PhraseEntry]
}

struct PhraseEntry: Identifiable {
    let id: String
    let english: String
    let translation: String
}

enum PhraseLibrary {
    static func categories(for languageCode: String) -> [PhraseCategory] {
        let lang = languageCode
        return [
            PhraseCategory(
                id: "greetings",
                title: "Greetings",
                phrases: [
                    PhraseEntry(id: "g1", english: "Hello", translation: translated("Hello", lang: lang)),
                    PhraseEntry(id: "g2", english: "Good morning", translation: translated("Good morning", lang: lang)),
                    PhraseEntry(id: "g3", english: "Thank you", translation: translated("Thank you", lang: lang)),
                    PhraseEntry(id: "g4", english: "Goodbye", translation: translated("Goodbye", lang: lang))
                ]
            ),
            PhraseCategory(
                id: "directions",
                title: "Directions",
                phrases: [
                    PhraseEntry(id: "d1", english: "Where is the station?", translation: translated("Where is the station?", lang: lang)),
                    PhraseEntry(id: "d2", english: "Turn left", translation: translated("Turn left", lang: lang)),
                    PhraseEntry(id: "d3", english: "How far is it?", translation: translated("How far is it?", lang: lang)),
                    PhraseEntry(id: "d4", english: "I am lost", translation: translated("I am lost", lang: lang))
                ]
            ),
            PhraseCategory(
                id: "dining",
                title: "Dining",
                phrases: [
                    PhraseEntry(id: "di1", english: "A table for two", translation: translated("A table for two", lang: lang)),
                    PhraseEntry(id: "di2", english: "The menu, please", translation: translated("The menu, please", lang: lang)),
                    PhraseEntry(id: "di3", english: "Water, please", translation: translated("Water, please", lang: lang)),
                    PhraseEntry(id: "di4", english: "The check, please", translation: translated("The check, please", lang: lang))
                ]
            ),
            PhraseCategory(
                id: "emergency",
                title: "Emergency",
                phrases: [
                    PhraseEntry(id: "e1", english: "I need help", translation: translated("I need help", lang: lang)),
                    PhraseEntry(id: "e2", english: "Call a doctor", translation: translated("Call a doctor", lang: lang)),
                    PhraseEntry(id: "e3", english: "Where is the pharmacy?", translation: translated("Where is the pharmacy?", lang: lang)),
                    PhraseEntry(id: "e4", english: "I am allergic", translation: translated("I am allergic", lang: lang))
                ]
            ),
            PhraseCategory(
                id: "shopping",
                title: "Shopping",
                phrases: [
                    PhraseEntry(id: "s1", english: "How much does it cost?", translation: translated("How much does it cost?", lang: lang)),
                    PhraseEntry(id: "s2", english: "Do you accept cards?", translation: translated("Do you accept cards?", lang: lang)),
                    PhraseEntry(id: "s3", english: "I am just looking", translation: translated("I am just looking", lang: lang)),
                    PhraseEntry(id: "s4", english: "Can I try this on?", translation: translated("Can I try this on?", lang: lang))
                ]
            )
        ]
    }

    private static func translated(_ english: String, lang: String) -> String {
        switch lang {
        case "ES":
            return spanish(english)
        case "FR":
            return french(english)
        case "DE":
            return german(english)
        case "IT":
            return italian(english)
        case "JA":
            return japanese(english)
        case "PT":
            return portuguese(english)
        default:
            return english
        }
    }

    private static func spanish(_ e: String) -> String {
        switch e {
        case "Hello": return "Hola"
        case "Good morning": return "Buenos días"
        case "Thank you": return "Gracias"
        case "Goodbye": return "Adiós"
        case "Where is the station?": return "¿Dónde está la estación?"
        case "Turn left": return "Gire a la izquierda"
        case "How far is it?": return "¿Qué tan lejos está?"
        case "I am lost": return "Estoy perdido"
        case "A table for two": return "Una mesa para dos"
        case "The menu, please": return "El menú, por favor"
        case "Water, please": return "Agua, por favor"
        case "The check, please": return "La cuenta, por favor"
        default: return e
        }
    }

    private static func french(_ e: String) -> String {
        switch e {
        case "Hello": return "Bonjour"
        case "Good morning": return "Bonjour"
        case "Thank you": return "Merci"
        case "Goodbye": return "Au revoir"
        case "Where is the station?": return "Où est la gare?"
        case "Turn left": return "Tournez à gauche"
        case "How far is it?": return "C'est loin?"
        case "I am lost": return "Je suis perdu"
        case "A table for two": return "Une table pour deux"
        case "The menu, please": return "Le menu, s'il vous plaît"
        case "Water, please": return "De l'eau, s'il vous plaît"
        case "The check, please": return "L'addition, s'il vous plaît"
        default: return e
        }
    }

    private static func german(_ e: String) -> String {
        switch e {
        case "Hello": return "Hallo"
        case "Good morning": return "Guten Morgen"
        case "Thank you": return "Danke"
        case "Goodbye": return "Auf Wiedersehen"
        case "Where is the station?": return "Wo ist der Bahnhof?"
        case "Turn left": return "Links abbiegen"
        case "How far is it?": return "Wie weit ist es?"
        case "I am lost": return "Ich habe mich verlaufen"
        case "A table for two": return "Ein Tisch für zwei"
        case "The menu, please": return "Die Speisekarte, bitte"
        case "Water, please": return "Wasser, bitte"
        case "The check, please": return "Die Rechnung, bitte"
        default: return e
        }
    }

    private static func italian(_ e: String) -> String {
        switch e {
        case "Hello": return "Ciao"
        case "Good morning": return "Buongiorno"
        case "Thank you": return "Grazie"
        case "Goodbye": return "Arrivederci"
        case "Where is the station?": return "Dov'è la stazione?"
        case "Turn left": return "Gira a sinistra"
        case "How far is it?": return "Quanto è lontano?"
        case "I am lost": return "Mi sono perso"
        case "A table for two": return "Un tavolo per due"
        case "The menu, please": return "Il menu, per favore"
        case "Water, please": return "Acqua, per favore"
        case "The check, please": return "Il conto, per favore"
        default: return e
        }
    }

    private static func japanese(_ e: String) -> String {
        switch e {
        case "Hello": return "こんにちは"
        case "Good morning": return "おはようございます"
        case "Thank you": return "ありがとう"
        case "Goodbye": return "さようなら"
        case "Where is the station?": return "駅はどこですか?"
        case "Turn left": return "左に曲がってください"
        case "How far is it?": return "どのくらい遠いですか?"
        case "I am lost": return "道に迷いました"
        case "A table for two": return "二人用のテーブル"
        case "The menu, please": return "メニューをください"
        case "Water, please": return "お水をください"
        case "The check, please": return "お会計をお願いします"
        default: return e
        }
    }

    private static func portuguese(_ e: String) -> String {
        switch e {
        case "Hello": return "Olá"
        case "Good morning": return "Bom dia"
        case "Thank you": return "Obrigado"
        case "Goodbye": return "Adeus"
        case "Where is the station?": return "Onde fica a estação?"
        case "Turn left": return "Vire à esquerda"
        case "How far is it?": return "É longe?"
        case "I am lost": return "Estou perdido"
        case "A table for two": return "Uma mesa para dois"
        case "The menu, please": return "O cardápio, por favor"
        case "Water, please": return "Água, por favor"
        case "The check, please": return "A conta, por favor"
        case "I need help": return "Preciso de ajuda"
        case "Call a doctor": return "Chame um médico"
        case "Where is the pharmacy?": return "Onde fica a farmácia?"
        case "I am allergic": return "Sou alérgico"
        case "How much does it cost?": return "Quanto custa?"
        case "Do you accept cards?": return "Aceita cartão?"
        case "I am just looking": return "Estou só olhando"
        case "Can I try this on?": return "Posso experimentar?"
        default: return e
        }
    }
}

enum CurrencyData {
    struct Currency: Identifiable, Hashable {
        let code: String
        let name: String
        let symbol: String
        let rateToUSD: Double

        var id: String { code }
    }

    static let currencies: [Currency] = [
        Currency(code: "USD", name: "US Dollar", symbol: "$", rateToUSD: 1.0),
        Currency(code: "EUR", name: "Euro", symbol: "€", rateToUSD: 0.92),
        Currency(code: "GBP", name: "British Pound", symbol: "£", rateToUSD: 0.79),
        Currency(code: "JPY", name: "Japanese Yen", symbol: "¥", rateToUSD: 149.5),
        Currency(code: "CAD", name: "Canadian Dollar", symbol: "C$", rateToUSD: 1.36),
        Currency(code: "AUD", name: "Australian Dollar", symbol: "A$", rateToUSD: 1.53),
        Currency(code: "CHF", name: "Swiss Franc", symbol: "Fr", rateToUSD: 0.88),
        Currency(code: "MXN", name: "Mexican Peso", symbol: "$", rateToUSD: 17.2)
    ]

    static let languageForCurrency: [String: String] = [
        "USD": "EN",
        "EUR": "ES",
        "GBP": "EN",
        "JPY": "JA",
        "CAD": "EN",
        "AUD": "EN",
        "CHF": "DE",
        "MXN": "ES"
    ]

    static func convert(amount: Double, from: Currency, to: Currency) -> Double {
        let usd = amount / from.rateToUSD
        return usd * to.rateToUSD
    }
}
