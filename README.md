<p align="center"><i>
  Kaldi-ASR  Advanced Project <br/>
  T-718-ATSR - Automatic Speech Recognition, TD-MSc, 2019-1 <br/>
  Reykjavik University - School of Computer Science, Menntavegur 1, IS-101 Reykjavik, Iceland
</i></p>

## Table of Contents
<!-- ⛔️ MD-MAGIC-EXAMPLE:START (TOC:collapse=true&collapseText=Click to expand) -->
<details>
<summary>Click to expand</summary>

1. [Introduction](#1-introduction)
2. [The Dataset](#2-the-dataset)
3. [The Adjustments](#3-the-adjustments)
    * [run.sh](#31-run.sh)
    * [create_yesno_txt.pl](#32-localcreate_yesno_txtpl)
		* [create_yesno_waves_test_train.pl](#33-localcreate_yesno_txtpl)
		* [prepare_data.sh](#34-localprepare_datash)
		* [mfcc.conf](#35-confmfccconf)
4. [Authors](#5-authors)
5. [License](#6-license)
6. [References](#7-references)

</details>
<!-- ⛔️ MD-MAGIC-EXAMPLE:END -->

## 1 Introduction
A modified version of the [Kaldi-ASR yesno](https://github.com/kaldi-asr/kaldi/tree/master/egs/yesno) example project adjusted for Icelandic, for multiple speakers, and finally, it it uses a phone-based model instead of word based-model.


## 2 The Dataset
Custom yes/no dataset for Icelandic, made from recordings from students and the staff members from the course.

Summary:
* 10 different speakers
* 120 sentences/utterances  
 * Speaker 0: 10 utterances
 * Speaker 1: 7 utterances
 * Speaker 2: 8 utterances
 * Speaker 3: 10 utterances
 * Speaker 4: 10 utterances
 * Speaker 5: 42 utterances
 * Speaker 6: 0 utterances
 * Speaker 7: 10 utterances
 * Speaker 8: 8 utterances
 * Speaker 9: 10 utterances
 * Speaker 10: 5 utterances
* Each utterance consist of 8 words.
* The vocabulary for the words:
 * Já (yes)
 * Nei (no

## 3 The Adjustments

### 3.1 run.sh

Edit following part in the file:

```bash
if [ ! -d waves_yesno ]; then
  wget waves_yesno.tar.gz || exit 1;
  tar -xvzf waves_yesno.tar.gz || exit 1;
fi
```

We have our dataset locally, so we dont have to fetch it from a remote file host.

Remember to re-compile the script.
```bash
$ chmod 777 s5/run.sh
```

### 3.2 [local/create_yesno_txt.pl](s5/local/create_yesno_txt.pl)

Add following code to the while loop:

```perl
    $trans =~ s/SA\d\d-//;
```

This will remove the speaker Id from our filename when creating our data/{X}/text files.


### 3.3 local/create_yesno_waves_test_train.pl

Specify which speakers you want to have in the test set.

```perl
while ($l = <FL>)
{
	chomp($l);
	if (index($l, "SA01") == -1  && index($l, "SA10") == -1)
	{
		print TRAINLIST "$l\n";
	}
	else
	{
		print TESTLIST "$l\n";
	}
}
```

### 3.4 local/prepare_data.sh 

Edit the code so each utterece has it corresponding speaker id istead of global.

```bash
  cat data/$x/text | awk '{printf("%s %s\n", $1, substr($1, 0, 5));}' > data/$x/utt2spk
```

Remember to re-compile the script.
```bash
$ chmod 777 s5/local/prepare_data.sh 
```

### 3.5 conf/mfcc.conf
Set the correct sample-frequency configuration based on the waves_yesno .wav file format.

```bash
--sample-frequency=16000 #  waves_yesno is sampled at 16kHz
```
### 3.6 input/lexicon.txt
For changing the model from a word-based model to a phone-based one, we will need to change the lexicon for our system.

input/lexicon.txt

```txt
<SIL> SIL
YES J A U
NO N E I
```

For simplicity we cept the same labels, but changed the corresponding phonems.


lexicon_nosil.txt

```txt
YES J A U
NO N E I
```

phones.txt

```txt
SIL
A
E
I
J
N
U
```

### Done

Now we should be able to run the run.sh file successfully.

```bash
$ cd s5/
$ bash run.sh
```

Expected output result:

```bash
%WER 11.46 [ 11 / 96, 7 ins, 1 del, 3 sub ] exp/mono0a/decode_test_yesno/wer_14_1.0
```

## 4 Authors
* [Egill Anton Hlöðversson](https://github.com/egillanton) - MSc. Language Technology Student

## 5 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 6 References
* [Kaldi-ASR](http://kaldi-asr.org/)
* [Kaldi-ASR yesno](https://github.com/kaldi-asr/kaldi/tree/master/egs/yesno)

<p align="center">
🌟 PLEASE STAR THIS REPO IF YOU FOUND SOMETHING INTERESTING 🌟
</p>