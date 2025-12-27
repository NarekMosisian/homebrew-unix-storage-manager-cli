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

    conf_files = Dir["*.conf"]
    libexec.install conf_files unless conf_files.empty?

    libexec.install "sounds" if Dir.exist?("sounds")
    libexec.install "images" if Dir.exist?("images")

    (bin/"unix-storage-manager").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      USM_HOME="#{libexec}"
      cd "$USM_HOME"
      exec bash "./main.sh" "$@"
    EOS
  end

  test do
    assert_path_exists bin/"unix-storage-manager"

    output = shell_output("#{bin}/unix-storage-manager --test-run")
    assert_match(/Dummy\\.app|dummy\\.desktop/i, output)
  end
end
