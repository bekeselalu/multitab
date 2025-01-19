#!/bin/bash
url_install='https://srv.ddns.my.id/genieacs/genieacs/'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
local_ip=$(hostname -I | awk '{print $1}')
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}========================EEEEEEE    KK  KK      AAA==========================${NC}"   
echo -e "${GREEN}========================EE         KK KK      AAAAA=========================${NC}"  
echo -e "${GREEN}========================EEEEE      KKKK      AA   AA========================${NC}" 
echo -e "${GREEN}========================EE         KK KK     AAAAAAA========================${NC}" 
echo -e "${GREEN}========================EEEEEEE    KK  KK    AA   AA========================${NC}" 
echo -e "${GREEN}========================EEEEEEE    KK  KK    AA   AA========================${NC}" 
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}========================= . Info 0812-8567-6444 ============================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================== WARNING!!! ==================================${NC}"
echo -e "${RED}${NC}"
echo -e "${GREEN} Apakah anda ingin melanjutkan bro? (y/n)${NC}"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo -e "${GREEN}Install dibatalkan..${NC}"
    sudo rm /tmp/install.sh
    exit 1
fi
for ((i = 5; i >= 1; i--)); do
	sleep 1
    echo "Lanjut Bos... $i. Tekan ctrl+c untuk membatalkan"
done

#MongoDB
if ! sudo systemctl is-active --quiet mongod; then
    curl -s \
${url_install}\
mongod.sh | \
sudo bash
else
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}=================== mongodb sudah terinstall sebelumnya. ===================${NC}"
    echo -e "${GREEN}============================================================================${NC}"
fi
sleep 3
if ! sudo systemctl is-active --quiet mongod; then
    sudo rm /tmp/install.sh
    exit 1
fi

#NodeJS Install
check_node_version() {
    if command -v node > /dev/null 2>&1; then
        NODE_VERSION=$(node -v | cut -d 'v' -f 2)
        NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)
        NODE_MINOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 2)

        if [ "$NODE_MAJOR_VERSION" -lt 12 ] || { [ "$NODE_MAJOR_VERSION" -eq 12 ] && [ "$NODE_MINOR_VERSION" -lt 13 ]; } || [ "$NODE_MAJOR_VERSION" -gt 22 ]; then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

if ! check_node_version; then
    curl -s \
${url_install}\
nodejs.sh | \
sudo bash
else
    NODE_VERSION=$(node -v | cut -d 'v' -f 2)
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}============== NodeJS sudah terinstall versi ${NODE_VERSION}. ==============${NC}"
    echo -e "${GREEN}========================= Lanjut install GenieACS ==========================${NC}"
    echo -e "${GREEN}============================================================================${NC}"

fi
if ! check_node_version; then
    sudo rm /tmp/install.sh
    exit 1
fi

#APP
if ! sudo systemctl is-active --quiet genieacs-{cwmp,fs,ui,nbi}; then
    curl -s \
${url_install}\
app.sh | \
sudo bash
    sleep 3
    if ! sudo systemctl is-active --quiet genieacs-{cwmp,fs,ui,nbi}; then
        echo -e "${RED}============================================================================${NC}"
        echo -e "${RED}======================= INSTALASI TIDAK BISA DILANJUTKAN. ==================${NC}"
        echo -e "${GREEN}=================== Informasi: Whatsapp 081-947-215-703 ==================${NC}"
        echo -e "${RED}============================================================================${NC}"
        sudo rm /tmp/install.sh
        exit 1
    fi

else
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}=================== GenieACS sudah terinstall sebelumnya. ==================${NC}"
    echo -e "${GREEN}============================================================================${NC}"
fi


sleep 3

if ! sudo systemctl is-active --quiet genieacs-{cwmp,fs,ui,nbi}; then
    sudo rm /tmp/install.sh
    exit 1
fi

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}========== GenieACS UI akses port 3000. : http://$local_ip:3000 ============${NC}"
echo -e "${GREEN}=================== Informasi: Whatsapp 081-947-215-703 ====================${NC}"
echo -e "${GREEN}============================================================================${NC}"

echo -e "${GREEN}Sekarang install parameter. Apakah anda ingin melanjutkan? (y/n)${NC}"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo -e "${GREEN}Install dibatalkan..${NC}"
    
    exit 1
fi
for ((i = 5; i >= 1; i--)); do
	sleep 1
    echo "Lanjut Install Parameter $i. Tekan ctrl+c untuk membatalkan"
done
echo -e "${GREEN}============================================================================$
echo -e "${GREEN}================== VIRTUAL PARAMETER BERHASIL DI INSTALL ===================${NC}"
echo -e "${GREEN}========== GenieACS UI akses port 3000. : http://$local_ip:3000 ============${NC}"
echo -e "${GREEN}=================== Informasi: Whatsapp 081-947-215-703 ====================${NC}"
echo -e "${GREEN}============================================================================${NC}"
cd -
sudo mongorestore --db=genieacs --drop genieacs
unzip multitab.zip -d /usr/lib/node_modules/
