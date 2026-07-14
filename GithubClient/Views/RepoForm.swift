import SwiftUI

struct RepoForm: View {
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Campos de entrada
                VStack(spacing: 15) {
                    TextField("Nombre del repositorio", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    TextField("Descripción", text: $description)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Botones horizontales
                HStack(spacing: 15) {
                    Button("Cancelar") {
                        // Acción cancelar
                        name = ""
                        description = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button("Crear") {
                        // Acción crear
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Nuevo Repositorio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RepoForm()
}
