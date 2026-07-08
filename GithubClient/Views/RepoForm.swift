//
//  RepoForm.swift
//  GithubClient
//
//  Created by Usuario invitado on 7/7/26.
//  Editado para el Laboratorio 10: se reemplaza el Text("Holo mundaso")
//  por un Form real conectado al RepoViewModel.
//

import SwiftUI

struct RepoForm: View {
    // Mismo ViewModel compartido con RepoList (inyectado desde ContentView)
    @EnvironmentObject var viewModel: RepoViewModel

    // Estado local: lo que el usuario va escribiendo en el formulario
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var isPrivate: Bool = false
    @State private var showConfirmacion: Bool = false // Alert de "repo creado"

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre del repo", text: $name)

                TextEditor(text: $description)
                    .frame(height: 100) // alto mínimo para que no se vea vacío

                Toggle("Privado", isOn: $isPrivate)

                Button("Crear") {
                    viewModel.createRepo(name: name, description: description, isPrivate: isPrivate)
                    showConfirmacion = true

                    // Limpiamos el formulario para poder crear otro repo
                    name = ""
                    description = ""
                    isPrivate = false
                }
            }
            .navigationTitle("formulario de Repositorio")
            .navigationBarTitleDisplayMode( .inline )
            .overlay {
                // Feedback visual mientras el ViewModel "crea" el repo
                if viewModel.isLoading {
                    ProgressView("Guardando...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
            // Alert de confirmación tras crear el repo
            .alert("Repositorio creado", isPresented: $showConfirmacion) {
                Button("OK", role: .cancel) { }
            }
            // Alert de error (ej. nombre vacío) que viene del ViewModel
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
    RepoForm().environmentObject(RepoViewModel())
}
