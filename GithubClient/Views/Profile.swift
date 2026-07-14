
import SwiftUI

struct Profile: View {
    @EnvironmentObject var viewModel: RepoViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.user == nil {
                    ProgressView("Cargando perfil...")
                } else if let user = viewModel.user {
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: user.avatarUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(uiImage: .githubLogo)
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 20)

                        VStack(spacing: 8) {
                            Text(user.name ?? user.login)
                                .font(.title.bold())

                            Text("@\(user.login)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let bio = user.bio, !bio.isEmpty {
                                Text(bio)
                                    .font(.body)
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }

                        HStack(spacing: 30) {
                            estadistica(valor: user.publicRepos, etiqueta: "Repos")
                            estadistica(valor: user.followers, etiqueta: "Seguidores")
                            estadistica(valor: user.following, etiqueta: "Siguiendo")
                        }
                        .padding(.top, 10)

                        Spacer()
                    }
                } else {
                    // Sin datos y sin estar cargando: probablemente falló la petición
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(viewModel.errorMessage ?? "No se pudo cargar el perfil.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        Button("Reintentar") {
                            viewModel.retry()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle("Perfil de usuario")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.user == nil { viewModel.load() }
            }
        }
    }

    @ViewBuilder
    private func estadistica(valor: Int, etiqueta: String) -> some View {
        VStack {
            Text("\(valor)")
                .font(.headline.bold())
            Text(etiqueta)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    Profile()
        .environmentObject(RepoViewModel())
}
