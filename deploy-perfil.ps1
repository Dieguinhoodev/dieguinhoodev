# deploy-perfil.ps1 — Publica o README de perfil no GitHub
$OutputEncoding = [System.Text.Encoding]::UTF8

$outputsBase = "C:\Users\gamep\AppData\Roaming\Claude\local-agent-mode-sessions\cc1c9934-36e6-4799-bd50-974e09a13a4e\fc1b7a32-acdf-44c5-b186-884634398684\local_e37ebc38-2da3-48d9-b582-891967d3ae23\outputs"

$repoPath = "$outputsBase\Dieguinhoodev"
$wslPath  = ($repoPath -replace 'C:\\','/mnt/c/' -replace '\\','/')
$repo     = "Dieguinhoodev"

Write-Host "Publicando perfil GitHub..." -ForegroundColor Cyan

# Pega token do gh
$token = gh auth token
if (-not $token) { Write-Host "ERRO: gh nao autenticado." -ForegroundColor Red; Pause; exit 1 }

# Remove .git anterior
if (Test-Path "$repoPath\.git") { Remove-Item -Recurse -Force "$repoPath\.git" }

# Git via WSL
$bash = "cd '$wslPath' && git init -b main && git config user.email 'dieguinho.fernandes001@gmail.com' && git config user.name 'Dieguinhoodev' && git add . && git commit -m 'feat: perfil GitHub profissional'"
wsl -d Arch -- bash -c $bash
if ($LASTEXITCODE -ne 0) { wsl -- bash -c $bash }

# Cria repo especial de perfil
Write-Host "Criando repositorio de perfil..." -ForegroundColor Gray
gh repo create "Dieguinhoodev/$repo" --public 2>&1 | Out-Null

# Push com token
$push = "cd '$wslPath' && git remote add origin 'https://$token@github.com/Dieguinhoodev/$repo.git' 2>/dev/null; git push -u origin main --force"
wsl -d Arch -- bash -c $push
if ($LASTEXITCODE -ne 0) { wsl -- bash -c $push }

Write-Host ""
Write-Host "PERFIL PUBLICADO!" -ForegroundColor Green
Write-Host "Acesse: https://github.com/Dieguinhoodev" -ForegroundColor Yellow
Write-Host ""
Pause
