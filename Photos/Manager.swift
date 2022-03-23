import UIKit
import Foundation

class Manager {
    
    static let shared = Manager()
    private init() {}
    
    func deleteAt(index: Int) {
        var array = loadArray()
        array.remove(at: index)
        update(items: array)
    }
    
    func update(items: [CustomImage]) {
        UserDefaults.standard.set(encodable: items, forKey: "key")
    }
    
    
    func save(item: CustomImage) {
        var array = Manager.shared.loadArray()
        array.insert(item, at: 0)
        UserDefaults.standard.set(encodable: array, forKey: "key")
        
    }
    
    
    func loadArray() -> [CustomImage] {
        
        let array = UserDefaults.standard.value([CustomImage].self, forKey: "key")
        return array ?? []
    }
    
    
    func saveImage(image: UIImage) -> String? {
        
        //1. Получить директорию
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        //2. создать уникальное имя файла
        let fileName = UUID().uuidString
        
        //3. Создать путь: директория + имя файла
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        //4. Преобразовать UIImage в 0101110100111
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        
        //5. Проверяем, есть ли там уже файл, если да - удаляем
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        //6. Записываем п.4 по пути п.3
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
        
    }
    
    
    func loadImage(fileName:String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
    
}
