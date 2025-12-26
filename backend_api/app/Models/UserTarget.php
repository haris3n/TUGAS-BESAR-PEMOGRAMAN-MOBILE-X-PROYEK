<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserTarget extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'water_target',
        'step_target',
        'workout_target', // <--- TAMBAHAN PENTING (JANGAN LUPA KOMA)
        'step_reminder_time',
        'workout_reminder_time',
    ];
}