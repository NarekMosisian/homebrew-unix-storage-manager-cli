class UnixStorageManagerCli < Formula
  desc "Cross-platform CLI for macOS & Linux that reclaims disk space"
  homepage "https://github.com/NarekMosisian/unix-storage-manager-cli"
  url "https://github.com/NarekMosisian/unix-storage-manager-cli/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a8c7e2fe001ce62b2077d84011001f4205eb10474eea0676c82c552094546873"
  license "AGPL-3.0-or-later"

  depends_on "jq"
  depends_on "newt"

  def install
    libexec.install Dir["*.sh"]
    libexec.install "sounds" if Dir.exist?("sounds")
    libexec.install "images" if Dir.exist?("images")

    (bin/"unix-storage-manager").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail

      USM_HOME="#{libexec}"
      export UNIX_STORAGE_MANAGER_SHARE="$USM_HOME"
      export MAC_STORAGE_MANAGER_SHARE="$USM_HOME"

      cd "$USM_HOME"
      exec bash "./main.sh" "$@"
    EOS

    chmod 0755, bin/"unix-storage-manager"
  end

  test do
    assert_path_exists bin/"unix-storage-manager"
    system "#{bin}/unix-storage-manager", "--test-run"
  end
end
