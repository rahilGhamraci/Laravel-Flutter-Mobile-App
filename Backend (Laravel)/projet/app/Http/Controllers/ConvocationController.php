<?php

namespace App\Http\Controllers;
use App\Models\Convocation;
use App\Models\Enseignant;
use App\Models\Tuteur;
use App\Models\Room;
use App\Models\Eleve;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Auth;

class ConvocationController extends Controller
{
    /**
     * retourner la liste des convocations de l'une des room de l'enseignant authentifié.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {

    $data=[];
        $convocations=Convocation::where(function ($query) use ($id) {
            $query->where('room_id', $id);
        })->orderBy('id','DESC')->get();
       // return $convocations;
        for($i = 0; $i <  count($convocations); $i++){
            $tuteur=Tuteur::where('id', $convocations[$i]->tuteur_id)->first();
            
             $obj=[
                "id"=> $convocations[$i]->id,
               "titre"=>$convocations[$i]->titre,
               "contenu"=>$convocations[$i]->contenu,
               "tuteur_id"=> $convocations[$i]->tuteur_id,
               "created_at"=>$convocations[$i]->created_at,
               "updated_at"=> $convocations[$i]->updated_at,
               "file_path"=> $convocations[$i]->file_path,
               "room_id"=> $convocations[$i]->room_id,
               "file_name"=>$convocations[$i]->file_name,
               "nom"=> $tuteur->nom,
               "prenom"=>$tuteur->prenom
                
                 
             ];
            
             array_push($data,$obj);
        }
        return response(
            $data
        ,200);
    }

    public function tuteurs($id)
    {
        
        $data=[];
        $room=Room::where('id', $id)->first();
       
        $elvs=Eleve::where('classe_id', $room->classe_id)->get();
        for($i = 0; $i <  count($elvs); $i++){
           
            $tuteur=Tuteur::where('id', $elvs[$i]->tuteur_id)->first();
            if (!in_array($tuteur, $data)) {
                array_push($data,$tuteur);
            }
           
         }
        return response(
            $data
        ,200);
    }

    public function index_tuteur($id)
    {
       $convocations=[];
       $tuteur=Tuteur::where('user_id', Auth::user()->id)->first();

       $elv=Eleve::where('id', $id)->first();
       $rooms=Room::where('classe_id', $elv->classe_id)->get();
      
       for($i = 0; $i <  count($rooms); $i++){
        $id_room=$rooms[$i]->id;
        $convocation=Convocation::where(function ($query) use ($id_room,$tuteur) {
            $query->where('tuteur_id', $tuteur->id);
            $query->where('room_id', $id_room);
        })->orderBy('id','DESC')->get();
        
        
        $convocations = array_merge($convocations, $convocation->toArray());
       
    }
     
    $data = [];
    foreach ($convocations as $convocation) {
        if (isset($convocation['room_id'])) {
            $room_id = $convocation['room_id'];
            $room = Room::where('id', $room_id)->first();
            $enst = Enseignant::where('id', $room->enseignant_id)->first();
           

            $obj = [
                "id" => $convocation['id'],
                "titre" => $convocation['titre'],
                "contenu" => $convocation['contenu'],
                "tuteur_id" => $convocation['tuteur_id'],
                "created_at" => $convocation['created_at'],
                "updated_at" => $convocation['updated_at'],
                "file_path" => $convocation['file_path'],
                "room_id" => $convocation['room_id'],
                "file_name" => $convocation['file_name'],
                "nom" => $enst->nom,
                "prenom" => $enst->prenom
            ];

            array_push($data, $obj);
        }
    }
        return response(
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
            'tuteur_id'=> 'required',
            'room_id'=> 'required',
        ]);
        $enst=Enseignant::where('user_id', Auth::user()->id)->first();
        if($request->file){ 
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/fichiersConvocations', $original_name);
           $new_file_path = 'public/fichiersConvocations/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            $convocation=Convocation::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'room_id'=>$request->room_id,
                'tuteur_id'=>$request->tuteur_id,
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName()
                           
            ]);
        }else{
            $convocation=Convocation::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'tuteur_id'=>$request->tuteur_id,
                'room_id'=>$request->room_id,
                
                           
            ]);

        }
       
       
        if($convocation){
             $tuteur=Tuteur::where('id', $convocation->tuteur_id)->first();
        
             $obj=[
                "id"=> $convocation->id,
               "titre"=>$convocation->titre,
               "contenu"=>$convocation->contenu,
               "tuteur_id"=> $convocation->tuteur_id,
               "created_at"=>$convocation->created_at,
               "updated_at"=> $convocation->updated_at,
               "file_path"=> $convocation->file_path,
               "room_id"=> $convocation->room_id,
               "file_name"=>$convocation->file_name,
               "nom"=> $tuteur->nom,
               "prenom"=>$tuteur->prenom
                
                 
             ];
            return response()->json([$obj],200);
        }else{
            return response()->json([
                "message"=>"la convocation n a pas ete crée"
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
        $enst=Enseignant::where('user_id', Auth::user()->id)->first();
        $id_enst=$enst->id;
        // chercher la convocation que l'enseignant authentifié avait redigé dans une room donnée
        $convocation=Convocation::where(function ($query) use ($id,$id_enst,$id_room) {
            $query->where('id',  $id);
            $query->where('room_id', $id_room);
        })->first();
       
        if($convocation){
            return response()->json([
                'data'=>$convocation
            ],200);
        }else{
            return response()->json([
                "message"=>"la convocation n'existe pas"
            ],401);

        }
    }
    public function show_file($id)
    {
       
        // chercher le support  
        $convocation=Convocation::Find($id);
        if($convocation){
        $file_path=$convocation->file_path;
        if(Storage::exists($file_path)){
            $file=Storage::get($convocation->file_path);
            $response = Response::make($file,200);
            $response->header('Content-Type', 'application/octet-stream');
            return $response;
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"la convocation n'existe pas"
            ],401);
        }
        
       
    }
    public function downoald_file($id)
    {
       
        // chercher le support  
        $convocation=Convocation::Find($id);
        if($convocation){
        $file_path=$convocation->file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"la convocation remis n'existe pas"
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
        $convocation=Convocation::Find($id);
        if($convocation){
        $old_file=$convocation->file_path;
        if($request->file){ 
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/fichiersConvocations', $original_name);
           $new_file_path = 'public/fichiersConvocations/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            $convocation->update([
                'file_path'=> $new_file_path,
             
            ]);
            $convocation->file_name=$file->getClientOriginalName();
            $convocation->save();
        }
        if($convocation->update($request->all())){
            $tuteur=Tuteur::where('id', $convocation->tuteur_id)->first();
        
             $obj=[
                "id"=> $convocation->id,
               "titre"=>$convocation->titre,
               "contenu"=>$convocation->contenu,
               "tuteur_id"=> $convocation->tuteur_id,
               "created_at"=>$convocation->created_at,
               "updated_at"=> $convocation->updated_at,
               "file_path"=> $convocation->file_path,
               "room_id"=> $convocation->room_id,
               "file_name"=>$convocation->file_name,
               "nom"=> $tuteur->nom,
               "prenom"=>$tuteur->prenom
                
                 
             ];
            return response()->json([$obj],200);
        }else{
            return response()->json([
                "message"=>"la convocation n'a pas ete modifiée"
            ],401);
        }  
              
                           
            
       
        
    }else{
        return response()->json([
            "message"=>"convocation n'existe pas pour pouvoir la modifier"
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
        $convocation=Convocation::Find($id);
        if ( $convocation){
            $old_file=$convocation->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            if( $convocation->delete()){
                return response()->json([
                    "message"=>"convocation supprimée"
                ],200); 
            }else{
                return response()->json([
                    "message"=>"la convocation n'a pas ete supprimée"
                ],401); 
            }
        }else{
            return response()->json([
                "message"=>"la convocation n'existe pas pour pouvoir la supprimer"
            ],401); 
        }
    }
}
