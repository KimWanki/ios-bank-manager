//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let yagomBank = BankManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //MARK: MainStackView(V)
        let mainStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.spacing = 8
            return view
        }()
        
        view.addSubview(mainStackView)
        
        let top = NSLayoutConstraint.init(item: mainStackView,
            attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide,
            attribute: .top, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint.init(item: mainStackView,
            attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide,
            attribute: .trailing, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint.init(item: mainStackView,
            attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide,
            attribute: .leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([top, trailing, leading])
        
        
        //MARK:- TopButtonStackView(H)
        let buttonStackView: UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            
            return view
        }()
        
        //MARK: TopButtonStackView(Elements)
        let makeButton: (String, UIColor, Selector) -> UIButton = { (title: String, Color: UIColor, function: Selector ) in
            let button = UIButton()
            button.setTitle("\(title)", for: .normal)
            button.addTarget(self, action: function, for: .touchUpInside)
            button.setTitleColor(Color, for: .normal)
            return button
        }
        
        let lineUpButton = makeButton("고객 10명 추가", .systemBlue, #selector(self.lineUp))
        let initButton = makeButton("초기화", .systemRed, #selector(self.initBank))
        
        buttonStackView.addArrangedSubview(lineUpButton)
        buttonStackView.addArrangedSubview(initButton)
        
        //MARK:- BankingStateStackView(H)
        let stateStackView: UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            return view
        }()
        
        //MARK: BankingStateStackView(Elements)
        let makeLabel: (String, UIColor) -> UILabel = { (text: String, Color: UIColor) in
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.textColor = .white
            label.font = .preferredFont(forTextStyle: .largeTitle)
            label.backgroundColor = Color
            return label
        }

        let waitingLabel = makeLabel("대기중", .systemGreen)
        let servingLabel = makeLabel("업무중", .systemPurple)

        stateStackView.addArrangedSubview(waitingLabel)
        stateStackView.addArrangedSubview(servingLabel)
        
        //MARK: Duration Label
        let durationLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.text = "업무시간 - 00:00:000"
            label.textAlignment = .center
            return label
        }()
        
        //MARK:- Add Main View
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(durationLabel)
        mainStackView.addArrangedSubview(stateStackView)
        
//        let buttonStackViewHeight = NSLayoutConstraint.init(item: buttonStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
//
//        let stateStackViewHeight = NSLayoutConstraint.init(item: stateStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
//
//        NSLayoutConstraint.activate([buttonStackViewHeight, stateStackViewHeight])
    }
    
    @objc func lineUp() {
        yagomBank.lineupClients()
        yagomBank.open()
    }
    
    @objc func initBank() {
        yagomBank.lineupClients()
        yagomBank.open()
    }
}

