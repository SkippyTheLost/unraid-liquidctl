<?php
header('Content-Type: text/plain; charset=UTF-8');
$action = $_POST['action'] ?? '';
if (!in_array($action, ['list', 'apply'], true)) {
    http_response_code(400);
    exit("Invalid action\n");
}
$control = '/usr/local/emhttp/plugins/liquidctl/scripts/liquidctlctl';
passthru(escapeshellarg($control).' '.escapeshellarg($action).' 2>&1', $status);
http_response_code($status === 0 ? 200 : 500);
