
import SwiftUI

struct RepoForm: View {
    @State private var repoName: String = ""
    @State private var repoDescription: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TextField(
                    "",
                    text: $repoName,
                    prompt: Text("Nombre del repositorio")
                        .foregroundStyle(.black.opacity(0.4))
                )
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)

                TextField(
                    "",
                    text: $repoDescription,
                    prompt: Text("Descripción del repositorio")
                        .foregroundStyle(.black.opacity(0.4))
                )
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
                .padding(.vertical)

                HStack {
                    Button(action: {
                        print("Botón presionado")
                    }) {
                        Label("Cancelar", systemImage: "xmark.circle")
                            .padding(.all, 4)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal, 4)

                    Button(action: {
                        print("Botón presionado")
                    }) {
                        Label("Guardar", systemImage: "square.and.arrow.down")
                            .padding(.all, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 4)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Formulario de repositorio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RepoForm()
}
