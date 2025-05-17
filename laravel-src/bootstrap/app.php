<?php

use Illuminate\Foundation\Application;
use Illuminate\Auth\Middleware\Authenticate;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful;

/**
 * Configure the application with routing, middleware, and exception handling.
 *
 * @return \Illuminate\Foundation\Application
 */
return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        // Define the paths for API and console routes, and health check endpoint
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Register authentication middlewares
        $middleware->alias([
            'auth' => Authenticate::class,
            'auth:sanctum' => EnsureFrontendRequestsAreStateful::class
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Customize exception handling here if needed
    })->create();
