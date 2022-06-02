#!/bin/bash
set -e
user="ubuntu"

echo $AWS_HOST
echo $user

ssh $user@$AWS_HOST "
cd ~/medpiperServer && \
git stash -u
touch .env
cd ..
cp -r env_file/.env medpiperServer/.env
exit
"

rm -rf .git
rm -rf .gitignore
mv .gitignore_cicd .gitignore

git config --global user.email "manish@medpiper.com"
git config --global user.name "manishmedp"
git config --global init.defaultBranch main


git init .
git add .
git commit -m "Deploying"
git show-ref
git remote add production ssh://$user@$AWS_HOST/~/medpiperServer
git push -f production main

ssh $user@$AWS_HOST "
   cd ~/medpiperServer && \
     echo "I am here"
     ls
     npm i
     pm2 kill
     pm2 start /home/ubuntu/medpiperServer/build/server.js
 exit
"