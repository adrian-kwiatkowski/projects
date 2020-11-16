import UIKit
import RxSwift
import RxCocoa

class ProjectsView: UIView, UITableViewDelegate {
    
    private let viewModel: ProjectsViewModel
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init(viewModel: ProjectsViewModel = ProjectsViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        bindUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: String(describing: ProjectTableViewCell.self))
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func bindUI() {
        viewModel.projects.asDriver()
            .drive(tableView.rx.items(cellIdentifier: String(describing: ProjectTableViewCell.self), cellType: ProjectTableViewCell.self)) { (row, element, cell) in
                cell.configure(with: element, action: { self.viewModel.projectSelected(element) })
            }.disposed(by: viewModel.disposeBag)
        
        tableView.rx.modelDeleted(Project.self)
            .bind(onNext: { [weak self] in
                self?.viewModel.removeProject(with: $0.name)
            }).disposed(by: viewModel.disposeBag)
    }
    
    @objc private func appWillEnterBackground() {
        debugPrint("App will enter background")
        viewModel.saveToJsonFile()
    }
    
    @objc private func appWillEnterForeground() {
        debugPrint("App will enter foreground")
        viewModel.retrieveFromJsonFile()
    }
    
    func addNewProjectTapped(with name: String) {
        viewModel.addProject(with: name)
    }
}
