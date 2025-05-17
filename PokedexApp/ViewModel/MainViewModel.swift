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
    
    // View가 구독할 relay(포켓몬 리스트를 담을 relay)
    let relay = PublishRelay<PokemonResponse>()
    
    // View가 구독할 relay(상세 데이터를 담을 relay)
    let detailRelay = PublishRelay<Details>()
    
    // 포켓몬 데이터를 API에서 가져오기
    func fetchPokeData() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else { return }
        
        NetworkManager.shared.fetch(url: url)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] (response: PokemonResponse) in
                self?.relay.accept(response)
            }.disposed(by: disposeBag)
    }
    
    // 포켓몬 상세 데이터 가져오고, detailRelay에 이벤트 방출.
    func fetchDetailData(from urlStirng: String) {
        
        guard let url = URL(string: urlStirng) else { return }
        NetworkManager.shared.fetch(url: url)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] (details: Details) in
                self?.detailRelay.accept(details)
            }.disposed(by: disposeBag)
    }
}
