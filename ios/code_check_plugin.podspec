#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint code_check_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'code_check_plugin'
  s.version = '0.0.15'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.script_phase = {
    :name => 'CodeCheckInit',
    :execution_position => :before_compile,
    :script => <<-SCRIPT
    #!/bin/sh
    echo "Executing CodeCheckInit shell script..."

    # 定义插件目录
    PLUGIN_DIR="$PODS_TARGET_SRCROOT"
    SOURCE_DIR="$PLUGIN_DIR/../scripts"
    # 输出插件目录
    echo "Plugin directory: $PLUGIN_DIR"

    # 执行插件目录下的脚本
    if [ -f "$SOURCE_DIR/code_check_tool_install.sh" ]; then
      chmod +x "$SOURCE_DIR/code_check_tool_install.sh"
      echo "Executing code_check_tool_install.sh..."
      sh "$SOURCE_DIR/code_check_tool_install.sh" $SOURCE_DIR
    else
      echo "Script code_check_tool_install.sh not found in $SOURCE_DIR. Skipping execution."
    fi
    SCRIPT
  }

end
