# traveller

Auf blackminded.de heißt der Song **„traveller"** mit zwei l — hier durchgehend
so geschrieben.

## Quellen

| Was | Wo |
|---|---|
| Aufnahme | `original_recording.wav` — 44,1 kHz Stereo, 4:47. Per `.gitignore` nicht im Repo |
| Songtext | `lyrics.md` (von blackminded.de/texte/traveller.htm) |
| Original-MP3 auf der Website | **gibt es nicht.** `music.htm` verlinkt nur fünf Audios (gi, rsjp, soyv, tf, wcah); `disclaimer.php?SONG=traveller` fällt auf `blackminded - kaputt` zurück |
| Gitarren-Tabs | offen |

## Gemessen

Alles unten stammt aus `original_recording.wav`, gerechnet mit macOS-Bordmitteln
(`afconvert` → Mono 22,05 kHz) und Standard-Python (`wave`, `array`, `math`,
`cmath`) — kein ffmpeg, kein librosa, kein numpy.

### Tempo: 132 BPM

Zwei unabhängige Wege, gleiches Ergebnis:

1. **Spektralfluss + Kammfilter**, in sechs 35-Sekunden-Fenstern über den Song:
   132,5 / 132,6 / 129,2 / 132,5 / 129,2 / 130,8 BPM. Die Streuung ist echtes
   Driften — gespielt ohne Klick.
2. **Wiederholungs-Lags der Chroma-Selbstähnlichkeit.** Sucht man das Tempo, bei
   dem diese Lags auf ganze Takte fallen, kommt **132,3 BPM** heraus:

   | Lag | Takte bei 132 BPM |
   |---|---|
   | 11 s | 6,06 |
   | 18 s | 9,92 |
   | 51 s | 28,11 |
   | 69 s | 38,04 |
   | 80 s | 44,10 |
   | 87 s | 47,96 |
   | 98 s | 54,02 |
   | 127 s | 70,01 |

Ein Takt sind damit **1,818 s**, der Song hat rund **158 Takte** 4/4.

Die erste, rohe Autokorrelation über die Energiehüllkurve war unentschieden
(112 / 108 / 129 / 136). Das lag am Detektor: der Mix ist hart limitiert, die
Energiekurve praktisch flach. **Auf dieser Aufnahme braucht es Spektralfluss,
Energiefluss reicht nicht.**

### Tonart: e-Moll

Krumhansl-Schmuckler über die Chroma des ganzen Songs, mit deutlichem Abstand:

| Kandidat | r |
|---|---|
| **e-Moll** | **0,928** |
| G-Dur | 0,596 |
| E-Dur | 0,564 |
| C-Dur | 0,537 |

Tonhöhenverteilung: E 20 %, B 15 %, G 14 % — Grundton, Quinte, Terz. Gitarren-
tonart in Standardstimmung.

### Form

Der Lautheitsverlauf gibt nichts her (limitiert, flach bis auf das Ausblenden ab
4:41). Die Form kommt deshalb aus der **Basslinie**: Chroma nur im Band
70–350 Hz, 8192-Punkt-FFT, Grundton je halbem Takt. Das umgeht die Verwechslung
verzerrter Powerchords mit ihren Terzverwandten, an der die Akkorderkennung über
den vollen Mix scheiterte (sie schwankte zwischen C, Em und G).

Es gibt **zwei wiederkehrende 16-Takt-Blöcke**, unterscheidbar am Ton auf
Zählzeit 1:

- **C-Block** — `C … E`, Takte 33–48, 77–92, 121–136
- **G-Block** — `G … E`, Takte 61–76, 105–120

Beide kehren im Abstand von **44 Takten** wieder — das ist der stärkste Lag der
Selbstähnlichkeit (80 s). Die große Einheit ist also `G-Block (16) + C-Block (16)
+ Überleitung (12)`.

| Takte | Zeit | Bass |
|---|---|---|
| 1–16 | 0:00–0:29 | A/C → E, dann C ↔ B |
| 17–32 | 0:29–0:58 | E-lastig, am Ende D–E |
| 33–48 | 0:58–1:27 | **C-Block** |
| 49–60 | 1:27–1:49 | E/A, C/G, D–E |
| 61–76 | 1:49–2:18 | **G-Block** |
| 77–92 | 2:18–2:43 | **C-Block** |
| 93–104 | 2:43–3:09 | A … E, dann C/G, D/E |
| 105–120 | 3:09–3:38 | **G-Block** |
| 121–136 | 3:38–4:03 | **C-Block** |
| 137–152 | 4:03–4:36 | C/E → E |
| 153–158 | 4:36–4:47 | E-Orgelpunkt, Ausblenden |

### Die Strophe: C – Am – Em (bestätigt)

**Der C-Block ist die Strophe.** Auf der Gitarre gespielt ist der Lauf
`C – a-Moll – e-Moll`. Die Messung sagt unabhängig dasselbe — im Bassband liest
sich der Block achtmal als `C … A … E … E` je halbem Takt. Auf Zählzeiten:

```
| C    C    Am   Am  | Em   Em   Em   Em  |
```

Eine **Zwei-Takt-Schleife**: C und a-Moll je zwei Schläge, dann ein ganzer Takt
e-Moll. Die 16 Takte des Blocks sind acht Durchläufe davon.

Der G-Block liest sich analog als Zwei-Takt-Schleife `| G | Em |` — ein ganzer
Takt G, ein ganzer Takt e-Moll. **Noch nicht auf der Gitarre bestätigt.**

**Welcher Block Refrain und welcher Bridge ist, sagt die Messung nicht** — das
ist noch zuzuordnen. Der Text gibt die Reihenfolge `V1 – C – V2 – C – B – V3 – C
– B` vor; wie sie auf die Takte oben fällt, ist offen.

Das `C ↔ B` in Takt 9–16 ist die auffälligste Bewegung des Songs (♭VI–V in
e-Moll) und kommt später nicht wieder — vermutlich ein Intro-Motiv.

## Play-Along zuerst, fertiger Song danach

Der Weg ist bewusst zweistufig:

1. **Play-Along-Fassungen** (`playalong/`) — die Strophenschleife endlos, zum
   Draufspielen und Ideensammeln. Kein Anfang, kein Ende, keine Form. Zweck ist
   nicht Vorführen, sondern Material.
2. **Fertige Songfassung** (`song.rb`, noch nicht da) — mit Sektionen, Übergängen
   und Schluss.

Solange Stufe 1 läuft, entstehen **mehrere Varianten nebeneinander**, statt eine
zu verfeinern. Aussortiert wird später.

### Die Varianten

| Datei | was sie anders macht |
|---|---|
| `verse_band.rb` | Rockbeat, `:fm`-Bass, verzerrte Powerchords auf Achteln, leise Fläche. Die Ausgangsfassung — klingt nach Band |
| `verse_sparse.rb` | Alles rausgenommen: keine Verzerrung, Schlagzeug nur auf den schweren Zählzeiten, Akkorde arpeggiert statt liegend. Platz für Melodien |
| `verse_heavy.rb` | Halftime — Kick auf 1, Snare auf 3, sonst nichts. Die Harmonik behält ihren Zweitakter, das Schlagzeug halbiert sich darunter. Bass eine Oktave tiefer |
| `verse_electronic.rb` | Hört auf, Band zu spielen: elektronisches Kit, `:tb303`-Sechzehntelbass, Akkorde als Stabs. Am weitesten weg vom Original |
| `verse_funk.rb` | Jazzy Funk, ausgedünnt: Cmaj9 und Am9 als grundtonlose Voicings, dazu der volle offene e-Moll-Griff als Ruhepunkt. Synkopierter Bass, `:pluck`-Stabs, Rhodes-artige `:fm`-Fläche, Ghost Notes im Beat |

Alle laufen auf denselben drei Akkorden und auf 132 BPM, alle fangen mit
vier Klicks Einzähler an. Abspielen:

```bash
bin/play songs/traveller/playalong/verse_band.rb
bin/play --stop
```

Jede Datei steht für sich und wiederholt die Akkordliste oben im Kopf. Das ist
Absicht — beim Rumprobieren will man eine Variante anfassen können, ohne die
anderen zu treffen.


#### Was am Funk schon abgehört ist

Beim Mitspielen sind drei Sachen entschieden worden — sie stehen so in
`verse_funk.rb`:

- **Der Beat bleibt.** Erste Rückmeldung war „der Drumbeat gefällt mir schon
  mal". Ghost Notes und die offene Hi-Hat auf den letzten Achteln vor dem
  Taktwechsel sind Teil davon.
- **Das e-Moll bleibt blank.** Erst war es Em9 (`G B D F♯`), das klang „strange".
  Septime raus, dann None raus — jetzt der reine Dreiklang. C und Am behalten
  ihre Erweiterungen; der Kontrast ist Absicht.
  **Achtung:** die Septime steckte auch im Bass, auf dem vorletzten Sechzehntel
  des Em-Takts. Nur das Voicing zu ändern hätte sie stehen lassen.
- **Das e-Moll ist der Griff, der auf der Gitarre gespielt wird.** Zweiter Bund auf A- und
  D-Saite, Rest offen, alle sechs Saiten angeschlagen: `E2 H2 E3 G3 H3 E4`.
  Drei E und zwei H über zwei Oktaven — **die Dopplungen sind die Schwere.**
  Vorher standen dort drei Töne im Diskant, und der Akkord fiel in sich zusammen.
  Dazu drei Dinge, die erst zusammen funktionieren: er wird **geschrammt** statt
  gegriffen, **einmal** angeschlagen statt wiederholt (mehrfach klang staccato),
  und er steht **hinten** — leise und dunkel, Cutoff 82 gegen 110.
- **Doppelte Akkordlängen sind verworfen.** Der Versuch, C und Am je einen ganzen
  Takt und Em zwei geben zu lassen, um es ruhiger zu machen, hat den Song
  kaputtgemacht. **Der Akkordwechsel bleibt wie er ist.** Ruhiger wird es über
  Dichte und Pegel, nicht über die Harmonik.
- **Ausgedünnt statt verlangsamt.** Bass von 14 auf 11 Töne je zwei Takte, Stabs
  von zehn auf vier und keiner auf der Eins, alle Pegel runter — die offene
  Hi-Hat am stärksten, die war der Hauptteil des Aggressiven. Das
  Schlagzeugmuster selbst ist unangetastet, das gefiel von Anfang an.

Die Akkorde sind deshalb als ausgeschriebene Tonlisten in `verse` notiert und
nicht aus `chord()` errechnet — so lässt sich einer davon umbauen, ohne die
anderen zu treffen.

### Umschalten live

`live.rb` ist die Bühnenfassung — getrennt von den Play-Alongs, weil sie anders
gebaut ist:

- **`live_loop` statt `in_thread`.** Ein `in_thread` läuft bis zum Stopp durch und
  lässt sich im Laufen nicht ersetzen. Nur `live_loop` ist umschaltbar.
- **Jede Stimme fragt `get[:section]` am Anfang jedes Durchlaufs.** Der Wechsel
  greift dadurch erst beim nächsten Zweitakter, nie mitten hinein — das Timing
  hält sich von selbst, was zählt, wenn beide Hände an der Gitarre sind.
- **Beide Sektionen sind exakt zwei Takte lang**, damit die Stimmen ausgerichtet
  bleiben, egal wann umgeschaltet wird.

Umgeschaltet wird aus einem zweiten Terminal, ohne die Datei anzufassen:

```bash
bin/play -e 'set :section, :chorus'
bin/play -e 'set :section, :verse'
```

Das geht, weil Sonic Pis **Time State global zum Server gehört**, nicht zum
einzelnen Lauf: ein separater Einzeiler kann einen Wert setzen, den die laufenden
`live_loop`s lesen.

**Nachgewiesen**, nicht bloß behauptet: in einer Aufnahme mit zwei Umschaltungen
liest sich die Basslinie als C–E–C–E (Takt 3–6), dann G–G–G–G (7–10), dann wieder
C–E–C (11–14). Beide Wechsel landeten auf einer Zweitaktgrenze.

**Der Refrain in `live.rb` ist nicht bestätigt.** Sein `| G | Em |` stammt aus der
Bassmessung (G-Block bei 1:49 und 3:09) und dient bisher nur dazu, dass es etwas
zum Umschalten gibt.

Ein Fußtaster käme über MIDI. MIDI-Sync ist in Sonic Pi heikel, deshalb ist der
Mechanismus erst einmal mit der Tastatur bewiesen.




## Was das fürs Arrangement heißt

Anders als bei RS:JP gibt es keine Fassung von 2015, die repariert werden müsste.
Wir bauen von null — und können die drei Dinge, die in `../rs_jp/NOTES.md` als
Mängel der alten Fassung stehen, gleich richtig machen:

1. **Ein Ende.** Der Text hat es eingebaut: `who will care about my broken mind?`
   steht 3× am Schluss der Bridge. Das ist bei traveller, was
   `away, away, away` bei RS:JP ist.
2. **Sektionen.** Die 16-Takt-Blöcke oben sind schon eine Form — sie muss nicht
   erfunden werden.
3. **Platz.** Sonic Pi nimmt Drums, Bass und Fläche; die Gitarre legt sich auf
   eine Stimme, die ohnehin klingt, statt in ein Loch zu spielen.

## Offen

- [ ] **Tabs** — danach lassen sich die Stimmen direkt daraus setzen
- [x] Strophe = C-Block, `| C  Am | Em |`
- [ ] Zuordnung der übrigen Blöcke zu Refrain / Bridge; G-Block prüfen
- [ ] Prüfen, ob 132 BPM in Sonic Pi trägt oder ob die Notendichte — wie bei
      RS:JP, wo aus 136 am Ende 68 wurden — ein anderes Rastertempo verlangt
- [x] Play-Along der Strophe, vier Varianten in `playalong/`
- [ ] Varianten durchspielen und aussortieren
- [ ] Play-Along für die übrigen Sektionen
- [ ] `song.rb`: Sektionen, Übergänge, Schluss
