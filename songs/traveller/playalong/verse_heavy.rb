# traveller — verse play-along: half-time
#
# The harmony keeps its two-bar cycle, but the drums drop to half time: kick on
# one, snare on three, nothing in between. The chords stop moving underneath a
# beat that suddenly does, which makes the same progression feel twice as slow
# and twice as heavy.
#
# Bass drops an octave and the power chords get pushed harder.

use_bpm 132

verse = [
  [:c2, chord(:c3, :major), 2],
  [:a1, chord(:a2, :minor), 2],
  [:e1, chord(:e2, :minor), 4]
]

in_thread(name: :drums) do
  sync :verse
  loop do
    8.times do |beat|
      sample :bd_haus, amp: 1.2 if beat % 8 == 0
      sample :drum_snare_hard, amp: 1.0 if beat % 8 == 4
      sample :drum_cymbal_closed, amp: 0.3 if beat % 2 == 0
      sample :drum_cymbal_hard, amp: 0.5 if beat % 8 == 0
      sleep 1
    end
  end
end

in_thread(name: :bass) do
  sync :verse
  use_synth :fm
  with_fx :distortion, distort: 0.3 do
    loop do
      verse.each do |root, _chord, beats|
        beats.times do
          play root, release: 0.95, amp: 1.1, divisor: 1.5
          sleep 1
        end
      end
    end
  end
end

# Whole-bar power chords instead of eighths — they ring out rather than chug.
in_thread(name: :rhythm) do
  sync :verse
  use_synth :dsaw
  with_fx :distortion, distort: 0.75 do
    with_fx :level, amp: 0.28 do
      loop do
        verse.each do |root, _chord, beats|
          play [note(root) + 12, note(root) + 19], release: beats, attack: 0.02, detune: 0.15
          sleep beats
        end
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
