
import SwiftUI

struct ContentView: View {
    @StateObject private var repoViewModel = RepoViewModel()
    
    var body: some View {
        TabView(selection: Binding(
            get: { repoViewModel.selectedTab },
            set: { repoViewModel.selectedTab = $0 }
        )) {
            RepoList()
                .tabItem {
                    Label("Repositorios", systemImage: "arrow.triangle.branch")
                }
                .tag(0)

            RepoForm()
                .tabItem {
                    Label("Crear", systemImage: "plus.circle.fill")
                }
                .tag(1)

            Profile()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
        .environmentObject(repoViewModel)
    }
}

#Preview {
    ContentView()
}
