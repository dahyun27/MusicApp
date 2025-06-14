//
//  MusicManager.swift
//  MyMusicApp
//
//  Created by 하다현 on 6/14/25.
//

import Foundation
import CoreData

//MARK: - 데이터 관리 모델 (전체 관리)

final class MusicManager {
    
    static let shared = MusicManager()
    
    private init() {
        
    }
    
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    private var musicArrays: [Music] = []
    private var musicSavedArrays: [MusicSaved] = []
    
    func getMusicArraysFromApI() -> [Music] {
        return musicArrays
    }
    
    func getMusicDatasFromCoreData() -> [MusicSaved] {
        return musicSavedArrays
    }
    
    //MARK: - API 통신 관련 메서드
    // 데이터 셋업하기
    func setupDatasFromAPI(completion: @escaping () -> Void) {
        getDatasFromAPI(with: "indid") {
            completion()
        }
    }
    
    // 특정 단어로 검색하기
    func fetchDatasFromAPI(withATerm searchTerm: String, completion: @escaping () -> Void) {
        getDatasFromAPI(with: searchTerm) {
            completion()
        }
    }
    
    // 네트워크 매니저한테 요청해서 (서버에서) 데이터 가져오기
    private func getDatasFromAPI(with searchTerm: String, completion: @escaping () -> Void) {
        networkManager.fetchMusic(searchTerm: searchTerm) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                self.checkWhetherSaved()
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.checkWhetherSaved()
                completion()
            }
        }
    }
    
    //MARK: - 코어데이터와 커뮤니케이션하는 메서드
    // 처음 셋팅
    private func setupDatasFromCoreData(competion: @escaping () -> Void) {
        self.fetchMusicsFromCoreData {
            competion()
        }
    }
    
    // Create (데이터 생성하기)
    func savedMusicData(with music: Music, message: String?, completion: @escaping () -> Void) {
        coreDataManager.saveMusic(with: music, message: message) {
            self.fetchMusicsFromCoreData {
                completion()
            }
        }
    }
    
    // Delete (저장되어 있는지 확인하고 데이터 지우기)
    func deleteMusic(with music: Music, completion: @escaping () -> Void) {
        let musicSaved = musicSavedArrays.filter{
            $0.songName == music.songName && $0.artistName == music.artistName
        }
        if let targetMusicSaved = musicSaved.first {
            self.deleteMusicFromCoreData(with: targetMusicSaved) {
                print("지우기 완료")
                completion()
            }
        } else {
            print("저장된 것 없음")
            completion()
        }
    }
    
    
    // Delete - 데이터 지우기
    func deleteMusicFromCoreData(with music: MusicSaved, completion: @escaping () -> Void) {
        coreDataManager.deleteMusic(with: music) {
            self.fetchMusicsFromCoreData {
                completion()
            }
        }
    }
    
    
    // Update - 데이터 수정하기
    func updateMusicCoreData(with music: MusicSaved, completion: @escaping () -> Void) {
        coreDataManager.updateMusic(with: music) {
            self.fetchMusicsFromCoreData {
                completion()
            }
        }
    }
    
    
    // Read (데이터 불러오기) (코어데이터에서 가져와서 ====> 현재 모델의 배열에 저장)
    private func fetchMusicsFromCoreData(completion: () -> Void) {
        musicSavedArrays = coreDataManager.getMusicSavedArrayFromCoreData()
        completion()
    }
    
    
    // 데이터 저장여부 확인
    func checkWhetherSaved() {
        musicArrays.forEach { music in
            //코어데이터에 저장된 것들 중 음악 및 가수 이름이 같은 것 찾아내서
            if musicSavedArrays.contains(where: {
                $0.songName == music.songName && $0.artistName == music.artistName
            }) {
                // 이미 저장되어있는데이터라고 설정
                music.isSaved = true
            }
        }
    }
}
