<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Foundation\Application;

Route::get('/', function () {
    return response()->json([
        'message' => '🚀 Welcome to your Laravel Octane API running on Swoole!',
        'laravel_version' => Application::VERSION,
        'php_version' => PHP_VERSION,
    ]);
});