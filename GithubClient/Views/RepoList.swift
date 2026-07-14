
import SwiftUI

struct RepoList: View {
    @EnvironmentObject var viewModel: RepoViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.repos.isEmpty {
                    ProgressView("Cargando...")
                } else if let error = viewModel.errorMessage, viewModel.repos.isEmpty {
                    // Estado de error a pantalla completa (solo si no hay datos previos que mostrar)
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        Button("Reintentar") {
                            viewModel.retry()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List(viewModel.repos) { repo in
                        RepoRow(repo: repo)
                    }
                    // RECARGA MANUAL (Pull to Refresh)
                    .refreshable {
                        viewModel.load()
                    }
                }
            }
            .navigationTitle("Repositorios")
            .onAppear {
                if viewModel.repos.isEmpty { viewModel.load() }
            }
            // Alerta adicional para errores que ocurren teniendo ya datos cargados
            // (ej. falla un refresh pero la lista anterior sigue visible)
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil && !viewModel.repos.isEmpty },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("Reintentar") { viewModel.retry() }
                Button("Cerrar", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
