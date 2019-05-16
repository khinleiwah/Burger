//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

open class FSPagerViewCell: UICollectionViewCell {
    
    /// Returns the label used for the main textual content of the pager view cell.
    
    @objc
    open var titleLabel: UILabel? {
        if let _ = _titleLabel {
            return _titleLabel
        }
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.8) //UIColor.black.withAlphaComponent(0.6)
        
        let textLabel = UILabel(frame: .zero)
        //textLabel.frame(forAlignmentRect: CGRect.init(x: 20, y: 0, width: 100, height: 50))
        textLabel.textColor = .white
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.contentView.addSubview(view)
        view.addSubview(textLabel)
        
        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
        
        _titleLabel = textLabel
        return _titleLabel
    }
    
    @objc
    open var priceLabel: UILabel? {
        if let _ = _priceLabel {
            return _priceLabel
        }
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.green.withAlphaComponent(0.8) //UIColor.black.withAlphaComponent(0.6)
        
        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
        textLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.contentView.addSubview(view)
        view.addSubview(textLabel)
        
        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
        
        _priceLabel = textLabel
        return _priceLabel
    }
    
    /// Returns the image view of the pager view cell. Default is nil.
    @objc
    open var imageView: UIImageView? {
        if let _ = _imageView {
            return _imageView
        }
        let imageView = UIImageView(frame: .zero)
        self.contentView.addSubview(imageView)
        _imageView = imageView
        return imageView
    }
    
    fileprivate weak var _titleLabel: UILabel?
    fileprivate weak var _priceLabel: UILabel?
    fileprivate weak var _imageView: UIImageView?
    
    fileprivate let kvoContext = UnsafeMutableRawPointer(bitPattern: 0)
    fileprivate let selectionColor = UIColor(white: 0.2, alpha: 0.2)
    
    fileprivate weak var _selectedForegroundView: UIView?
    fileprivate var selectedForegroundView: UIView? {
        guard _selectedForegroundView == nil else {
            return _selectedForegroundView
        }
        guard let imageView = _imageView else {
            return nil
        }
        let view = UIView(frame: imageView.bounds)
        imageView.addSubview(view)
        _selectedForegroundView = view
        return view
    }
    
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            if newValue {
                self.selectedForegroundView?.layer.backgroundColor = self.selectionColor.cgColor
            } else if !super.isSelected {
                self.selectedForegroundView?.layer.backgroundColor = UIColor.clear.cgColor
            }
        }
        get {
            return super.isHighlighted
        }
    }
    
    open override var isSelected: Bool {
        set {
            super.isSelected = newValue
            self.selectedForegroundView?.layer.backgroundColor = newValue ? self.selectionColor.cgColor : UIColor.clear.cgColor
        }
        get {
            return super.isSelected
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.75
        self.contentView.layer.shadowOffset = .zero
    }
    
    deinit {
        if let priceLabel = _priceLabel {
            priceLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
        if let titleLabel = _titleLabel {
            titleLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = _imageView {
            imageView.frame = self.contentView.bounds
        }
        if let titleLabel = titleLabel {
            titleLabel.superview!.frame = {
                var rect = self.contentView.bounds
                let height = titleLabel.font.pointSize*1.5
                rect.size.height = height
                //rect.size.width = 200
                rect.origin.y = 0
                return rect
            }()
            titleLabel.frame = {
                var rect = titleLabel.superview!.bounds
                rect = rect.insetBy(dx: 8, dy: 0)
                rect.size.height -= 1
                rect.origin.y += 1
                return rect
            }()
        }
        if let priceLabel  = _priceLabel {
            priceLabel .superview!.frame = {
                var rect = self.contentView.bounds
                let height = priceLabel.font.pointSize*1.5
                rect.size.height = height
                rect.size.width = 70
                rect.origin.y = 25
                return rect
            }()
            priceLabel.frame = {
                var rect = priceLabel.superview!.bounds
                rect = rect.insetBy(dx: 8, dy: 0)
                rect.size.height -= 1
                rect.origin.y += 1
                return rect
            }()
        }
        if let selectedForegroundView = _selectedForegroundView {
            selectedForegroundView.frame = self.contentView.bounds
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == kvoContext {
            if keyPath == "font" {
                self.setNeedsLayout()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
