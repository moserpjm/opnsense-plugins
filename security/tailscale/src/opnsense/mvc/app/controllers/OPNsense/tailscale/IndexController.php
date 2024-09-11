<?php

namespace OPNsense\tailscale;

/**
 * Class IndexController
 * @package OPNsense\tailscale
 */
class IndexController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->generalForm = $this->getForm("general");
        $this->view->pick('OPNsense/tailscale/index');
    }
}
