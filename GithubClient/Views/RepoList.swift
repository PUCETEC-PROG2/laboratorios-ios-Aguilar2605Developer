//
//  RepoList.swift
//  GithubClient
//
//  Created by Usuario invitado on 7/7/26.
//  Editado para el Laboratorio 10: ahora usa List dinámico + RepoViewModel
//  en vez de 6 RepoItem() fijos.
//

import SwiftUI

struct RepoList: View {
    // ViewModel compartido, inyectado desde ContentView con .environmentObject
    @EnvironmentObject var viewModel: RepoViewModel

    var body: some View {
        NavigationStack {
            Group {
                // Feedback visual: ProgressView solo en la carga inicial (lista vacía)
                if viewModel.isLoading && viewModel.repos.isEmpty {
                    ProgressView("Cargando repositorios...")
                } else {
                    // List dinámico recorriendo viewModel.repos, como pide el enunciado
                    List(viewModel.repos) { repo in
                        RepoRow(repo: repo) {
                            // Acción del botón "eliminar" (si aplica) dentro de RepoRow
                            viewModel.deleteRepo(repo)
                        }
                    }
                }
            }
            .navigationTitle("Repositorios")
            .navigationBarTitleDisplayMode( .inline )
            // Alert para mostrar errores que vengan del ViewModel
            .alert("Error", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { isPresented in if !isPresented { viewModel.error = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.error ?? "")
            }
        }
    }
}

#Preview {
    // Para el preview necesitamos inyectar un ViewModel de ejemplo
    RepoList().environmentObject(RepoViewModel())
}
