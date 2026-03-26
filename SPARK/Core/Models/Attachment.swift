import Foundation

enum Attachment: Identifiable, Codable, Hashable {
    case voice(VoiceAttachment)
    case sketch(SketchAttachment)

    var id: UUID {
        switch self {
        case .voice(let attachment):
            return attachment.id
        case .sketch(let attachment):
            return attachment.id
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case voice
        case sketch
    }

    private enum Kind: String, Codable {
        case voice
        case sketch
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .type)
        switch kind {
        case .voice:
            self = .voice(try container.decode(VoiceAttachment.self, forKey: .voice))
        case .sketch:
            self = .sketch(try container.decode(SketchAttachment.self, forKey: .sketch))
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .voice(let attachment):
            try container.encode(Kind.voice, forKey: .type)
            try container.encode(attachment, forKey: .voice)
        case .sketch(let attachment):
            try container.encode(Kind.sketch, forKey: .type)
            try container.encode(attachment, forKey: .sketch)
        }
    }
}
