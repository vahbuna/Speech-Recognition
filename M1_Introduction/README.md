# Module 1 Lab

## Lab for Module 1: Create a speech recognition scoring program

### Required files:

* `wer.py`
* `M1_Score.py`

## Instructions:

In this lab, you will write a program in Python to compute the word error rate (WER) and sentence error rate (SER) for a test corpus.
A set of hypothesized transcriptions from a speech recognition system and a set of reference transcriptions with the correct word sequences will be provided for you.

This lab assumes the transcriptions are in a format called the "trn" format, created by NIST.
The format is as follows.
The transcription is output on a single line followed by a single space and then the root name of the file, without any extension, in parentheses.
For example, the audio file "tongue_twister.wav" would have a transcription

sally sells seashells by the seashore (tongue_twister)

Notice that the transcription does not have any punctuation or capitalization, nor any other formatting (e.g. converting "doctor" to "dr.", or "eight" to "8").
This formatting is called "Inverse Text Normalization" and is not part of this course.

The python code **M1_Score.py** and **wer.py** contain the scaffolding for the first lab.
A main function parses the command line arguments and **string_edit_distance()** computes the string edit distance between two strings.

Add code to read the trn files for the hypothesis and reference transcriptions, to compute the edit distance on each, and to aggregate the error counts. Your code should report:

* Total number of reference sentences in the test set
* Number of sentences with an error
* Sentence error rate as a percentage
* Total number of reference words
* Total number of word errors
* Total number of word substitutions, insertions, and deletions
* The percentage of total errors (WER) and percentage of substitutions, insertions, and deletions

The specific format for outputting this information is up to you.
Note that you should not assume that the order of sentences in the reference and hypothesis trn files is consistent.
You should use the utterance name as the key between the two transcriptions.

When you believe your code is working, use it to process **hyp.trn** and **ref.trn** in the misc directory, and compare your answers to the solution.
