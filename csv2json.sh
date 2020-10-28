#!/bin/sh
################################################################################
# 必須コマンド： jq
#
# 想定するcsv
# 1行目：keys
# 2~行目：values
#----
#id,name
#111,hoge
#222,fuga
#----
#
# 使用例
# $ cat data.csv | ./csv2json.sh
#[{"id":"111","name":"hoge"},{"id":"222","name":"fuga"}]
#
# デバッグTips
# 最後の行をコメントアウトしていくと、見やすい
################################################################################

if [ -p /dev/stdin ]; then
  cat -
else
  cat $@
fi \
  | jq --slurp --raw-input 'split("\n")' \
  | jq --compact-output '.[] | select(length > 0) | split(",")' \
  | jq --slurp --sort-keys --compact-output '.[0] as $keys | .[1:] | map([$keys, .] | transpose | map({"key": (.[0]//""), "value": (.[1]//"")}) | from_entries)'
