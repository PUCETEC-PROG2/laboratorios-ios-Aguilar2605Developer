//
//  ContentView.swift
//  GithubClient
//
//  Created by Usuario invitado on 13/1/26.
//

import SwiftUI

struct ContentView: View {
    // Laboratorio 10: un único RepoViewModel compartido entre RepoList y RepoForm
    // para que ambas pestañas vean y modifiquen la misma lista de repos.
    @StateObject private var repoViewModel = RepoViewModel()

    var body: some View {
        TabView {
            RepoList()
                .tabItem {
                    Label("Repositorios", systemImage: "arrow.triangle.branch")
                }
            
            RepoForm()
                .tabItem {
                    Label("Crear", systemImage: "plus.circle.fill")
                }
            
            Profile()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
        }
        .environmentObject(repoViewModel) // inyectamos el ViewModel a las vistas hijas
    }
}

#Preview {
    ContentView()
}
