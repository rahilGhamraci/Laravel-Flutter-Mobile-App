<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tuteur;
use App\Models\Justification;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Response;
use Auth;

class JustificationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
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
            'objet'=> 'required|string',
            'text'=> 'required|string',
          
        ]);
        $tuteur=Tuteur::where('user_id', Auth::user()->id)->first();
        if($request->file){ 
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/Justifications', $original_name);
           $new_file_path = 'public/Justifications/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            $justification=Justification::create([
                'objet'=>$fields['objet'],
                'text'=>$fields['text'],
                'tuteur_id'=>$tuteur->id,
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName()
                           
            ]);
        }else{
            
            $justification=Justification::create([
                'objet'=>$fields['objet'],
                'text'=>$fields['text'],
                'tuteur_id'=>$tuteur->id,          
            ]);

        }
       
       
        if($justification){
            return response()->json(
                $justification
           ,200);
        }else{
            return response()->json([
                "message"=>"la justification n a pas ete crée"
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
        $justification=Justification::Find($id);
        if($justification){
            return response()->json(
                $justification
            ,200);
        }else{
            return response()->json([
                "message"=>"la justification n existe pas"
            ],401);
        }  
    }

    public function show_file($id)
    {
       
        // chercher le support  
        $justification=Justification::Find($id);
        if($justification){
        $file_path=$justification->file_path;
        if(Storage::exists($file_path)){
            $file=Storage::get($justification->file_path);
            $response = Response::make($file,200);
            $response->header('Content-Type', 'application/octet-stream');
            return $response;
            
        }else{
            return response()->json([
                "message"=>"la justification ne contient pas de fichier"
            ],401);
        }}else{
            return response()->json([
                "message"=>"la justificationn'existe pas"
            ],401);
        }
        
       
    }
    public function downoald_file($id)
    {
       
        // chercher le support  
        $justification=Justification::Find($id);
        if($justification){
        $file_path=$justification->file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"la justification n'existe pas"
            ],401);
        }
        
       
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
        $tuteur=Tuteur::where('user_id', Auth::user()->id)->first();
        $id_tuteur=$tuteur->id;
        // chercher la justification 
        $justification=Justification::where(function ($query) use ($id,$id_tuteur) {
            $query->where('id',  $id);
            $query->where('tuteur_id', $id_tuteur);
          
        })->first();
        
     
        if($justification){
        
        if($request->file){ 
           
                $old_file=$justification->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
           
        }
        $file = $request->file('file');
        $original_name = $file->getClientOriginalName();
       $fichier = $file->storeAs('public/Justifications', $original_name);
       $new_file_path = 'public/Justifications/' . uniqid() . '_' . $original_name;
       Storage::copy($fichier, $new_file_path);
            $justification->update([
                'file_path'=> $new_file_path,
               
            ]);
            $justification->file_name=$file->getClientOriginalName();
            $justification->save();
        }
        if($justification->update($request->all())){
            return response()->json(
                $justification
            ,200);
        }else{
            return response()->json([
                "message"=>"la justification n'a pas ete modifiée"
            ],401);
        }  
    }else{
        return response()->json([
            "message"=>"la justification n'existe pas pour pouvoir le modifier"
        ],401); 
    }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {   
        
        $tuteur=Tuteur::where('user_id', Auth::user()->id)->first();
        $id_tuteur=$tuteur->id;
        // chercher la justification 
        $justification=Justification::where(function ($query) use ($id,$id_tuteur) {
            $query->where('id',  $id);
            $query->where('tuteur_id', $id_tuteur);
          
        })->first();
       
        if ( $justification){
            $old_file=$justification->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
           
            if($justification->delete()){
            return response()->json([
                "message"=>"justification supprimée"
            ],200); 
        }else{
            return response()->json([
                "message"=>"la justification n'a pas ete supprimée"
            ],401); 
        }
        }else{
            return response()->json([
                "message"=>"la justification n'existe pas pour pouvoir le supprimer"
            ],401);
        }
    }
}
