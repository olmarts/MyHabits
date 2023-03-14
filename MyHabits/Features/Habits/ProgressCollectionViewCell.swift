import UIKit

final class ProgressCollectionViewCell: CustomCollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Всё получится!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .bar
        progressView.backgroundColor = .systemYellow
        progressView.progressTintColor = .purple
        progressView.progress = 0.0
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 5
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        [titleLabel, percentLabel, progressView].forEach({ addSubview($0) })

        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSettings.inset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSettings.inset),
            
            percentLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSettings.inset),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppSettings.inset),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSettings.inset),
            progressView.widthAnchor.constraint(equalTo: widthAnchor, constant: -AppSettings.inset * 2),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppSettings.inset),
        ])
    }
    
    func setProgress(_ progress: Float) {
        progressView.progress = progress
        percentLabel.text = "\(Int(progress * 100)) %"
    }
}

