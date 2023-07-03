//
//  Content.swift
//  NetflixStyleApp
//
//  Created by 하영진 on 2023/06/22.
//

import UIKit

struct Content: Decodable {
    let sectionType: SectionType
    let sectionName: String
    let contentItem: [Item]
    
    enum SectionType: String, Decodable {
        case basic
        case main
        case large
        case rank
        
        var identifier: String {
            switch self {
            case .basic:
                return "ContentCollectionViewCell"
            case .main:
                return "ContentCollectionViewMainCell"
            case .large:
                return "ContentCollectionViewLargeCell"
            case .rank:
                return "ContentCollectionViewRankCell"
            }
        }
    }
}

struct Item: Decodable {
    let description: String
    let imageName: String
    
    var image: UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}
