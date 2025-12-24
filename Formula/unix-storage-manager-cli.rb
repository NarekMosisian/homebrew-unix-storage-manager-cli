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

    (bin/"unix-storage-manager").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      cd "#{libexec}"
      exec bash "./main.sh" "$@"
    EOS
  end

  test do
    assert_predicate bin/"unix-storage-manager", :exist?
  end
end

