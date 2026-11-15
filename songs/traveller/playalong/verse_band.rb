# traveller — verse play-along: band
#
# A bed to solo over: the verse progression on repeat, nothing else yet. This is
# not the arrangement — the full form is sketched in NOTES.md and still needs the
# blocks assigned to verse, chorus and bridge.
#
# 132 BPM and E minor are measured from original_recording.wav. The progression
# C - A minor - E minor comes from playing it on the guitar. The two agree: the bass
# band of the recording reads C and A for two beats each, then a whole bar of E.
#
# use_bpm has to sit above the in_thread blocks: it is thread-local, and threads
# inherit it from the parent at the moment they are created.

use_bpm 132

# One pass is two bars: [bass root, chord, beats]
verse = [
  [:c3, chord(:c4, :major), 2],
  [:a2, chord(:a3, :minor), 2],
  [:e2, chord(:e3, :minor), 4]
]

in_thread(name: :drums) do
  sync :verse
  loop do
    8.times do |beat|
      sample :drum_cymbal_closed, amp: 0.6
      sample :drum_bass_hard, amp: 1.3 if beat.even?
      sample :drum_snare_hard, amp: 1.0 if beat.odd?
      sleep 0.5
      sample :drum_cymbal_closed, amp: 0.4
      sleep 0.5
    end
  end
end

in_thread(name: :bass) do
  sync :verse
  use_synth :fm
  loop do
    verse.each do |root, _chord, beats|
      beats.times do
        play root, release: 0.9, amp: 1.4, divisor: 1.2
        sleep 1
      end
    end
  end
end

# Power chords on eighths — the rhythm guitar's job, so the bed carries on its
# own when nobody plays along.
in_thread(name: :rhythm) do
  sync :verse
  use_synth :pulse
  with_fx :distortion, distort: 0.55 do
    with_fx :level, amp: 0.3 do
      loop do
        verse.each do |root, _chord, beats|
          (beats * 2).times do
            play [note(root) + 12, note(root) + 19], release: 0.45
            sleep 0.5
          end
        end
      end
    end
  end
end

# Sustained chords underneath, kept quiet and low-passed so the midrange stays
# free for a solo.
in_thread(name: :pad) do
  sync :verse
  use_synth :hollow
  with_fx :reverb, room: 0.8, mix: 0.4 do
    loop do
      verse.each do |_root, notes, beats|
        play notes, attack: 0.25, release: beats, amp: 0.4, cutoff: 85
        sleep beats
      end
    end
  end
end

# Defined last so every voice above already exists when the cue fires. Four
# clicks lead in.
in_thread(name: :clock) do
  4.times do
    sample :drum_cymbal_closed, amp: 0.8
    sleep 1
  end
  cue :verse
  loop { sleep 8 }
end
