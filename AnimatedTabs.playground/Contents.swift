//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class AnimatedTabBarController: UITabBarController {
    
    var indicatorView: UIView?
    var numberOfItems: CGFloat {
        guard let items = tabBar.items else { return 0 }
        return CGFloat(items.count)
    }
    var colors: [UIColor] {
        guard let vcs = viewControllers else { return [] }
        return vcs.map { return $0.view.backgroundColor ?? UIColor.red }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupVCs()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        let index = CGFloat(integerLiteral: items.index(of: item) ?? 0)
        let itemWidth = indicatorView?.frame.width ?? 0
        let newCenterX = (itemWidth / 2) + (itemWidth * index)
        var color = UIColor.red
        if colors.count > Int(index) {
            color = colors[Int(index)]
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
            self.indicatorView?.center.x = newCenterX
            self.indicatorView?.backgroundColor = color
        })
    }
    
    func setupVCs() {
        guard numberOfItems > 0 else { return }
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        let color = colors.first ?? UIColor.red
        indicatorView = createSelectionIndicator(color: color, size: tabBarItemSize, lineHeight: 4)
        indicatorView?.center.x = tabBar.frame.width / numberOfItems / 2
        guard let indicator = indicatorView else { return }
        tabBar.addSubview(indicator)
    }
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIView {
        guard indicatorView == nil else { return UIView() }
        let rect = CGRect(x: 0, y: size.height - lineHeight, width: size.width, height: lineHeight)
        let view = UIView(frame: rect)
        view.backgroundColor = color
        return view
    }
    
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        let tabVC = AnimatedTabBarController()
        tabVC.viewControllers = getVCs()
        for vc in tabVC.viewControllers! {
            let _ = vc.view
        }
        addChildViewController(tabVC)
        tabVC.view.frame = self.view.frame
        self.view.addSubview(tabVC.view)
        tabVC.didMove(toParentViewController: self)
    }
    
    func getVCs() -> [UIViewController] {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .orange
        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        return [vc1, vc2, vc3]
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
