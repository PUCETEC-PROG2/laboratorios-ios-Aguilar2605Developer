
import SwiftUI
struct RepoRow: View {
    let repo: Repository              // Repositorio a mostrar en esta fila
    var onDelete: (() -> Void)? = nil // Se mantiene para no romper la llamada desde RepoList
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: .githubLogo)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 5) {
                Text(repo.name)
                    .font(.title2)
                    .bold()
                Text(repo.description)      
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
