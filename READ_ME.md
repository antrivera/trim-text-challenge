# Trim Text

A function that takes a string of text, and parameters for minimum length, ideal length, and maximum length, and returns two strings: the generated snippet and the rest of the string after the clip.

## How To Use

Navigate to the project directory and open up a Ruby shell (such as irb or pry).  Then load the `trim_text.rb` file from within the REPL:

```
  pry(main)> require_relative 'trim_text'
```

Call the method by passing in parameters as follows:

```
  pry(main)> text = "What I highly recommend is creating hobbies together and exploring new things together. When life becomes dull and has become a stalemate routine then this affects communication. Take a trip to the theaters for example. After the move people usually proceed to have a discussion about it afterwords. Couples need to have new experiences and constantly push themselves out of that same day to day routine, or else that routine will slowly kill the relationship one step at a time."
  pry(main)> trim_text(text, 80, 100, 200)
=> {:snippet=>
  "What I highly recommend is creating hobbies together and exploring new things together.",
 :remaining_txt=>
  " When life becomes dull and has become a stalemate routine then this affects communication. Take a trip to the theaters for example. After the move people usually proceed to have a discussion about it afterwords. Couples need to have new experiences and constantly push themselves out of that same day to day routine, or else that routine will slowly kill the relationship one step at a time."}

```

## Implementation Details

The method breaks the input text string at the main terminal points of a sentence, which are stored in a hash.

```Ruby
terminal_pts = { '.' => 3, '!' => 3, '?' => 3, ';' => 2, ',' => 1, ':' => 1, ' ' => 0 }

```

These terminal point strings map to integer "rankings" corresponding to the strength of the given terminal point. For example: periods, exclamation marks, and question marks are the definitive ending points in a sentence, so they each map to the highest rank possible (3).  Likewise, whitespace may serve as a breaking point if there is no other punctuation in the text string, since it is better than cutting off the string in the middle of a word.  Since whitespace should be used as a breaking point only when no other punctuation is present, it is assigned the lowest rank (0).

Beginning from the index of the text string corresponding to the minimum length parameter, and until the index corresponding to the maximum length parameter, we examine each character of the string searching for break points resulting in a snippet that is closest to the ideal length parameter.

Along the way, we use three variables to keep track of the best break point encountered thus far:

```Ruby
  break_idx = nil
  ideal_delta = nil
  current_rank = 0
```
The `break_idx` variable stores the index of the best break point encountered so far, `ideal_delta` stores the distance from the ideal length parameter to the break_idx, and `current_rank` keeps track of the rank of the terminal point at break_idx (the highest ranking terminal point encountered thus far).

These variables are updated whenever we:

(a.) Encounter a terminal point with a higher ranking than our current_rank (For example, encountering a period when the previous break point was a comma or whitespace).

*note:*  This is done to achieve a snippet that forms as complete of a sentence as possible, which I believe should be a priority, especially when reading the snippet over voice.  Therefore, even if a whitespace terminal point is closer to the ideal length, if a period or other punctuation is present then the snippet will break on the punctuation instead.      

(b.) Encounter a terminal point of the same rank that is closer to the ideal length than that of our previous break_idx.

Once we have reached the index corresponding to the maximum length parameter or the end of the text string, we are left with our final break_idx.

The method then returns the two strings in a Hash as follows:

```Ruby
  result = { snippet: text[0..break_idx], remaining_txt: text[break_idx+1..-1] }
```
*note:* The result could also be returned as an array with two elements, but I felt that a hash would be more explicit and not require the programmer to rely on the ordering of the items in an array to determine which element is the snippet and which is the remaining text.

The algorithm runs in linear time.

## Key Edge Cases

Assuming that the method caller passes in valid min, max, and ideal parameters that make sense, most edge cases revolve around the user text string.  

1.) The length of the text string is less than min:

  I have decided to return nil in this scenario, although other actions could be taken as well (e.g. throwing an exception).

2.) The text string has no whitespace or punctuation at all:

  I decided to return nil in this scenario as well, although this may be a good place to use the naive approach of cutting the string mid-word and appending '...' if desired.

3.) The text string length is less than the max length and does not end in punctuation:

  Whenever the full text string is less than the max length, I decided to return the full text if its length is closer to the ideal length than that of the break_idx (which accounts for sentences that end without punctuation), or if there was no punctuation at all in the string up to this point (current_rank == 0).
