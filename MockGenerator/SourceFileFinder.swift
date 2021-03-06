import Foundation

class SourceFileFinder {
    
    private let projectRoot: URL
    
    init(projectRoot: URL) {
        self.projectRoot = projectRoot
    }
    
    func findSourceFiles() -> [String] {
        let enumerator = FileManager.default.enumerator(atPath: projectRoot.path)
        var files = [String]()
        while let file = enumerator?.nextObject() as? String {
            if file.hasSuffix(".swift") {
                files.append(projectRoot.path + "/" + file)
            }
        }
        return files
    }
}
