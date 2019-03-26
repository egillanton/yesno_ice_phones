#!/bin/bash

echo
echo "===== RUNNING run.sh ====="
echo

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"

if [ ! -d waves_yesno ]; then
  tar -xf waves_yesno.tar.xz || exit 1;
fi

train_yesno=train_yesno
test_base_name=test_yesno

rm -rf data exp mfcc

echo
echo "===== PREPEARING DATA ====="
echo

local/prepare_data.sh waves_yesno
local/prepare_dict.sh
utils/prepare_lang.sh --position-dependent-phones false data/local/dict "<SIL>" data/local/lang data/lang
local/prepare_lm.sh

echo
echo "===== FEATURE EXTRACTION ====="
echo


for x in train_yesno test_yesno; do 
 steps/make_mfcc.sh --nj 1 data/$x exp/make_mfcc/$x mfcc
 steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x mfcc
 utils/fix_data_dir.sh data/$x
done

echo
echo "===== MONO TRAINING ====="
echo

steps/train_mono.sh --nj 1 --cmd "$train_cmd" \
  --totgauss 400 \
  data/train_yesno data/lang exp/mono0a 
  
# Graph compilation  
echo
echo "===== GRAPH COMPILATION ====="
echo

utils/mkgraph.sh data/lang_test_tg exp/mono0a exp/mono0a/graph_tgpr

echo
echo "===== DECODING ====="
echo

steps/decode.sh --nj 1 --cmd "$decode_cmd" \
    exp/mono0a/graph_tgpr data/test_yesno exp/mono0a/decode_test_yesno

for x in exp/*/decode*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done
