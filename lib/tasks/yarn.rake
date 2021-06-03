namespace :yarn do
  task :install_packages do
    system "apt-get update --yes"
    system "apt-get install --yes npm"
    system "npm install --global yarn"
    system "yarn add ion-rangeslider"
  end
end
