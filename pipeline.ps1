# ============================================
# SCRIPT D'AUTOMATISATION DU PIPELINE MAVEN
# ============================================

# ---- ETAPE 1 : Verification de Java ----
Write-Host "Verification de Java..."

$javaPath = Get-Command java -ErrorAction SilentlyContinue

if ($javaPath) {
    $javaVersion = java -version 2>&1
    Write-Host "Java est disponible"
    Write-Host "Chemin : $($javaPath.Source)"
    Write-Host "Version : $javaVersion"
} else {
    Write-Host "Java n'est pas installe - arret du script"
    exit 1
}

# ---- ETAPE 2 : Verification de Maven ----
Write-Host "Verification de Maven..."

$mavenPath = Get-Command mvn -ErrorAction SilentlyContinue

if ($mavenPath) {
    $mavenVersion = mvn -version 2>&1
    Write-Host "Maven est disponible"
    Write-Host "Chemin : $($mavenPath.Source)"
    Write-Host "Version : $mavenVersion"
} else {
    Write-Host "Maven n'est pas installe - arret du script"
    exit 1
}

# ---- ETAPE 3 : Verification du dossier ----
Write-Host "Verification du dossier..."

$dossierActuel = Get-Location
Write-Host "Dossier actuel : $dossierActuel"

if (Test-Path "pom.xml") {
    Write-Host "pom.xml trouve - bon dossier"
} else {
    Write-Host "pom.xml introuvable - mauvais dossier"
    exit 1
}

# ---- ETAPE 4 : Pipeline Maven ----
Write-Host "DEBUT DU PIPELINE MAVEN"

$phases = @("validate", "compile", "test", "package", "verify", "install", "deploy")

$repetitions = 5
$total = $phases.Length

for ($i = 1; $i -le $repetitions; $i++) {

    Write-Host "EXECUTION $i sur $repetitions"

    $compteur = 0

    foreach ($phase in $phases) {
        $compteur++
        Write-Host "[$compteur/$total] Lancement de : $phase"

        mvn $phase

        if ($LASTEXITCODE -ne 0) {
            Write-Host "ECHEC a la phase : $phase - arret du script"
            exit 1
        }

        Write-Host "$phase : OK"
    }

    Write-Host "Execution $i sur $repetitions terminee"
}

Write-Host "PIPELINE TERMINE - $repetitions executions completees"