# blackminded

A new dawn in a new era. Tribute to blackminded themes. Persisting the music in
a digital world and set the foundation for something new.

Die Songs der Band blackminded, digital festgehalten: als Texte, Noten, Akkorde,
Tabs und Skripte, dazu alles, was sich über sie herausfinden lässt.

## Die Band

blackminded waren **Robin** (Gitarre, Gesang), **Basti** (Bass) und **Andi**
(Schlagzeug) aus Perleberg in der Prignitz. Die drei Freunde fingen 2003 ohne
Erfahrung mit Gitarre, Stick und Rockzirkus an zu experimentieren und fanden mit
der Zeit ihren eigenen Stil: alternative Rockmusik mit intensiven Riffs und
grungigen Sounds.

- **19.09.2003** — erster Auftritt im KlimBim in Wittenberge, mit Nexus und Trivial.
- **2004 und 2005** — zweimal Publikumssieger beim Bandcontest *Prignitz Rockt*
  in der Bänghalle Perleberg, 2004 außerdem Sieger des SOS-Talente-Festivals in
  Wittenberge.
- **2005–2007** — Konzerte in der ganzen Prignitz und darüber hinaus, von
  Parchim und Neuruppin bis St. Peter-Ording, auf Open Airs wie Rock im Moor,
  Kuhstock und Krankenschwesterrock(t).
- **11.03.2007** — die EP **„Patches In The Sky“** erscheint: when clouds are
  hangin', tedium fever & the nxp, giving in, scared of your view, rs:jp.
- **2013** — nach zehn Jahren zwei Abschlusskonzerte: Krankenschwesterrock(t) in
  Haaren (10.05.) und Rock im Moor in Boberow (03.08.).

Alle bekannten Auftritte stehen in [`auftritte.csv`](auftritte.csv). Die alte
Website gibt es noch unter [blackminded.de](https://blackminded.de).

## Songs

| Song | Ordner | Stand |
|---|---|---|
| a destroyed universe | `songs/a_destroyed_universe/` | Text |
| between the lines | `songs/between_the_lines/` | Text, Tabs |
| d-tune | `songs/d_tune/` | nur von einer Setlist bekannt |
| dallairium | `songs/dallairium/` | Text |
| free will and farewell | `songs/free_will_and_farewell/` | Text |
| fwd, fwd! | `songs/fwd_fwd/` | Text (unvollständig), Form, Refrain-Tab |
| giving in | `songs/giving_in/` | Text |
| pink-glassed prison | `songs/pink_glassed_prison/` | Text, Tabs |
| pretend | `songs/pretend/` | Text, Tabs |
| rotor | `songs/rotor/` | Text |
| rs:jp | `songs/rs_jp/` | Text, Sonic-Pi-Fassung von 2015 (`original_2015.rb`) |
| scared of your view | `songs/scared_of_your_view/` | Text |
| senseless to cry | `songs/senseless_to_cry/` | Text, Tabs |
| tedium fever and the nxp | `songs/tedium_fever_and_the_nxp/` | Text |
| traveller | `songs/traveller/` | Text, Messwerte (132 BPM, e-Moll, `\| C Am \| Em \|`), Play-Along der Strophe in fünf Varianten |
| when clouds are hangin' | `songs/when_clouds_are_hangin/` | Text |
| zero | `songs/zero/` | Text |

Titel so, wie die Band sie geschrieben hat. Texte und Tabs stammen von
blackminded.de und der alten Website, unverändert.

## Abspielen

Sonic Pi ist das Hilfsmittel, mit dem festgehaltene Akkorde, Riffs und Formen
hörbar werden. Gebraucht wird nur Sonic Pi 5 und Ruby:

```bash
brew install --cask sonic-pi
```

Abgespielt wird über `bin/play`, ein Skript im Repo, das direkt mit Sonic Pis
OSC-Server spricht. **Die Sonic-Pi-App muss laufen**, sie bringt den Server mit.
Geschrieben wird im eigenen Editor, nicht in der Sonic-Pi-IDE.

```bash
open -a "Sonic Pi"

bin/play songs/rs_jp/song.rb     # abspielen
bin/play --stop                  # alles stoppen
bin/play --status                # läuft der Server?
```

## Struktur

```
songs/<song>/     ein Ordner je Song, alle gleich aufgebaut:
                  NOTES.md, lyrics.md, chords.md, tabs.md, recordings/, sonic_pi/
lib/              Gemeinsames: Drumkits, Synth-Presets, Helfer
bin/              Wrapper zum Abspielen
auftritte.csv     Alle Auftritte von blackminded, wird nach und nach ergänzt
```

Aufnahmen (WAV, MP3 und Co.) liegen nicht im Repo, sie sind zu groß.
