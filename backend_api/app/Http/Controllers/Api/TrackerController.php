<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class TrackerController extends Controller
{
    // -------------------------------------------------------------------------
    // 1. DASHBOARD (OPSIONAL - Untuk Load Awal)
    // -------------------------------------------------------------------------
    public function dashboard(Request $request)
    {
        // Fungsi ini hanya pembantu jika kamu ingin mengambil semua data sekaligus
        // Biarkan kosong atau sesuaikan jika dipakai
        return response()->json(['message' => 'Dashboard ready']);
    }

    // -------------------------------------------------------------------------
    // 2. TARGETS
    // -------------------------------------------------------------------------
    public function getTargets(Request $request)
    {
        $user = $request->user();
        $targets = DB::table('user_targets')->where('user_id', $user->id)->first();

        return response()->json([
            'water_target' => $targets->water_target ?? 0,
            'step_target' => $targets->step_target ?? 0,
            'workout_target' => $targets->workout_target ?? 0,
        ]);
    }

    public function updateTargets(Request $request)
    {
        $user = $request->user();
        $data = ['updated_at' => now()];
        
        if($request->has('water_target')) $data['water_target'] = $request->water_target;
        if($request->has('step_target')) $data['step_target'] = $request->step_target;
        if($request->has('workout_target')) $data['workout_target'] = $request->workout_target;

        $exists = DB::table('user_targets')->where('user_id', $user->id)->exists();

        if ($exists) {
            DB::table('user_targets')->where('user_id', $user->id)->update($data);
        } else {
            $data['user_id'] = $user->id;
            $data['created_at'] = now();
            // Default jika tidak dikirim
            if(!isset($data['water_target'])) $data['water_target'] = 0;
            if(!isset($data['step_target'])) $data['step_target'] = 0;
            if(!isset($data['workout_target'])) $data['workout_target'] = 0;
            
            DB::table('user_targets')->insert($data);
        }
        return response()->json(['message' => 'Target updated']);
    }

    // -------------------------------------------------------------------------
    // 3. WATER (LOGIC: INCREMENT)
    // -------------------------------------------------------------------------
    public function getWaterStats(Request $request)
    {
        $user = $request->user();
        $today = Carbon::today()->toDateString();
        $total = DB::table('water_logs')->where('user_id', $user->id)->where('date', $today)->sum('glasses');
        return response()->json(['total_water' => (int)$total]);
    }

    public function addWater(Request $request)
    {
        $user = $request->user();
        $date = Carbon::today()->toDateString();
        // Terima input 'value' atau 'amount' atau 'glasses'
        $amount = $request->value ?? $request->amount ?? $request->glasses ?? 1;

        $exist = DB::table('water_logs')->where('user_id', $user->id)->where('date', $date)->first();
        
        if ($exist) {
            // INCREMENT: Tambahkan ke angka yang sudah ada!
            DB::table('water_logs')->where('id', $exist->id)->increment('glasses', $amount);
        } else {
            DB::table('water_logs')->insert([
                'user_id' => $user->id, 'glasses' => $amount, 'date' => $date, 'created_at' => now(), 'updated_at' => now()
            ]);
        }
        return response()->json(['message' => 'Water added successfully']);
    }

    // -------------------------------------------------------------------------
    // 4. STEPS (LOGIC: INCREMENT)
    // -------------------------------------------------------------------------
    public function getStepStats(Request $request)
    {
        $user = $request->user();
        $today = Carbon::today()->toDateString();
        $total = DB::table('step_logs')->where('user_id', $user->id)->where('date', $today)->sum('steps');
        return response()->json(['total_steps' => (int)$total]);
    }

    public function updateSteps(Request $request)
    {
        $user = $request->user();
        $date = Carbon::today()->toDateString();
        // Terima input 'value' atau 'steps'
        $steps = $request->value ?? $request->steps ?? 0;

        $exist = DB::table('step_logs')->where('user_id', $user->id)->where('date', $date)->first();

        if ($exist) {
            // INCREMENT: Tambahkan langkah baru ke langkah lama
            DB::table('step_logs')->where('id', $exist->id)->increment('steps', $steps);
        } else {
            DB::table('step_logs')->insert([
                'user_id' => $user->id, 'steps' => $steps, 'date' => $date, 'created_at' => now(), 'updated_at' => now()
            ]);
        }
        return response()->json(['message' => 'Steps added successfully']);
    }

    // -------------------------------------------------------------------------
    // 5. WORKOUT (LOGIC: INSERT NEW HISTORY)
    // -------------------------------------------------------------------------
    public function getWorkouts(Request $request)
    {
        $user = $request->user();
        $today = Carbon::today()->toDateString();
        $totalDuration = DB::table('workout_logs')->where('user_id', $user->id)->where('date', $today)->sum('duration');
        
        return response()->json(['total_duration' => (int)$totalDuration]);
    }

    public function addWorkout(Request $request)
    {
        $user = $request->user();
        $date = Carbon::today()->toDateString();
        
        // Workout selalu insert baru (History), jadi otomatis nambah totalnya
        DB::table('workout_logs')->insert([
            'user_id' => $user->id,
            'activity_type' => $request->workout_name ?? $request->activity_type ?? 'Olahraga',
            'duration' => $request->value ?? $request->duration ?? 0,
            'date' => $date,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        return response()->json(['message' => 'Workout added successfully']);
    }
}