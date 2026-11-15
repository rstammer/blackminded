# traveller — verse play-along: machine
#
# The one that stops pretending to be a band. Same three chords, but an
# electronic kit, a sixteenth-note filtered bassline and the chords as short
# stabs instead of a wash.
#
# The furthest of the five from the original: Sonic Pi is allowed to sound
# electronic, and the guitar over the top keeps the song recognisable.

use_bpm 132

verse = [
  [:c2, chord(:c4, :major), 2],
  [:a1, chord(:a3, :minor), 2],
  [:e1, chord(:e3, :minor), 4]
]

in_thread(name: :drums) do
  sync :verse
  loop do
    8.times do |beat|
      4.times do |sixteenth|
        sample :bd_tek, amp: 1.4 if sixteenth == 0
        sample :elec_hi_snare, amp: 0.9 if beat.odd? && sixteenth == 0
        sample :drum_cymbal_closed, amp: (sixteenth.even? ? 0.35 : 0.18)
        sleep 0.25
      end
    end
  end
end

in_thread(name: :bass) do
  sync :verse
  use_synth :tb303
  with_fx :lpf, cutoff: 100 do
    loop do
      verse.each do |root, _chord, beats|
        (beats * 4).times do |i|
          play((i % 4 == 2) ? note(root) + 12 : root,
            release: 0.2, cutoff: 70 + (i % 8) * 6, res: 0.8, amp: 1.2)
          sleep 0.25
        end
      end
    end
  end
end

in_thread(name: :stabs) do
  sync :verse
  use_synth :prophet
  with_fx :reverb, room: 0.6, mix: 0.3 do
    loop do
      verse.each do |_root, notes, beats|
        beats.times do |i|
          play notes, release: 0.15, attack: 0.01, amp: (i.zero? ? 0.55 : 0.3), cutoff: 95
          sleep 1
        end
      end
    end
  end
end

in_thread(name: :clock) do
  4.times do
    sample :elec_blip, amp: 0.8
    sleep 1
  end
  cue :verse
  loop { sleep 8 }
end
