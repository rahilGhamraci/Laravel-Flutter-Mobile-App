<?php

namespace App\Http\Controllers;
use App\Models\ListeAbsences;
use App\Models\Eleve;
use App\Models\Room;
use Illuminate\Http\Request;

class ListeAbsencesController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {
        $listes=ListeAbsences::where('room_id', $id)->orderBy('id','DESC')->get();
        return response()->json(
             $listes
            ,200);
    }

    public function elv_index($id){
        $room=Room::Find($id);
        $elvs=Eleve::where('classe_id', $room->classe_id)->get();
        return response()->json(
            $elvs
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
          
            'date'=>'required',
            'seance'=>'required',
            'room_id'=>'required'
        ]);
        //$enst=Enseignant::where('user_id', Auth::user()->id)->first();
        
           
            $liste=ListeAbsences::create([
                
                'date'=>$fields['date'],
                'seance'=>$fields['seance'],
                'room_id'=>$fields['room_id'],
                           
            ]);
        
       
           
            if($liste){
                return response()->json(
                    $liste
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
        
        $liste=ListeAbsences::Find($id);
        if ($liste){
            if($liste->delete()){
                return response()->json([
                    "message"=>"liste absences supprimée"
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
