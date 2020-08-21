import UIKit

public enum TableRows {}

open class TableRow<CellType: ConfigurableCell>: TableRowConfigurable {
    // MARK: - Properties

    /// Модель данных
    public private(set) var viewModel: CellType.ViewModelType

    override open var cellVM: TableCellVM {
        // swiftlint:disable:next force_cast
        viewModel as! TableCellVM
    }

    // MARK: - Init

    public init(viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        id = "\(Date().timeIntervalSince1970)"
    }

    public init(id: Int, viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.id = "\(id)"
    }

    public init(id: String, viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.id = id
    }

    // MARK: - RowConfigurable

    /// Конфигурация ячейки
    ///
    /// - Parameter cell: Ячейка, которую необходимо сконфигурировать
    override public func configure(_ cell: UITableViewCell) {
        if let configurableCell = cell as? CellType {
            configurableCell.viewModel = viewModel
            configurableCell.configure(with: viewModel)
        }
    }

    override public func configure(collectionCell: UICollectionViewCell) {
        if let configurableCell = collectionCell as? CellType {
            configurableCell.viewModel = viewModel
            configurableCell.configure(with: viewModel)
        }
    }

    /// :nodoc:
    // >>> NIB
    override public var cellNib: UINib? {
        CellType.cellNib
    }

    //=== was
    // <<< NIB

    /// :nodoc:
    override public var reuseId: String {
        CellType.reuseId
    }

    /// :nodoc:
    override public var cellType: AnyClass {
        CellType.self
    }

    // MARK: - DeepHashable

    /// :nodoc:
    override public func equal(object: Any?) -> Bool {
        guard let object = object as? TableRow<CellType> else { return false }

        guard id == object.id else { return false }
        guard viewModel == object.viewModel else { return false }
        guard cellVM.isEqual(object.cellVM) else { return false }
        return true
    }
}
