<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'service' => 'laravel',
        'timestamp' => now()->toISOString(),
    ]);
});

Route::get('/api/code1', function () {
    return response()->json([
        'message' => 'Code 1 API endpoint',
        'status' => 'success',
        'data' => [
            'id' => 1,
            'name' => 'Theo TTD',
            'description' => 'Test-driven development example'
        ]
    ]);
});