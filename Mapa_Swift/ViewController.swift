//
//  ViewController.swift
//  Mapa_Swift
//
//  Created by Antonio Olvera on 30/07/16.
//  Copyright © 2016 My ManzanitaTI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import Darwin



class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var Mapa: MKMapView!
    
    @IBOutlet weak var Mostrar: UILabel!
    @IBOutlet weak var Cambio: UISegmentedControl!
    private let manejador = CLLocationManager()
    var punto = CLLocationCoordinate2D()
    var region =  MKCoordinateRegion()
    var poner_punto = 0
    var centrar = 0
    var distancia = 0.0
    var longi_actual = 0.0
    var lati_actual = 0.0
    var distancia_total = 0.0
    let decimales = 2.0
    var zoom_actual = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()

        
        
    }
    
    //FUNCION PARA EL CAMBIO DE VISTA DEL MAPA
    @IBAction func Cambio(sender: UISegmentedControl) {
        
        switch Cambio.selectedSegmentIndex
        {
        case 0:
            
            Mapa.mapType = MKMapType.Standard
            break
        case 1:
            Mapa.mapType = MKMapType.Satellite
            break
        case 2:
            Mapa.mapType = MKMapType.Hybrid
            break
        default:
            
            break
        }
        
        
    }
    
    
    
    //FUNCION PARA ZOOM
    
    @IBAction func Zoom(sender: UIStepper) {
        
        Mostrar.text = "Zoom \(String(sender.value*100))"
        var region = Mapa.region;
        var span = MKCoordinateSpan();
        
        if Int(sender.value) > zoom_actual {
            span.latitudeDelta = region.span.latitudeDelta/2;
            span.longitudeDelta = region.span.longitudeDelta/2;
            zoom_actual = Int(sender.value)
        }
        
        
        if Int(sender.value) < zoom_actual {
            span.latitudeDelta = region.span.latitudeDelta*2;
            span.longitudeDelta = region.span.longitudeDelta*2;
            zoom_actual = Int(sender.value)
        }
        
        
        
        region.span = span;
        Mapa.setRegion(region, animated: true)
        
        
      
        
        
        
        
    }
    
    
    
    
    //FUNCION PARA OBTENER LA LONG, LATI, EXACTI
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        punto.latitude = manager.location!.coordinate.latitude
        punto.longitude = manager.location!.coordinate.longitude
        let multiplicador = pow(10.0, decimales)
        
        let pin = MKPointAnnotation()
        if centrar == 0 {
            Mapa.setCenterCoordinate(punto, animated: true)
            centrar++
        }
        
        
        if poner_punto == 0{
            pin.title = "Lat \(round(punto.latitude * multiplicador) / multiplicador), Lon \(round(punto.longitude*multiplicador)/multiplicador)"
            pin.subtitle="Distancia Total \(round(distancia_total*multiplicador)/multiplicador)"
            distancia_total+=distancia
            pin.coordinate = punto
            Mapa.addAnnotation(pin)
            lati_actual = punto.latitude
            longi_actual = punto.longitude
            poner_punto++
            
        }
        
        distancia = distancia(punto.latitude, lon1: punto.longitude, lat2: lati_actual, lon2: longi_actual)
        
        NSLog(String(distancia))
        if distancia >= 50 {
            poner_punto=0
            
        }
        
       
        
    }
    
    
    //FUNCION PARA CALCULAR LA DISTANCIA ENTRE DOS PUNTOS
    
    
    func distancia(var lat1: Double, var lon1:Double, var lat2:Double, var lon2:Double)-> Double{
        
        let deg2radMultiplier = 3.14159265358979323846/180;
        lat1 = abs(lat1 * deg2radMultiplier)
        lon1 = abs(lon1 * deg2radMultiplier)
        lat2 = abs(lat2 * deg2radMultiplier)
        lon2 = abs(lon2 * deg2radMultiplier)
        let radius:Double = 6378.137
        let dlon = lon2 - lon1;
        let distance:Double = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(dlon)) * radius
    
        return distance*1000
        
    }
    
    
    
    
    //FUNCION PARA PEDIR AUTORIZACION
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            Mapa.showsUserLocation = true
        }
        else {
            manejador.stopUpdatingLocation()
            Mapa.showsUserLocation = false
            
        }
    }


    //FUNCION PARA MANDAR MENSAJE DE ERROR EN CASO FALLA EN OBTENER POSICION
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController (title: "ERROR", message: "Error: \(error.code)", preferredStyle: .Alert)
        let accionOK = UIAlertAction (title: "OK", style: .Default, handler: {
            accion in
        })
        
        alerta.addAction(accionOK)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

