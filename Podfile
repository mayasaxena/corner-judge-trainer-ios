source 'https://github.com/CocoaPods/Specs'

platform :ios, '8.0'

use_frameworks!

target 'CornerJudgeTrainer' do
    pod 'Intrepid'
    pod 'Intrepid/Rx'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxSwiftExt'
    pod 'IQKeyboardManager', :git => 'git@github.com:IntrepidPursuits/IQKeyboardManager.git'
    pod 'Starscream', '~> 2.0.0'
    pod 'Genome', '~> 3.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
