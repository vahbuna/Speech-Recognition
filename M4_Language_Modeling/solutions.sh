#!/bin/bash

wc -wl data/dev.txt data/test.txt

# Defining a vocabulary

ngram-count -text ~/librispeech-lm-norm.txt.gz -order 1 -write ~/librispeech.1grams -tolower
sort -k 2,2 -n -r ~/librispeech.1grams | head -10000 > ~/librispeech.top10k.1grams
cut -f 1 ~/librispeech.top10k.1grams | sort > ~/librispeech.top10k.vocab

ngram-count -text data/dev.txt -order 1 -write ~/dev.1grams
compute-oov-rate ~/librispeech.top10k.vocab ~/dev.1grams
ngram-count -text data/test.txt -order 1 -write ~/test.1grams
compute-oov-rate ~/librispeech.top10k.vocab ~/test.1grams

sort -k 2,2 -n -r ~/librispeech.1grams | head -5000 | cut -f 1 |sort > ~/librispeech.top5k.vocab
compute-oov-rate ~/librispeech.top5k.vocab ~/test.1grams
sort -k 2,2 -n -r ~/librispeech.1grams | head -20000 | cut -f 1 |sort > ~/librispeech.top20k.vocab
compute-oov-rate ~/librispeech.top5k.vocab ~/test.1grams
sort -k 2,2 -n -r ~/librispeech.1grams | head -50000 | cut -f 1 |sort > ~/librispeech.top50k.vocab
compute-oov-rate ~/librispeech.top5k.vocab ~/test.1grams
sort -k 2,2 -n -r ~/librispeech.1grams | head -100000 | cut -f 1 |sort > ~/librispeech.top100k.vocab
compute-oov-rate ~/librispeech.top5k.vocab ~/test.1grams
sort -k 2,2 -n -r ~/librispeech.1grams | head -200000 | cut -f 1 |sort > ~/librispeech.top200k.vocab
compute-oov-rate ~/librispeech.top5k.vocab ~/test.1grams

# Training a model
ngram-count -text ~/librispeech-lm-norm.txt.gz -order 3 -write ~/librispeech.3grams -tolower

ngram-count -debug 1 -order 3 -vocab ~/librispeech.top10k.vocab -read ~/librispeech.3grams -wbdiscount -lm ~/librispeech.3bo.gz

# Model evaluation
zgrep " model was born" ~/librispeech.3bo.gz
# The first number is the log probability P(was | model)
# The number at the end is the backoff weight associated with the context "model was"
zgrep -E "\smodel was" ~/librispeech.3bo.gz | head -1

# The first number is the bigram probability P(born | was)
zgrep -E "\swas born" ~/librispeech.3bo.gz | head -1
# We can now compute the log probability for P(born | model was) as the sum of the backoff weight and the bigram probability
# 0.02913048 + -2.597636 = -2.568506, or as a linear probability 10^-2.568506 = 0.002700813

ngram -debug 2 -lm ~/librispeech.3bo.gz -ppl /dev/stdout 
# write “a model was born”

ngram -lm ~/librispeech.3bo.gz -ppl data/dev.txt
# perplexity of about 113
# OOV rate is 625/10841 = 5.8%

# Model adaptation
ngram-count -text data/ami-train.txt -tolower -order 3 -write ~/ami.3grams.gz
ngram-count -debug 1 -order 3 -vocab data/ami-train.min3.vocab -read ~/ami.3grams.gz -wbdiscount -lm ~/ami.3bo.gz
ngram -lm ~/ami.3bo.gz -ppl data/ami-dev.txt

ngram -debug 1 -order 3 -lm ~/ami.3bo.gz -lambda 0.8 -mix-lm ~/librispeech.3bo.gz -write-lm ~/ami+librispeech.bo.gz
ngram -lm ~/ami+librispeech.bo.gz -ppl data/ami-dev.txt
#  -limit-vocab option tells ngram to only use the vocabulary specified by the -vocab option argument.
ngram -debug 1 -order 3 -lm ~/ami.3bo.gz -lambda 0.8 -mix-lm ~/librispeech.3bo.gz -write-lm ~/ami+librispeech.bo.gz -vocab data/ami-train.min3.vocab -limit-vocab
ngram -lm ~/ami+librispeech.bo.gz -ppl data/ami-dev.txt

# Model pruning
ngram -debug 1 -lm ~/librispeech.3bo.gz -prune 1e-5 -write-lm ~/librispeech-pruned.3bo.gz
ngram -lm ~/librispeech-pruned.3bo.gz -ppl data/ami-dev.txt
