<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Otp;
class ResetPasswordVerificationNotification extends Notification
{
    use Queueable;
    public $message;
    public $subject;
    public $fromEmail;
    public $mailer;
    public $otp;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->message='Utilisez le code ci-dessous pour récupérer votre mot de passe';
        $this->subject='Récuperation Mot De Passe';
        $this->fromEmail="ourclassalgerie@gmail.com";
        $this->mailer='smtp';
        $this->otp=new Otp;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toMail($notifiable)
    {   
        $otp=$this->otp->generate($notifiable->email,6,60);
        $data=[

            'body' => '<div style="border: 1px solid #ccc; padding: 10px; text-align: center; background-color: #001920; color: #ffffff; font-size: 14px;">' .
            "<img src=\"https://cdn.cp.adobe.io/content/2/dcx/1360d10a-779d-4575-8fdb-9b7f40b0a3e2/rendition/preview.jpg/version/1/format/jpg/dimension/width/size/1200\"
            style=\"max-width: 30%; display: block; margin: 0 auto;\">".
            "<h2>Bonjour,</h2>" .
            "<p>Utilisez le code ci-dessous pour récupérer votre mot de passe.</p>" .
            "<p>Code: ".$otp->token."</p>" .
            "<p>Cordialement,</p>" .
            "<p>[L'équipe OurClass]</p>".
            '</div>',

        ];
        return (new MailMessage)
            ->subject($this->subject)
            ->view('welcome')
            ->with([
                'data' => $otp->token,
             ]);
            
    }

    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
            //
        ];
    }
}
