import UIKit

public enum CollectionItems {}

open class CollectionItem<CellType: ConfigurableCell>: CollectionItemConfigurable {
    // MARK: - Properties

    /// Модель данных
    public private(set) var viewModel: CellType.ViewModelType

    override public var cellVM: CollectionCellVM {
        // swiftlint:disable:next force_cast
        viewModel as! CollectionCellVM
    }

    // MARK: - Init

    public init(viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        identifier = "\(Date().timeIntervalSince1970)"
    }

    public init(id: Int, viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.identifier = "\(id)"
    }

    public init(id: String, viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.identifier = id
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
        guard let object = object as? CollectionItem<CellType> else { return false }

        guard identifier == object.identifier else { return false }
        return viewModel == object.viewModel
    }
}
