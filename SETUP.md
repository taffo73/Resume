Local setup and build

Windows (recommended)

1. Install Ruby (use RubyInstaller for Windows): https://rubyinstaller.org/
2. During installation, enable MSYS2 and run the MSYS2 setup when prompted.
3. Open a new PowerShell window and install Bundler:

```
gem install bundler
```

4. From the repository root, install gems and build the site:

```powershell
bundle install
bundle exec jekyll build --trace
```

macOS / Linux

1. Install Ruby (system package manager, rbenv or rvm).
2. Install Bundler:

```
gem install bundler
```

3. Install gems and build:

```bash
bundle install
bundle exec jekyll build --trace
```

Notes

- The repository includes a `Gemfile` with `github-pages` in the `jekyll_plugins` group to match GitHub Pages versions.
- If you encounter native extension build failures on Windows, ensure MSYS2 toolchain is installed (RubyInstaller step).