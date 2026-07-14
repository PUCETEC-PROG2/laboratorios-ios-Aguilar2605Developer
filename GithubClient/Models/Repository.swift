
import Foundation

struct Repository: Identifiable, Codable {
    let id: Int
    var name: String
    var description: String
    var language: String
    var isPrivate: Bool

    enum CodingKeys: String, CodingKey {
        case id, description, language
        case name = "full_name"
        case isPrivate = "private"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? "Sin descripción"
        language = try container.decodeIfPresent(String.self, forKey: .language) ?? "N/A"
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
    }

    init(id: Int, name: String, description: String, language: String, isPrivate: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.language = language
        self.isPrivate = isPrivate
    }
}
