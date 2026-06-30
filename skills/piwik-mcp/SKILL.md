---
name: piwik-mcp
description: Bruk denne skill-en når noen skal hente eller analysere data fra Piwik Pro — for eksempel sidevisninger, sessjoner, bruksmønstre, konvertering, eller trafikk for en spesifikk app. Inneholder nettstedsnavn, website_id-er, dimensjonsnavn, metrikknavn og hvordan man bygger spørringer mot Piwik MCP. Trigger på "Piwik", "besøksstatistikk", "sidevisninger", "sessjoner", "analysere trafikk", "hente data fra Piwik", "custom dimensions", "gjensidige.no analytics", "produktdata fra Piwik", eller når en produkteier vil forstå bruk av en app uten å kontakte analyseteamet.
---

# Piwik Pro Analytics

Denne skill-en gir deg det du trenger for å hente og analysere data fra Piwik Pro via MCP — uten å måtte spørre analyseteamet.

---

## MCP-server

Piwik Pro MCP kjøres via `uvx` (Python-basert) — ikke `npx`.

| Innstilling | Verdi |
|-------------|-------|
| Kommando (Mac/Linux) | `uvx piwik-pro-mcp` |
| Kommando (Windows) | `C:\Users\<brukernavn>\.local\bin\uvx.exe piwik-pro-mcp` |
| Host | `gjensidige.piwik.pro` |
| Env-variabel host | `PIWIK_PRO_HOST` |
| Env-variabel klient-ID | `PIWIK_PRO_CLIENT_ID` |
| Env-variabel hemmelighet | `PIWIK_PRO_CLIENT_SECRET` |

Hvis Piwik MCP ikke er installert enda, bruk `install-mcp`-skillen.

---

## Tilgjengelige apper

Bruk alltid `website_id` (ikke `app_id`) i alle spørringer.

| App                          | website_id                                   |
|------------------------------|----------------------------------------------|
| gjensidige.no                | `f7ebd082-fc5d-471e-925e-88e9a8f4284a`       |
| gjensidige.dk                | `fafaebf4-2b0e-46e9-a6cd-00c97c62ddc9`       |
| gjensidige.se                | `8b6361f9-5fbb-4227-85cc-edeeccdc1566`       |
| gjensidige.com               | `407eff76-fbfb-4626-9077-81eb3ee9904e`       |
| Gjensidige Mobile App - Prod | `f46b195e-b2c5-44bc-91dc-ff48491f21aa`       |
| testgjensidige.no            | `f8b3c559-e704-44df-a18b-dbae6ad09612`       |
| testgjensidige.dk            | `ce451e0b-c90d-437a-9a22-18869302184a`       |
| gouda.no                     | `018efca0-0560-462c-b518-b2c5fb37a0e1`       |
| gouda.dk                     | `cf31de58-4edb-481b-acef-36d37fc05e3f`       |
| gouda.fi                     | `82d6533d-331e-4c20-94b4-9bb6dc2bdf3f`       |
| gouda-rf.se                  | `91251724-0d84-4bed-9cb9-ed78d2aeb718`       |
| intranet.no                  | `898bb4a2-1929-4c2a-8eba-0f57726793ec`       |
| intranet.dk                  | `41dd72e8-245e-46f6-8024-5599df494c54`       |
| intranet.se                  | `f92afe8c-68a3-42aa-a9e1-895d9b7812a2`       |

---

## Custom dimensions (gjensidige.no)

Filtrer på applikasjon, modul og scenario via `event_custom_dimension_X`.

### Applikasjonsdimensjoner

| Column ID                   | Navn                        | Eksempel                        |
|-----------------------------|-----------------------------|---------------------------------|
| `event_custom_dimension_1`  | Application Name (cd1)      | `"claims_selector"`, `"sales"`  |
| `event_custom_dimension_2`  | Application Module (cd2)    | Modul innen applikasjonen       |
| `event_custom_dimension_3`  | Application Submodule (cd3) | Undermodul                      |
| `event_custom_dimension_4`  | Application Partner (cd4)   | Partner                         |
| `event_custom_dimension_5`  | Application Version (cd5)   | Appversjon                      |
| `event_custom_dimension_6`  | Scenario Name (cd6)         | Scenarionavn                    |
| `event_custom_dimension_7`  | Scenario Step (cd7)         | Steg i scenario                 |
| `event_custom_dimension_8`  | Scenario Type (cd8)         | Scenariotype                    |
| `event_custom_dimension_12` | Business Area (cd12)        | Forretningsområde               |
| `event_custom_dimension_13` | Customer Segment (cd13)     | Kundesegment                    |
| `event_custom_dimension_14` | Login Status (cd14)         | Innloggingsstatus               |

### Skadedimensjoner

| Column ID                   | Navn                        | Beskrivelse                     |
|-----------------------------|-----------------------------|---------------------------------|
| `event_custom_dimension_21` | Processguide ID (cd21)      | Skadeprosess-guide ID           |
| `event_custom_dimension_22` | Processguide Title (cd22)   | Skadeprosess-guide tittel       |
| `event_custom_dimension_33` | Claims Incident (cd33)      | Hendelsestype                   |
| `event_custom_dimension_34` | Claims Accident (cd34)      | Ulykkestype                     |
| `event_custom_dimension_35` | Claims Object (cd35)        | Skadens objekt                  |

### Hendelse/konverteringsdimensjoner

| Column ID                   | Navn                        | Beskrivelse                     |
|-----------------------------|-----------------------------|---------------------------------|
| `event_custom_dimension_40` | Event Name (cd40)           | Hendelsesnavn                   |
| `event_custom_dimension_44` | Event Type (cd44)           | Hendelsestype                   |
| `event_custom_dimension_50` | Conversion Name (cd50)      | Konverteringsnavn               |

---

## Vanlige dimensjoner

| Column ID               | Beskrivelse                              |
|-------------------------|------------------------------------------|
| `timestamp`             | Tidsstempel (bruk med transformasjoner)  |
| `device_type`           | Enhetstype (returnerer [id, navn]-par)   |
| `browser_name`          | Nettlesernavn                            |
| `operating_system`      | Operativsystem                           |
| `source`                | Trafikkilde                              |
| `medium`                | Trafikk-medium                           |
| `referrer_type`         | Kanal                                    |
| `location_country_name` | Land                                     |
| `location_city_name`    | By                                       |
| `event_url`             | Side-URL                                 |
| `event_title`           | Sidetittel                               |
| `local_hour`            | Time på dagen (0–23)                     |

---

## Vanlige metrikker

| Column ID    | Beskrivelse        |
|--------------|--------------------|
| `sessions`   | Antall sesjoner    |
| `page_views` | Sidevisninger      |
| `visitors`   | Unike besøkende    |
| `events`     | Antall hendelser   |
| `bounces`    | Antall avhopp      |
| `bounce_rate`| Avhoppsrate        |

---

## Bygge spørringer

### Nødvendig rekkefølge

Kall disse før `analytics_query_execute`:

1. `analytics_dimensions_list` — gyldige dimension-IDer
2. `analytics_metrics_list` — gyldige metrikk-IDer
3. `analytics_dimensions_details_list` — transformasjonsalternativer
4. `analytics_metrics_details_list` — metrikk-typer

### Eksempel: daglige sesjoner filtrert på modul

```json
{
  "website_id": "f7ebd082-fc5d-471e-925e-88e9a8f4284a",
  "date_from": "2025-05-26",
  "date_to": "2025-06-25",
  "columns": [
    {"column_id": "timestamp", "transformation_id": "to_date"},
    {"column_id": "sessions"}
  ],
  "filters": {
    "operator": "and",
    "conditions": [
      {
        "column_id": "event_custom_dimension_2",
        "condition": {"operator": "eq", "value": "claims_selector"}
      }
    ]
  },
  "limit": 31,
  "order_by": [[0, "asc"]]
}
```

### Kritiske regler

| Regel | Detalj |
|-------|--------|
| Bruk `website_id` | Aldri `app_id` |
| `filters`-struktur | Toppnivå-objekt med `operator` ("and"/"or") og `conditions`-array |
| Hver betingelse | Har `column_id` + nestet `condition`-objekt med `operator` og `value` |
| `order_by`-format | `[[kolonneindeks, "asc"\|"desc"]]` — indeks er 0-basert |
| Metrikker kan ikke transformeres | Kun dimensjoner aksepterer `transformation_id` |

### Filteroperatorer

| Type     | Operatorer                                                                    |
|----------|-------------------------------------------------------------------------------|
| Streng   | `eq`, `neq`, `contains`, `not_contains`, `starts_with`, `ends_with`, `matches`, `not_matches` |
| Numerisk | `gt`, `gte`, `lt`, `lte`                                                     |
| Null     | `empty`, `not_empty`                                                          |

### Tidsstempel-transformasjoner

| Transformasjon       | Granularitet |
|---------------------|--------------|
| `to_date`           | Per dag      |
| `to_start_of_hour`  | Per time     |
| `to_start_of_week`  | Per uke      |
| `to_start_of_month` | Per måned    |

---

## Tilgjengelige MCP-verktøy

| Verktøy                                 | Beskrivelse                                |
|-----------------------------------------|--------------------------------------------|
| `apps_list`                             | List alle trackede apper                   |
| `analytics_query_execute`               | Kjør en dataspørring                       |
| `analytics_custom_dimensions_list`      | List custom dimensions for et nettsted     |
| `analytics_custom_dimensions_get_slots` | Hent slotbruk-statistikk                   |
| `analytics_dimensions_list`             | List alle tilgjengelige dimensjon-IDer     |
| `analytics_dimensions_details_list`     | Hent detaljer for spesifikke dimensjoner   |
| `analytics_metrics_list`                | List alle tilgjengelige metrikker          |
| `analytics_metrics_details_list`        | Hent detaljer for spesifikke metrikker     |
| `analytics_goals_list`                  | List mål for et nettsted                   |
| `analytics_annotations_list`            | List annotasjoner                          |

---

## Visualisering

Når du lager dashbord eller visualiseringer:

1. Lagre som HTML-fil og åpne med `open`-kommandoen på macOS
2. Mørkt tema (bakgrunn: `#0a0a1a`) med gradientaksentfarger (`#667eea` til `#764ba2`)
3. Kombiner gjerne: stolpediagram for daglige data, smultring for enhetsfordeling, varmekart for timemønstre
4. Legg til oppsummeringskort øverst med nøkkeltall
5. Ta med hover-tooltips og jevne animasjoner
6. Marker helger vs. hverdager med ulike farger i stolpediagram
7. Gjør det responsivt
