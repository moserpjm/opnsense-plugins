<?php

namespace OPNsense\tailscale\Api;

use OPNsense\Base\ApiMutableServiceControllerBase;
use OPNsense\Core\Backend;
use OPNsense\Core\Config;
use OPNsense\tailscale\Initial;
use OPNsense\tailscale\Tailscale;


/**
 * Class ServiceController
 * @package OPNsense\tailscale
 */
class ServiceController extends ApiMutableServiceControllerBase
{
    protected static $internalServiceClass = '\OPNsense\tailscale\Tailscale';
    protected static $internalServiceEnabled = 'general.Enabled';
    protected static $internalServiceTemplate = 'OPNsense/tailscale';
    protected static $internalServiceName = 'tailscale';







    public function setUpAction(): string
    {
        $backend = new Backend();
        try {
            return $backend->configdRun("tailscale set-up");
        } catch (\Exception $e) {
            return "Error running tailscale up" . "\n" . $e->getMessage();
        }
    }



    public function setDownAction(): string
    {
        $backend = new Backend();
        try {
            return $backend->configdRun("tailscale set-down");
        } catch (\Exception $e) {
            return "Error running tailscale down" . "\n" . $e->getMessage();
        }
    }

    public function reloadAction()
    {
        $status = "failed";
        if ($this->request->isPost()) {
            try {
                $mdlTailscale = new Tailscale();
                $backend = new Backend();
                if (trim($backend->configdRun('template reload OPNsense/tailscale')) == "OK") {
                    $status = "ok";
                }

                $enabled = $mdlTailscale->general->Enabled->__toString() == 1;
                $carpEnabled = $mdlTailscale->general->CarpIf->__toString() != '';
                $action = $enabled ? "restart" : "stop";
                $backend->configdRun("tailscale $action");
                if($carpEnabled && $enabled) {
                    $backend->configdRun("tailscale set-down");
                }
            } catch (\Exception $e) {
                $status = "failed";
                syslog(LOG_ERR, "tailscale: failed to reload configuration: " . $e->getMessage());
            }
        }
        return array("status" => $status);
    }


}
