//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/23/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var mainViewControllerLogicController: MainViewControllerLogicController
    private var datasource: MainCollectionViewDatasource<Movie>?
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: MainViewController.createLayout())
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(mainViewControllerLogicController: MainViewControllerLogicController) {
        self.mainViewControllerLogicController = mainViewControllerLogicController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.render(.loading)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVC()
        
        self.mainViewControllerLogicController.getMovies { [weak self] (state) in
            self?.render(state)
        }
    }
    
    private func setupVC() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Movies"
        
        self.view.addSubview(collectionView)
        collectionView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "cellID")
        
        self.view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
    }
}

private extension MainViewController {
    func render(_ state: MainViewControllerViewState) {
        DispatchQueue.main.async { [unowned self] in
            switch state {
            case .loading:
                self.collectionView.isHidden = true
                self.spinner.isHidden = false
                self.spinner.startAnimating()
            case .presenting(let movies):
                self.collectionView.isHidden = false
                self.spinner.stopAnimating()
                self.datasource = MainCollectionViewDatasource(models: movies, reuseIdentifier: "cellID", cellConfigurator: { (movie, cell) in
                    let cell = cell as? ItemCell
                    cell?.imageUrl = "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
                })
                self.collectionView.dataSource = self.datasource
                self.collectionView.reloadData()
            case .failed(_):
                ()
                // Show an error view for example this one
            }
        }
    }
}

extension MainViewController {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5*16/9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5*16/9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: View State
enum MainViewControllerViewState {
    case loading
    case presenting([Movie])
    case failed(Error)
}

// MARK: Reusable datasource
class MainCollectionViewDatasource<Model>: NSObject, UICollectionViewDataSource {
    var models: [Model]
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void

    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cellConfigurator(model, cell)

        return cell
    }
}
