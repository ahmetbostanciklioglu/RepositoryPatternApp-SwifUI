import Foundation

protocol UserRepository {
    /// Inserts a new user in the data store.
    func create(_ user: User) async throws
    
    /// Deletes an existing user if it exists.
    func deleteUser(for id: UUID) async throws
    
    /// Returns a user for the given ID if it exists.
    func find(id: UUID) async throws -> User?
}
