//
//  ViewControllerFotos.swift
//  Caile
//
//  Created by Nery on 28/12/17.
//  Copyright © 2017 Nery. All rights reserved.
//

import UIKit

class ViewControllerFotos: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,DescargaImagenReferenciaDelegate,UICollectionViewDelegateFlowLayout{
    
    var googlePlaceDatail = GooglePlaceDetail()
    var lsFotos = [GooglePlaceFoto]()
    
    let descargaFoto = DescargaImagenReferencia()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        construyeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //******************************************************************************************************************************************************
    //Metodos de collectionviewDelegate y CollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lsFotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let googleFoto = lsFotos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_fotos", for: indexPath) as! CollectionViewCellFotos
        if let foto = googleFoto.foto{
            cell.imageViewFoto.image = foto
        }else{
            //Descarga la foto
            self.descargaFoto.descarga(elemento: indexPath.row, referencia: googleFoto.referencia)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 120, height: 80)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    //******************************************************************************************************************************************************
    //Metodos de DescargaImagenReferenciaDelegate
    
    func descargaImagenReferencia(descargaImagenreferencia: DescargaImagenReferencia, fallido error: Error) {
        print(error.localizedDescription)
    }
    
    func descargaImagenReferencia(descargaImagenreferencia: DescargaImagenReferencia, fallido mensaje: String) {
        print(mensaje)
    }
    
    func descargaImagenReferencia(descargaImagenreferencia: DescargaImagenReferencia, correcto imagn: UIImage, elemento: Int) {
        lsFotos[elemento].foto = imagn
        collectionView.reloadData()
    }
    
    //******************************************************************************************************************************************************

    //Metodos generales
    func construyeUI()  {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.descargaFoto.delegate = self
        DispatchQueue.global(qos: .background).async {
            //back ground
            if let diccionarioFotos = self.googlePlaceDatail.fotos{
                for foto in diccionarioFotos{
                    let googleFoto =  GooglePlaceFoto(diccionario: foto)
                    self.lsFotos.append(googleFoto)
                }
            }else{
                //TODO : NOTIFICAR DE ALGUNA MANERA AL USUARIO QUE NO EXISTEN FOTOS
                print("no hay nada")
            }
            DispatchQueue.main.async {
                //hilo principal
                self.collectionView.reloadData()
            }
        }
        
    }
    //******************************************************************************************************************************************************
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
