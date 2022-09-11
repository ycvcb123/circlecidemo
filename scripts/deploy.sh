# !/bin/sh

# 非0退出shell脚本
set -e 

# 当前的工作路径
pwd
remote=$(git config remote.origin.url)

echo 'remote is: '$remote

# 新建发布目录
mkdir gh-pages-branch
cd gh-pages-branch

# 创建一个新的仓库，设置发布的用户名和邮箱
git config --global user.email "$GH_EMAIL" >/dev/null 2>&1 
git config --global user.name "$GH_NAME" >/dev/null 2>&1 
git init
git remote add --fetch origin "$remote"

echo 'email is: '$GH_EMAIL
echo 'name is: '$GH_NAME
echo 'siteSource is: '$siteSource


# 切换到gh-pages分支
if git rev-parse --verify origin/gh-pages >/dev/null 2>&1; then
    git checkout origin/gh-pages
    # 删除旧的文件内容
    git rm -rf .
else 
    # https://im.shellj.com/2020/04/clean-git-history.html (orphan)
    git checkout --orphan gh-pages


# 把构建好的文件目录给拷贝进来
cp -a "../${siteSource}/." .

ls -la

# 把所有文件添加到git
git add -A

# 添加提交内容
git commit --allow-empty -m "deploy to github pages [ci skip]"

# 推送远程文件
git push --force --quiet origin  gh-pages

# 资源回收，删除临时的脚本和目录
cd ..
rm -rf gh-pages-branch

echo "finished deployment!!!"