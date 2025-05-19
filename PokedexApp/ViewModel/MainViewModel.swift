//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by 김기태 on 5/13/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    // 구독 해제를 위한 DisposeBag
    private let disposeBag = DisposeBag()
    
    private var offset = 0
    private let limit = 20
    private var isLoading = false
    
    // View가 구독할 relay(포켓몬 리스트를 담을 relay)
    let relay = PublishRelay<PokemonResponse>()
    
       
    // 포켓몬 데이터를 API에서 가져오기
    func fetchPokeData() {
        guard !isLoading else { return }
        isLoading = true
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else { return }
        
        NetworkManager.shared.fetch(url: url)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] (response: PokemonResponse) in
                self?.offset += self?.limit ?? 20
                self?.relay.accept(response)
                self?.isLoading = false
            }.disposed(by: disposeBag)
    }
    
    
}
