
Сделано в контексте MVVM на UITableView

+ CellView.swift

UITableViewCell, модель ячейки, допкэш на 1MB, чтобы не гонять каждый раз NSData -> UIImage

* ViewController.swift

VC, держит таблицу, UI тягает с Main.storyboard (внутри UIStackView, cell height жестко заданы)
Содержит мутный кусок кода для скроллинга таблицы на последнюю добавленную ячейку: сначала добавляется пустая ячейка, на нее делается move (без аниманции все), потом эта новая ячейка анимируется через fade in reload

* ViewControllerModel.swift

Аналог ViewModel для ячейки: поставляет данные в VC, реагирует на действия VC, запрашивает допданные из VC, дергает VC по асинхронным событиям, подписана на DataModel

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
