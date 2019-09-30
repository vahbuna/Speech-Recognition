# Module 4 Lab

## Language Modeling

Preparing the data

We will be using the transcripts of the acoustic development and test data as our dev and test sets for language modeling.

TASK: Locate files in the ‘data’ subdirectory and count the number of lines and words in them.

TASK: View the contents of these files, using your favorite pager, editor, or other tool. What do you notice about the format of these files? How do they differ from text you are used to?

TASK: Inspect the file and count lines and word tokens. How does the text normalization of this file differ from our test data?

OPTIONAL TASK: Download the raw training data at http://www.openslr.org/12/librispeech-lm-corpus.tgz, and compare it to the normalized text. How would you perform TN for this data?

Defining a vocabulary

The first step in building a LM is to define the set of words that it should model. We want to cover the largest possible share of the word tokens with the smallest set of words, so as to keep model size to a minimum. That suggests picking the words that are most frequent based on the training data.

One of the functions of the ngram-count tool is to count word and ngram occurrences in a text file.

TASK: Extract the list of the 10,000 most frequent word types in the training data. What kinds of words do you expect to be at the top of the list? Check your intuition.

TASK: What is the rate of out-of-vocabulary (OOV) words on the training, dev and test sets? 

OPTIONAL TASK: Repeat the steps above for different vocabulary sizes (5k, 20k, 50k, 100k, 200k). Plot the OOV rate as a function of vocabulary size. What shape do you see?

Training a model

We are now ready to build a language model from the training data and the chosen vocabulary. This is also done using the ngram-count command. For instructional purpose we will do this in two steps: compute the N-gram statistics (counts), and then estimate the model parameters. (ngram-count can do both in one step, but that’s not helpful to understand what happens under the hood.)

TASK: Generate a file containing counts of all trigrams from the training data. Inspect the resulting file

TASK: Estimate a backoff trigram LM from librispeech.3grams.gz, using the Witten-Bell smoothing method.


Model evaluation

Consult the description of the backoff LM file format ngram-format(5), and compare to what you see in our model file, to be used in the next task.

TASK: Given the sentence "a model was born", what is the conditional probability of "born"?

TASK: Compute the total sentence probability of "a model was born" using the ngram -ppl function. Verify that the conditional probability for "born" is as computed above.

TASK: Compute the perplexity of the model over the entire dev set.

TASK: Vary the size of the training data and observe the effect this has on model size and quality (perplexity).

Model adaptation

We will now work through the steps involved in adapting an existing LM to a new application domain. In this scenario we typically have a small amount of training data for the new, target domain, but a large amount, albeit mismatched data from other sources. For this exercise we target the AMI domain of multi-person meetings as our target domain. The language in this are spontaneous utterances from face-to-face interactions, whereas the "librispeech" data we used so far consisted of read books, a dramatic mismatch in speaking styles and topics.

TASK: Build the same kind of Witten-Bell-smoothed trigram model as before, using the provide AMI training data and vocabulary. Evaluate its perplexity on the AMI dev data.

TASK: Evaluate the previously built librispeech model on the AMI dev set.

TASK: Construct an interpolated model based on the existing librispeech and AMI models, giving weight 0.8 to the AMI model, and evaluate it on the dev set.

TASK (optional): Repeat this process for different interpolation weights, and see if you can reduce perplexity further. Check results on both AMI dev and test sets.

Model pruning

We saw earlier that model size (and perplexity) varies with the amount of training data. However, if a model gets too big for deployment as the data size increases it would be a shame to have to not use it just for that reason. A better approach is to train a model on all available data, and then eliminate parameters that are redundant or have little effect on model performance. This is what model pruning does.

A widely used algorithm for model pruning based on entropy is implemented in the ngram tool. The option -prune takes a small value, such as 10-8 or 10-9, and remove all ngrams from the model that (by themselves) raise the perplexity of the model less than that value in relative terms.

TASK: Shrink the large librispeech model trained earlier, using pruning values between 10-5 and 10-10 (stepping by powers of ten). Observe/plot the resulting model sizes and perplexities, and compare to the original model.

