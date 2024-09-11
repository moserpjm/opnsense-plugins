<?php

function tailscale_enabled()
{
    $mdlTailscale = new \OPNsense\tailscale\Tailscale();
    return $mdlTailscale->general->Enabled->__toString() == 1;
}

function tailscale_services()
{
    $services = array();

    if (!tailscale_enabled()) {
        return $services;
    }

    $services[] = array(
        'description' => gettext('Tailscale'),
        'configd' => array(
            'restart' => array('tailscale restart'),
            'start' => array('tailscale start'),
            'stop' => array('tailscale stop'),
        ),
        'name' => 'tailscaled',
        'pidfile' => '/var/run/tailscaled.pid'
    );

    return $services;
}

