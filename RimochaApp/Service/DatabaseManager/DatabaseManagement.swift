//
//  DatabaseManagement.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import FirebaseDatabase

/// Manager object to read and write data to real time firebase database
final class DatabaseManager {
    
    /// Shared instance of class
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
extension DatabaseManager {
    
    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
}

// MARK: - Account Mgmt

extension DatabaseManager {
    
    /// Checks if user exists for given email
    /// Parameters
    /// - `email`:              Target email to be checked
    /// - `completion`:   Async closure to return with result
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            print(snapshot)
            completion(true)
        })
        
    }
    
    /// Inserts new user to database
    public func insertUser(with user: UserManager, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "sex": user.sex,
            "urlAvatar": user.profilePictureFileName
            ], withCompletionBlock: { [weak self] error, _ in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil else {
                    print("failed ot write to database")
                    completion(false)
                    return
                }
                
                strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    if var usersCollection = snapshot.value as? [[String: Any]] {
                        // append to user dictionary
                        let newElement = [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail,
                            "sex": user.sex
                            ] as [String : Any]
                        usersCollection.append(newElement)
                        
                        strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                    else {
                        // create that array
                        let newCollection: [[String: Any]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail,
                                "sex": user.sex
                            ]
                        ]
                        
                        strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                })
        })
    }
    /// Get profile User from database
//    public func getProfileUser(_ email: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
//        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
//            guard let value = snapshot.value as? [String: Any] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//            completion(.success(value))
//        })
//    }
    
    public func getProfileUser(with email: String,
                           completion: @escaping (Result<[String: Any], Error>) -> Void) {

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            completion(.success(value))
        })

    }
    
    /// Gets all users from database
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
    
    /*
     users => [
     [
     "name":
     "safe_email":
     ],
     [
     "name":
     "safe_email":
     ]
     ]
     */
}
