
import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    var switchButton: [Int : Bool] = [:]
    private var isDarkModeEnabled: Bool = false
    private let colors = Colors()
    
    // MARK: - UI Elements
    
    private let tableView = UITableView()
    private let apiLabel = UILabel()
    private let versionLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupApiLabelView()
        setupVersionLabelView()
        setupConstraints()
    }

    // MARK: - Setup UI Elements
    
    private func setupView() {
        view.backgroundColor = colors.viewBackgroundColor
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ThemeTableViewCell.self, forCellReuseIdentifier: ThemeTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    private func setupApiLabelView() {
        let labelText = "Приложение использует API «Яндекс.Расписания»"
        let fontSize: CGFloat = 12
        let fontWeight: UIFont.Weight = .regular
        let letterSpacing: CGFloat = 0.4
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: colors.themeTintColor(),
            .kern: letterSpacing
        ]
        let attributedString = NSAttributedString(string: labelText, attributes: attributes)
        apiLabel.attributedText = attributedString
        apiLabel.textAlignment = .center
        apiLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(apiLabel)
    }
    
    private func setupVersionLabelView() {
        let labelText = "Версия 1.0 (beta)"
        let fontSize: CGFloat = 12
        let fontWeight: UIFont.Weight = .regular
        let letterSpacing: CGFloat = 0.4
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: colors.themeTintColor(),
            .kern: letterSpacing
        ]
        let attributedString = NSAttributedString(string: labelText, attributes: attributes)
        versionLabel.attributedText = attributedString
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 120),
            apiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            apiLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            apiLabel.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -16),
            apiLabel.heightAnchor.constraint(equalToConstant: 14),
            apiLabel.widthAnchor.constraint(equalToConstant: 343),
            versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            versionLabel.heightAnchor.constraint(equalToConstant: 14),
            versionLabel.widthAnchor.constraint(equalToConstant: 343),
        ])
    }
}

// MARK: - TableView Delegate & DataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeTableViewCell.reuseIdentifier, for: indexPath) as? ThemeTableViewCell else {
                return UITableViewCell()
            }
            cell.textLabel?.text = "Темная тема"
            cell.setupSwitch(isOn: isDarkModeEnabled) { [weak self] isOn in
                self?.isDarkModeEnabled = isOn
                if isOn {
                } else {
                }
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "Пользовательское соглашение"
            cell.accessoryType = .none
            let chevronImageView = UIImageView(image: UIImage(named: "Chevron"))
            chevronImageView.tintColor = colors.imageTintColor
            cell.accessoryView = chevronImageView
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            print("Переход на экран пользовательского соглашения")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


final class ThemeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ThemeTableViewCell"
    
    // MARK: - Private Properties
    
    private var switchHandler: ((Bool) -> Void)?
    
    // MARK: - UI Elements
    
    private let themeSwitch = UISwitch()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupThemeSwitch()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI Elements
    
    private func setupThemeSwitch(){
        themeSwitch.onTintColor = UIColor(resource: .blue)
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(themeSwitch)
    }
    
    public func setupSwitch(isOn: Bool, handler: @escaping (Bool) -> Void) {
        themeSwitch.isOn = isOn
        themeSwitch.removeTarget(nil, action: nil, for: .allEvents)
        themeSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        self.switchHandler = handler
    }

    // MARK: - Action Handling
    
    @objc private func switchValueChanged() {
        switchHandler?(themeSwitch.isOn)
    }

    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        switchHandler = nil
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            themeSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            themeSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.5),
            themeSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.5)
        ])
    }
}
