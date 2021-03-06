import SourceKittenFramework

class ResolveUtil {

    static var files = [String]()
    private let tempFileWriter = TempFileWriterUtil()
    private var tempFile: String { return tempFileWriter.tempFile }

    func resolve(_ element: Element) -> Element? {
        guard let file = element.file else { return nil }
        tempFileWriter.write(file.text)
        let arguments = ResolveUtil.files + [tempFile]
        let data = Request.cursorInfo(file: tempFile, offset: element.offset, arguments: arguments).send()
        if let path = data["key.filepath"] as? String,
           let offset = data["key.offset"] as? Int64,
           let file = SourceKittenFramework.File(path: path) {
            let structure = Structure(file: file)
            let resolvedFile = StructureBuilder(data: structure.dictionary, text: file.contents).build()
            return CaretUtil().findElementUnderCaret(in: resolvedFile, cursorOffset: offset)
        }
        return nil
    }
}
