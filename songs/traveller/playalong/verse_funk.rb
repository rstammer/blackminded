# traveller — verse play-along: jazzy funk, thinned out
#
# The chord rhythm is the original one and stays that way: C and A minor for two
# beats each, then a bar of E minor. Stretching it to twice the length was tried
# and killed the song.
#
# What is reduced instead is density. The bass went from fourteen notes per two
# bars to eleven, the comp from ten stabs to six with none on the downbeat, and
# every level came down — the open hi-hat hardest, since that was most of what
# read as aggressive. The drum pattern itself is untouched.
#
# The same three chords, taken up a storey. C and A minor sit in E minor, so
# sevenths and ninths go on top without pulling the harmony anywhere else. The
# bass keeps the roots, the comp drops them and plays the upper structure only —
# that rootless voicing is what makes it read as jazz rather than as a triad
# with a note glued on.
#
# The E minor is the exception: it stays a plain triad, no seventh and no ninth —
# both made it float. It sits an octave below the other two, so the two bars fall
# away at the end rather than lifting. All of that is Robin's call after hearing
# it.
#
# The funk is in the placement, not the notes. Everything runs on a sixteenth
# grid where the hits deliberately avoid the beat: the comp stabs on the "a" of
# one and the "and" of two, the bass leaves holes instead of walking, and the
# snare carries ghost notes between the backbeats.
#
# Still 132 BPM, still the two-bar loop.

use_bpm 132

# [bass root, voicing the comp and keys play, beats]. Written out by hand rather
# than derived, so any single chord can be reshaped without touching the others.
# [bass root, voicing, beats, how long it rings, how loud, how bright]
#
# The E minor is the open guitar shape Robin actually plays: second fret on the
# A and D strings, the rest open, all six strings struck. Three E's and two B's
# across two octaves — the doubling is where the weight comes from, and leaving
# it out was what made the chord fall flat. It also rings far longer than the
# other two instead of being clipped short.
verse = [
  [:c2, [:e4, :g4, :b4, :d5], 2, 0.65, 0.34, 110],          # Cmaj9, root to the bass
  [:a1, [:c4, :e4, :g4, :b4], 2, 0.65, 0.34, 110],          # Am9, root to the bass
  [:e1, [:e2, :b2, :e3, :g3, :b3, :e4], 4, 3.6, 0.17, 82]   # open E minor, six strings
]

# The loop as 32 sixteenths, so every voice can index the same grid and the
# syncopation lines up between them.
grid = []
verse.each do |root, notes, beats, ring_len, amp, cutoff|
  (beats * 4).times { grid << [root, notes, ring_len, amp, cutoff] }
end

# Offsets in semitones from the chord root; nil is a rest. The gaps are the
# point — a funk bass is mostly silence.
bass_pattern = [
  0, nil, nil, 0, nil, nil, nil, nil,
  0, nil, nil, nil, nil, 12, nil, nil,
  0, nil, nil, 0, nil, nil, nil, nil,
  0, nil, nil, nil, nil, 3, nil, 7
]

# Slots 0-7 are the C, 8-15 the A minor, 16-31 the E minor. The E minor gets a
# single strike on its downbeat and is then left alone to ring — repeating it
# turned the one chord that should hang in the air into staccato.
comp_hits = [3, 6, 14, 16]

kick_hits = [0, 6, 10, 16, 19, 26]
snare_hits = [4, 12, 20, 28]
ghost_hits = [7, 10, 15, 23, 26, 31]
open_hat = [14, 30]

in_thread(name: :drums) do
  sync :verse
  loop do
    32.times do |slot|
      sample :drum_bass_hard, amp: 0.95 if kick_hits.include?(slot)
      sample :drum_snare_hard, amp: 0.8 if snare_hits.include?(slot)
      sample :drum_snare_soft, amp: 0.16 if ghost_hits.include?(slot)
      if open_hat.include?(slot)
        sample :drum_cymbal_open, amp: 0.18, sustain: 0.08, release: 0.15
      else
        sample :drum_cymbal_closed, amp: (slot % 4 == 0) ? 0.34 : 0.14
      end
      sleep 0.25
    end
  end
end

in_thread(name: :bass) do
  sync :verse
  use_synth :fm
  loop do
    32.times do |slot|
      offset = bass_pattern[slot]
      unless offset.nil?
        play note(grid[slot][0]) + offset,
          release: 0.55, amp: 1.15, divisor: 0.6, depth: 1.3
      end
      sleep 0.25
    end
  end
end

# Short muted stabs — a clean funk guitar rather than a sustained chord.
in_thread(name: :comp) do
  sync :verse
  use_synth :pluck
  with_fx :reverb, room: 0.4, mix: 0.2 do
    loop do
      32.times do |slot|
        if comp_hits.include?(slot)
          notes = grid[slot][1]
          # Spread the notes across a fraction of the step, then take that time
          # back out of the sleep, so strumming costs nothing on the grid.
          #
          # Not named "spread" or "ring": Sonic Pi refuses to run a buffer that
          # uses a built-in function name as a variable, and both of those are
          # built-ins.
          strum_span = 0.05
          step = strum_span / (notes.length - 1)
          notes.each_with_index do |n, i|
            play n, amp: grid[slot][3], coef: 0.38,
              release: grid[slot][2], cutoff: grid[slot][4]
            sleep step if i < notes.length - 1
          end
          sleep 0.25 - strum_span
        else
          sleep 0.25
        end
      end
    end
  end
end

# Electric-piano-ish pad holding the harmony together underneath. FM is what a
# Rhodes is built from, so :fm with a low divisor lands close enough.
in_thread(name: :keys) do
  sync :verse
  use_synth :fm
  with_fx :reverb, room: 0.7, mix: 0.35 do
    loop do
      verse.each do |_root, notes, beats|
        play notes,
          attack: 0.3, release: beats * 0.95, amp: 0.26,
          divisor: 2.0, depth: 1.2
        sleep beats
      end
    end
  end
end

in_thread(name: :clock) do
  4.times do
    sample :drum_cymbal_closed, amp: 0.8
    sleep 1
  end
  cue :verse
  loop { sleep 8 }
end
