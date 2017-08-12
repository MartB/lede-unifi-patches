#!/bin/bash
set -e
./scripts/feeds update -a
./scripts/feeds install -a
echo Remove Support for PPPOA
rm ./feeds/luci/protocols/luci-proto-ppp/luasrc/model/cbi/admin_network/proto_pppoa.lua
echo Remove AICCU Obsolete
rm ./feeds/luci/protocols/luci-proto-ipv6/luasrc/model/network/proto_aiccu.lua
rm ./feeds/luci/protocols/luci-proto-ipv6/luasrc/model/cbi/admin_network/proto_aiccu.lua
echo Remove Support for DIR-825 and AllNet Devices
rm ./target/linux/ar71xx/base-files/lib/upgrade/dir825.sh
rm ./target/linux/ar71xx/base-files/lib/upgrade/allnet.sh
rm ./target/linux/ar71xx/base-files/lib/upgrade/merakinand.sh
        for i in $( ls patch ); do
            echo Applying patch $i
            patch -p1 < patch/$i
        done

make defconfig
cat ubnt-config >> .config
make defconfig

./minify.sh