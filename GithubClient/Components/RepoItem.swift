
import SwiftUI

struct RepoItem: View {
    let repository: Repository

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "folder.fill")
                .resizable().frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(repository.name).font(.headline).bold()
                Text(repository.description).font(.subheadline).foregroundColor(.secondary)
                Text(repository.language).font(.caption).bold()
            }
        }.padding(.vertical, 5)
    }
}
