<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
{
    Schema::create('user_targets', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->onDelete('cascade');
        
        // Target Air
        $table->integer('water_target')->default(8); // Default 8 gelas
        
        // Target & Pengingat Langkah
        $table->integer('step_target')->default(5000); // Default 5000
        $table->time('step_reminder_time')->nullable(); // Jam pengingat
        
        // Pengingat Workout (Targetnya dinamis per aktivitas, jadi cuma butuh pengingat global)
        $table->time('workout_reminder_time')->nullable(); 

        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_targets');
    }
};
