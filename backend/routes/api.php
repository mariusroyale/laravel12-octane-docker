<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Foundation\Application;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

/**
 * Route for the homepage of the API.
 * 
 * @return \Illuminate\Http\JsonResponse
 */
Route::get('/', function () {
    return response()->json([
        'message' => '🚀 Welcome to your Laravel Octane API running on Swoole!',
        'laravel_version' => Application::VERSION,
        'php_version' => PHP_VERSION,
    ]);
});

/**
 * Route for the login endpoint. Provides instructions for authentication.
 * 
 * @return \Illuminate\Http\JsonResponse
 */
Route::get('/login', function () {
    return response()->json([
        'message' => '🔐 Authentication required. Please POST your credentials to /login to obtain an access token.',
        'instructions' => [
            'method' => 'POST',
            'endpoint' => '/login',
            'payload' => [
                'email' => 'user@example.com',
                'password' => 'your-password',
            ],
            'response' => [
                'access_token' => 'your-access-token',
                'token_type' => 'Bearer',
                'expires_in' => '3600 seconds',
            ],
        ],
        'laravel_version' => Application::VERSION,
        'php_version' => PHP_VERSION,
    ]);
})->name('login');

/**
 * Route secured with Sanctum middleware for testing authentication.
 * 
 * @return \Illuminate\Http\JsonResponse
 */
Route::middleware('auth:sanctum')->get('/test-auth-sanctum', function () {
    return response()->json([
        'message' => '🚀 Test with middleware Auth:Sanctum!',
        'laravel_version' => Application::VERSION,
        'php_version' => PHP_VERSION,
    ]);
});

/**
 * Route secured with default authentication middleware for testing.
 * 
 * @return \Illuminate\Http\JsonResponse
 */
Route::middleware('auth')->get('/test-auth', function () {
    return response()->json([
        'message' => '🚀 Test with middleware Auth!',
        'laravel_version' => Application::VERSION,
        'php_version' => PHP_VERSION,
    ]);
});
