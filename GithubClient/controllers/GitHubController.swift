
import Foundation
import Alamofire

class GitHubController {
    static let shared = GitHubController()

    func getRepos(page: Int, perPage: Int, completion: @escaping (Result<[Repository], AFError>) -> Void) {
        GitHubService.shared.fetchRepos(page: page, perPage: perPage, completion: completion)
    }

    func getUser(completion: @escaping (Result<User, AFError>) -> Void) {
        GitHubService.shared.fetchUser(completion: completion)
    }

    // Lab 12
    func createRepo(name: String, description: String?, isPrivate: Bool, completion: @escaping (Result<Repository, ServiceError>) -> Void) {
        GitHubService.shared.createRepo(name: name, description: description, isPrivate: isPrivate, completion: completion)
    }
}
