//
//  APOD.swift
//  SwiftData-Sample
//
//  Created by Bhavesh on 09/01/24.
//

import SwiftData
import Foundation

@Model class APOD: Decodable {
    
    public var date: String?
    public var explanation: String?
    public var hdUrl: String?
    public var isFavorite: Bool
    public var mediaType: String?
    public var thumbnail: String?
    public var title: String?
    public var url: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdUrl = "hdurl"
        case mediaType = "media_type"
        case thumbnail = "thumbnail_url"
        case title
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        explanation = try? container.decode(String?.self, forKey: .explanation)
        hdUrl = try? container.decode(String?.self, forKey: .hdUrl)
        mediaType = try? container.decode(String?.self, forKey: .mediaType)
        thumbnail = try? container.decode(String?.self, forKey: .thumbnail)
        title = try? container.decode(String?.self, forKey: .title)
        url = try? container.decode(String?.self, forKey: .url)
        date = try? container.decode(String?.self, forKey: .date)
        isFavorite = false
    }
}

enum APODMediaType: String {
    case image
    case video
    case unknown
}

enum Constants {
    static let noSpace = ""
}

extension APOD {
    var APODMediaTypeEnum: APODMediaType {
        if let apodMediaType = APODMediaType(rawValue: mediaType ?? Constants.noSpace) {
              return apodMediaType
          }
          return APODMediaType.unknown
    }
   
    var imageURL: String? {
      switch APODMediaTypeEnum {
      case .image:
          return url
      case .video:
          return thumbnail
      default:
          return nil
      }
   }
}
