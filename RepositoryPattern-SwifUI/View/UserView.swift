import SwiftUI

struct UserView: View {
    /// Using an in-memory store:
    /// @StateObject private var viewModel = UsersViewModel(repository: InMemoryUserRepository())
    @StateObject private var viewModel = UsersViewModel(repository: UserDefaultsUserRepository())
    @State private var newUserName: String = ""
    @State private var users: [User] = []
    
    var body: some View {
        VStack {
            TextField("Enter User Name", text: $newUserName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .padding()
            
            Button("Add User") {
                Task {
                    do {
                        try await viewModel.createUser(name: newUserName)
                        await refreshUsers()
                        newUserName = ""
                    } catch {
                        print("Error creating user: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            List(users, id: \.id) { user in
                HStack {
                    Text(user.name)
                    Spacer()
                    Button("Delete") {
                        Task {
                            do {
                                try await viewModel.delete(user: user)
                                await refreshUsers()
                            } catch {
                                print("Error deleting user: \(error)")
                            }
                        }
                    }
                }
            }
        }
        .task {
            await refreshUsers()
        }
    }
    
    private func refreshUsers() async {
        do {
            /// Here we fetch users manually
            /// let fetchedUsers = try await (viewModel.repository as! InMemoryUserRepository).users
            /// users = fetchedUsers
            if let userDefaultsRepository = viewModel.repository as? UserDefaultsUserRepository {
                let fetchedUsers = try userDefaultsRepository.fetchUsers()
                await MainActor.run {
                    users = fetchedUsers
                }
            }
        } catch {
            print("Error refreshing users: \(error)")
        }
    }
}

#Preview {
    UserView()
}
