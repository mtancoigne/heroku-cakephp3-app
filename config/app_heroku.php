<?php
$db = parse_url(env('DATABASE_URL'));

return [
    'debug' => false,

    'Security' => [
        'salt' => env('SALT'),
    ],

    'Cache' => [
        'default' => [
            'className' => 'Memcached',
            'prefix' => 'myapp_cake_',
            'servers' => [env('MEMCACHIER_SERVERS')],
            'username' => env('MEMCACHIER_USERNAME'),
            'password' => env('MEMCACHIER_PASSWORD'),
            'duration' => '+1440 minutes',
        ],

        'session' => [
            'className' => 'Memcached',
            'prefix' => 'myapp_cake_session_',
            'servers' => [env('MEMCACHIER_SERVERS')],
            'username' => env('MEMCACHIER_USERNAME'),
            'password' => env('MEMCACHIER_PASSWORD'),
            'duration' => '+1440 minutes',
        ],

        '_cake_core_' => [
            'className' => 'Memcached',
            'prefix' => 'myapp_cake_core_',
            'servers' => [env('MEMCACHIER_SERVERS')],
            'username' => env('MEMCACHIER_USERNAME'),
            'password' => env('MEMCACHIER_PASSWORD'),
            'duration' => '+1 years',
        ],

        '_cake_model_' => [
            'className' => 'Memcached',
            'prefix' => 'myapp_cake_model_',
            'servers' => [env('MEMCACHIER_SERVERS')],
            'username' => env('MEMCACHIER_USERNAME'),
            'password' => env('MEMCACHIER_PASSWORD'),
            'duration' => '+1 years',
        ],
    ],

    'Datasources' => [
        'default' => [
            'className' => 'Cake\Database\Connection',
            'driver' => 'Cake\Database\Driver\Postgres',
            'persistent' => false,
            'host' => $db['host'],
            'username' => $db['username'],
            'password' => $db['password'],
            'database' => substr($db['path'], 1),
            'encoding' => 'utf8',
            'timezone' => 'UTC',
            'cacheMetadata' => true,
            'quoteIdentifiers' => false,
            //'url' => env('DATABASE_URL', null),
        ],
    ],

    'Log' => [
        'debug' => [
            'className' => 'Cake\Log\Engine\ConsoleLog',
            'stream' => 'php://stdout',
            'levels' => ['notice', 'info', 'debug'],
        ],
        'error' => [
            'className' => 'Cake\Log\Engine\ConsoleLog',
            'stream' => 'php://stderr',
            'levels' => ['warning', 'error', 'critical', 'alert', 'emergency'],
        ],
    ],

    'Session' => [
        'defaults' => 'cache',
        'handler' => [
            'config' => 'session'
        ]
    ],
];
