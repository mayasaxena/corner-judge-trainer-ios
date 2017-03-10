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

    let viewModel = JoinMatchViewModel()

    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        JoinMatchTableViewCell.registerNib(tableView)

        viewModel.cellViewModels.bindTo(tableView.rx.items(
            cellIdentifier: JoinMatchTableViewCell.cellIdentifier,
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
