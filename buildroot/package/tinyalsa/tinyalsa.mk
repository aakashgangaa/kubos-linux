################################################################################
#
# tinyalsa
#
################################################################################

TINYALSA_VERSION = v1.0.2
TINYALSA_SITE = $(call github,tinyalsa,tinyalsa,$(TINYALSA_VERSION))
TINYALSA_LICENSE = BSD-3c
TINYALSA_INSTALL_STAGING = YES

define TINYALSA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D)
endef

define TINYALSA_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		-C $(@D) \
		PREFIX="/usr" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		DESTDIR="$(STAGING_DIR)" install
endef

define TINYALSA_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		-C $(@D) \
		PREFIX="/usr" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
