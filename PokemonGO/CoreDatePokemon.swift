//
//  CoreDatePokemon.swift
//  PokemonGO
//
//  Created by Enzo on 26/09/23.
//

import UIKit
import CoreData

class CoreDataPokemon {
    
    //recuperar o context
    func getContext() ->  NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    //let coreDataPokemon = CoreDataPokemon()
    
    func recuperarPokemonsCapturados(capturado : Bool) -> [Pokemon]{
        let context = self.getContext()
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        //requisicao.predicate = NSPredicate(format: "capturado == %@", capturado as CVarArg)
        
         do {
             
            let pokemons = try context.fetch(requisicao) as [Pokemon]
           return pokemons
        
        } catch {}
        print("Erro ao recuperar pokemons capturados")
        return[]
    }

    func recuperarTodosPokemons() -> [Pokemon] {
        let context = self.getContext()
        do{
            let pokemons = try context.fetch( Pokemon.fetchRequest()) as [Pokemon]
            if pokemons.count == 0 {
                self.adicionarTodosPokemons()
                return self.recuperarTodosPokemons()
            }
            return pokemons
        }catch{}
        return []
    }
    
        func salvarPokemon( pokemon: Pokemon ){
            let context = self.getContext()
            pokemon.capturado = true
            do{
                try context.save()
            }catch{}
        }

    //adicionar todos os pokemons
    func adicionarTodosPokemons(){
        
        let context = self.getContext()
        
        self.criarPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        self.criarPokemon(nome: "Pikachu", nomeImagem: "pikachu-2", capturado: true)
        self.criarPokemon(nome: "Player", nomeImagem: "player", capturado: false)
        self.criarPokemon(nome: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.criarPokemon(nome: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.criarPokemon(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.criarPokemon(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        do{
            try context.save()
            }catch{}
    }
    //criar os pokemons
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool ){
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context )
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
        
}
    //func recuperarTodosPokemons(){
        
    }
    

