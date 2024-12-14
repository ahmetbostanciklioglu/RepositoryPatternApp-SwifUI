import Foundation

final class UsersViewModel: ObservableObject {
    let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func createUser(name: String) async throws {
        let user = User(id: UUID(), name: name)
        try await repository.create(user)
    }
    
    func delete(user: User) async throws {
        try await repository.deleteUser(for: user.id)
    }
    
    func findUser(for id: UUID) async throws -> User? {
        try await repository.find(id: id)
    }
}
