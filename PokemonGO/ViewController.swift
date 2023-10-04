//
//  ViewController.swift
//  PokemonGO
//
//  Created by Enzo on 10/09/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDatePokemon: CoreDataPokemon!
    var pokemons: [Pokemon] =  []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //recuperar pokemons
        self.coreDatePokemon = CoreDataPokemon()
        self.pokemons =  self.coreDatePokemon.recuperarTodosPokemons()
        
        
        //Exibir Pokemons
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true)  { (timer) in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {

        let totalPokemons = UInt32(self.pokemons.count)
        let indicePokemonAleatorio = arc4random_uniform(totalPokemons)
        let pokemon = self.pokemons[ Int(indicePokemonAleatorio)]
                print(pokemon.nome)
                
            
            let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                
        let latAleatoria = (Double(arc4random_uniform(400)) - 200 ) / 100000.0
        let longAleatoria = (Double(arc4random_uniform(400))) - 200 / 100000.0
                
                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                
                self.mapa.addAnnotation( anotacao )
            
        }
        
    }
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
        anotacaoView.image = UIImage(named: "player")
        }else{
            
       // let pokemon = (annotation as! PokemonAnotacao).pokemon
        //anotacaoView.image = UIImage(named: pokemon.nomeImagem! )
        }
        //let anot = annotation as! PokemonAnotacao
            anotacaoView.image = UIImage(named: "pikachu-2")
            
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
            
        anotacaoView.frame = frame
        
        return anotacaoView
         
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let anotacao = view.annotation
        let pokemon = (view.annotation as! PokemonAnotacao).pokemon
        
        mapView.deselectAnnotation( anotacao, animated: true)

        if anotacao is MKUserLocation {
            return
        }
        
        if let coordAnotacao = anotacao?.coordinate  {
            let regiao = MKCoordinateRegion(center: coordAnotacao, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
            
        }
        Timer.scheduledTimer(withTimeInterval: 1,  repeats: false) { (timer) in
            
            if let coord = self.gerenciadorLocalizacao.location?.coordinate {
                
                self.mapa.visibleMapRect.contains(MKMapPoint(coord))
                print("voce pode capturar o pokemon")
                self.coreDatePokemon.salvarPokemon(pokemon: pokemon)
                self.mapa.removeAnnotation(anotacao! )
                
                let alertController = UIAlertController(title: "Parabéns", message: "voce capturou o \(pokemon.nome!) ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                
            }else{
                let alertController = UIAlertController(title: "voce nao pode capturar o pokemon", message: "voce precisa se aproximar mais para  capturar o \(pokemon.nome!) ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)            }
        }
        
        }

        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegion(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        
        if contador < 3 {
       self.centralizar()
        contador += 1
        } else {
       }
        
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            //Alerta
            let alertController = UIAlertController(title: "Permissao de localizacao", message: "Para que você possa caçar pokemons, precisamos de sua localizacao!! por favor habilite" , preferredStyle: .alert)
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configuracoes", style: .default, handler:  { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            })
            
            let acaoCancelar = UIAlertAction(title: "cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }

        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
   
    func centralizar(){
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegion(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    @IBAction func centralizarJogador(_ sender: AnyObject) {
       self .centralizar()
            }
    
            //self.centralizar()
        

    
    @IBAction func abrirPokedex(_ sender: AnyObject) {
    }


}
