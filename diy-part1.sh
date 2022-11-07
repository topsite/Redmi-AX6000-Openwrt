#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a
sed -i '$a src-git mosdns https://github.com/sbwml/luci-app-mosdns' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a -f -p kenzo
./scripts/feeds install -a -f -p small

./scripts/feeds uninstall luci-app-mosdns mosdns v2ray-geodata
./scripts/feeds install -f -p mosdns mosdns luci-app-mosdns
find ./ -name v2ray-geodata | xargs rm -rf
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
svn export https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-vlmcsd package/luci-app-vlmcsd
svn export https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/vlmcsd  package/vlmcsd
svn export https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/new/luci-app-openclash
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/new/luci-app-adguardhome
svn export https://github.com/openwrt/packages/trunk/net/adguardhome feeds/packages/net/adguardhome
sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' ./package/*/Makefile
./scripts/feeds update -i && ./scripts/feeds install -a
