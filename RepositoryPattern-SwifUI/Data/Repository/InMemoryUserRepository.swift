import Foundation

actor InMemoryUserRepository: UserRepository {
    var users: [User] = []
    
    func create(_ user: User) async throws {
        users.append(user)
    }
    
    func deleteUser(for id: UUID) async throws {
        users.removeAll(where: { $0.id == id })
    }
    
    func find(id: UUID) async throws -> User? {
        users.first(where: { $0.id == id })
    }
    
    func allUsers() async -> [User] {
        return users
    }
}
