<#
run-jekyll-build.ps1

Checks for Ruby, installs Bundler if missing, runs bundle install (excluding jekyll_plugins),
and runs `bundle exec jekyll build --trace` in the repository root.
Usage: Open PowerShell as administrator if installing gems globally.
#>

param(
    [string]$RepoPath = "C:\Users\taffg\OneDrive\Documents\GitHub\Resume"
)

function Exec-Log($cmd) {
    Write-Host "`n> $cmd" -ForegroundColor Cyan
    & powershell -NoProfile -Command $cmd
    return $LASTEXITCODE
}

if (-not (Test-Path $RepoPath)) {
    Write-Error "Repo path not found: $RepoPath"
    exit 1
}

Set-Location $RepoPath

if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
    Write-Host "Ruby not found. Please install Ruby (RubyInstaller on Windows) and re-run." -ForegroundColor Yellow
    Write-Host "See: https://rubyinstaller.org/"
    exit 1
}

if (-not (Get-Command gem -ErrorAction SilentlyContinue)) {
    Write-Error "`gem` command not found despite Ruby present. Ensure Ruby is properly installed."
    exit 1
}

if (-not (Get-Command bundle -ErrorAction SilentlyContinue)) {
    Write-Host "Bundler not found. Installing bundler..." -ForegroundColor Yellow
    Exec-Log "gem install bundler --no-document"
    if (-not (Get-Command bundle -ErrorAction SilentlyContinue)) {
        Write-Error "Bundler installation failed. Install Bundler manually and retry."
        exit 1
    }
}

Write-Host "Running: bundle install --without jekyll_plugins" -ForegroundColor Green
Exec-Log "bundle config set path vendor/bundle"
$rc = Exec-Log "bundle install --without jekyll_plugins"
if ($rc -ne 0) {
    Write-Host "bundle install failed with exit code $rc" -ForegroundColor Red
    Write-Host "You can try running `bundle install` without `--without jekyll_plugins` or inspect the full error above." -ForegroundColor Yellow
    exit $rc
}

Write-Host "Building site with: bundle exec jekyll build --trace" -ForegroundColor Green
$rc = Exec-Log "bundle exec jekyll build --trace"
if ($rc -ne 0) {
    Write-Host "jekyll build failed with exit code $rc" -ForegroundColor Red
    exit $rc
}

Write-Host "Build completed successfully. Output in ./_site" -ForegroundColor Green
