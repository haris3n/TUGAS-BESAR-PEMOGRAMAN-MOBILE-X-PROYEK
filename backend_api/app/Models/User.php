<?php

namespace App\Models;

// Pastikan import ini ada
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    // Gunakan trait HasApiTokens
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    // --- BAGIAN INI YANG KITA PERBAIKI ---
    // Jangan panggil HealthActivity lagi karena filenya sudah dihapus.
    // Ganti dengan relasi ke tabel-tabel baru:

    public function waterLogs()
    {
        return $this->hasMany(WaterLog::class);
    }

    public function stepLogs()
    {
        return $this->hasMany(StepLog::class);
    }

    public function workoutLogs()
    {
        return $this->hasMany(WorkoutLog::class);
    }
}