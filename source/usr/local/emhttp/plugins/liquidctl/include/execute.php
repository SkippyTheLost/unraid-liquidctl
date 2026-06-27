<?php
header('Content-Type: text/plain; charset=UTF-8');
$action = $_POST['action'] ?? '';
if (!in_array($action, ['save', 'list', 'apply'], true)) {
    http_response_code(400);
    exit("Invalid action\n");
}

if ($action === 'save') {
    $configDir = '/boot/config/plugins/liquidctl';
    $configFile = $configDir.'/liquidctl.cfg';
    $commandsFile = $configDir.'/startup.conf';
    $enabled = ($_POST['ENABLED'] ?? 'no') === 'yes' ? 'yes' : 'no';
    $extraArgs = trim(str_replace(["\r", "\n"], '', (string) ($_POST['EXTRA_ARGS'] ?? '')));
    $commands = str_replace(["\r\n", "\r"], "\n", (string) ($_POST['STARTUP_COMMANDS'] ?? ''));

    if (!is_dir($configDir) && !mkdir($configDir, 0755, true)) {
        http_response_code(500);
        exit("Unable to create configuration directory.\n");
    }

    $quotedArgs = '"'.addcslashes($extraArgs, "\\\"$`").'"';
    $config = "ENABLED=\"$enabled\"\nEXTRA_ARGS=$quotedArgs\n";
    if (file_put_contents($configFile, $config, LOCK_EX) === false ||
        file_put_contents($commandsFile, $commands, LOCK_EX) === false) {
        http_response_code(500);
        exit("Unable to save liquidctl settings.\n");
    }

    echo "liquidctl settings saved.\n";
    exit;
}

$control = '/usr/local/emhttp/plugins/liquidctl/scripts/liquidctlctl';
passthru(escapeshellarg($control).' '.escapeshellarg($action).' 2>&1', $status);
http_response_code($status === 0 ? 200 : 500);
