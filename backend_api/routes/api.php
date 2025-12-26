<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\TrackerController;

// 1. PUBLIC ROUTES
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// 2. PRIVATE ROUTES
Route::middleware('auth:sanctum')->group(function () {

    // Auth - Logout
    Route::post('/logout', [AuthController::class, 'logout']);

    // ==========================================
    // TAMBAHAN BARU (BIAR ERROR 404 HILANG)
    // ==========================================
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    // ==========================================

    // FITUR HEALTH TRACKER...
    Route::get('/targets', [TrackerController::class, 'getTargets']);
    Route::post('/targets', [TrackerController::class, 'updateTargets']);

    Route::post('/water', [TrackerController::class, 'addWater']);
    Route::get('/water', [TrackerController::class, 'getWaterStats']);

    Route::post('/steps', [TrackerController::class, 'updateSteps']);
    Route::get('/steps', [TrackerController::class, 'getStepStats']);

    Route::post('/workout', [TrackerController::class, 'addWorkout']);
    Route::get('/workout', [TrackerController::class, 'getWorkouts']);
});