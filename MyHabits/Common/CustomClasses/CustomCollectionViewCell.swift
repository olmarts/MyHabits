/*
 Ячейка с настраиваемой шириной для UICollectionView.
 
 Класс UICollectionView имеет мало возможностей задавать размеры ячеек,
 которые динамически изменяются в зависимости от их контента.
 Свойство layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
 помогает в этом, но в данном случае необходимо явно указать ширину ячейки,
 чтобы все ячейки коллекции имели одинаковую ширину.
 Данный базовый класс ячейки коллекции позволяет это сделать.
 
 A. Ячейка UICollectionViewCell
 Просто установить класс CustomCollectionViewCell в качестве суперкласса:
 final class MyCollectionViewCell: CustomCollectionViewCell { ... }
 
 Примечание: Для ячейки важно правильно настроить NSLayoutConstraint так, чтобы
 высота ячейки автоматически подстраивалась под ее контент.
 
 
 B. Коллекция UICollectionView
 
 1. Задать layout.estimatedItemSize:
 private lazy var collectionView: UICollectionView = {
 let layout = UICollectionViewFlowLayout()
 layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
 let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
 collectionView.translatesAutoresizingMaskIntoConstraints = false
 ...
 return collectionView
 }()
 
 2. При повороте экрана необходимо заново отрендерить все видимые ячейки:
 override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
 collectionView.reloadData()
 }
 
 3. Установить желаемую ширину ячейки cell.cellWidth:
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = ...
 cell.cellWidth = collectionView.bounds.width
 return cell
 }
 */
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    lazy var widthConstraint = self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
    
    lazy var cellWidth: CGFloat? = nil {
        didSet {
            if let width = cellWidth  {
                self.widthConstraint.constant = width
                self.widthConstraint.isActive = true
                self.setNeedsLayout()
            }
        }
    }
}
