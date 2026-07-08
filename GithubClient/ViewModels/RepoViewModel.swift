//
//  RepoViewModel.swift
//  GithubClient
//
//  Creado para el Laboratorio 10 - Diseño de UI con SwiftUI
//  Maneja el estado compartido entre RepoList y RepoForm.
//

import Foundation

// ObservableObject: permite que las vistas se redibujen automáticamente
// cuando cambian repos, isLoading o error (gracias a @Published).
class RepoViewModel: ObservableObject {

    @Published var repos: [Repository] = []   // Lista de repos que muestra RepoList
    @Published var isLoading: Bool = false     // Controla el ProgressView
    @Published var error: String? = nil        // Mensaje mostrado en el Alert de error

    init() {
        cargarRepositoriosDePrueba()
    }

    // Simula una carga inicial (aquí luego se conectaría la API real de GitHub).
    // Se usa DispatchQueue solo para simular el tiempo de espera de una red.
    private func cargarRepositoriosDePrueba() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.repos = [
                Repository(name: "GithubClient",
                           description: "App de ejemplo para consumir la API de GitHub",
                           language: "Swift",
                           isPrivate: false),
                Repository(name: "Laboratorio9",
                           description: "Corrección de errores en Profile.swift",
                           language: "Swift",
                           isPrivate: true),
                Repository(name: "Laboratorio10",
                           description: "Diseño de UI con SwiftUI",
                           language: "Swift",
                           isPrivate: false)
            ]
            self.isLoading = false
        }
    }

    // Crea un nuevo repositorio a partir de los datos capturados en RepoForm.
    func createRepo(name: String, description: String, isPrivate: Bool) {
        // Validación mínima antes de "guardar"
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "El nombre del repositorio no puede estar vacío"
            return
        }

        isLoading = true

        // Simulamos una llamada asíncrona de creación (ej. POST a la API)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let nuevoRepo = Repository(name: name,
                                        description: description,
                                        language: "Swift",
                                        isPrivate: isPrivate)
            self.repos.append(nuevoRepo)
            self.isLoading = false
        }
    }

    // Elimina un repo de la lista. La usa el botón de acción de RepoRow.
    func deleteRepo(_ repo: Repository) {
        repos.removeAll { $0.id == repo.id }
    }
}
