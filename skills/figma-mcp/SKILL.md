---
name: figma-mcp
description: Hjelper designere og produkteiere med å utforske og forstå Figma-filer via MCP — uten å måtte åpne Figma eller be en utvikler om hjelp. Bruk når noen limer inn en Figma-lenke og vil vite hva som er i den, vil ha en oppsummering av en skjerm eller komponent, lurer på hvilke tekster eller farger som brukes, vil sammenligne to versjoner, eller vil beskrive et design til en utvikler. Trigger på "figma", "design", "skjerm", "komponent", "prototype", "lim inn figma-lenke", "hva er i denne figma-filen", "kan du se på designet", "hva står det i figma", "beskriv designet", "hvilke farger", "hvilke tekster", "Figma og OpenCode", "lese design", "hva kan jeg bruke Figma MCP til", "hvordan funker Figma i OpenCode", "jeg er designer og vil prøve OpenCode".
---

# Figma MCP

Figma MCP lar OpenCode lese Figma-filene dine direkte. Du slipper å kopiere og lime inn skjermbilder — bare lim inn en lenke og still spørsmålet ditt.

---

## Kom i gang — lim inn en lenke

Lim inn en lenke til en Figma-fil, ramme eller komponent. Lenken ser typisk slik ut:

```
https://www.figma.com/design/ABC123/Mitt-prosjekt?node-id=1234-5678
```

**Tips:** Lenk til den spesifikke rammen du vil ha hjelp med — ikke hele filen. Da går det raskere og svarene blir mer presise.

Slik kopierer du lenken fra Figma:
- **Hel fil:** Kopier URL-en fra nettleseren
- **Spesifikk ramme eller komponent:** Høyreklikk på elementet → "Copy link to selection"

---

## Hva du kan spørre om

### Forstå innholdet på en skjerm

> "Hva er på denne skjermen?"
> "Hvilke tekster er synlige for brukeren?"
> "Er det noen knapper, og hva står det på dem?"

Bra for å dobbeltsjekke at ingenting mangler, eller for å lage en innholdsinventar uten å telle manuelt.

---

### Få en beskrivelse til en utvikler

> "Beskriv layouten på denne skjermen slik at en utvikler kan bygge den"
> "Hva er plasseringen og størrelsen på elementene?"
> "Hva er marginer og padding mellom seksjonene?"

OpenCode kan lage en teknisk spec direkte fra Figma — nyttig når du vil gi utvikleren noe å jobbe ut fra.

---

### Sjekke farger og stil

> "Hvilke farger brukes på denne skjermen?"
> "Bruker dette designet Gjensidige-tokens, eller egne fargeverdier?"
> "Er det noen farger som ikke er fra designsystemet?"

Bra for QA av design mot designsystemet.

---

### Finne komponentnavn

> "Hva heter denne komponenten i Figma?"
> "Er dette en lokal komponent eller fra et bibliotek?"

Nyttig når du vil referere til komponenten i en ticket eller når du snakker med en utvikler.

---

### Sammenligne to versjoner

Lim inn to lenker og spør:

> "Hva er forskjellen mellom disse to skjermene?"
> "Hvilke tekster er endret fra versjon A til versjon B?"

---

## Tips for beste resultat

- **Vær konkret** — "hvilke tekster er på denne skjermen?" er bedre enn "fortell meg alt om denne filen"
- **Still ett spørsmål om gangen** — du får mer presise svar
- **Lenk til rett nivå** — en ramme, ikke hele filen
- **Bilder og ikoner** vises bare hvis de har navn i Figma — spør om navn på elementer, ikke om å "se" ikonene

---

## Hvis Figma MCP ikke er koblet til

Sjekk først om Figma MCP er tilgjengelig ved å be brukeren lime inn en Figma-lenke og prøve å hente innholdet. Hvis det feiler eller verktøyet ikke finnes, da er det ikke installert.

I så fall: bruk `install-mcp`-skillen til å sette opp Figma MCP. Den tar deg gjennom hele installasjonen steg for steg — inkludert å hente API-token og oppdatere OpenCode-konfigen.
