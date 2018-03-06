hexo generate
cp -R public/* .deploy/toverpomelo.github.io
cd .deploy/toverpomelo.github.io
git add .
git commit -m “update”
git push origin master
