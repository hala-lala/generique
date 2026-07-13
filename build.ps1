# recuperer le nom et la version depuis le pom.xml
[xml]$pom = Get-Content pom.xml
$name = $pom.project.artifactId
$version = $pom.project.version

Write-Host "nom : $name"
Write-Host "version : $version"

docker build --build-arg ARTIFACT_ID=$name --build-arg VERSION=$version -t $name":"$version .

