<?php

namespace App\Http\Controllers;
use App\Models\Absence;
use App\Models\Eleve;
use App\Models\Tuteur;
use App\Models\ListeAbsences;
use App\Models\Justification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
class AbsenceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    //retourner les elves absents dans une liste d'absences donnée
    public function index($id)
    {   $data=[];
       $absences=Absence::where('liste_absences_id', $id)->get();
        for($i = 0; $i <  count($absences); $i++){
           $elv=Eleve::where('id', $absences[$i]->eleve_id)->first();
           $j=Justification::where('id', $absences[$i]->justification_id)->first();
           $tuteur=Tuteur::where('id', $elv->tuteur_id)->first();;
           if($j){
   
            $obj=[
                'id'                    => $elv->id,
                'nom'                   => $elv->nom,
                'prenom'                => $elv->prenom,
                'date_naissance'        => $elv->date_naissance,
                'lieu_naissance'        => $elv->lieu_naissance,
                'classe_id'             => $elv->classe_id,
                'tuteur_id'             =>$elv->tuteur_id,
                'user_id'               =>$elv->user_id,
                'created_at'            =>$elv->created_at,
                'updated_at'             =>$elv->updated_at,
                'justification_id'      => $j->id,
                'justification_created_at' =>$j->created_at,
                'justification_updated_at' =>$j->updated_at,
                'objet'                 => $j->objet,
                'text'                  => $j->text,
                'file_name'             => $j->file_name,
                'file_path'             => $j->file_path,
                'tuteur_nom'             => $tuteur->nom,
                'tuteur_prenom'          => $tuteur->prenom,
               
               
                
            ];
           }else{
            $obj=[
                'id'                    => $elv->id,
                'nom'                   => $elv->nom,
                'prenom'                => $elv->prenom,
                'date_naissance'        => $elv->date_naissance,
                'lieu_naissance'        => $elv->lieu_naissance,
                'classe_id'             => $elv->classe_id,
                'tuteur_id'             =>$elv->tuteur_id,
                'user_id'               =>$elv->user_id,
                'created_at'            =>$elv->created_at,
                'updated_at'             =>$elv->updated_at,
                'is_selected'           => false,
                'justification_created_at' =>null,
                'justification_updated_at' =>null,
                'justification_id'      => null,
                'objet'                 => null,
                'text'                  => null,
                'file_name'             => null,
                'file_path'             => null,
                'tuteur_nom'             => $tuteur->nom,
                'tuteur_prenom'          => $tuteur->prenom,
                
               
                
            ];}
          
            array_push($data,$obj);
        }
        return response()->json(
             $data
            ,200);
    }

    //retourner les absences de'un fils donné pour le tuteur

    public function abs_fils($id)
    {   $data=[];
        $absences=Absence::where('eleve_id', $id)->orderBy('id','DESC')->get();
        for($i = 0; $i <  count($absences); $i++){
           $liste=ListeAbsences::where('id', $absences[$i]->liste_absences_id)->first();
           $j=Justification::where('id', $absences[$i]->justification_id)->first();
           if($j){
            $obj=[
                'id'                    => $absences[$i]->id,
                'date'                  => $liste->date,
                'seance'                => $liste->seance,
                'is_selected'           => false,
                'justification_id'      => $absences[$i]->justification_id,
                'objet'                 => $j->objet,
                'text'                  => $j->text,
                'file_name'             =>$j->file_name,
                'file_path'             =>$j->file_path,
                'tuteur_id'             =>$j->tuteur_id,
                'created_at'             =>$j->created_at,
               
                
            ];
           }else{
            $obj=[
                'id'                    => $absences[$i]->id,
                'date'                  => $liste->date,
                'seance'                => $liste->seance,
                'is_selected'           => false,
                'justification_id'      => null,
                'objet'                 => null,
                'text'                  => null,
                'file_name'             => null,
                'file_path'             =>null,
                'tuteur_id'             =>null,
                'created_at'             =>null,
                
            ];
           }
         
           
            array_push($data,$obj);
        }
        return response()->json(
             $data
            ,200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $fields= $request->validate([
          
            'eleve_id'=>'required',
            'liste_absences_id'=>'required'
        ]);
        //$enst=Enseignant::where('user_id', Auth::user()->id)->first();
        
           
            $absence=Absence::create([
                
                'eleve_id'=>$fields['eleve_id'],
                'liste_absences_id'=>$fields['liste_absences_id'],
                           
            ]);
        
       
       
            if($absence){
                return response()->json(
                    $absence
                ,200);
            }else{
                return response()->json([
                    "message"=>"l'absence n'a pas ete enregistrée"
                ],401);
    
            }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
          $abs=Absence::find($id);
          return $abs;
    }
    public function nbAbsences($id)
    {
        $count = DB::select("SELECT COUNT(*) as count FROM absences WHERE justification_id = ?", [$id])[0]->count;
          return $count;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {   
       $a=Absence::Find($id);
        
        if($a){
            $abs=Absence::where('id', $id)->update(array('justification_id' =>$request["justification_id"]));
            return response()->json(
                $abs
            ,200);
        }else{
            return response()->json(
                ["message"=>"absence n existe pas"]
            ,401);
        }

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id,$id_liste)
    {
        $absence=Absence::where(function ($query) use ($id,$id_liste) {
            $query->where('eleve_id', $id);
            $query->where('liste_absences_id', $id_liste);
           
             })->first();
       
       
        if ($absence){
            if($absence->delete()){
                return response()->json([
                    "message"=>"absence supprimée"
                ],200); 
            }else{
                return response()->json([
                    "message"=>"l'absence n'a pas ete supprimée"
                ],401); 
            }
        }else{
            return response()->json([
                "message"=>"l'absence n'existe pas pour pouvoir le supprimer"
            ],401);
        }
    }
}
