
import Foundation
import Alamofire

class GitHubService {
    static let shared = GitHubService()
    private let headers: HTTPHeaders = [
        "Authorization": "token \(AppConfig.apiToken)",
        "Accept": "application/vnd.github.v3+json"
    ]

    func fetchRepos(page: Int, perPage: Int, completion: @escaping (Result<[Repository], AFError>) -> Void) {
        let url = "\(AppConfig.baseURL)/user/repos"
        let parameters: [String: Any] = ["page": page, "per_page": perPage]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)   // 👈 antes era .validate()
            .responseDecodable(of: [Repository].self) { response in
                #if DEBUG
                if let statusCode = response.response?.statusCode {
                    print("📡 GET /user/repos -> HTTP \(statusCode)")
                }
                if case .failure(let error) = response.result {
                    print("❌ Error fetchRepos: \(error.localizedDescription)")
                }
                #endif
                completion(response.result)
            }
    }

    func fetchUser(completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(AppConfig.baseURL)/user"

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)   // 👈 antes era .validate()
            .responseDecodable(of: User.self) { response in
                #if DEBUG
                if let statusCode = response.response?.statusCode {
                    print("📡 GET /user -> HTTP \(statusCode)")
                }
                if case .failure(let error) = response.result {
                    print("❌ Error fetchUser: \(error.localizedDescription)")
                }
                #endif
                completion(response.result)
            }
    }
}
