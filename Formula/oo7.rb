class Oo7 < Formula
  desc "D-Bus Secret Service provider (org.freedesktop.secrets)"
  homepage "https://github.com/linux-credentials/oo7"
  url "https://github.com/linux-credentials/oo7/archive/refs/tags/0.7.0.alpha.tar.gz"
  version "0.7.0-alpha"
  sha256 "d999c235e5028558db901a5f92793441b90e2340a3a7392c331ee0dfa1d98176"
  license "MIT"
  head "https://github.com/linux-credentials/oo7.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "server")
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  def caveats
    <<~EOS
      oo7 is a D-Bus Secret Service provider. Run it as a systemd user service:
        systemctl --user enable --now oo7-daemon.service
      The login keyring starts locked; unlock manually with:
        printf 'password' | oo7-daemon --login --replace
    EOS
  end

  test do
    system bin/"oo7-cli", "--help"
  end
end
