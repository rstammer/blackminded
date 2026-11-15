# traveller — live version
#
# The stage arrangement, as opposed to the play-alongs next door. Two things
# make it different from those:
#
#   1. live_loop instead of in_thread. An in_thread runs to the end and cannot be
#      replaced while it runs; a live_loop can be redefined mid-flight and keeps
#      the beat across a re-run. Only live_loop is switchable.
#   2. Every voice asks get[:section] at the top of each pass, so switching
#      changes what the next two bars do rather than cutting into the current
#      ones. The music stays in time on its own — which matters when both hands
#      are on the guitar.
#
# Switch from a second terminal, without touching this file:
#
#   bin/play -e 'set :section, :chorus'
#   bin/play -e 'set :section, :verse'
#
# That works because Sonic Pi's Time State is global to the server, not local to
# a run: a separate one-line run can set a value the running live_loops read.
#
# THE CHORUS IS NOT CONFIRMED. Its | G | Em | comes from the bass-band
# measurement of the recording (NOTES.md, the G-Block at 1:49 and 3:09) and has
# never been checked against Robin. It is here so there is something to switch
# to. The verse is the real one.

use_bpm 132

# Both sections are exactly two bars, so the voices stay aligned no matter when
# a switch lands.
#
# chords: [bass root, voicing, beats, ring, level, brightness]
sections = {
  verse: {
    chords: [
      [:c2, [:e4, :g4, :b4, :d5], 2, 0.65, 0.34, 110],
      [:a1, [:c4, :e4, :g4, :b4], 2, 0.65, 0.34, 110],
      [:e1, [:e2, :b2, :e3, :g3, :b3, :e4], 4, 3.6, 0.17, 82]
    ],
    bass_at: [
      0, nil, nil, 0, nil, nil, nil, nil,
      0, nil, nil, nil, nil, 12, nil, nil,
      0, nil, nil, 0, nil, nil, nil, nil,
      0, nil, nil, nil, nil, 3, nil, 7
    ],
    comp_at: [3, 6, 14, 16],
    kick_at: [0, 6, 10, 16, 19, 26],
    snare_at: [4, 12, 20, 28],
    ghost_at: [7, 10, 15, 23, 26, 31],
    open_at: [14, 30]
  },
  chorus: {
    chords: [
      [:g1, [:g2, :b2, :d3, :g3, :b3, :g4], 4, 3.4, 0.3, 100],
      [:e1, [:e2, :b2, :e3, :g3, :b3, :e4], 4, 3.4, 0.3, 100]
    ],
    bass_at: [
      0, nil, nil, nil, 0, nil, nil, nil, 0, nil, nil, nil, 0, nil, 7, nil,
      0, nil, nil, nil, 0, nil, nil, nil, 0, nil, nil, nil, 0, nil, 10, nil
    ],
    comp_at: [0, 8, 16, 24],
    kick_at: [0, 8, 16, 24],
    snare_at: [4, 12, 20, 28],
    ghost_at: [],
    open_at: [12, 28]
  }
}

set :section, :verse

# Expands a section's chord list into one entry per sixteenth, so every voice can
# index the same 32-slot grid.
grid_for = lambda do |part|
  out = []
  part[:chords].each do |root, notes, beats, ring_len, lvl, bright|
    (beats * 4).times { out << [root, notes, ring_len, lvl, bright] }
  end
  out
end

live_loop :clock do
  cue :bar
  sleep 8
end

live_loop :drums, sync: :bar do
  part = sections[get[:section]]
  32.times do |slot|
    sample :drum_bass_hard, amp: 0.95 if part[:kick_at].include?(slot)
    sample :drum_snare_hard, amp: 0.8 if part[:snare_at].include?(slot)
    sample :drum_snare_soft, amp: 0.16 if part[:ghost_at].include?(slot)
    if part[:open_at].include?(slot)
      sample :drum_cymbal_open, amp: 0.18, sustain: 0.08, release: 0.15
    else
      sample :drum_cymbal_closed, amp: (slot % 4 == 0) ? 0.34 : 0.14
    end
    sleep 0.25
  end
end

live_loop :bass, sync: :bar do
  part = sections[get[:section]]
  gr = grid_for.call(part)
  use_synth :fm
  32.times do |slot|
    offset = part[:bass_at][slot]
    unless offset.nil?
      play note(gr[slot][0]) + offset,
        release: 0.55, amp: 1.15, divisor: 0.6, depth: 1.3
    end
    sleep 0.25
  end
end

live_loop :comp, sync: :bar do
  part = sections[get[:section]]
  gr = grid_for.call(part)
  use_synth :pluck
  with_fx :reverb, room: 0.6, mix: 0.3 do
    32.times do |slot|
      if part[:comp_at].include?(slot)
        notes = gr[slot][1]
        strum_span = 0.05
        step = strum_span / (notes.length - 1)
        notes.each_with_index do |n, i|
          play n, amp: gr[slot][3], coef: 0.38,
            release: gr[slot][2], cutoff: gr[slot][4]
          sleep step if i < notes.length - 1
        end
        sleep 0.25 - strum_span
      else
        sleep 0.25
      end
    end
  end
end

live_loop :keys, sync: :bar do
  part = sections[get[:section]]
  use_synth :fm
  with_fx :reverb, room: 0.85, mix: 0.45 do
    part[:chords].each do |_root, notes, beats, ring_len, _lvl, _bright|
      play notes,
        attack: 0.3, release: [beats * 0.95, ring_len].max, amp: 0.26,
        divisor: 2.0, depth: 1.0
      sleep beats
    end
  end
end
