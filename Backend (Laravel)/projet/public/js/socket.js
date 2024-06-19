import io from 'socket.io-client';
import Echo from 'laravel-echo';

let socket = io(window.config.server);
let echo = new Echo({
    broadcaster: 'socket.io',
    client: socket
});
