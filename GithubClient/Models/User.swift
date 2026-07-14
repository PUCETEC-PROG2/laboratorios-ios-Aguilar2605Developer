
import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var login: String
    var name: String?
    var bio: String?
    var avatarUrl: String
    var publicRepos: Int
    var followers: Int
    var following: Int

    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, followers, following
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
    }
}
