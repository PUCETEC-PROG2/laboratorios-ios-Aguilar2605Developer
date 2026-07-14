
import SwiftUI

struct RepoRow: View {
    let repo: Repository
    var onEdit: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "folder.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(repo.name)
                    .font(.headline)
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
            }
            
            if let onEdit = onEdit {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    RepoRow(repo: Repository(id: 1,
                             name: "Demo Repo",
                             description: "Descripción de prueba",
                             language: "Swift",
                             isPrivate: false))
}
