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
            'restart' => array('tailscaled restart'),
            'start' => array('tailscaled start'),
            'stop' => array('tailscaled stop'),
        ),
        'name' => 'tailscaled',
        'pidfile' => '/var/run/tailscaled.pid'
    );

    return $services;
}

