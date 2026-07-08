//
//  Repository.swift
//  GithubClient
//
//  Creado para el Laboratorio 10 - Diseño de UI con SwiftUI
//

import Foundation

// Modelo de datos que representa un repositorio de GitHub.
// Identifiable es necesario para poder usarlo directamente dentro de un List().
struct Repository: Identifiable {
    let id = UUID()          // Identificador único que pide List(viewModel.repos)
    var name: String         // Nombre del repositorio
    var description: String  // Descripción corta del repositorio
    var language: String     // Lenguaje principal (ej. "Swift")
    var isPrivate: Bool      // true = privado, false = público
}
