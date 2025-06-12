//
//  NetworkManager.swift
//  MyMusicApp
//
//  Created by 하다현 on 6/12/25.
//

import Foundation

enum NetworkError {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    
}
