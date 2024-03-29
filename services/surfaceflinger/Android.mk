LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    Client.cpp                              \
    DisplayDevice.cpp                       \
    EventThread.cpp                         \
    Layer.cpp                               \
    LayerBase.cpp                           \
    LayerDim.cpp                            \
    LayerScreenshot.cpp                     \
    DisplayHardware/FramebufferSurface.cpp  \
    DisplayHardware/GraphicBufferAlloc.cpp  \
    DisplayHardware/HWComposer.cpp          \
    DisplayHardware/PowerHAL.cpp            \
    GLExtensions.cpp                        \
    MessageQueue.cpp                        \
    SurfaceFlinger.cpp                      \
    SurfaceTextureLayer.cpp                 \
    Transform.cpp                           \
    

LOCAL_CFLAGS:= -DLOG_TAG=\"SurfaceFlinger\"
LOCAL_CFLAGS += -DGL_GLEXT_PROTOTYPES -DEGL_EGLEXT_PROTOTYPES

ifeq ($(TARGET_BOARD_PLATFORM),omap4)
	LOCAL_CFLAGS += -DHAS_CONTEXT_PRIORITY
endif
ifeq ($(TARGET_BOARD_PLATFORM),s5pc110)
	LOCAL_CFLAGS += -DHAS_CONTEXT_PRIORITY
	LOCAL_CFLAGS += -DNEVER_DEFAULT_TO_ASYNC_MODE
endif

ifeq ($(TARGET_DISABLE_TRIPLE_BUFFERING),true)
	LOCAL_CFLAGS += -DTARGET_DISABLE_TRIPLE_BUFFERING
endif

ifeq ($(BOARD_EGL_NEEDS_LEGACY_FB),true)
	LOCAL_CFLAGS += -DBOARD_EGL_NEEDS_LEGACY_FB
endif

ifneq ($(NUM_FRAMEBUFFER_SURFACE_BUFFERS),)
  LOCAL_CFLAGS += -DNUM_FRAMEBUFFER_SURFACE_BUFFERS=$(NUM_FRAMEBUFFER_SURFACE_BUFFERS)
endif

ifeq ($(BOARD_HAVE_HDMI_SUPPORT),SAMSUNG_HDMI_SUPPORT)
	LOCAL_CFLAGS += -DSAMSUNG_HDMI_SUPPORT
endif

# HWComposer.cpp contains 2 pretty bad aliasing violations
LOCAL_CFLAGS += -fno-strict-aliasing

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libdl \
	libhardware \
	libutils \
	libEGL \
	libGLESv1_CM \
	libbinder \
	libui \
	libgui

ifeq ($(BOARD_HAVE_HDMI_SUPPORT),SAMSUNG_HDMI_SUPPORT)
        LOCAL_C_INCLUDES += vendor/samsung/origen/proprietary/include
        LOCAL_LDFLAGS += vendor/samsung/origen/proprietary/system/lib/libfimc.so
        LOCAL_LDFLAGS += vendor/samsung/origen/proprietary/system/lib/libhdmi.so
endif

LOCAL_MODULE:= libsurfaceflinger

include $(BUILD_SHARED_LIBRARY)

###############################################################
# uses jni which may not be available in PDK
ifneq ($(wildcard libnativehelper/include),)
include $(CLEAR_VARS)
LOCAL_CFLAGS:= -DLOG_TAG=\"SurfaceFlinger\"

LOCAL_SRC_FILES:= \
    DdmConnection.cpp

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libdl

LOCAL_MODULE:= libsurfaceflinger_ddmconnection

include $(BUILD_SHARED_LIBRARY)
endif # libnativehelper
