import UIKit

/// Не используется пользователем
/// :nodoc:
public protocol BindingCell: AnyObject {
    /// Связывание ячейки с вьюмоделью
    ///
    /// - Parameter viewModel: viewModel
    func bind(viewModel: Any)

    /// Отвязать viewModel
    func unbind()
}

public protocol ConfigureCell: AnyObject {
    /// Конфигурация ячейки с моделью
    ///
    /// - Parameter viewModel: viewModel
    func configure(with viewModel: Any?)
}

/// Данный протокол должна реализовывать любая ячейка, которая используется через TableAdapter
public protocol ConfigurableCell: BindingCell, ConfigureCell {
    // MARK: Types

    /// Тип View Model
    associatedtype ViewModelType: SuperCellVM & Equatable
    var viewModel: ViewModelType? { get set }

    // MARK: Properties

    // >>> NIB
    static var cellNib: UINib? { get }
    //=== was
    // <<< NIB

    /// Идентификатор для повторного использования ячейки (Имеет реализацию по умолчанию)
    static var reuseId: String { get }

    // MARK: Configure

    /// Конфигурация ячейки используя объект ViewModel
    ///
    /// - Parameter viewModel: модель данных для ячейки
    func configure(with viewModel: ViewModelType)
}

public extension ConfigurableCell where Self: UITableViewCell {
    static var reuseId: String {
        String(describing: self)
    }

    // MARK: BindingCell

    /// Связывание ячейки с вьюмоделью
    ///
    /// Тип Any, чтобы избавиться от проблем с дженериками
    ///
    /// - Parameter viewModel: viewModel типа ViewModelType
    /// :nodoc:
    func bind(viewModel: Any) {
        self.viewModel = viewModel as? ViewModelType
    }

    /// Отвязать viewModel
    /// :nodoc:
    func unbind() {
        let vm = viewModel
        viewModel = nil
        vm?.unbind()
    }

    // MARK: ConfigureCell

    /// Конфигурация ячейки с моделью
    ///
    /// Тип Any, чтобы избавиться от проблем с дженериками
    ///
    /// - Parameter viewModel: viewModel типа ViewModelType
    func configure(with viewModel: Any?) {
        guard let vm = viewModel as? ViewModelType else { return }
        configure(with: vm)
    }
}

public extension ConfigurableCell where Self: UICollectionViewCell {
    static var reuseId: String {
        String(describing: self)
    }

    // MARK: BindingCell

    /// Связывание ячейки с вьюмоделью
    ///
    /// Тип Any, чтобы избавиться от проблем с дженериками
    ///
    /// - Parameter viewModel: viewModel типа ViewModelType
    /// :nodoc:
    func bind(viewModel: Any) {
        self.viewModel = viewModel as? ViewModelType
    }

    /// Отвязать viewModel
    /// :nodoc:
    func unbind() {
        let vm = viewModel
        viewModel = nil
        vm?.unbind()
    }

    // MARK: ConfigureCell

    /// Конфигурация ячейки с моделью
    ///
    /// Тип Any, чтобы избавиться от проблем с дженериками
    ///
    /// - Parameter viewModel: viewModel типа ViewModelType
    func configure(with viewModel: Any?) {
        guard let vm = viewModel as? ViewModelType else { return }
        configure(with: vm)
    }
}
