import Foundation

class RepoViewModel: ObservableObject {
    @Published var repos: [Repository] = []
    @Published var user: User? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var selectedTab: Int = 0

    // MARK: - Lab 12: estado del formulario de creación
    @Published var isSubmitting: Bool = false
    @Published var createErrorMessage: String? = nil
    @Published var didCreateSuccessfully: Bool = false

    func load() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()

        group.enter()
        GitHubController.shared.getRepos(page: 1, perPage: 20) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data): self?.repos = data
                case .failure(let err): self?.errorMessage = self?.mensajeAmigable(para: err)
                }
                group.leave()
            }
        }

        group.enter()
        GitHubController.shared.getUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user): self?.user = user
                case .failure(let err): print("⚠️ No se pudo cargar el usuario: \(err.localizedDescription)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }

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

    // MARK: - Lab 12: crear repositorio

    /// Valida el formulario localmente y, si todo está bien, llama a la API.
    /// - Returns: true si pasó la validación local (útil si la vista quiere reaccionar).
    @discardableResult
    func createRepo(name: String, description: String, isPrivate: Bool) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            createErrorMessage = "El nombre del repositorio no puede estar vacío."
            return false
        }

        guard trimmedName.range(of: "^[A-Za-z0-9._-]+$", options: .regularExpression) != nil else {
            createErrorMessage = "El nombre solo puede contener letras, números, guiones (-), guiones bajos (_) y puntos."
            return false
        }

        createErrorMessage = nil
        didCreateSuccessfully = false
        isSubmitting = true

        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)

        GitHubController.shared.createRepo(
            name: trimmedName,
            description: trimmedDescription.isEmpty ? nil : trimmedDescription,
            isPrivate: isPrivate
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSubmitting = false
                switch result {
                case .success(let repo):
                    self?.repos.insert(repo, at: 0)
                    self?.didCreateSuccessfully = true
                case .failure(let err):
                    self?.createErrorMessage = err.errorDescription ?? "No se pudo crear el repositorio."
                }
            }
        }

        return true
    }
}
