# traveller — verse play-along: sparse
#
# Same progression, all the density taken out: no distortion, no eighth-note
# rhythm guitar, drums only on the strong beats. Chords are arpeggiated instead
# of sustained, so the harmony is stated rather than filled in.
#
# For finding melodies over — a vocal line or a slow solo has room here.

use_bpm 132

verse = [
  [:c3, chord(:c4, :major), 2],
  [:a2, chord(:a3, :minor), 2],
  [:e2, chord(:e3, :minor), 4]
]

in_thread(name: :drums) do
  sync :verse
  loop do
    8.times do |beat|
      sample :drum_bass_hard, amp: 0.9 if beat % 4 == 0
      sample :drum_snare_soft, amp: 0.7 if beat % 4 == 2
      sample :drum_cymbal_closed, amp: 0.25 if beat.odd?
      sleep 1
    end
  end
end

in_thread(name: :bass) do
  sync :verse
  use_synth :fm
  loop do
    verse.each do |root, _chord, beats|
      play root, release: beats * 0.8, amp: 1.1, divisor: 0.8
      sleep beats
    end
  end
end

in_thread(name: :arpeggio) do
  sync :verse
  use_synth :pluck
  with_fx :reverb, room: 0.85, mix: 0.5 do
    loop do
      verse.each do |_root, notes, beats|
        ring_of = notes.to_a
        (beats * 2).times do |i|
          play ring_of[i % ring_of.length], amp: 0.7, coef: 0.3
          sleep 0.5
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
