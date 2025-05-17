//
//  MainViewController.swift
//  PokedexApp
//
//  Created by 김기태 on 5/13/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    private var pokemonList: [PokemonSummary] = []
    
    
    private let imageView = UIImageView()
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.frame = .zero
        collectionView.collectionViewLayout = layout
        collectionView.register(
            PokeCell.self,
            forCellWithReuseIdentifier: String(describing: PokeCell.self)
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.fetchPokeData()
    }
    
    private func setupUI() {
        [imageView,
         collectionView
        ].forEach { view.addSubview($0) }
        imageView.image = UIImage(named: "pokemonBall")
        
    }
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(100)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func bindViewModel() {
        
        viewModel.relay
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] response in
                self?.pokemonList = response.results
                self?.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.detailRelay
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] details in
                let detailVC = DetailViewController()
                detailVC.pokemonDetails = details
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0 / 3.0) // 3개 가로로 배치
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemon = pokemonList[indexPath.item]
        // URL로 상세 데이터 가져오기
        viewModel.fetchDetailData(from: pokemon.url)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PokeCell.self), for: indexPath) as? PokeCell else { return UICollectionViewCell() }
        let pokemon = pokemonList[indexPath.item]
        
        guard let url = URL(string: pokemon.url) else { return cell }
        
        // 리턴타입이 Single이므로 이 코드 자체가 Observable
        NetworkManager.shared.fetch(url: url)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { (details: Details) in
                cell.configure(with: details)
            }, onFailure: { error in
                print("상세 정보 로딩 실패 \(error)")
            })
            .disposed(by: disposeBag)
        
        return cell
    }
    
}
