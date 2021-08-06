//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let yagomBank = BankManager()
    var count = 0
    
    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "업무시간 - 00:00:000"
        label.textAlignment = .center
        return label
    }()
    
    let stateStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    let makeLabel: (String, UIColor) -> UILabel = { (text: String, Color: UIColor) in
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.backgroundColor = Color
        return label
    }
    
    let waitingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let waitingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let workingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let workingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //MARK: MainStackView(V)
        
        
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

        let waitingLabel = makeLabel("대기중", .systemGreen)
        let servingLabel = makeLabel("업무중", .systemPurple)
        
        stateStackView.addArrangedSubview(waitingLabel)
        stateStackView.addArrangedSubview(servingLabel)
        
        view.addSubview(waitingScrollView)
        view.addSubview(workingScrollView)
        waitingScrollView.addSubview(waitingStackView)
        workingScrollView.addSubview(workingStackView)
        
        NSLayoutConstraint.activate([
            waitingScrollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            waitingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            waitingScrollView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            waitingScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            waitingScrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            waitingScrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.centerXAnchor),

            waitingScrollView.contentLayoutGuide.topAnchor.constraint(equalTo: waitingStackView.topAnchor),
            waitingScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: waitingStackView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            workingScrollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            workingScrollView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            workingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workingScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            workingScrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            workingScrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.centerXAnchor),

            workingScrollView.contentLayoutGuide.topAnchor.constraint(equalTo: workingStackView.topAnchor),
            workingScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: workingStackView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            waitingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            waitingStackView.trailingAnchor.constraint(equalTo: view.centerXAnchor),

            workingStackView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            workingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        //MARK:- Add Main View
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(durationLabel)
        mainStackView.addArrangedSubview(stateStackView)
    }
    
    func addList() {
        let label: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .body)
            label.textColor = .black
            count += 1
            label.text = "\(count)"
            
            return label
        }()
        
        let label2: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .body)
            label.textColor = .black
            label.text = "\(count)업무중"
            
            return label
        }()
        
        waitingStackView.addArrangedSubview(label)
        
        workingStackView.addArrangedSubview(label2)
    }
    
    
    @objc func lineUp() {
        addList()
//        yagomBank.lineupClients()
//        yagomBank.open()
    }
    
    @objc func initBank() {
        yagomBank.lineupClients()
        yagomBank.open()
    }
}

