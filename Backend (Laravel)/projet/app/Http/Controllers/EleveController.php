<?php

namespace App\Http\Controllers;
use App\Models\Eleve;
use App\Models\Tuteur;
use App\Models\Classe;
use Illuminate\Http\Request;
use Auth;

class EleveController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {   $data=[];
        $tuteur=Tuteur::where('user_id', Auth::user()->id)->first();
        $elves=Eleve::where('tuteur_id',$tuteur->id)->get();
        for($i = 0; $i <  count($elves); $i++){
           
            $c=Classe::where('id', $elves[$i]->classe_id)->first();
           
         
    
             $obj=[
                 'id'                    => $elves[$i]->id,
                 'nom'                   => $elves[$i]->nom,
                 'prenom'                => $elves[$i]->prenom,
                 'date_naissance'        => $elves[$i]->date_naissance,
                 'lieu_naissance'        => $elves[$i]->lieu_naissance,
                 'classe_id'             => $elves[$i]->classe_id,
                 'tuteur_id'             =>$elves[$i]->tuteur_id,
                 'user_id'               =>$elves[$i]->user_id,
                 'created_at'            =>$elves[$i]->created_at,
                 'updated_at'            =>$elves[$i]->updated_at,
                 'section'               =>$c->section,
                 'niveau'                =>$c->niveau, 
                 
             ];
           
           
             array_push($data,$obj);
         }
        if($elves){
            return response()->json(
               $data
            ,200);
        }else{
            return response()->json([
                'message'=>'une erreur s\'est produite'
             ],401);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
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
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
