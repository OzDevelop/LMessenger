//
//  AuthenticationService.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invaildated
}

// combine 관련 내용 학습해야 할듯
protocol AuthenticationServiceType {
    func signInWithGoogle() ->  AnyPublisher<User, ServiceError>
}

// ????????
class AuthenticationService: AuthenticationServiceType {
    func signInWithGoogle() ->  AnyPublisher<User, ServiceError> {
        Future { [weak self] promise in
            self?.signInWithGoogle { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

extension AuthenticationService {
    private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthenticationError.clientIDError))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthenticationError.tokenError))
                return
            }
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            
            self?.authenticateUserWithFirebase(credential: credential, completion: completion)
        }
    }
    
    //firebase 인증
    private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let result else {
                completion(.failure(AuthenticationError.invaildated))
                return
            }
            
            let firebaseUser = result.user
            let user: User = .init(id: firebaseUser.uid, 
                                   name: firebaseUser.displayName ?? "",
                                   phoneNumber: firebaseUser.phoneNumber,
                                   profileURL: firebaseUser.photoURL?.absoluteString
            )
            
            completion(.success(user))
        }
    }
}


class StubAuthenticationService: AuthenticationServiceType {
    func signInWithGoogle() ->  AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}


/// 구글로그인은 combine을 지원하지 않기 때문에 completionHandler를 이용해야 함
