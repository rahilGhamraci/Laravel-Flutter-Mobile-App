<?php

namespace App\Http\Controllers;
use App\Models\Devoir;
use App\Models\Enseignant;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Auth;
use Illuminate\Support\Str;

class DevoirController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {   
        $data=[];
        $devoirs=Devoir::where('room_id', $id)->orderBy('id','DESC')->get();
        for($i = 0; $i <  count($devoirs); $i++){
           
                $enst=Enseignant::where('id', $devoirs[$i]->enseignant_id)->first();
                $display_contenent = explode(' ', Str::limit($devoirs[$i]->contenu, 20));
               $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

               $display_title = explode(' ', Str::limit($devoirs[$i]->titre, 22));
                $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $devoirs[$i]->id,
                "titre_resume"=> $display_title,
                "titre"=> $devoirs[$i]->titre,
                "contenu"=>  $devoirs[$i]->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $devoirs[$i]->file_path,
                "file_name"=> $devoirs[$i]->file_name,
                "enseignant_id"=>  $devoirs[$i]->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $devoirs[$i]->room_id,
                "created_at"=> $devoirs[$i]->created_at,
                "updated_at"=> $devoirs[$i]->updated_at,
                "delai"=> $devoirs[$i]->delai,
                
                 
             ];
         
          
            
             array_push($data,$obj);

            
            
        }
  
    return response()->json(
        $data
        ,200);
    }

    public function index_limite($id)
    {   
        $data=[];
        $devoirs=Devoir::where('room_id', $id)->orderBy('id','DESC')
        ->skip(0)
        ->take(5)
        ->get();
        for($i = 0; $i <  count($devoirs); $i++){
           
            $enst=Enseignant::where('id', $devoirs[$i]->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($devoirs[$i]->contenu, 20));
           $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

           $display_title = explode(' ', Str::limit($devoirs[$i]->titre, 22));
                $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
       
        
         $obj=[
            "id"=> $devoirs[$i]->id,
            "titre_resume"=> $display_title,
            "titre"=> $devoirs[$i]->titre,
            "contenu"=>  $devoirs[$i]->contenu,
            "contenu_resume"=>  $display_contenent,
            "file_path"=> $devoirs[$i]->file_path,
            "file_name"=> $devoirs[$i]->file_name,
            "enseignant_id"=>  $devoirs[$i]->enseignant_id,
            "enseignant_nom"=>  $enst->nom,
            "enseignant_prenom"=>  $enst->prenom,
            "room_id"=> $devoirs[$i]->room_id,
            "created_at"=> $devoirs[$i]->created_at,
            "updated_at"=> $devoirs[$i]->updated_at,
            "delai"=> $devoirs[$i]->delai,
            
             
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
            'titre'=> 'required|string',
            'contenu'=> 'required|string',
            'room_id'=> 'required',
        ]);
        $enst=Enseignant::where('user_id', Auth::user()->id)->first();
        if($request->file){ 
            $file = $request->file('file');
        $original_name = $file->getClientOriginalName();
       $fichier = $file->storeAs('public/fichiersDevoirs', $original_name);
       $new_file_path = 'public/fichiersDevoirs/' . uniqid() . '_' . $original_name;
       Storage::copy($fichier, $new_file_path);
            $devoir=Devoir::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'room_id'=>$request->room_id,
                'enseignant_id'=> $enst->id,
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName(),
                'delai' => 0
                           
            ]);
        }else{
            //dd($request->room_id);
            $devoir=Devoir::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'room_id'=>$request->room_id,
                'enseignant_id'=>$enst->id,
                'delai' => 0,           
            ]);

        }
       
       
        if($devoir){
            $enst=Enseignant::where('id', $devoir->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($devoir->contenu, 20));
           $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

           $display_title = explode(' ', Str::limit($devoir->titre, 22));
                $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
       
        
         $obj=[
            "id"=> $devoir->id,
            "titre_resume"=> $display_title,
            "titre"=> $devoir->titre,
            "contenu"=>  $devoir->contenu,
            "contenu_resume"=>  $display_contenent,
            "file_path"=> $devoir->file_path,
            "file_name"=> $devoir->file_name,
            "enseignant_id"=>  $devoir->enseignant_id,
            "enseignant_nom"=>  $enst->nom,
            "enseignant_prenom"=>  $enst->prenom,
            "room_id"=> $devoir->room_id,
            "created_at"=> $devoir->created_at,
            "updated_at"=> $devoir->updated_at,
            "delai"=> $devoir->delai,
            
             
         ];
           
            return response()->json([
                $obj
            ],200);
        }else{
            return response()->json([
                "message"=>"le devoir n a pas ete crée"
            ],401);

        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id,$id_room)
    {
        
        // chercher le devoir  dans une room donnée
        $devoir=Devoir::where(function ($query) use ($id,$id_room) {
            $query->where('id',  $id);
            $query->where('room_id', $id_room);
        })->first();
        if($devoir){
            return response()->json([
                'data'=>$devoir
            ],200);
        }else{
            return response()->json([
                "message"=>"le devoir n'existe pas"
            ],401);

        }
    }


    public function show_file($id)
    {
       
        // chercher le support  
        $devoir=Devoir::Find($id);
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
       
        
        $devoir=Devoir::Find($id);
        if($devoir){
        $file_path=$devoir->file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
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

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {   
        $devoir=Devoir::Find($id);
        if($devoir){
        
        if($request->file){ 
           
                $old_file=$devoir->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
           
        }
        $file = $request->file('file');
        $original_name = $file->getClientOriginalName();
       $fichier = $file->storeAs('public/fichiersDevoirs', $original_name);
       $new_file_path = 'public/fichiersDevoirs/' . uniqid() . '_' . $original_name;
       Storage::copy($fichier, $new_file_path);
            $devoir->update([
                'file_path'=> $new_file_path ,
                
            ]);
            $devoir->file_name=$file->getClientOriginalName();
            $devoir->save();
        }
        if($devoir->update($request->all())){
            if($request->delai==="1"){
                $devoir->delai=1;
                $devoir->save();

            }else{
                $devoir->delai=0;
                $devoir->save();
            }
           
            $enst=Enseignant::where('id', $devoir->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($devoir->contenu, 20));
           $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

           $display_title = explode(' ', Str::limit($devoir->titre, 22));
           $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
       
        
         $obj=[
            "id"=> $devoir->id,
            "titre_resume"=> $display_title,
            "titre"=> $devoir->titre,
            "contenu"=>  $devoir->contenu,
            "contenu_resume"=>  $display_contenent,
            "file_path"=> $devoir->file_path,
            "file_name"=> $devoir->file_name,
            "enseignant_id"=>  $devoir->enseignant_id,
            "enseignant_nom"=>  $enst->nom,
            "enseignant_prenom"=>  $enst->prenom,
            "room_id"=> $devoir->room_id,
            "created_at"=> $devoir->created_at,
            "updated_at"=> $devoir->updated_at,
            "delai"=> $devoir->delai,
             
         ];
           
            return response()->json([
                $obj
            ],200);
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
        $devoir=Devoir::Find($id);
        if ( $devoir){
            $old_file=$devoir->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
           
            if($devoir->delete()){
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
