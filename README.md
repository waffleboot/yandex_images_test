
Сделано на UITableView

+ CellView.swift

UITableViewCell

* ViewController.swift

VC, держит таблицу и реакцию на пользовательские клики, подписан на data model и выступает делегатом к ней, UI тягает с Main.storyboard (внутри UIStackView, cell height жестко заданы)
Содержит мутный кусок кода для скроллинга таблицы на последнюю добавленную ячейку: сначала добавляется пустая ячейка, на нее делается move (без анимации), потом эта новая ячейка обновляется через fade animation.

* CellViewConfigurator.swift

Конфигурит ячейку из модельного item + кэш изображении


* DataModel.swift

Хранит массив Item

Item хранится в UserDefaults (NSCoding), содержит NSDate, String, NSData для изображения, Token

DataModel хранит массив Item, дергает ImageSource если нет изображения, создает Items, меняет имена Item

* DataStorage.swift

Хранилка данных в UserDefaults.

Иногда странным образом отваливается в симуляторе, фифти/фифти, вывожу «Strange UserDefaults error» в лог, иногда лечится перезапуском симулятора

* ImageSource.h/.m

ObjC загрузка изображении: асинхронно по отношению к main thread, последовательно по отношению друг к другу (через NSCondition): загрузка не начнется пока не исполнится прежний запрос. Item все в ImageSource работают через weak-ссылки, так что для удаленных Item загрузок не будет. Чтобы не дублировать запросы по одному и тому же Item используется Token. Приостановку загрузки при resign active/background не делал.

![screenshot](https://github.com/waffleboot/yandex_images_test/blob/master/yandex_images_test.png)
