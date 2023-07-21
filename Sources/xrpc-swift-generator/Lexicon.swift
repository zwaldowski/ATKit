import Foundation

struct Lexicon: Identifiable, Decodable {

    var lexicon: Int
    var id: String
    var revision: Int?
    var description: String?
    var defs: [String: Definition]
    var swiftTypeNamePrefix = ""
    var swiftIdentifierPrefix = ""
    
    enum CodingKeys: CodingKey {
        case lexicon, id, revision, description, defs
    }

}

extension Lexicon {
    
    init(contentsOf url: URL) throws {
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        self = try decoder.decode(Self.self, from: data)
    }

}
