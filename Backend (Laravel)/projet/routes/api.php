<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AnnonceController;
use App\Http\Controllers\DevoirController;
use App\Http\Controllers\SupportController;
use App\Http\Controllers\ConvocationController;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\ConversationController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\NoteController;
use App\Http\Controllers\DevoirRemisController;
use App\Http\Controllers\JustificationController;
use App\Http\Controllers\EdtController;
use App\Http\Controllers\EleveController;
use App\Http\Controllers\AbsenceController;
use App\Http\Controllers\ListeAbsencesController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\ForgetPasswordController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\Auth\EmailVerficationController;



/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/email_verfication',[EmailVerficationController::class,'verify']);
Route::post('/forget_password',[ForgetPasswordController::class,'forgetPassword']);
Route::post('/reset_password',[ResetPasswordController::class,'resetPassword']);

Route::post('/login',[AuthController::class,'login']);



Route::post('/test',[AuthController::class,'test']);
Route::post('/send_mail',[AuthController::class,'send']);
Route::post('/eleve_registration',[AuthController::class,'register']);
Route::post('/tuteur_registration',[AuthController::class,'register_tuteur']);
Route::get('/etabs',[AuthController::class,'etabs']);

// routes de l'agent
Route::post('/edts',[EdtController::class,'store']);
Route::post('/edts/{id}',[EdtController::class,'update']);
Route::delete('/edts/{id}',[EdtController::class,'destroy']);
Route::post('/annonces_administratives',[AnnonceController::class,'storeAgt']);
Route::post('/annonces_administratives/{id}',[AnnonceController::class,'updateAgt']);
Route::delete('/annonces_administratives/{id}',[AnnonceController::class,'destroy']);

//pour l'instant on va les laisser ici pour pouvoir tester en attendant de devlopper le front end 
Route::get('/supports_telechargement/{id}',[SupportController::class,'downoald_file']);
Route::get('/annonces_telechargement/{id}',[AnnonceController::class,'downoald_file']);
Route::get('/devoirs_telechargement/{id}',[DevoirController::class,'downoald_file']);
Route::get('/edts_telechargement/{id}',[EdtController::class,'downoald_file']);
Route::get('/justifications_telechargement/{id}',[JustificationController::class,'downoald_file']);
Route::get('/devoirs_remis_telechargement/{id}',[DevoirRemisController::class,'downoald_file']);
Route::get('/convocations_telechargement/{id}',[ConvocationController::class,'downoald_file']);





Route::group(['middleware' => ['auth:sanctum','role:Enseignant']], function(){
Route::get('/enst_rooms',[RoomController::class,'enstRooms']);

    //Route::get('/annonces_room/{id}',[AnnonceController::class,'index']);
    Route::post('/annonces',[AnnonceController::class,'store']);
    Route::post('/annonces/{id}',[AnnonceController::class,'update']);
    Route::delete('/annonces/{id}',[AnnonceController::class,'destroy']);

   // Route::get('/devoirs_room/{id}',[DevoirController::class,'index']);
    Route::post('/devoirs',[DevoirController::class,'store']);
    Route::post('/devoirs/{id}',[DevoirController::class,'update']);
    Route::delete('/devoirs/{id}',[DevoirController::class,'destroy']);

   // Route::get('/supports_room/{id}',[SupportController::class,'index']);
    Route::post('/supports',[SupportController::class,'store']);
    Route::post('/supports/{id}',[SupportController::class,'update']);
    Route::delete('/supports/{id}',[SupportController::class,'destroy']);

    Route::get('/convocations_room/{id}',[ConvocationController::class,'index']);
    Route::get('/liste_tuteurs/{id}',[ConvocationController::class,'tuteurs']);
    Route::post('/convocations',[ConvocationController::class,'store']);
    Route::get('/convocations/{id}/{id_room}',[ConvocationController::class,'show']);
    Route::post('/convocations/{id}',[ConvocationController::class,'update']);
    Route::delete('/convocations/{id}',[ConvocationController::class,'destroy']);
    Route::get('/convocations/{id}',[ConvocationController::class,'show_file']);

    Route::get('/index_absences/{id}',[AbsenceController::class,'index']);
    Route::post('/absences',[AbsenceController::class,'store']);
    Route::delete('/absences/{id}/{id_liste}',[AbsenceController::class,'destroy']);
    
    Route::get('/index_liste_absences/{id}',[ListeAbsencesController::class,'index']);
    Route::get('/elv_liste/{id}',[ListeAbsencesController::class,'elv_index']);
    Route::post('/liste_absences',[ListeAbsencesController::class,'store']);
    Route::delete('/liste_absences/{id}',[ListeAbsencesController::class,'destroy']);

    Route::get('/devoirs_remis_enst/{id}',[DevoirRemisController::class,'index']);
    Route::get('/justifications_enst/{id}',[JustificationController::class,'show']);

});




Route::group(['middleware' => ['auth:sanctum']], function(){
    Route::get('/devoirs_room/{id}',[DevoirController::class,'index']);
    Route::get('/devoirs_room_page/{id}',[DevoirController::class,'index_limite']);
    Route::get('/devoirs/{id}/{id_room}',[DevoirController::class,'show']);
    Route::get('/devoirs/{id}',[DevoirController::class,'show_file']);

    Route::get('/annonces_room/{id}',[AnnonceController::class,'index']);
    Route::get('/annonces_room_page/{id}',[AnnonceController::class,'index_limite']);
    Route::get('/annonces/{id}/{id_room}',[AnnonceController::class,'show']);
    Route::get('/annonces/{id}',[AnnonceController::class,'show_file']);

    Route::get('/supports_room/{id}',[SupportController::class,'index']);
    Route::get('/supports_room_page/{id}',[SupportController::class,'index_limite']);
    Route::get('/supports/{id}/{id_room}',[SupportController::class,'show']);
    Route::get('/supports/{id}',[SupportController::class,'show_file']);
   
    
    Route::get('/users',[ConversationController::class,'users']);

    Route::get('/conversations',[ConversationController::class,'index']);
    Route::post('/conversations',[ConversationController::class,'store']);
    Route::get('/conversations/{id}',[ConversationController::class,'show']);
    Route::post('/conversation_read/{id}',[ConversationController::class,'markAsReaded']);

    Route::get('/messages/{id}',[MessageController::class,'index']);
    Route::post('/messages',[MessageController::class,'store']);
    Route::get('/new-message', function () {
        event(new App\Events\NewMessageEvent());
        return response()->json(['message' => 'New message event triggered.']);
    });
    Route::get('/messages/{id}/{word}',[MessageController::class,'show']);
    Route::post('/messages/{id}',[MessageController::class,'update']);
    Route::delete('/messages/{id}',[MessageController::class,'destroy']);

    Route::get('/devoirs_remis/{id}',[DevoirRemisController::class,'show_file']);

    Route::get('/annonces_administratives_index/{id}',[AnnonceController::class,'indexAnnonceAdministrative']);

    Route::post('/logout',[AuthController::class,'logout']);
  
});

Route::group(['middleware' => ['auth:sanctum','role:Eleve']], function(){
    Route::get('/elv_rooms',[RoomController::class,'elvRooms']);
    Route::get('/notes/{trimestre}/{annee}',[NoteController::class,'index']);
    Route::get('/mes_bulletins',[NoteController::class,'bulletins_eleve']);
    Route::get('/edts',[EdtController::class,'index']);
    Route::get('/devoirs_remis/{id}',[DevoirRemisController::class,'show']);
    Route::post('/devoirs_remis',[DevoirRemisController::class,'store']);
    Route::post('/devoirs_remis/{id}',[DevoirRemisController::class,'update']);
    Route::delete('/devoirs_remis/{id}',[DevoirRemisController::class,'destroy']);
   

});

Route::group(['middleware' => ['auth:sanctum','role:Tuteur']], function(){
    Route::get('/tuteur_rooms/{id}',[RoomController::class,'tutRooms']);
    Route::get('/convocations_tut_room/{id}',[ConvocationController::class,'index_tuteur']);
    Route::get('/bulletin_enfants/{id}',[NoteController::class,'bulletins_tuteur']);
    Route::get('/notes_enfants/{id}/{trimestre}/{annee}',[NoteController::class,'index_tuteur']);
    Route::post('/justifications',[JustificationController::class,'store']);
    Route::post('/justifications/{id}',[JustificationController::class,'update']);
    Route::delete('/justifications/{id}',[JustificationController::class,'destroy']);
    Route::get('/justifications_tuteur/{id}',[JustificationController::class,'show']);
    Route::get('/nb_absences/{id}',[AbsenceController::class,'nbAbsences']);
    Route::get('/index_absences_tuteur/{id}',[AbsenceController::class,'abs_fils']);
    Route::post('/absences/{id}',[AbsenceController::class,'update']);
    Route::get('/absences_tuteur/{id}',[AbsenceController::class,'show']);
    Route::get('/eleves_tuteur',[EleveController::class,'index']);
    Route::get('/edts/{id}',[EdtController::class,'index_tuteur']);
});

