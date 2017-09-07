import XCTest
import SourceKittenFramework
@testable import SwiftStructureInterface

class RecursiveElementVisitorTests: XCTestCase {

    var visitor: RecursiveElementVisitor!
    var mockInnerVisitor: MockElementVisitor!

    override func setUp() {
        super.setUp()
        mockInnerVisitor = MockElementVisitor()
        visitor = RecursiveElementVisitor(visitor: mockInnerVisitor)
    }

    override func tearDown() {
        visitor = nil
        mockInnerVisitor = nil
        super.tearDown()
    }

    // MARK: - visit

    func test_visit_shouldRecursivelyForwardToInnerVisitor() {
        let file = getClassFile() as! SwiftFile
        let classElement = file.children[0] as! SwiftElement
        let innerClass = classElement.children[0] as! SwiftElement
        let innerMethod = innerClass.children[0] as! SwiftElement
        let method = classElement.children[1] as! SwiftElement
        file.accept(visitor)
        XCTAssertEqual(getInvokedSwiftElementCount(), 5)
        XCTAssert(getInvokedSwiftElement(at: 0) === file)
        XCTAssert(getInvokedSwiftElement(at: 1) === classElement)
        XCTAssert(getInvokedSwiftElement(at: 2) === innerClass)
        XCTAssert(getInvokedSwiftElement(at: 3) === innerMethod)
        XCTAssert(getInvokedSwiftElement(at: 4) === method)

        XCTAssertEqual(getInvokedSwiftTypeElementCount(), 2)
        XCTAssert(getInvokedSwiftTypeElement(at: 0) === classElement)
        XCTAssert(getInvokedSwiftTypeElement(at: 1) === innerClass)

        XCTAssertEqual(getInvokedSwiftFileCount(), 1)
        XCTAssert(getInvokedSwiftFile(at: 0) === file)

        XCTAssertEqual(getInvokedSwiftMethodElementCount(), 2)
        XCTAssert(getInvokedSwiftMethodElement(at: 0) === innerMethod)
        XCTAssert(getInvokedSwiftMethodElement(at: 1) === method)
    }

    // MARK: - Helpers

    private func getInvokedSwiftElement(at index: Int) -> SwiftElement {
        return mockInnerVisitor.invokedVisitSwiftElementParametersList[index].element
    }

    private func getInvokedSwiftTypeElement(at index: Int) -> SwiftTypeElement {
        return mockInnerVisitor.invokedVisitSwiftTypeElementParametersList[index].element
    }

    private func getInvokedSwiftFile(at index: Int) -> SwiftFile {
        return mockInnerVisitor.invokedVisitSwiftFileParametersList[index].element
    }

    private func getInvokedSwiftMethodElement(at index: Int) -> SwiftMethodElement {
        return mockInnerVisitor.invokedVisitSwiftMethodElementParametersList[index].element
    }

    private func getInvokedSwiftElementCount() -> Int {
        return mockInnerVisitor.invokedVisitSwiftElementCount
    }

    private func getInvokedSwiftTypeElementCount() -> Int {
        return mockInnerVisitor.invokedVisitSwiftTypeElementCount
    }

    private func getInvokedSwiftFileCount() -> Int {
        return mockInnerVisitor.invokedVisitSwiftFileCount
    }

    private func getInvokedSwiftMethodElementCount() -> Int {
        return mockInnerVisitor.invokedVisitSwiftMethodElementCount
    }

    private func getClassFile() -> Element {
        return StructureBuilderTestHelper.build(from: getNestedClassString())!
    }

    private func getNestedClassString() -> String {
        return """
class A {

    class B: C, D {

        func innerMethodA() {}
    }

    func methodA() {}
}
"""
    }
}
