<?php

namespace OPNsense\tailscale;

/**
 * Class ConstatusController
 * @package OPNsense\tailscale
 */
class ConstatusController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->pick('OPNsense/tailscale/constatus');
    }
}
