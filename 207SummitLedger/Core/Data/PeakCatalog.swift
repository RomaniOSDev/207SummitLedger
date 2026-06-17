import Foundation

struct PeakCatalogEntry: Identifiable {
    let id: String
    let name: String
    let country: String
    let flagEmoji: String
    let elevationMeters: Int
    let mountainRange: String
    let difficulty: SummitDifficulty

    func asDestination() -> Destination {
        Destination(
            name: name,
            country: country,
            flagEmoji: flagEmoji,
            elevationMeters: elevationMeters,
            mountainRange: mountainRange,
            difficulty: difficulty
        )
    }
}

enum PeakCatalog {
    static let featured: [PeakCatalogEntry] = [
        PeakCatalogEntry(id: "everest", name: "Mount Everest", country: "Nepal", flagEmoji: "🇳🇵", elevationMeters: 8849, mountainRange: "Himalayas", difficulty: .expert),
        PeakCatalogEntry(id: "kilimanjaro", name: "Mount Kilimanjaro", country: "Tanzania", flagEmoji: "🇹🇿", elevationMeters: 5895, mountainRange: "Eastern Rift", difficulty: .moderate),
        PeakCatalogEntry(id: "montblanc", name: "Mont Blanc", country: "France", flagEmoji: "🇫🇷", elevationMeters: 4808, mountainRange: "Alps", difficulty: .hard),
        PeakCatalogEntry(id: "elbrus", name: "Mount Elbrus", country: "Russia", flagEmoji: "🇷🇺", elevationMeters: 5642, mountainRange: "Caucasus", difficulty: .hard),
        PeakCatalogEntry(id: "aconcagua", name: "Aconcagua", country: "Argentina", flagEmoji: "🇦🇷", elevationMeters: 6961, mountainRange: "Andes", difficulty: .hard),
        PeakCatalogEntry(id: "denali", name: "Denali", country: "United States", flagEmoji: "🇺🇸", elevationMeters: 6190, mountainRange: "Alaska Range", difficulty: .expert),
        PeakCatalogEntry(id: "fuji", name: "Mount Fuji", country: "Japan", flagEmoji: "🇯🇵", elevationMeters: 3776, mountainRange: "Honshu", difficulty: .beginner),
        PeakCatalogEntry(id: "matterhorn", name: "Matterhorn", country: "Switzerland", flagEmoji: "🇨🇭", elevationMeters: 4478, mountainRange: "Alps", difficulty: .expert),
        PeakCatalogEntry(id: "vinson", name: "Mount Vinson", country: "Antarctica", flagEmoji: "🏔️", elevationMeters: 4892, mountainRange: "Sentinel Range", difficulty: .expert),
        PeakCatalogEntry(id: "whitney", name: "Mount Whitney", country: "United States", flagEmoji: "🇺🇸", elevationMeters: 4421, mountainRange: "Sierra Nevada", difficulty: .moderate),
        PeakCatalogEntry(id: "ararat", name: "Mount Ararat", country: "Turkey", flagEmoji: "🇹🇷", elevationMeters: 5137, mountainRange: "Armenian Highlands", difficulty: .moderate),
        PeakCatalogEntry(id: "olympus", name: "Mount Olympus", country: "Greece", flagEmoji: "🇬🇷", elevationMeters: 2917, mountainRange: "Thessaly", difficulty: .beginner)
    ]
}
