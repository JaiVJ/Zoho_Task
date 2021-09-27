//
//  WeatherViewController.swift
//  Zoho
//
//  Created by Jai on 26/09/21.
//

import UIKit

class WeatherDetailsViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    var gradientLayer = CAGradientLayer()
    var viewModel: WeatherViewModelData!

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var weatherMainView: CustomView!    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
        
    var weatherView: WeatherView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewData()
        createGredientBackground()
        setComponents()
        weatherView = .fromNib()
        weatherView.frame = weatherMainView.bounds
        weatherMainView.addSubview(weatherView)
        mainView.isHidden = true
        viewBind()
    }
    
    func collectionViewData()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        hourlyCollectionView?.setCollectionViewLayout(layout, animated: true)

        hourlyCollectionView.register(WeatherHourlyCollectionViewCell.nib, forCellWithReuseIdentifier: WeatherHourlyCollectionViewCell.identifier)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        hourlyCollectionView.showsVerticalScrollIndicator = false
        hourlyCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func viewBind() {
        viewModel.refreshData = {
                [unowned self] result in
                switch result {
                case .success:
                    self.bindData()
                    break;
                case .failure(let error):

                    self.showAlertError(messageStr: error)
                break;
            }
        }
    }
    
    private func bindData() {
        
        mainView.isHidden = false        
        cityLbl.text = viewModel.city
        dateLbl.text = viewModel.date
        self.hourlyCollectionView.reloadData()
        weatherView.loadData(viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getLocation()
    }
    
    override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         gradientLayer.frame = view.layer.bounds
    }


    func createGredientBackground() {

         let colorTop =  UIColor.init(named: "weather_gradiant_top")!.cgColor
         let colorBottom = UIColor.init(named: "weather_gradiant_bottom")!.cgColor
            
         gradientLayer.colors = [colorTop, colorBottom]
         gradientLayer.locations = [0.0, 1.0]
         gradientLayer.frame = self.view.bounds
                    
         self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    @IBAction func backAtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension WeatherDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        self.viewModel.weather?.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let modal = self.viewModel.weather?.hourly?[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHourlyCollectionViewCell.identifier, for: indexPath) as! WeatherHourlyCollectionViewCell
        
    
        let icon = viewModel.getWeatherIconFor(
            icon: (modal?.weather?.count ?? 0) > 0 ? (modal?.weather?[0].icon ?? "sun.max.fill") : "sun.max.fill"
        )
        cell.iconView.image = icon
        cell.timeLbl.text = viewModel.getTimeFor(timestamp: modal?.dt ?? 0)
        cell.temperatureLbl.text = "\(viewModel.getTempFor(temp: modal?.temp ?? 0.0)) ℃"

        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 130, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }

}

extension WeatherDetailsViewController {
    
    func setComponents() {
        cityLbl.text = ""
        dateLbl.text = ""
        cityLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
        dateLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
    }
    
}
