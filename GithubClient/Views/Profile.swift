
import SwiftUI

struct Profile: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(uiImage: .githubLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("Carlos Pazmiño")
                        .font(.title.bold())
                    
                    Text("crpazmino@puce.edu.ec")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Desarrollador de software")
                        .font(.body)
                        .italic()
                }
                
                Spacer()
            }
            .navigationTitle("Perfil de usuario")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Profile()
}
