
import Foundation
import SwiftData

final class SwiftDataStorage {

    // MARK: - Private properties
    private let modelContext: ModelContext

    
    // MARK: - Exposed methods
    init() throws {
        let container = try ModelContainer(for: MovieQueryEntity.self)
        self.modelContext = ModelContext(container)
    }
    
    func save<T>(_ model: T) where T : PersistentModel {
        modelContext.insert(model)
        try? modelContext.save()
    }

    func fetch<T: PersistentModel>() throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetch(descriptor)
    }
    
    func delete<T: PersistentModel>(_ models: [T]) {
        for model in models {
            modelContext.delete(model)
        }
        try? modelContext.save()
    }
}
