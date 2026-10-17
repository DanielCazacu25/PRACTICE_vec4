# vec4_dot — specificație

Unitate pipeline care calculează **produsul scalar** a doi vectori cu 4 elemente, în virgulă fixă. E operația de bază dintr-un vertex shader: transformarea unui punct 3D cu o matrice 4×4 înseamnă 4 astfel de produse scalare.

> **Regula jocului:** tratează DUT-ul ca pe o **cutie neagră**. Lucrezi doar cu această specificație și cu porturile. Nu citi RTL-ul ca să cauți bug-uri: în RTL sunt ascunse **câteva bug-uri**, iar scopul e să le găsească testbench-ul.

---

## 1. Porturi

| Port | Direcție | Lățime | Descriere |
|---|---|---|---|
| `clk` | in | 1 | Ceas. Totul se eșantionează pe frontul crescător |
| `rst_n` | in | 1 | Reset **asincron**, activ pe **0** |
| `in_valid` | in | 1 | Intrarea e validă în acest ciclu |
| `in_tag` | in | 4 | Identificator al tranzacției, trecut neschimbat la ieșire |
| `in_a` | in | 64 | Vectorul A = `{a3, a2, a1, a0}`, fiecare element pe 16 biți |
| `in_b` | in | 64 | Vectorul B = `{b3, b2, b1, b0}`, fiecare element pe 16 biți |
| `out_valid` | out | 1 | Rezultatul e valid în acest ciclu |
| `out_tag` | out | 4 | `in_tag`-ul tranzacției căreia îi aparține rezultatul |
| `out_result` | out | 16 | Rezultatul, în format Q8.8 |
| `out_sat` | out | 1 | 1 dacă rezultatul a fost saturat (vezi secțiunea 4) |

Nu există backpressure: DUT-ul acceptă o tranzacție nouă **în fiecare ciclu**.

## 2. Formatul numeric: Q8.8 cu semn

Fiecare element e un număr pe 16 biți, în **complement față de 2**, cu **8 biți fracționari**:

```
valoare = (întregul pe 16 biți, cu semn) / 256
```

| Cod hex | Valoare |
|---|---|
| `0x0100` | 1,0 |
| `0x0080` | 0,5 |
| `0xFF00` | −1,0 |
| `0x7FFF` | 127,99609375 (maximul) |
| `0x8000` | −128,0 (minimul) |

## 3. Funcția

```
S = a0·b0 + a1·b1 + a2·b2 + a3·b3        (calculat exact, fără pierderi)
R = rotunjire(S) la 8 biți fracționari
```

**Rotunjirea:** *round half up*. Dacă S e reprezentat cu 16 biți fracționari:

```
R_întreg = floor( (S_întreg + 128) / 256 )
```

(adică aduni 128, apoi faci deplasare aritmetică la dreapta cu 8 biți)

## 4. Saturarea

Dacă R nu încape în Q8.8:

| Condiție | `out_result` | `out_sat` |
|---|---|---|
| R > 127,99609375 (cod > 32767) | `0x7FFF` | **1** |
| R < −128,0 (cod < −32768) | `0x8000` | **1** |
| altfel | R | 0 |

## 5. Timing

- **Latența: exact 3 cicluri.** Dacă `in_valid` = 1 la frontul N, atunci `out_valid` = 1 la frontul N + 3, cu rezultatul tranzacției respective.
- **Debitul: o tranzacție pe ciclu.** Tranzacții pe cicluri consecutive dau rezultate pe cicluri consecutive, în aceeași ordine.
- `out_tag` e egal cu `in_tag`-ul tranzacției de la frontul N.
- Când `out_valid` = 0, valorile `out_result`, `out_tag` și `out_sat` nu contează.

```
ciclu     :  0    1    2    3    4    5
in_valid  :  1    1    0    1    0    0
in_tag    :  A    B    -    C    -    -
out_valid :  0    0    0    1    1    0    1
out_tag   :            -    A    B    -    C
```

Structura internă, orientativ (nu trebuie verificată direct):

```
Etaj 1: 4 înmulțiri în paralel
Etaj 2: (p0 + p1), (p2 + p3)
Etaj 3: suma finală, rotunjire, saturare → registrele de ieșire
```

## 6. Resetul

- `rst_n` = 0 aduce **imediat** (asincron) `out_valid` la 0. Orice tranzacție aflată în pipeline în acel moment e **abandonată**: nu trebuie să mai apară la ieșire.
- După eliberarea resetului, `out_valid` trebuie să fie 0 până la primul rezultat al unei tranzacții trimise **după** reset.
- `out_valid` nu trebuie să fie niciodată X sau Z după eliberarea resetului.

---

## 7. Ce trebuie să conțină mediul tău (checklist)

**Componente**

- [ ] Agent de intrare (driver + monitor) și monitor de ieșire
- [ ] Scoreboard cu **model de referință** în SystemVerilog. Atenție la lățimea intermediarilor și la semn
- [ ] Potrivirea intrare ↔ ieșire: prin `tag` sau printr-o coadă, ținând cont de latență
- [ ] Verificare că, la final, nu au rămas tranzacții fără rezultat

**Aserțiuni (SVA)**

- [ ] Latența fixă de 3 cicluri
- [ ] `out_tag` corespunde cu `in_tag`-ul de acum 3 cicluri
- [ ] `out_valid` fără X/Z după reset

**Coverage**

- [ ] Semnul fiecărui element (pozitiv / negativ / zero), **pe fiecare poziție** 0–3
- [ ] Saturare pozitivă și saturare negativă
- [ ] Valori extreme (`0x7FFF`, `0x8000`)
- [ ] Tranzacții consecutive (back-to-back) și cu pauze
- [ ] Reset în timp ce pipeline-ul conține tranzacții

**Teste**

- [ ] Câteva teste dirijate cu rezultat calculat de mână (de exemplu, din tabelul de la secțiunea 2)
- [ ] Test random constrâns, cu distribuții care ating și colțurile, nu doar valori mici
- [ ] Un test cu reset în mijlocul traficului

La final, notează pentru fiecare bug găsit: **simptomul**, **testul care l-a prins** și **ce credeai inițial că e**.