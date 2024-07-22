echo "------------------------------------"
echo "         ANURAOS TO STATIC          "
echo "------------------------------------"

rm -rf static_version # remove the directory if it exist
mkdir static_version # create the directory

# move all directories
cp -r ./public/* ./static_version
cp -r ./apps ./static_version
cp -r ./build/* ./static_version

# remove useless apps
rm -rf ./static_version/apps/term.app ./static_version/apps/marketplace.app
mv ./static_version/config.json ./static_version/temp.json
jq ' .apps |= map(select(. != "apps/term.app" and . != "apps/marketplace.app"))' ./static_version/temp.json > ./static_version/config.json
rm ./static_version/temp.json

# hide browser
echo "\"use strict\";class BrowserApp extends App {}" > ./static_version/lib/coreapps/BrowserApp.js
echo -e "\n.appsView > .app:first-child{ display:none !important; }" >> ./static_version/bundle.css
mv ./static_version/config.json ./static_version/temp.json
jq ' .defaultsettings.applist |= map(select(. != "anura.browser"))' ./static_version/temp.json > ./static_version/config.json

# remove x86 stuff to make anura more lightweight
rm -rf ./static_version/x86images
rm -rf ./static_version/bios
echo -e "\n.sidebar > .sidebar-settings-item:nth-child(2), .v86{ display:none !important; }" >> ./static_version/bundle.css

# skip oobe
perl -pi -e 's/this.nextStep\(\)/{this.nextStep();anura.settings.set("x86-disabled", true);anura.settings.set("use-sw-cache", false);anura.settings.set("applist", [...anura.settings.get("applist"),"anura.ashell",]);this.nextStep();}/g' ./static_version/lib/oobe/OobeView.js

# remove file browser
mv ./static_version/config.json ./static_version/temp.json
jq ' .apps |= map(select(. != "apps/fsapp.app"))' ./static_version/temp.json > ./static_version/config.json
mv ./static_version/config.json ./static_version/temp.json
jq ' .defaultsettings.applist |= map(select(. != "anura.fsapp"))' ./static_version/temp.json > ./static_version/config.json

# install custom apps
python3 ../customapps.py
cp -r ../CustomApps/* ./static_version/apps/