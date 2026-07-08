//
//  RepoRow.swift
//  GithubClient
//
//  Creado para el Laboratorio 10 - Diseño de UI con SwiftUI
//  Reutiliza el mismo diseño visual de RepoItem.swift, pero recibe
//  los datos de forma dinámica (repo: Repository) en vez de texto fijo.
//  RepoItem.swift NO se modifica, sigue existiendo tal cual estaba.
//

import SwiftUI

struct RepoRow: View {
    let repo: Repository              // Repositorio a mostrar en esta fila
    var onDelete: (() -> Void)? = nil // Botón de acción "si aplica" (opcional)

    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: .githubLogo)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 5) {
                Text(repo.name)              // Nombre dinámico del repo
                    .font(.title2)
                    .bold()
                Text(repo.description)       // Descripción dinámica del repo
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Text(repo.isPrivate ? "Privado" : "Público")
                        .font(.caption)
                    Spacer()
                    Text(repo.language)
                        .font(.caption)
                        .bold()
                }
                .padding(.top, 5)
            }

            Spacer()

            // Botón de acción solo aparece si RepoList nos pasa un onDelete
            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless) // evita conflicto con el tap de la fila en el List
            }
        }
        .padding()
    }
}

#Preview {
    RepoRow(repo: Repository(name: "Nombre del repositorio",
                              description: "Lorem ipsum dolor descripción del repositorio",
                              language: "Swift",
                              isPrivate: false))
}
