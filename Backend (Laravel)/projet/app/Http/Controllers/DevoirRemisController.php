<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DevoirRemis;
use App\Models\Eleve;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Response;
use Auth;

class DevoirRemisController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {   
        $data=[];
        $devoirs_remis=DevoirRemis::where('devoir_id', $id)->get();
        for($i = 0; $i <  count($devoirs_remis); $i++){
            $elv=Eleve::where('id', $devoirs_remis[$i]->eleve_id)->first();
            
            $obj=[
                'id'                    => $devoirs_remis[$i]->id,
                'file_path'               => $devoirs_remis[$i]->file_path,
                'eleve_id'                  => $devoirs_remis[$i]->eleve_id,
                'devoir_id'               =>$devoirs_remis[$i]->devoir_id,
                'file_name'             => $devoirs_remis[$i]->file_name,
                'created_at'            =>  $devoirs_remis[$i]->created_at->format('d/m/Y H:i:s') ,
                'updated_at'            => $devoirs_remis[$i]->updated_at->format('d/m/Y H:i:s'),
                'elv_nom'                =>$elv->nom,
                'elv_prenom'            =>$elv->prenom
               
                
            ];
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
            'file'=>'required',
            'devoir_id'=> 'required',

        ]);
        $elv=Eleve::where('user_id', Auth::user()->id)->first();

        
        $file = $request->file('file');
        $original_name = $file->getClientOriginalName();
        $fichier = $file->storeAs('public/DevoirsRemis', $original_name);
        $new_file_path = 'public/DevoirsRemis/' . uniqid() . '_' . $original_name;
        Storage::copy($fichier, $new_file_path);

            $devoir_remis=DevoirRemis::create([
                'devoir_id'=>$fields['devoir_id'],
                'eleve_id'=>  $elv->id,
                'file_path'=> $new_file_path,
                'file_name'=> $file->getClientOriginalName(),
                
            ]);
           /* $devoir_remis->file_name=$file->getClientOriginalName();
            $devoir_remis->save();*/
       
       
            if($devoir_remis){
                return response()->json(
                    $devoir_remis
                ,200);
            }else{
                return response()->json([
                    "message"=>"le devoir n'a pas ete soumis"
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
        $elv=Eleve::where('user_id', Auth::user()->id)->first();
        $id_elv=$elv->id;
        $devoir=DevoirRemis::where(function ($query) use ($id,$id_elv) {
            $query->where('devoir_id',  $id);
            $query->where('eleve_id', $id_elv);
        })->first();
       
        if($devoir){
            return response()->json(
                $devoir
            ,200);
        }else{
            return response()->json([
                "message"=>"le devoir n'existe pas"
            ],401);

        }
    }
    public function show_file($id)
    {
       
        // chercher le support  
        $devoir=DevoirRemis::Find($id);
        if($devoir){
        $file_path=$devoir->file_path;
        if(Storage::exists($file_path)){
            $file=Storage::get($devoir->file_path);
            $response = Response::make($file,200);
            $response->header('Content-Type', 'application/octet-stream');
            return $response;
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"le devoir n'existe pas"
            ],401);
        }
        
       
    }

    public function downoald_file($id)
    {
       
        $devoir_remis=DevoirRemis::Find($id);
        if($devoir_remis){
        $file_path=$devoir_remis->file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"le devoir remis n'existe pas"
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
        $elv=Eleve::where('user_id', Auth::user()->id)->first();
        $id_elv=$elv->id;
        // chercher le devoir remis par l'eleve connecté 
        $devoir_remis=DevoirRemis::where(function ($query) use ($id,$id_elv) {
            $query->where('id',  $id);
            $query->where('eleve_id', $id_elv);
        })->first();
        if($devoir_remis){
            $old_file=$devoir_remis->file_path;
       
           //supprimer l'ancien fichier
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
             $file = $request->file('file');
             $original_name = $file->getClientOriginalName();
            $fichier = $file->storeAs('public/DevoirsRemis', $original_name);
            $new_file_path = 'public/DevoirsRemis/' . uniqid() . '_' . $original_name;
            Storage::copy($fichier, $new_file_path);
            
      
        if($devoir_remis->update(['file_path'=> $new_file_path,'file_name'=>$file->getClientOriginalName()])){
            return response()->json($devoir_remis,200);
        }else{
            return response()->json([
                "message"=>"le devoir n'a pas ete modifié"
            ],401);
        }  
              
                           
            
       
        
    }else{
        return response()->json([
            "message"=>"le devoir n'existe pas pour pouvoir le modifier"
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
        $elv=Eleve::where('user_id', Auth::user()->id)->first();
        $id_elv=$elv->id;
        // chercher le devoir que l'eleve authentifié avait soumis
        $devoir_remis=DevoirRemis::where(function ($query) use ($id,$id_elv) {
            $query->where('id',  $id);
            $query->where('eleve_id', $id_elv);
        })->first();
        if ($devoir_remis){
            $old_file=$devoir_remis->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            if($devoir_remis->delete()){
                return response()->json([
                    "message"=>"devoir supprimé"
                ],200); 
            }else{
                return response()->json([
                    "message"=>"le devoir n'a pas ete supprimé"
                ],401); 
            }
        }else{
            return response()->json([
                "message"=>"le devoir n'existe pas pour pouvoir le supprimer"
            ],401);
        }
    }
}
