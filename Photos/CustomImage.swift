import UIKit
import Foundation

class CustomImage: Codable {
    
    var imagePath: String?
    var comment: String?
    var like: Bool = false
    
    init() {}
    
    public enum CodingKeys: String, CodingKey {
        case imagePath, comment, like
    }
    
    
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.like = try container.decodeIfPresent(Bool.self, forKey: .like) ?? false
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.imagePath, forKey: .imagePath)
        try container.encode(self.comment, forKey: .comment)
        try container.encode(self.like, forKey: .like)
    }
}
