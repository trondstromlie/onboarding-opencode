#!/usr/bin/env node

import { existsSync, mkdirSync, cpSync, readdirSync, statSync, readFileSync } from "fs";
import { join, resolve } from "path";
import { fileURLToPath } from "url";
import { homedir, platform } from "os";
import { createInterface } from "readline";
import { execSync } from "child_process";

const SKILLS_SRC = fileURLToPath(new URL("../skills", import.meta.url));
const SKILLS_DEST = join(homedir(), ".agents", "skills");

const SKILLS = readdirSync(SKILLS_SRC).filter((f) =>
  statSync(join(SKILLS_SRC, f)).isDirectory()
);

const isDryRun = process.argv.includes("--dry-run");
const isNonInteractive = process.argv.includes("--all");

function log(msg) {
  console.log(msg);
}

function ensureDir(dir) {
  if (!existsSync(dir)) {
    if (!isDryRun) mkdirSync(dir, { recursive: true });
    log(`  Oppretter mappe: ${dir}`);
  }
}

function installSkill(skillName) {
  const src = join(SKILLS_SRC, skillName);
  const dest = join(SKILLS_DEST, skillName);

  if (existsSync(dest)) {
    log(`  [oppdaterer] ${skillName}`);
  } else {
    log(`  [installerer] ${skillName}`);
  }

  if (!isDryRun) {
    cpSync(src, dest, { recursive: true });
  }
}

function prompt(rl, question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => resolve(answer.trim()));
  });
}

function checkNpmrc() {
  const npmrcPath = join(homedir(), ".npmrc");
  if (!existsSync(npmrcPath)) return false;
  const contents = readFileSync(npmrcPath, "utf8");
  return contents.includes("npm.pkg.github.com") && contents.includes("_authToken");
}

function installGjensidigeSKills() {
  if (!checkNpmrc()) {
    log("  ⚠️  Finner ikke GitHub-token i ~/.npmrc.");
    log("  Gjensidige-skills krever tilgang til GitHub Packages.");
    log("  Kjør github-setup-skillen i OpenCode for å sette opp .npmrc, og kjør deretter opencode-setup på nytt.\n");
    return;
  }

  log("  Laster ned offisielle Gjensidige-skills (gap-onboarding, builders)...");
  try {
    if (!isDryRun) {
      execSync("npx --yes skills add gjensidige/skills", {
        stdio: "inherit",
        env: { ...process.env },
      });
    } else {
      log("  (tørrkjøring) ville kjørt: npx skills add gjensidige/skills");
    }
  } catch (err) {
    log(`  ✗ Klarte ikke laste ned Gjensidige-skills: ${err.message}`);
    log("  Prøv manuelt: npx skills add gjensidige/skills\n");
  }
}

async function selectSkills(rl) {
  log("\nTilgjengelige skills:\n");
  SKILLS.forEach((s, i) => log(`  [${i + 1}] ${s}`));
  log(`  [a] Alle skills\n`);

  const answer = await prompt(
    rl,
    'Hvilke vil du installere? (f.eks. "1 3" eller "a"): '
  );

  if (answer.toLowerCase() === "a") return SKILLS;

  const indices = answer
    .split(/\s+/)
    .map((n) => parseInt(n) - 1)
    .filter((i) => i >= 0 && i < SKILLS.length);

  return indices.map((i) => SKILLS[i]);
}

const LOGO = `
                              .###############-                              
                         +##########################-                        
                     +#  +##############################                     
                  .####  -################################-                  
                #######  .###################################                
              +########   ############+      -#################              
             ##########   ############        ##################.            
           +###########   ############        ####################           
          #############   ###########         +####################          
         ##############.  ##########-         +#####################         
        +##############.  #######               -####################        
        ###############    -###                   ####################       
       ###############+     ++                     ###################       
      +###############+                             ###################      
      #################           +                 ###################      
      ##################        -##                  ##################.     
      ##################   ##+#####                   #################-     
      ##################   ######+              .      ################-     
      ##################   ######                      ################.     
      ##################.  ######                #+    ################      
      ##################+  -####                 -#     ###############      
       ##################   ####                  #-   +##############       
       .#################   ####                        +#############       
        +################   ###-                    #    ############        
         ################   ###                   -   #  ###########         
          ###############   ###                       -  ##########          
           ##############   ###                          #########           
             ############+  +##                    -############-            
              ############  .#####-             .+#############              
                ##########   ######            ##############                
                  -#######   ######+          #############                  
                     #####   #######        ############                     
                        -#   #######        #########                        
                              +#####         ++                              

       ██████  ███    ██ ██████   ██████   █████  ██████  ██████  ██ ███    ██  ██████  
      ██    ██ ████   ██ ██   ██ ██    ██ ██   ██ ██   ██ ██   ██ ██ ████   ██ ██       
      ██    ██ ██ ██  ██ ██████  ██    ██ ███████ ██████  ██   ██ ██ ██ ██  ██ ██   ███ 
      ██    ██ ██  ██ ██ ██   ██ ██    ██ ██   ██ ██   ██ ██   ██ ██ ██  ██ ██ ██    ██ 
       ██████  ██   ████ ██████   ██████  ██   ██ ██   ██ ██████  ██ ██   ████  ██████  

                         ███████ ██   ██ ██ ██      ██      ███████                     
                         ██      ██  ██  ██ ██      ██      ██                          
                         ███████ █████   ██ ██      ██      ███████                     
                              ██ ██  ██  ██ ██      ██           ██                     
                         ███████ ██   ██ ██ ███████ ███████ ███████                     
`;

async function main() {
  log(LOGO);

  if (isDryRun) {
    log("(Tørrkjøring — ingenting blir installert)\n");
  }

  log(`Installerer til: ${SKILLS_DEST}\n`);
  ensureDir(SKILLS_DEST);

  let selected = SKILLS;

  if (!isNonInteractive) {
    const rl = createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    selected = await selectSkills(rl);
    rl.close();
  }

  if (selected.length === 0) {
    log("\nIngen skills valgt. Avslutter.");
    process.exit(0);
  }

  log(`\nInstallerer ${selected.length} skill(s)...\n`);
  selected.forEach(installSkill);

  log("\n--- Gjensidige offisielle skills ---\n");
  installGjensidigeSKills();

  log("\nFerdig! Start OpenCode på nytt for at skills skal lastes inn.");
  log(
    "Skriv f.eks. 'sett opp GitHub SSH' i OpenCode for å bruke github-setup-skill-en.\n"
  );
}

main().catch((err) => {
  console.error("Feil:", err.message);
  process.exit(1);
});
