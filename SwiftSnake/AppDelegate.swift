import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var calcTimer:Timer?
    var totalLife = 0
    var totalTimes = 60
    let userDefault = UserDefaults.standard
    // 声明成员变量 (相当于OC中的属性 @property)
    var window: UIWindow?
    
    // 当应用程序已经加载到内存是调用该方法
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("程序被加载到内存")
        return true
    }
    
    // 当应用程序取消激活状态时调用该方法
    func applicationWillResignActive(_ application: UIApplication) {
        print("取消激活")
        saveDate()
        saveSecond(second: totalTimes)
        saveLife(life: totalLife)
        //初始化日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMdd"
        userDefault.set(dformatter.string(from:Date()), forKey: "date")
        print(userDefault.integer(forKey: "life"),userDefault.integer(forKey: "second"))

    }
    
    // 当应用程序已经进入到后台时调用该方法
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("已经进入后台")
    }
    
    // 当应用程序进入前台时调用该方法
    func applicationWillEnterForeground(_ application: UIApplication) {
//        let lastDate = userDefault.integer(forKey: "lastDate")
        print("将要进入前台")
    }
    
    // 当应用程序已经被激活时调用该方法
    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("程序被激活")
        var lastDate = userDefault.integer(forKey: "lastDate")
        lastDate = Int(lastDate) == 0 ? getNowDataInt() : lastDate
        print("oldTime:\(lastDate)---\(getNowDataInt())")
        
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyyMMdd"
////        上次
////        let old = userDefault.string(forKey: "date")
////        let now = dformatter.string(from: Date())
////        
////        print("上次时间\(dformatter.date(from: old!))")
////        print("当前时间\(now)")
////        if Calendar.current.isDate(dformatter.date(from: old!)!, inSameDayAs: dformatter.date(from: now)!) {
////            print("它们是同一天:\(old)")
////        }else {
////            print("它们不是同一天old:\(old),now:\(now)")
////        }
        
//
//        let nowDate = getNowDataInt()
//
        let temp = userDefault.integer(forKey: "life") // + (nowDate - lastDate) / 60
   
        totalLife = temp // >= 10 ? 10 : temp
        totalTimes = userDefault.integer(forKey: "second")
//        print("回来得到的心心：\((nowDate - lastDate) / 60)")
        timeStart()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            //code
            print("1 秒后输出")
            let toast = ToastView()
            if(self.getNowDataInt() - lastDate > 0){
            toast.showToast(text: "欢迎回来！距离上次离开已有\(self.getNowDataInt() - lastDate)秒", pos: .Bottom)
            }
        }

    }
    
    // 当应用程序结束时调用该方法
    func applicationWillTerminate(_ application: UIApplication) {
        print("程序结束")
        
    }
    
    func timerIntervalx() {
        if(totalLife >= 10){
            totalTimes = 60
          return
        }
        if totalTimes < 1 {
            totalTimes = 60
            totalLife += 1
            self.saveHeart(heart: totalLife)
        }
        
        totalTimes -= 1;
    
//        heartTotal?.text = "💖\(totalLife) \(totalTimes)s"
    }
    func timeStart() {
        if !(self.calcTimer != nil) {
            self.calcTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerIntervalx), userInfo: nil, repeats: true)
        }
    }
    
    func getHeart() -> Int{
        let value = userDefault.integer(forKey: "heart")
        return value
    }
    func saveHeart(heart:Int){
        userDefault.set(heart, forKey: "heart")
    }
    func saveSecond(second:Int){
        userDefault.set(second, forKey: "second")
    }
    func saveLife(life:Int){
        userDefault.set(life, forKey: "life")
    }
    func saveDate(){
        userDefault.set(getNowDataInt(), forKey: "lastDate")
    }
    func getNowDataInt() -> Int {
        
        // 当前的时间 例如 "May 31, 2017, 10:43 AM"
        
        let date:NSDate = NSDate()
        
        // 把时间转换成时间戳 例如 1496198622.22576，想要毫秒的话直接time * 1000就可以了
        
        let time: TimeInterval = date.timeIntervalSince1970
        
        return Int(time)
        
    }
}
