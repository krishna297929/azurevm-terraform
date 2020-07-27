#!/bin/bash
# a bash script to create folders with subfolders all in one go.
#For a new server host: sh file
#- mkdir .ssh 
#- change permissions for .ssh folder to 700 
#- create a file authorized_keys in .ssh folder
#- copy pub key 
#  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAmQ4wkR480rUdJkELxtCHmCe8pYIflyMiNJ+rfBli1gMSN/3HWJM99AgxFpqJidtnNg+gdhpb5ENUZe1RsrwHDWRWuPt8tgPY3XoVAw/CGzEWhMDlJqkpi4MWlAt7oR8eLWyCcW0cR8vlVfxVoewQgrtxKWS/Ph7eMZYPn+3MfDv/De93YkR3+Vv53PJg5AVZivrHaz5qgv7mRc6h4nyNjN0CmW8+kqc0L6u1uuQFto+4jI0AYXJp0QhjrvHsr1Aha+j3KokdaHPkbuN4Iw/pS4XMYxp1QiS/YNK9CLqMw0sP/YN8AWTILOpIdzDbNh5qnZVnlDCrRSYJRk8RH46Z azureadmin@uw1vminas001p.arwcloud.net
#- change permissions for authorized_keys file to 0644
#- add line for vim /etc/sudoers 'azureadmin ALL=(ALL) NOPASSWD: ALL' under #includedir /etc/sudoers.d at end of file 

cd /home/azureadmin/
 mkdir -p .ssh &&  touch /home/azureadmin/.ssh/authorized_keys
 chown azureadmin:azureadmin .ssh
 chmod 700 .ssh
# touch /home/azureadmin/.ssh/authorized_keys
 echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCo61ECY2sepEObAhB4koTKWLWa4e93MSRtk2EgEy16EXupZUZZN46YvTBfHxxuAdUVBKXBCXDKpTnqRgrgWxcMWsZuggy8pfeilkeTE0UD8Q2hdyNnBbC5YvAvxRHChyonAwKzRFO2B27r2mRj5ZyNYjOayU8rthgwA2qO/Hek6szVmLkqRxkKDYGVJ9bLbJmLJXbHy1xzIBSHHslD7eNZetjNbCRzDE5Cup2ix4PII07sRvS2rmQDLLOXM9rdZDpeo+y/HG2u8w/naoN7hT8DGk0WER4Hc+/pldPaGReyTbdAFGnKQWPFAs4QaQAYDrTsD1qnYHwDaiXGltw3Fp7L azureadmin@uw1vminas001p.arwcloud.net" >> /home/azureadmin/.ssh/authorized_keys
 cd .ssh
 chown azureadmin:azureadmin authorized_keys
 chmod 644 authorized_keys
 cd ..
 echo "azureadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
