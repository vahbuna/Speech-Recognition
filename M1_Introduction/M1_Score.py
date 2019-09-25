import argparse
import wer

# create a function that calls wer.string_edit_distance() on every utterance
# and accumulates the errors for the corpus. Then, report the word error rate (WER)
# and the sentence error rate (SER). The WER should include the the total errors as well as the
# separately reporting the percentage of insertions, deletions and substitutions.
# The function signature is
# num_tokens, num_errors, num_deletions, num_insertions, num_substitutions = wer.string_edit_distance(ref=reference_string, hyp=hypothesis_string)
#
def score(ref_trn=None, hyp_trn=None):
    if ref_trn is None or hyp_trn is None:
        RuntimeError("ref_trn and hyp_trn are required, cannot be None")
    sentences = 0
    error_sentences = 0
    ref_words = 0
    word_errors = 0
    total_subs = 0
    total_ins = 0
    total_dels = 0
    with open(ref_trn) as ref, open(hyp_trn) as hyp:
        for line_ref, line_hyp in zip(ref, hyp):
            sentences += 1
            ref, _ = line_ref.split("(")
            hyp, _ = line_hyp.split("(")
            tokens, edits, dels, ins, subs = wer.string_edit_distance(ref.split(), hyp.split())
            ref_words += tokens
            word_errors += edits
            total_subs += subs
            total_ins += ins
            total_dels += dels
            if edits > 0:
                error_sentences += 1
    print("Reference sentences:",sentences)
    print("Number of sentences with an error", error_sentences)
    print("Sentence error rate:", error_sentences * 100.0 / sentences)
    print("Total number of reference words:", ref_words)
    print("Total number of word errors:", word_errors)
    print("Substitutions:",total_subs,"Insertions:",total_ins,"Deletions:",total_dels)
    print("WER:", word_errors *100.0/ref_words, "Substitutions %:", total_subs * 100.0 / ref_words,
            "Insertions %:", total_ins * 100.0 / ref_words, "Deletions %:", total_dels * 100.0 / ref_words)
    return


if __name__=='__main__':
    parser = argparse.ArgumentParser(description="Evaluate ASR results.\n"
                                                 "Computes Word Error Rate and Sentence Error Rate")
    parser.add_argument('-ht', '--hyptrn', help='Hypothesized transcripts in TRN format', required=True, default=None)
    parser.add_argument('-rt', '--reftrn', help='Reference transcripts in TRN format', required=True, default=None)
    args = parser.parse_args()

    if args.reftrn is None or args.hyptrn is None:
        RuntimeError("Must specify reference trn and hypothesis trn files.")

    score(ref_trn=args.reftrn, hyp_trn=args.hyptrn)
