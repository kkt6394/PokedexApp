//
//  PokeCell.swift
//  PokedexApp
//
//  Created by 김기태 on 5/15/25.
//

import UIKit
import Kingfisher

final class PokeCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(with details: Details) {
        let id = details.id 
        let urlStirng = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlStirng) else { return }
        
        imageView.kf.setImage(
            with: url
        )
    }
}
