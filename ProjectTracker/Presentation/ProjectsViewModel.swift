import Foundation
import RxSwift
import RxRelay

class ProjectsViewModel {
    
    let disposeBag = DisposeBag()
    let projects = BehaviorRelay<[Project]>(value: [])
    
    init() {
        debugPrint(NSHomeDirectory())
    }
    
    func addProject(with projectName: String) {
        if let existingProject = projects.value.first(where: { $0.name == projectName }) {
            debugPrint("Project with name \(existingProject.name) already exists!")
            return
        }
        
        let newProject = Project(name: projectName, timeSpent: 0, isActive: false)
        var existingProjects = projects.value
        existingProjects.append(newProject)
        existingProjects.sort { $0.name < $1.name }
        
        debugPrint("Adding new project: \(projectName)")
        projects.accept(existingProjects)
    }
    
    func projectSelected(_ project: Project) {
        guard let modifiedProjectIndex = projects.value.firstIndex(where: { $0.name == project.name }) else { return }
        var modifiedProjects = projects.value
        modifiedProjects[modifiedProjectIndex].isActive.toggle()
        modifiedProjects.sort { $0.name < $1.name }
        projects.accept(modifiedProjects)
    }
    
    func saveToJsonFile() {
        let pathDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = pathDirectory.appendingPathComponent("projects.json")
        
        do {
            try FileManager.default.createDirectory(at: pathDirectory, withIntermediateDirectories: true)
            let json = try JSONEncoder().encode(projects.value)
            try json.write(to: filePath)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func retrieveFromJsonFile() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("projects.json")
            
            let data = try Data(contentsOf: fileURL)
            var foo = try JSONDecoder().decode([Project].self, from: data)
            foo.sort { $0.name < $1.name }
            projects.accept(foo)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
