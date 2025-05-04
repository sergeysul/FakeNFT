import Foundation

struct UpdateProfileDto: Dto {
    let profile: Profile

    func asDictionary() -> [String: String] {
        return ["name": profile.name,
                "avatar": profile.avatar,
                "description": profile.description,
                "website": profile.website,
                "nfts": profile.nfts.joined(separator: ","),
                "likes": profile.likes.joined(separator: ","),
                "id": profile.id]
    }
}
