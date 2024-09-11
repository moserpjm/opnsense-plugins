<?php


namespace OPNsense\tailscale\Api;

use OPNsense\Base\ApiMutableModelControllerBase;

/**
 * tailscale settings controller
 * @package OPNsense\tailscale
 */
class SettingsController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'tailscale';
    protected static $internalModelClass = 'OPNsense\tailscale\Tailscale';
}
