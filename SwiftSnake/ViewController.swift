import UIKit


class ViewController: UIViewController, SnakeViewDelegate {
	@IBOutlet var startButton:UIButton?
   
     @IBOutlet weak var length: UILabel!
	var snakeView:SnakeView?
	var timer:Timer?
    var calcTimer:Timer?
    var speed:Double = 0.4
//    var totalLife = 0
//    var totalTimes = 0
//    @IBAction func historyGrade(_ sender: UIButton) {
//        print("历史最高：\(self.getData())")
//    }
    let app = (UIApplication.shared.delegate) as! AppDelegate
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var enterGameBtn: UIButton!
    @IBOutlet weak var historyGradeBtn: UIButton!
    @IBOutlet weak var historyText: UILabel!
    @IBOutlet weak var heartTotal: UILabel!
    @IBOutlet weak var gameViewHeart: UILabel!
   
    @IBAction func historyGrande(_ sender: UIButton) {
        print("历史最高：\(self.getGrade())")
        
        historyText.text = "\(self.getGrade())"
        
    }
    
    @IBAction func normalMode(_ sender: UIButton) {
        self.endGame()
        self.speed = 0.4
        self.startGame(speed: 0.4)
    }
    @IBAction func difficultMode(_ sender: UIButton) {
        self.endGame()
        self.speed = 0.25
        self.startGame(speed: 0.25)
    }
    @IBAction func nightmareMode(_ sender: UIButton) {
        self.endGame()
        self.speed = 0.1
        self.startGame(speed: 0.1)
    }
    @IBAction func beginGame(_ sender: UIButton) {
        self.endGame()
        self.startGame(speed: speed)
    }
    let userDefault = UserDefaults.standard
    var snake:Snake?
	var fruit:Point?
    let savePath:String = "/users/bqy⁩/downloads⁩/SwiftSnake-master⁩/SwiftSnake/test.plist"
    var grade:Int = 0
    
	override func viewDidLoad() {
		super.viewDidLoad()
//        开始计时
       self.timeStart()
        setupUI()
	}
//    加载视图
    func setupUI() {
        var screen = UIScreen.main
//        设置❤️的位置
        heartTotal?.frame = CGRect(x: screen.bounds.size.width / 2 - 30, y: screen.bounds.size.height / 2 - 90, width: 92, height: 30)
//        设置历史最高按钮位置
        historyGradeBtn?.frame = CGRect(x: screen.bounds.size.width / 2 - 30, y: screen.bounds.size.height / 2 - 50, width: 62, height: 30)
        //设置进入游戏按钮位置
        enterGameBtn?.frame = CGRect(x: screen.bounds.size.width / 2 - 30, y: screen.bounds.size.height / 2, width: 62, height: 30)
//        设置历史最高文本显示位置
        historyText?.frame = CGRect(x: screen.bounds.size.width / 2 + 36, y: screen.bounds.size.height / 2 - 50, width: 62, height: 30)
//        设置回到首页按钮位置
        homeBtn?.frame = CGRect(x: screen.bounds.size.width - 66, y: 100, width: 62, height: 30)
//        设置重新开始按钮位置
        beginBtn?.frame = CGRect(x: screen.bounds.size.width - 66, y: 140, width: 62, height: 30)
//        设置分数显示位置
        length?.frame = CGRect(x: screen.bounds.size.width - 66, y: 180, width: 92, height: 30)
        //设置分数显示位置
        gameViewHeart?.frame = CGRect(x: screen.bounds.size.width - 66, y: 70, width: 92, height: 30)
        
        print("历史最高：\(getGrade())")
        self.view.backgroundColor = UIColor.gray
        historyText?.text = "\(self.getGrade())"
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        let snakeX = Int((width - height) / 2)
        
        let snakeFrame = CGRect(x: Int(snakeX), y: Int(0), width: Int(height), height: Int(height))
        
        self.snakeView = SnakeView(frame: snakeFrame)
        self.view.insertSubview(self.snakeView!, at: 0)
        
        
        if let view = self.snakeView {
            view.delegate = self
        }
        for direction in [UISwipeGestureRecognizerDirection.right,
                          UISwipeGestureRecognizerDirection.left,
                          UISwipeGestureRecognizerDirection.up,
                          UISwipeGestureRecognizerDirection.down] {
                            let gr = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
                            gr.direction = direction
                            self.view.addGestureRecognizer(gr)
        }
    }
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    func timerIntervalx() {
        if(app.totalLife >= 10){
            heartTotal?.text = "💖\(app.totalLife)"
        }else{
            heartTotal?.text = "💖\(app.totalLife) \(app.totalTimes)s"
        }
        
        gameViewHeart?.text = "💖\(app.totalLife)"
    }
    func timeStart() {
        if !(self.calcTimer != nil) {
            self.calcTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerIntervalx), userInfo: nil, repeats: true)
        }
    }
    func saveGrade(grade:Int) -> Void{
        userDefault.set(grade, forKey: "grade")
    }

    func getGrade() -> Int {
            let value = userDefault.integer(forKey: "grade")
            return value
    }

	func swipe (_ gr:UISwipeGestureRecognizer) {
		let direction = gr.direction
		switch direction {
		case UISwipeGestureRecognizerDirection.right:
			if (self.snake?.changeDirection(Direction.right) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.left:
			if (self.snake?.changeDirection(Direction.left) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.up:
			if (self.snake?.changeDirection(Direction.up) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.down:
			if (self.snake?.changeDirection(Direction.down) != nil) {
				self.snake?.lockDirection()
			}
		default:
			assert(false, "This could not happen")
		}
	}

	func makeNewFruit() {
		srandomdev()
		let worldSize = self.snake!.worldSize
		var x = 0, y = 0
		while (true) {
            x = Int(arc4random_uniform(UInt32(worldSize)))
            y = Int(arc4random_uniform(UInt32(worldSize)))
			var isBody = false
			for p in self.snake!.points {
				if p.x == x && p.y == y {
					isBody = true
					break
				}
			}
			if !isBody {
				break
			}
		}
		self.fruit = Point(x: x, y: y)
	}

    func startGame(speed:Double) {
        print(app.totalLife)
        if(app.totalLife <= 0){
            app.totalLife = 0
            let toast = ToastView()
            toast.showToast(text: "心心消耗完了！休息一下吧！", pos: .Top)
            return
        }
        app.totalLife -= 1
        
		if (self.timer != nil) {
			return
		}
        self.grade = 0
        length.text = "分数：\(String(describing: self.grade))"
		self.startButton!.isHidden = true
        let height = self.view.frame.size.height
		let worldSize = Int(height.truncatingRemainder(dividingBy: 100))
		self.snake = Snake(inSize: worldSize, length: 2)
		self.makeNewFruit()
		self.timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(ViewController.timerMethod(_:)), userInfo: nil, repeats: true)
        print("\(String(describing: self.snake!.length))")
        
		self.snakeView!.setNeedsDisplay()
	}

	func endGame() {
        if (self.timer == nil) {
            return
        }
        self.startButton?.setTitle("再来一次", for: .normal)
		self.timer!.invalidate()
//        如果本地储存的分数小于游戏结束时的分数，则存储新分数
        if self.getGrade() < self.grade {
          self.saveGrade(grade: self.grade)
        }
        
		self.timer = nil
        
	}

	func timerMethod(_ timer:Timer) {
		self.snake?.move()
		let headHitBody = self.snake?.isHeadHitBody()
        
		if headHitBody == true {
			self.endGame()
            self.startButton!.isHidden = false
			return
		}
        

		let head = self.snake?.points[0]
		if head?.x == self.fruit?.x &&
			head?.y == self.fruit?.y {
				self.snake!.increaseLength(2)
				self.makeNewFruit()
            self.grade += 2
            length.text = "分数：\(String(describing: self.grade))"
		}

		self.snake?.unlockDirection()
		self.snakeView!.setNeedsDisplay()
	}

	@IBAction func start(_ sender:AnyObject) {
        self.startGame(speed: speed)
	}

	func snakeForSnakeView(_ view:SnakeView) -> Snake? {
		return self.snake
	}
	func pointOfFruitForSnakeView(_ view:SnakeView) -> Point? {
		return self.fruit
	}
}
