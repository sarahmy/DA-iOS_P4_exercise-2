//
//  UserListViewModel.swift
//  UserList
//
//  Created by Sarah Maimoun on 13/02/2025.
//

import Foundation

// Deal with the user list and its loading
class UserListViewModel : ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var isGridView: Bool = false
    
    private let repository = UserListRepository()
    
    // Fetch users
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                DispatchQueue.main.async {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
                
            DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    // Reload user list anew after deleting the user list already there
    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
    // Check if more loading is needed
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

        }
        
