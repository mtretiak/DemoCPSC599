//
//  ChatLogMessageCell.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-31.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    
    // MARK: - API
    
    var isSender: Bool? {
        didSet {
            guard let isSender = isSender else { return }
            _profileImageView.isHidden = isSender
            switch isSender {
            case  true:
                _bubbleImageView.tintColor = StyleSheet.defaultTheme.outGoingMessageColor
                _bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                _messageTextView.textColor = StyleSheet.defaultTheme.outGoingMessageTextColor
            case false:
                _bubbleImageView.tintColor = StyleSheet.defaultTheme.incomingMessageColor
                _bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                _messageTextView.textColor = StyleSheet.defaultTheme.incomingMessageTextColor
            }
        }
    }
    
    var message: Message? {
        didSet {
            _messageTextView.text = message?.body
            _usernameLabel.text = message?.from
        }
    }
    
    var textViewFrame: CGRect? {
        didSet {
            _messageTextView.frame = textViewFrame!
        }
    }
    
    var textBubbleViewFrame: CGRect? {
        didSet {
            _textBubbleView.frame = textBubbleViewFrame!
        }
    }
    
    
    // MARK: UI
    
    private let _usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private let _messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    private let _textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        return view
    }()
    private let _profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "user")
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    private let _bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    // MARK: - Layout code
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(_textBubbleView)
        addSubview(_messageTextView)
        addSubview(_profileImageView)
        addSubview(_usernameLabel)
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: _profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: _profileImageView)
        _textBubbleView.addSubview(_bubbleImageView)
        _textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: _bubbleImageView)
        _textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: _bubbleImageView)
        
        NSLayoutConstraint.activate([
            _usernameLabel.bottomAnchor.constraint(equalTo: _bubbleImageView.topAnchor),
            _usernameLabel.leftAnchor.constraint(equalTo: _bubbleImageView.leftAnchor, constant: 20),
            _usernameLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
}



