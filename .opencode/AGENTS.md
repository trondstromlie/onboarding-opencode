# Prosjektinstrukser

Dette repoet vedlikeholdes av folk med ulik teknisk bakgrunn, ofte via AI. Reglene under er derfor ekstra tydelige — følg dem nøyaktig.

---

## Git-regler

1. **Push aldri direkte til main** — main har branch protection. Lag alltid en branch og PR.
2. **Sjekk branch-status før du gjør noe** — er current branch merget? Har den en åpen PR? Hvis brukeren begynner på noe nytt, spør: "Skal jeg lage en ny branch for dette?"
3. **Lag alltid PR ved push** — hver gang du pusher til en branch, lag en PR hvis det ikke finnes en allerede.
4. **Én branch per endring** — aldri gjenbruk en branch til flere uavhengige endringer. Lag en ny branch for hver ting du jobber med.
5. **Versjonsbump er en egen branch** — `npm version patch` skal alltid skje på en egen branch, aldri blandes med feature-endringer.
6. **Ikke legg feature-commits på en version-branch** — det fører til at endringer mistes ved squash-merge.
7. **Bruk squash-merge** — alle PRs merges med squash for å holde historikken ren.

### Riktig rekkefølge for endring + publisering:

```
1. git checkout -b feat/min-endring        ← ny branch fra main
2. gjør endringene, commit og push
3. lag PR → merge til main
4. git checkout main && git pull            ← hent oppdatert main
5. git checkout -b chore/version-x.x.x     ← ny branch for versjon
6. npm version patch                        ← bump versjon
7. push → lag PR → merge til main
8. git checkout main && git pull            ← hent oppdatert main
9. npm publish --otp=KODE                   ← publiser til npm
```

Aldri hopp over steg. Aldri kombiner steg 1–3 med steg 5–7.

---

## npm-regler

- **npm publish** krever OTP-kode fra brukerens autentiseringsapp.
- Publiser kun fra main etter at versjonsbumpen er merget.
- Hvis publish feiler med "You cannot publish over the previously published versions": versjonsnummeret er allerede brukt. Bump igjen.

---

## Etter endringer — sjekk README

Hver gang skills, CLI (`bin/cli.js`) eller onboarding-flyt endres:
- Les gjennom README.md og sjekk at skill-listen, instruksjonene og rekkefølgen fortsatt stemmer.
- Oppdater README i **samme PR** som endringen — ikke i en separat PR etterpå.

---

## Oppdatere skills

Når brukeren ber deg "oppdatere skills" betyr det alltid dette:

1. Oppdater skillsene i dette repoet (`skills/`) med innholdet fra de lokale skillsene (`~/.agents/skills/`, `~/.claude/skills/`, `~/.config/opencode/skills/`)
2. Sjekk diff mellom repo og lokale filer for å finne hva som har endret seg
3. Skriv endringene til riktige filer under `skills/` i dette repoet
4. Lag en branch og PR — ikke push direkte til main
5. Etter merge: hent main, bump versjon og publiser til npm

Skills som hører til dette repoet (ikke kopier andre):
- `github-setup`
- `install-mcp`
- `piwik-analytics`
- `figma-mcp`
- `onboarding`
