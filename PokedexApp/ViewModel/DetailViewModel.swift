//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by 김기태 on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {
    // 구독 해제를 위한 DisposeBag
    private let disposeBag = DisposeBag()
    
    
    // View가 구독할 relay(상세 데이터를 담을 relay)
    let detailRelay = PublishRelay<Details>()
    

    // 포켓몬 상세 데이터 가져오고, detailRelay에 이벤트 방출.
    func fetchDetailData(from urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        NetworkManager.shared.fetch(url: url)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] (details: Details) in
                self?.detailRelay.accept(details)
            }.disposed(by: disposeBag)
    }
}
