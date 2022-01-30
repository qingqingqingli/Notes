//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Qing Li on 23/01/2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    var titleLabel = UILabel()
    var contentLabel = UILabel()
    var creationTimeLabel = UILabel()
    var avatarImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
        
        creationTimeLabel.font = .systemFont(ofSize: 10)
        creationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(creationTimeLabel)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        let widthPadding: CGFloat = 20
        let heightPadding: CGFloat = 8
        let labelHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: heightPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: heightPadding / 2),
            contentLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    // MARK: - Configure note
    func configure(note: Note){
        titleLabel.text = note.title
        contentLabel.text = note.content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
