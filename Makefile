#
# Copyright (C) 2017 Dan Luedtke <mail@danrl.com>
#
# This is free software, licensed under the GNU General Public License v2.

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for the MWAN3 MultiWAN Manager
LUCI_DEPENDS:=+luci-base +mwan3
PKG_LICENSE:=GPL-2.0
PKG_SRC_PREFIX:=$(shell date +%y).999
PKG_SRC_SUFFIX:=3.6.12
PKG_VERSION:=$(PKG_SRC_PREFIX).$(PKG_SRC_SUFFIX)
PKG_RELEASE:=1

PKG_MAINTAINER:=Florian Eckert <fe@dev.tdt.de>

include ../../luci.mk

# luci.mk 默认把翻译拆分成独立的 luci-i18n-* 软件包。本仓库只发布单一
# 软件包，因此在这里把简体中文翻译目录一并安装进主包，安装一个 apk
# 即可显示中文界面。
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)$(HTDOCS)
	cp -pR $(PKG_BUILD_DIR)/htdocs/* $(1)$(HTDOCS)/
	$(if $(CONFIG_LUCI_JSMIN),$(call JsMin,$(1)$(HTDOCS)/),true)
	$(if $(CONFIG_LUCI_CSSTIDY),$(call CssTidy,$(1)$(HTDOCS)/),true)
	$(INSTALL_DIR) $(1)/
	cp -pR $(PKG_BUILD_DIR)/root/* $(1)/
	$(INSTALL_DIR) $(1)$(LUCI_LIBRARYDIR)/i18n
	po2lmo $(CURDIR)/po/zh_Hans/mwan3.po $(1)$(LUCI_LIBRARYDIR)/i18n/mwan3.zh-cn.lmo
endef

# call BuildPackage - OpenWrt buildroot signature
