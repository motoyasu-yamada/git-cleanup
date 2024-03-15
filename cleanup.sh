#!/bin/bash

###############################################################################
# main以外のブランチを削除する
###############################################################################
# リモート追跡ブランチとローカルブランチのリストを取得
branches=$(git branch --all | grep -vE '^\*|^\s+remotes/origin/HEAD|^(main|master)$|^\s+remotes/origin/(main|master)$')

# 各ブランチを削除
for branch in $branches; do
    if [[ $branch == remotes/origin/* ]]; then
        echo "Deleting remote-tracking branch: $branch"
        # git branch -d -r ${branch#remotes/origin/} # コメント外してね
    else
        echo "Deleting local branch: $branch"
        # git branch -d $branch # コメント外してね
    fi
done

###############################################################################
# 古いコミット(10000件以前)を削除する
###############################################################################
commit_date=$(git log --skip=10000 -1 --format=%ct)
echo "commit_date: $commit_date";

commit_callback=$(cat <<EOF
    if int(commit.committer_date.decode('utf-8').split()[0]) < $commit_date:
        commit.skip()
EOF
)

echo "commit_callback: $commit_callback"

# git filter-repo --force  --commit-callback "$commit_callback" # コメント外してね

###############################################################################
# 圧縮する
###############################################################################
# git gc --aggressive --prune=now # コメント外してね
# git reflog expire --expire=now --all # コメント外してね