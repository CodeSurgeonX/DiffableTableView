//
//  ViewController.swift
//  DiffableTableView
//
//  Created by Shashwat Kashyap on 22/01/24.
//

import UIKit

struct SectionData: Hashable {
    var sectionName: String
    var rows: [RowData]
    let uuid = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        _ = hasher.finalize()
    }
}

struct RowData: Hashable {
    var name: String
    let uuid = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        _ = hasher.finalize()
    }
}

var dummy: [SectionData] = [.init(sectionName: "Digits",
                              rows: [.init(name: "1"),
                                     .init(name: "2")
                              ]),
                        .init(sectionName: "Alphabets", rows: [
                            .init(name: "A"),
                            .init(name: "F")
                        ])]


class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.delegate = self
        self.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        view.register(CustomCell.self, forCellReuseIdentifier: String(describing: CustomCell.self))
        return view
    }()
    
    
    var dataSource: UITableViewDiffableDataSource<SectionData, RowData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = UITableViewDiffableDataSource<SectionData, RowData>(tableView: self.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell
            cell?.configWith(dummy[indexPath.section].rows[indexPath.row].name)
            return cell
        })
        
        
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionData, RowData>()
        snapshot.appendSections(dummy)
        for section in dummy {
            snapshot.appendItems(section.rows, toSection: section)
            snapshot.appendItems(section.rows, toSection: section)
        }
        self.dataSource?.apply(snapshot)
        
        doSomeCoolThings()
        
    }
    
    func doSomeCoolThings() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            dummy[0].rows.append(.init(name: "3"))
            dummy[0].rows.append(.init(name: "4"))
            self?.reload()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: { [weak self] in
            dummy[1].rows.append(.init(name: "B"))
            dummy[1].rows.append(.init(name: "C"))
            self?.reload()
        })
        
    }
    
    
    func reload() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionData, RowData>()
        snapshot.appendSections(dummy)
        for section in dummy {
            snapshot.appendItems(section.rows, toSection: section)
            snapshot.appendItems(section.rows, toSection: section)
        }
        self.dataSource?.apply(snapshot)
    }
    
}


class CustomCell: UITableViewCell {
    
    var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialise()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.textColor = .red.withAlphaComponent(0.6)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    public func configWith(_ string: String) {
        self.label.text = string
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        print(cell.label.text)
    }
    
}
