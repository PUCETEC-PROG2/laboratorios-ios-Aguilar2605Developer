
import Foundation

class RepoViewModel: ObservableObject {
    @Published var repos: [Repository] = []
    @Published var user: User? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var selectedTab: Int = 0

    func load() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()

        // 1. Cargar Repositorios
        group.enter()
        GitHubController.shared.getRepos(page: 1, perPage: 20) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.repos = data
                case .failure(let err):
                    self?.errorMessage = self?.mensajeAmigable(para: err)
                }
                group.leave()
            }
        }

        // 2. Cargar Perfil de Usuario
        group.enter()
        GitHubController.shared.getUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let err):
                    // No bloqueamos la carga de repos por esto, pero sí lo registramos
                    print("No se pudo cargar el usuario: \(err.localizedDescription)")
                }
                group.leave()
            }
        }

        // 3. Notificar cuando ambas terminen
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }

    /// Alias explícito para reintentar tras un error (usado por el botón "Reintentar" en la UI)
    func retry() {
        load()
    }

    private func mensajeAmigable(para error: Error) -> String {
        let nsError = error as NSError
        if nsError.code == NSURLErrorNotConnectedToInternet {
            return "Sin conexión a internet. Verifica tu red e intenta de nuevo."
        }
        return "No se pudieron cargar los repositorios. \(error.localizedDescription)"
    }
}
