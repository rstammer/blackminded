# RS:JP

## Quellen

| Was | Wo |
|---|---|
| Video-Ausschnitt „blackminded – rs:jp" | youtube.com/watch?v=vlxsA0EV5JI — Kanal `blackmindedrobin`. Was genau darauf zu sehen ist, ist hier nicht festgehalten — **nicht** die Originalaufnahme |
| Sonic-Pi-Fassung 2015 (Audio) | soundcloud.com/open_horse_music/blackminded-rsjp-vague-sonic-pi-interpretation-v2 |
| Sonic-Pi-Fassung 2015 (Code) | `original_2015.rb` |
| Songtext | `lyrics.md` (von blackminded.de/texte/rsjp.htm) |
| Original-MP3 | blackminded.de/mp3/disclaimer.php?SONG=rsjp |

## Bestand

`original_2015.rb` — die Sonic-Pi-Fassung von 2015, unverändert übernommen aus
[euruband/sonic-pi-examples](https://github.com/euruband/sonic-pi-examples).
Selbstbeschreibung im Kopf der Datei: *„theme interpretation of a 'conventional'
rock song"*. Aufnahme davon:
SoundCloud „blackminded-rsjp-vague-sonic-pi-interpretation-v2" (open_horse_music).

## Wie die Fassung von 2015 gebaut ist

Zeiteinheit ist `tick = 1.0`. Sonic Pi läuft per Default auf 60 BPM, ein Tick ist
also **eine Sekunde**. `length = 32` Ticks.

### Das Riff (`monolithic_pattern`)

Sechs Blöcke, jeder Ton eine Sechzehntel (`quart = 0.25`), zusammen **16 Ticks**:

| Wdh. | Töne | MIDI | Dauer | klingt nach |
|---|---|---|---|---|
| 4× | `a3, cs4, a4, cs4` | 57, 61, 69, 61 | 4 Ticks | **A** |
| 2× | `ab3, cs4, ab4, cs4` | 56, 61, 68, 61 | 2 Ticks | **Ab** (chromatisch runter) |
| 1× | `ab3, cs4, 66, cs4` | 56, 61, 66, 61 | 1 Tick | Ab mit F♯ oben |
| 1× | `56, cs4, 65, cs4` | 56, 61, 65, 61 | 1 Tick | Ab mit F oben |
| 4× | `57, d3, 66, d3` | 57, 50, 66, 50 | 4 Ticks | **D** (A + F♯ über D) |
| 4× | `54, b2, 66, b2` | 54, 47, 66, 47 | 4 Ticks | **B** (F♯ über B) |

Harmonisch also grob **A → Ab → D → B** — A-Dur / f♯-Moll. Bemerkenswert: in den
ersten vier Blöcken liegt der Pendelton C♯4 **über** der Melodie, in den letzten
beiden kippt er nach **unten** (D3, B2). Der Bezugston wandert vom Diskant in den
Bass. Das ist der Trick, der das Riff trägt.

### Der Aufbau

Alle Stimmen hängen an `sync :frame`. Der `:frame`-Thread feuert den Cue und
spielt dann endlos `permanent_drumset` (geschlossene Hi-Hat, ein Schlag pro Tick)
— er ist die Uhr. Die anderen Stimmen setzen gestaffelt ein:

| Tick | Stimme | was |
|---|---|---|
| 0 | `:frame` | Hi-Hat-Puls, durchgehend |
| 0 | `:the_red_line` | Riff auf `:sine` — die nackte Melodie |
| 16 | `:supportive` | Riff auf `:fm` |
| 28 | `:groll` | verzerrtes `:fm`, F♯/H-Figur, alle 12 Ticks |
| 32 | `:letsgetloud` | Bassdrum + Snare, `amp: 2.0` — das Schlagzeug kommt |
| 48 | `:screaming_git` | Riff auf `:pulse` + Distortion, `amp: 0.4` |
| 64 | `:supportive_dist` | Riff auf `:fm` + Distortion |

Rund **64 Sekunden additiver Aufbau**, danach läuft alles zusammen endlos weiter.

## Was das für mcblinded heißt

Die Idee des additiven Aufbaus über einen gemeinsamen Cue ist gut und sollte
bleiben. Drei Dinge stehen der neuen Fassung aber im Weg:

1. **Es endet nie.** Ein Endlos-Loop ist eine Installation, kein Song. Es braucht
   Sektionen und einen Schluss.
2. **Kein Platz für die Gitarre.** Ab Tick 64 spielen vier Stimmen dasselbe Riff
   gleichzeitig. Genau das Riff will ich aber selbst spielen — Sonic Pi muss an
   der Stelle zurücktreten.
3. **Kein Platz für Gesang.** Das Mittenband ist voll.

Der Rollentausch aus `../../CLAUDE.md` gibt die Richtung vor: Sonic Pi behält
Hi-Hat, Schlagzeug, Bass und Flächen. Das Riff selbst wandert auf die Gitarre —
Sonic Pi spielt es allenfalls im Intro, solange die Gitarre noch schweigt, und
gibt es dann ab. Das wäre auch dramaturgisch schön: die Maschine stellt das Thema
vor, der Mensch übernimmt es.

## Tempo

Das Original (EP-Aufnahme) läuft bei **~136 BPM**, belastbar 132–140 — gemessen
per Onset-Hüllkurve und Autokorrelation.

Die Fassung von 2015 setzt nie `use_bpm` und läuft deshalb auf Sonic Pis Default
von 60 BPM. **136 direkt einzusetzen ist trotzdem falsch:** ausprobiert und zu
hektisch. `monolithic_pattern` spielt durchgehend Sechzehntel — bei 136 BPM sind
das neun Töne pro Sekunde. Tempo und Notendichte hängen hier zusammen.

Entsprechen die Sechzehntel des Riffs den Achteln des Originals, ist das passende
Rastertempo **68 BPM**. Damit lagen die 60 von 2015 fast richtig.

## Geparkte Ideen fürs neue Arrangement

**Noch nichts davon umgesetzt — erst wird die Fassung von 2015 angehört.**
Festgehalten, damit die Gedanken nicht verloren gehen; nach dem Hören kann sich
alles davon erledigen.

### 1. ~~Die Maschine gibt das Thema ab~~ — verworfen

*Ursprüngliche Idee: Sonic Pi stellt das Riff allein vor und verstummt, sobald
die Gitarre einsetzt.*

**Fällt weg.** Live-Instrumente sind ausdrücklich optional (siehe
`../../CLAUDE.md`), also darf das Arrangement kein Loch haben, das erst von außen
gefüllt wird. Ohne Gitarre bliebe an der Stelle Stille.

Was sich retten lässt: der **Wechsel der Klangfarbe** an derselben Stelle. Das
Riff bleibt durchgehend da, wandert aber von einer Stimme in eine andere. Dann
ist die Geste erhalten, das Stück steht trotzdem für sich, und eine live
mitspielende Gitarre legt sich einfach auf die Stimme, die dort ohnehin klingt.

### 2. Den additiven Aufbau behalten, aber begrenzen

Die Staffelung (0 / 16 / 28 / 32 / 48 / 64 Ticks) ist das Beste an der Fassung
von 2015 und sollte bleiben. Nur endet sie heute nicht — sie kippt nach 64 Ticks
in einen Dauerzustand. Idee: dieselbe Staffelung als **Intro** verwenden, das in
den ersten Einsatz mündet, statt als Selbstzweck.

### 3. Der Pendelton als Sektionsmarker

Das Riff kippt in den letzten beiden Blöcken den Bezugston von oben (C♯4) nach
unten (D3, B2). Dieses Kippen ist bereits ein eingebauter Formteil-Wechsel —
man könnte die Sektionsgrenzen genau darauf legen, statt eigene zu erfinden.
Dann folgt die Form dem, was der Song ohnehin tut.

### 4. Vier Stimmen auf demselben Riff — **das bleibt so**

Ab Tick 64 spielen `:the_red_line`, `:supportive`, `:screaming_git` und
`:supportive_dist` alle dasselbe `monolithic_pattern`.

Hier stand einmal, das sei Verdichtung ohne neue Information und damit eine
Schwäche. **Das ist falsch.** Die vierfache Verdopplung ist genau der Reiz des
Songs und erzeugt die Wucht — sie ist Absicht, nicht Versehen.

Nicht ausdünnen.

### 5. Klick oder nicht

Der Hi-Hat-Puls aus `permanent_drumset` läuft durchgehend und ist damit faktisch
schon ein Klick. Wenn das zum Mitspielen reicht, braucht es kein In-Ear-Setup —
das wäre live eine große Vereinfachung. Beim Hören darauf achten.

## Offen

- [ ] Originalaufnahme anhören und Tonart/BPM gegen die Ableitung oben prüfen —
      die 60 BPM sind Sonic-Pi-Default, nicht notwendigerweise das Songtempo
- [ ] Gitarrenpart festhalten. Offen, in welcher Form. Eine aus
      `monolithic_pattern` errechnete Tab-Fassung war falsch — auf der Gitarre
      wird anders gegriffen, als die reine Umrechnung der Noten nahelegt.
      Muss von Robin kommen, nicht abgeleitet werden. Später.
- [ ] Songtext — liegt auf blackminded.de unter `texte/`
- [ ] Sektionsplan: Intro / Strophe / Refrain / Bridge / Schluss
