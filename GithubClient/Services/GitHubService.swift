import Foundation
import Alamofire

/// Error específico para operaciones de escritura (POST/PATCH), que intenta
/// traer el mensaje real que manda GitHub en el body en vez de solo el genérico de Alamofire.
enum ServiceError: LocalizedError {
    case api(String)
    case network(AFError)

    var errorDescription: String? {
        switch self {
        case .api(let message):
            return message
        case .network(let afError):
            return afError.localizedDescription
        }
    }
}

/// Estructura mínima para decodificar el error que devuelve la API de GitHub, ej:
/// { "message": "Repository creation failed.", "errors": [...] }
private struct GitHubErrorResponse: Decodable {
    let message: String?
}

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
            .validate(statusCode: 200..<300)
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
            .validate(statusCode: 200..<300)
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

    // MARK: - Lab 12: POST — Crear repositorio

    func createRepo(name: String, description: String?, isPrivate: Bool, completion: @escaping (Result<Repository, ServiceError>) -> Void) {
        let url = "\(AppConfig.baseURL)/user/repos"
        let parameters: [String: Any] = [
            "name": name,
            "description": description ?? "",
            "private": isPrivate
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Repository.self) { response in
                #if DEBUG
                if let statusCode = response.response?.statusCode {
                    print("📡 POST /user/repos -> HTTP \(statusCode)")
                }
                #endif

                switch response.result {
                case .success(let repo):
                    #if DEBUG
                    print("✅ Repo creado: \(repo.name)")
                    #endif
                    completion(.success(repo))

                case .failure(let afError):
                    // Intentamos extraer el mensaje real que manda GitHub en el body
                    if let data = response.data,
                       let githubError = try? JSONDecoder().decode(GitHubErrorResponse.self, from: data),
                       let message = githubError.message {
                        #if DEBUG
                        print("❌ Error createRepo (GitHub): \(message)")
                        #endif
                        completion(.failure(.api(message)))
                    } else {
                        #if DEBUG
                        print("❌ Error createRepo: \(afError.localizedDescription)")
                        #endif
                        completion(.failure(.network(afError)))
                    }
                }
            }
    }
}
