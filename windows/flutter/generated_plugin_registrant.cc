//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_unity_widget/flutter_unity_widget_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <screen_brightness_windows/screen_brightness_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterUnityWidgetPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterUnityWidgetPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  ScreenBrightnessWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenBrightnessWindowsPlugin"));
}
