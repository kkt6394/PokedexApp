//
//  DetailViewController.swift
//  PokedexApp
//
//  Created by 김기태 on 5/15/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift


final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let heightLabel = UILabel()
    private let weightLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, typeLabel, heightLabel, weightLabel])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
        view.addSubview(stackView)
        setupConstraints()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.detailRelay
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] details in
                self?.setupUI(with: details)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setupUI(with details: Details) {
        guard let type = details.types.first?.type.name,
        let translatedType = PokemonTypeName(rawValue: type)?.displayName else { return }
        
        let urlStirng = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(details.id).png"
        guard let url = URL(string: urlStirng) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self?.imageView.image = image
                    }
                }
            }
        }
        // 레이블 설정
        let koreanName = PokemonTranslator.getKoreanName(for: details.name)
        nameLabel.text = "No.\(details.id) \(koreanName)"
        typeLabel.text = "타입 : \(translatedType)"
        
        let heightInMeters = Double(details.height) / 10.0
        heightLabel.text = "키 : \(heightInMeters) m"
        let weightInMeters = Double(details.weight) / 10.0
        weightLabel.text = "몸무게 : \(weightInMeters) kg"
        
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        [typeLabel, heightLabel, weightLabel].forEach {
            $0.textColor = .white
            $0.textAlignment = .center
            // 줄 수를 무제한으로 설정, 줄 바꿈 가능
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 20)
        }
        
        imageView.contentMode = .scaleAspectFit
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
        stackView.layer.cornerRadius = 10
        // 둥근 모서리 밖 내용은 잘리게
        stackView.clipsToBounds = true
    }
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(150)
        }
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
    }
}
