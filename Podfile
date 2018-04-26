# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

use_frameworks!

def shared_pods
    pod 'Kingfisher', '~> 4.0'
    pod 'KDEAudioPlayer', :git => 'https://github.com/delannoyk/AudioPlayer'
end

target 'MusicPlayer' do
    shared_pods
end

target 'MusicPlayerTests' do
    shared_pods
end

target 'MusicPlayerUITests' do
    shared_pods
end
