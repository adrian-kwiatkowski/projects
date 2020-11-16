import UIKit

class ProjectsViewController: UIViewController {
    
    private let mainView: ProjectsView
    private let alertController = UIAlertController(title: "Add new project", message: "Enter project name:", preferredStyle: .alert)
    
    init(mainView: ProjectsView = ProjectsView()) {
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Projects Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        setupAlertController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    private func setupAlertController() {
        alertController.addTextField()
        if let textField = alertController.textFields?.first {
            textField.clearButtonMode = .whileEditing
            textField.addTarget(self, action: #selector(textfieldValueChanged(sender:)), for: .editingChanged)
        }
        
        let submitAction = UIAlertAction(title: "Confirm", style: .cancel) { [weak self] _ in
            guard let textField = self?.alertController.textFields?.first,
                  let projectName = textField.text else { return }
            self?.mainView.addNewProjectTapped(with: projectName)
            textField.text?.removeAll()
            textField.sendActions(for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { [weak self] _ in
            self?.alertController.dismiss(animated: true)
        }
        
        submitAction.isEnabled = false
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
    }
    
    @objc private func addButtonTapped() {
        present(alertController, animated: true)
    }
    
    @objc private func textfieldValueChanged(sender: UITextField) {
        guard let action = alertController.actions.first else { return }
        guard let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        action.isEnabled = !text.isEmpty
    }
}
