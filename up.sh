git config --global user.email "actions@github.com"
git config --global user.name "actions"
echo "$(date "+%Y%m%d-%H%M")" > update.txt
git add . && git commit -m "$(date "+%Y%m%d")" && git push && echo "更新完毕!!!" || echo "暂无更新!!!"
echo "======================="
