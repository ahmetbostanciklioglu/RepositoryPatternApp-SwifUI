import Foundation

struct UserDefaultsUserRepository: UserRepository {
    var userDefaults: UserDefaults = .standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func create(_ user: User) async throws {
        var users = try fetchUsers()
        users.append(user)
        try store(users: users)
    }
    
    func deleteUser(for id: UUID) async throws {
        var users = try fetchUsers()
        users.removeAll(where: { $0.id == id })
        try store(users: users)
    }
    
    func find(id: UUID) async throws -> User? {
        try fetchUsers().first(where: { $0.id == id })
    }
    
    func fetchUsers() throws -> [User] {
        guard let usersData = userDefaults.object(forKey: "users") as? Data else {
            return []
        }
        return try decoder.decode([User].self, from: usersData)
    }
    
    private func store(users: [User]) throws {
        let usersData = try encoder.encode(users)
        userDefaults.set(usersData, forKey: "users")
    }
}
