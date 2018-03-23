
Сделано в контексте MVVM на UITableView

1. CellView.swift
ячейка, модель ячейки, допкэш на 1MB чтобы не гонять каждый раз NSData -> UIImage
2. ViewController.swift
VC, держит таблицу, UI тягает с Main.storyboard
3. ViewControllerModel.swift
аналог ViewModel для ячейки, поставляет данные в VC, реагирует на действия VC, запрашивает доданные из VC, дергает VC по асинхронным событиям, подписана на DataModel
4. DataModel.swift
хранит массив Item
Item хранится в UserDefaults (NSCoding), содержит NSDate, String, NSData для изображения, token
DataModel хранит массив Item, дергает ImageSource по необходимости, создает Items, меняет имена Item
5. DataStorage.swift
хранилка данных в UserDefaults.
Иногда странным образом отваливается в симуляторе, фифти/фифти, вывожу «Strange UserDefaults error» в лог, иногда лечится перезапуском симулятора
6. ImageSource.h/.m
objc загрузка изображении: асинхронно по отношению к main thread, последовательно по отношению друг к другу (через NSCondition): загрузка item.image не начнется пока не исполнится прежний запрос. Дабы не держать Item, для которых нужна картинка и которым могут быть удалены используется Item.Token, а Item через weak-ссылки идут. weak-ссылки позволяют не делать запрос по удаленному item, token позволяет не дублировать запросы