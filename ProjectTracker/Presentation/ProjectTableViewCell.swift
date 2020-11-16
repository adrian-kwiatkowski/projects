import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    var timer: Timer?
    var project: Project?
    var accessoryViewAction: (( ) -> ( ))?
    
    func configure(with project: Project, action: @escaping ( ) -> ( )) {
        self.project = project
        fireTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        selectionStyle = .none
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: project.isActive ? "pause.circle" : "play.circle"), for: [])
        accessoryViewAction = action
        button.addTarget(self, action: #selector(accessoryTapped), for: .touchUpInside)
        accessoryView = button
        button.sizeToFit()
    }
    
    @objc private func accessoryTapped() {
        accessoryViewAction?()
    }
    
    @objc private func fireTimer() {
        var configuration = defaultContentConfiguration()
        configuration.text = project?.name
        
        var timeSpent = project?.timeSpent ?? 0
        
        if let startedAt = project?.startedAt {
            timeSpent += Int(Date().timeIntervalSince(startedAt))
        }
        
        let seconds = timeSpent % 60
        let minutes = (timeSpent / 60) % 60
        let hours = (timeSpent / 3600)
        
        configuration.secondaryText = "\(hours)h \(minutes)min \(seconds)sec"
        
        contentConfiguration = configuration
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        project = nil
        timer?.invalidate()
        
        accessoryViewAction = nil
    }
}
