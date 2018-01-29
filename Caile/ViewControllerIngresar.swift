//
//  ViewControllerIngresar.swift
//  Caile
//
//  Created by Nery on 31/10/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit

class ViewControllerIngresar: UIPageViewController ,UIPageViewControllerDelegate,UIPageViewControllerDataSource{

    @objc lazy var viewControllersOrdenados: [UIViewController] = {
        return [self.nuevoViewController(viewController: Constantes.VIEW_CONTROLLER_CREAR_CUENTA),
                self.nuevoViewController(viewController: Constantes.VIEW_CONTROLLER_INGRESAR)]
    }()

    @objc var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inflaUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //**********************************************************************************************************************
    //Metodos de UIPAgeViewControllerDelegate y UIPAgeViewControllerDataSourse
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersOrdenados.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return viewControllersOrdenados.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard viewControllersOrdenados.count > previousIndex else {
            return nil
        }
        
        return viewControllersOrdenados[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersOrdenados.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewControllersOrdenados.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return viewControllersOrdenados.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return viewControllersOrdenados[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllersOrdenados.index(of: pageContentViewController)!
    }
    
    @objc func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllersOrdenados.count
    }
    
    @objc func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = viewControllersOrdenados.index(of:firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    //**********************************************************************************************************************
    //Metodos generales
    
    
    @objc func nuevoViewController(viewController:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    @objc func inflaUI() {
        self.dataSource = self
        self.delegate = self
        configurePageControl()
        // This sets up the first view that will show up on our page control
        if let firstViewController = viewControllersOrdenados.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    @objc func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = viewControllersOrdenados.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.yellow
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = MisColores.secondaryColor
        self.view.addSubview(pageControl)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
