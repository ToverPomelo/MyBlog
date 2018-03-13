cd ~/blog
rm -rf ./public_old/
cp -r ./public ./public_old

git add .
git add themes/mellow/.
git commit -m “backup”
git push -u origin master

