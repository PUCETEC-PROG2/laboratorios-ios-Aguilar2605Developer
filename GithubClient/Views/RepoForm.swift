import SwiftUI

struct RepoForm: View {
    @EnvironmentObject var viewModel: RepoViewModel

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var isPrivate: Bool = false
    @State private var showSuccessAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Nombre del repositorio", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        // Error de validación local, justo debajo del campo
                        if let error = viewModel.createErrorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 4)
                        }
                    }

                    TextField("Descripción (opcional)", text: $description)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Toggle("Repositorio privado", isOn: $isPrivate)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()

                HStack(spacing: 15) {
                    Button("Cancelar") {
                        limpiarFormulario()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .disabled(viewModel.isSubmitting)

                    Button(action: crear) {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Crear")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.isSubmitting ? Color.blue.opacity(0.5) : Color.blue)
                    .cornerRadius(12)
                    .disabled(viewModel.isSubmitting || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Nuevo Repositorio")
            .navigationBarTitleDisplayMode(.inline)
            .alert("¡Repositorio creado!", isPresented: $showSuccessAlert) {
                Button("Ver repositorios") {
                    viewModel.selectedTab = 0
                }
                Button("Aceptar", role: .cancel) { }
            } message: {
                Text("\"\(name)\" se creó correctamente en tu cuenta de GitHub.")
            }
            .onChange(of: viewModel.didCreateSuccessfully) { didSucceed in
                if didSucceed {
                    showSuccessAlert = true
                    limpiarFormulario(mantenerNombreEnAlert: true)
                    viewModel.didCreateSuccessfully = false
                }
            }
        }
    }

    private func crear() {
        // Oculta el teclado antes de enviar
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        viewModel.createRepo(name: name, description: description, isPrivate: isPrivate)
    }

    private func limpiarFormulario(mantenerNombreEnAlert: Bool = false) {
        if !mantenerNombreEnAlert {
            name = ""
        }
        description = ""
        isPrivate = false
        viewModel.createErrorMessage = nil
    }
}

#Preview {
    RepoForm()
        .environmentObject(RepoViewModel())
}
