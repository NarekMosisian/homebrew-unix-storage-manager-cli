class UnixStorageManagerCli < Formula
  desc "Cross-platform CLI for macOS & Linux that reclaims disk space"
  homepage "https://github.com/NarekMosisian/unix-storage-manager-cli"
  url "https://github.com/NarekMosisian/unix-storage-manager-cli/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a8c7e2fe001ce62b2077d84011001f4205eb10474eea0676c82c552094546873"
  license "AGPL-3.0-or-later"

  depends_on "bash"
  depends_on "jq"
  depends_on "newt"

  def install
    # Prevent runtime files from being written into the Cellar (read-only in CI and bad practice).
    inreplace "config.sh" do |s|
      s.sub!(
        /^XDG_CACHE=.*\n/,
        "\\0\n" \
        "# App-specific directories (Homebrew patch)\n" \
        "USM_APP_NAME=\"unix-storage-manager-cli\"\n" \
        "XDG_STATE=\"${XDG_STATE_HOME:-$HOME/.local/state}\"\n" \
        "USM_CONFIG_DIR=\"$XDG_CONFIG/$USM_APP_NAME\"\n" \
        "USM_STATE_DIR=\"$XDG_STATE/$USM_APP_NAME\"\n" \
        "mkdir -p \"$USM_CONFIG_DIR\" \"$USM_STATE_DIR\"\n"
      )

      s.gsub!(/^FIND_METHOD_FILE=.*$/, 'FIND_METHOD_FILE="$USM_CONFIG_DIR/find_method.conf"')
      s.gsub!(/^LANG_CONF_FILE=.*$/, 'LANG_CONF_FILE="$USM_CONFIG_DIR/language.conf"')
      s.gsub!(/^LOG_FILE=.*$/, 'LOG_FILE="$USM_STATE_DIR/unix_storage_manager.log"')
    end

    libexec.install Dir["*.sh"]

    confs = Dir["*.conf"]
    libexec.install confs if confs.any?

    libexec.install "sounds" if (buildpath/"sounds").exist?
    libexec.install "images" if (buildpath/"images").exist?

    (bin/"unix-storage-manager").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail

      USM_HOME="#{libexec}"
      export MAC_STORAGE_MANAGER_SHARE="$USM_HOME"

      cd "$USM_HOME"
      exec "#{Formula["bash"].opt_bin}/bash" "./main.sh" "$@"
    EOS
  end

  test do
    assert_path_exists bin/"unix-storage-manager"
    assert_match(/unix-storage-manager|usage/i, shell_output("#{bin}/unix-storage-manager --help"))
  end

end
