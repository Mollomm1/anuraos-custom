sudo apt update 
sudo apt install -y uuid-runtime
git clone https://github.com/MercuryWorkshop/anuraOS -b v2.0
cd anuraOS
bash codespace-basic-setup.sh
bash ../ats.sh
zip -r static_version.zip static_version/*
mv static_version.zip ..
echo "the static build is avilable as static_version.zip"