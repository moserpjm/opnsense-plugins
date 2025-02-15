<?php

/*
 * Copyright (C) 2024 Sheridan Computers
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

namespace OPNsense\Tailscale\Api;

use OPNsense\Base\ApiMutableServiceControllerBase;
use OPNsense\Core\Backend;
use OPNsense\Core\Config;
use OPNsense\Tailscale\Settings;

/**
 * Class ServiceController
 * @package OPNsense\Tailscale
 */
class ServiceController extends ApiMutableServiceControllerBase
{
    protected static $internalServiceClass = '\OPNsense\Tailscale\Settings';
    protected static $internalServiceEnabled = 'enabled';
    protected static $internalServiceTemplate = 'OPNsense/Tailscale';
    protected static $internalServiceName = 'tailscale';

    private const CARP_MASTER_FILE = '/var/run/tailscale/CARP_MASTER';

    public function reconfigureAction()
    {
        $settings = new Settings();
        $carpif = $settings->carpIf->__toString();


        if ($carpif != "" && $this->isCarpMaster()) {
            touch(self::CARP_MASTER_FILE);
        } elseif (file_exists(self::CARP_MASTER_FILE)) {
            unlink(self::CARP_MASTER_FILE);
        }


        return parent::reconfigureAction();
    }

    private function isCarpMaster()
    {
        $settings = new Settings();
        $carpif = $settings->carpIf->__toString();
        $vhid = $settings->vhid;
        $realif = null;
        $config = Config::getInstance()->object();
        if ($config->interfaces->count() > 0) {
            foreach ($config->interfaces->children() as $key => $node) {
                if ($key == $carpif) {
                    $realif = (string)$node->if;
                    break;
                }
            }
        }
        $ifconfig = json_decode((new Backend())->configdRun('interface list ifconfig'), true);
        foreach ($ifconfig[$realif]['carp'] as $item) {
            if ($item["vhid"] == $vhid && $item["status"] == "MASTER") {
                return true;
            }
        }
        return false;
    }
}
