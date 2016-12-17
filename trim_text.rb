#
# text - The String to be trimmed.
# min - The Integer number of minimum characters in the snippet.
# ideal - The Integer ideal number of characters in the snippet.
# max - The Integer number of maximum characters in the snippet.
#
# Returns a Hash with :snippet and :remaining_txt keys containing the corresponding
#   substrings, OR nil if the text length is less than min or the text contains
#   no breakpoints and is longer than max.

def trim_text(text, min, ideal, max)
  return nil if text.length < min

  terminal_pts = { '.' => 3, '!' => 3, '?' => 3, ';' => 2, ',' => 1, ':' => 1, ' ' => 0 }

  break_idx = nil
  ideal_delta = nil
  current_rank = 0

  (min-1...max).each do |idx|
    if idx == text.length-1
      break_idx = idx if ideal_delta.nil? || current_rank == 0 || (ideal - text.length).abs <= ideal_delta
      break
    end

    rank = terminal_pts[text[idx]]
    next unless rank

    snippet_len = idx + 1
    delta = (ideal - snippet_len).abs

    if ideal_delta.nil? || (rank == current_rank && delta <= ideal_delta) || rank > current_rank
      break_idx = idx
      ideal_delta = delta
      current_rank = rank
    end
  end

  return nil if break_idx.nil?

  result = { snippet: text[0..break_idx], remaining_txt: text[break_idx+1..-1] }
end
