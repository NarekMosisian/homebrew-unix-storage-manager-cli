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
    libexec.install Dir["*.sh"]

    confs = Dir["*.conf"]
    libexec.install confs if confs.any?

    libexec.install "sounds" if (buildpath/"sounds").directory?
    libexec.install "images" if (buildpath/"images").directory?

    bash = Formula["bash"].opt_bin/"bash"

    (bin/"unix-storage-manager").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail

      USM_HOME="#{libexec}"
      export MAC_STORAGE_MANAGER_SHARE="$USM_HOME"

      cd "$USM_HOME"
      exec "#{bash}" "./main.sh" "$@"
    EOS

    (bin/"unix-storage-manager").chmod 0755
  end

  test do
    assert_path_exists bin/"unix-storage-manager"

    output = `#{bin}/unix-storage-manager --help 2>&1`
    status = $?.exitstatus

    assert_includes [0, 1], status
    assert_match(/unix-storage-manager|usage/i, output)
  end
end
