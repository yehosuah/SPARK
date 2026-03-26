import Foundation
import PencilKit

protocol SketchService: AnyObject {
    func saveDrawing(_ drawing: PKDrawing, note: String?) throws -> SketchAttachment
}

final class DefaultSketchService: SketchService {
    func saveDrawing(_ drawing: PKDrawing, note: String?) throws -> SketchAttachment {
        let fileURL = try FileStorage.makeFileURL(prefix: "sketch", pathExtension: "drawing")
        try drawing.dataRepresentation().write(to: fileURL)
        return SketchAttachment(filePath: fileURL.path(), note: note)
    }
}
