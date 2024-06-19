<?php

use Illuminate\Support\Facades\Broadcast;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
*/


Broadcast::channel('public.newmessage.1', function () {
    return true; // Replace with your authorization logic
});

Route::prefix('laravel-websockets')->group(function () {
    Route::post('/broadcasting/auth', function (\Illuminate\Http\Request $request) {
        $pusher = new \Pusher\Pusher(env('PUSHER_APP_KEY'), env('PUSHER_APP_SECRET'), env('PUSHER_APP_ID'));
        $socket_id = $request->input('socket_id');
        $channel_name = $request->input('channel_name');
        $user_id = 48; // Replace with your user ID logic
        $auth = $pusher->socket_auth($channel_name, $socket_id, $user_id);
        return response($auth);
    });
});