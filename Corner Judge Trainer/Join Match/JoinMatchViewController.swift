//
//  JoinMatchViewController.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid
import RxSwift
import RxCocoa

public final class JoinMatchViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var originControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewMatchButton: RoundedButton!

    let viewModel = JoinMatchViewModel()
    let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        createNewMatchButton.rx.tap.single().subscribeNext { [weak self] in
            let newMatchViewController = NewMatchViewController()
            self?.navigationController?.pushViewController(newMatchViewController, animated: true)
        } >>> disposeBag

        originControl.rx.selectedSegmentIndex <-> viewModel.selectedIndex >>> disposeBag
    }

    private func setupTableView() {
        JoinMatchTableViewCell.registerNib(tableView)

        viewModel.cellViewModels.bindTo(tableView.rx.items(
            cellIdentifier: JoinMatchTableViewCell.identifier,
            cellType: JoinMatchTableViewCell.self
        )) { row, cellViewModel, cell in
            cell.configure(with: cellViewModel)
        } >>> disposeBag

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let welf = self else { return }
            let matchViewController = MatchViewController(matchViewModel: welf.viewModel.matchViewModel(for: indexPath.row))
            welf.navigationController?.pushViewController(matchViewController, animated: true)
        }) >>> disposeBag
    }
}
