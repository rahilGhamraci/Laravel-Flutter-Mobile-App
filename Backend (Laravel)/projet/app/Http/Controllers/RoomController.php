<?php

namespace App\Http\Controllers;
use App\Models\Room;
use App\Models\Enseignant;
use App\Models\Tuteur;
use App\Models\Classe;
use App\Models\Eleve;
use App\Models\Matiere;
use Illuminate\Http\Request;
use Auth;

class RoomController extends Controller
{   /**
    * Retourner les rooms de l'enseignant.
    *
    * @return \Illuminate\Http\Response
    */
    public function enstRooms(){
        $obj=[];
        $enst=Enseignant::where('user_id', Auth::user()->id)->first();
        $rooms=Room::where('enseignant_id',$enst->id)->get();

        $classes=Classe::where('id',$rooms[0]->classe_id)->get();
        $ensts=Enseignant::where('id',$rooms[0]->enseignant_id)->get();
        $mat=Matiere::where('id',$ensts[0]->matiere_id)->first();
        $obj1=[
            'id'                    => $rooms[0]->id,
            'classe_id'             => $rooms[0]->classe_id,
            'enseignant_id'         => $rooms[0]->enseignant_id,
            'niveau'                => $classes[0]->niveau,
            'section'               => $classes[0]->section,
            'nom'                   => $ensts[0]->nom,
            'prenom'                => $ensts[0]->prenom,
            'matiere'               => $mat->libelle,

        ];
        array_push($obj,$obj1);

        for ($i = 1; $i <  count($rooms); $i++) {
            $classes=Classe::where('id',$rooms[$i]->classe_id)->get();           
            $ensts=Enseignant::where('id',$rooms[$i]->enseignant_id)->get();
            $mat=Matiere::where('id',$ensts[0]->matiere_id)->first();
           

            $obj1=[
                'id'                    => $rooms[$i]->id,
                'classe_id'             => $rooms[$i]->classe_id,
                'enseignant_id'         => $rooms[$i]->enseignant_id,
                'niveau'                => $classes[0]->niveau,
                'section'               => $classes[0]->section,
                'nom'                   => $ensts[0]->nom,
                'prenom'                => $ensts[0]->prenom,
                'matiere'               => $mat->libelle,
    
            ];
            
            array_push($obj,$obj1);
            
        }

       
        return response()->json(
            $obj
            ,200);

    }
     /**
    * Retourner les rooms de l'eleve.
    *
    * @return \Illuminate\Http\Response
    */
    public function elvRooms(){
        $obj=[];
        $elv=Eleve::where('user_id', Auth::user()->id)->first();
        $rooms=Room::where('classe_id',$elv->classe_id)->get();
        // creer data à retourner
        $classes=Classe::where('id',$rooms[0]->classe_id)->get();
        $ensts=Enseignant::where('id',$rooms[0]->enseignant_id)->get();
        $mat=Matiere::where('id',$ensts[0]->matiere_id)->first();
        $obj1=[
             'id'                    => $rooms[0]->id,
             'classe_id'             => $rooms[0]->classe_id,
             'enseignant_id'         => $rooms[0]->enseignant_id,
             'niveau'                => $classes[0]->niveau,
             'section'               => $classes[0]->section,
             'nom'                   => $ensts[0]->nom,
             'prenom'                => $ensts[0]->prenom,
             'matiere'               => $mat->libelle,
 
         ];
         array_push($obj,$obj1);
 
         for ($i = 1; $i <  count($rooms); $i++) {
             $classes=Classe::where('id',$rooms[$i]->classe_id)->get();           
             $ensts=Enseignant::where('id',$rooms[$i]->enseignant_id)->get();
             $mat=Matiere::where('id',$ensts[0]->matiere_id)->first();
            
 
             $obj1=[
                 'id'                    => $rooms[$i]->id,
                 'classe_id'             => $rooms[$i]->classe_id,
                 'enseignant_id'         => $rooms[$i]->enseignant_id,
                 'niveau'                => $classes[0]->niveau,
                 'section'               => $classes[0]->section,
                 'nom'                   => $ensts[0]->nom,
                 'prenom'                => $ensts[0]->prenom,
                 'matiere'               => $mat->libelle,
     
             ];
             
             array_push($obj,$obj1);
             
         }
 
        
         return response()->json(
             $obj
             ,200);
 
 

    }
     /**
    * Retourner les rooms du tuteur.
    *
    * @return \Illuminate\Http\Response
    */
    public function tutRooms($id){
        $obj=[];
        $classes=[];
        //recuperer l'eleve  du tuteur connecté
        $elv=Eleve::where('id', $id)->first();
        // recuperer les rooms 
        $rooms=Room::where('classe_id',$elv->classe_id)->get();

        
         // creer data à retourner
         $classes=Classe::where('id',$rooms[0]->classe_id)->get();
         $ensts=Enseignant::where('id',$rooms[0]->enseignant_id)->get();
         $mat=Matiere::where('id',$ensts[0]->matiere_id)->first();
         $obj1=[
              'id'                    => $rooms[0]->id,
              'classe_id'             => $rooms[0]->classe_id,
              'enseignant_id'         => $rooms[0]->enseignant_id,
              'niveau'                => $classes[0]->niveau,
              'section'               => $classes[0]->section,
              'nom'                   => $ensts[0]->nom,
              'prenom'                => $ensts[0]->prenom,
              'matiere'               => $mat->libelle,
  
          ];
          array_push($obj,$obj1);
  
          for ($i = 1; $i <  count($rooms); $i++) {
              $classes=Classe::where('id',$rooms[$i]->classe_id)->get();           
              $ensts=Enseignant::where('id',$rooms[$i]->enseignant_id)->get(); 
              $mat=Matiere::where('id',$ensts[0]->matiere_id)->first();
             if(isset($ensts[0])){
                $obj1=[
                    'id'                    => $rooms[$i]->id,
                    'classe_id'             => $rooms[$i]->classe_id,
                    'enseignant_id'         => $rooms[$i]->enseignant_id,
                    'nom'                   => $ensts[0]->nom,
                    'prenom'                => $ensts[0]->prenom,
                    'niveau'                => $classes[0]->niveau,
                    'section'               => $classes[0]->section,
                    'matiere'               => $mat->libelle,
                    
        
                ];
                
                array_push($obj,$obj1);
                

             }
             
          }
  
         
          return response()->json(
              $obj
              ,200);
  
    }

}
