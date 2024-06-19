<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Edt;
use App\Models\Eleve;
use Illuminate\Support\Facades\Storage;
use Auth;

class EdtController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {   
        $elv=Eleve::where('user_id', Auth::user()->id)->first();
        $edts=Edt::where('classe_id',$elv->classe_id)->get();
        return response()->json(
            $edts
            ,200);

    }
    public function index_tuteur($id)
    {   
        $elv=Eleve::where('id', $id)->first();
        $edts=Edt::where('classe_id',$elv->classe_id)->get();
        return response()->json(
            $edts
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
       // return $request;
        $fields= $request->validate([
            'trimestre'=> 'required|string',
            'annee_scolaire'=> 'required|string',
            'file'=>'required',
            'classe_id'=> 'required',
        ]);
        //$enst=Enseignant::where('user_id', Auth::user()->id)->first();
           //return $fields['annee_scolaire'];
           $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/Edts', $original_name);
           $new_file_path = 'public/Edts/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            $edt=Edt::create([
                'trimestre'=>$fields['trimestre'],
                'annee_scolaire'=>$fields['annee_scolaire'],
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName(),
                'classe_id'=>$fields['classe_id'],
                           
            ]);
        
       
       
            if($edt){
                return response()->json([
                    'data'=>$edt
                ],200);
            }else{
                return response()->json([
                    "message"=>"le edt n'a pas ete crée"
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
    public function downoald_file($id)
    {
       
        
        $edt=Edt::Find($id);
        if($edt){
        $file_path=$edt->file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"l'edt n'existe pas"
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
        $edt=Edt::find($id);
        if($edt){
            $old_file=$edt->file_path;
            if($request->file){ 
               //supprimer l'ancien fichier
                if(Storage::exists($old_file)){
                    Storage::delete($old_file);
                }
                $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/Edts', $original_name);
           $new_file_path = 'public/Edts/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
                $edt->update([
                    'file_path'=> $new_file_path,
                ]);
                $edt->file_name=$file->getClientOriginalName();
                $edt->save();
            }
            if($edt->update($request->all())){
                return response()->json([
                    'message'=>'edt modifié avec succès'
                ],200);
            }else{
                return response()->json([
                    "message"=>"l'edt n'a pas ete modifié"
                ],401);
            }  
                  
                               
                
           
            
        }else{
            return response()->json([
                "message"=>"l'edt n'existe pas pour pouvoir le modifier"
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
        $edt=Edt::find($id);
        if ($edt){
            $old_file=$edt->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            if($edt->delete()){
                return response()->json([
                    "message"=>"edt supprimé"
                ],200); 
            }else{
                return response()->json([
                    "message"=>"le edt n'a pas ete supprimé"
                ],401); 
            }
        }else{
            return response()->json([
                "message"=>"l'edt n'existe pas pour pouvoir le supprimer"
            ],401);
        }
    }
}
