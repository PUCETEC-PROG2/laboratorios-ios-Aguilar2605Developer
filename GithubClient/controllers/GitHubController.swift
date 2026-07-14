
import Foundation
import Alamofire

class GitHubController {
    static let shared = GitHubController()
    
    func getRepos(page: Int, perPage: Int, completion: @escaping (Result<[Repository], AFError>) -> Void) {
        GitHubService.shared.fetchRepos(page: page, perPage: perPage, completion: completion)
    }
    
    // Método necesario para cumplir con el lab
    func getUser(completion: @escaping (Result<User, AFError>) -> Void) {
        GitHubService.shared.fetchUser(completion: completion)
    }
}
