#!/bin/sh
cd /home/root/ozw
mkdir /tmp/ozw_config
tar xzf ozw_config.tgz -C /tmp/ozw_config
./ozwcp -p 8000 &> /tmp/ozwcp.log&
