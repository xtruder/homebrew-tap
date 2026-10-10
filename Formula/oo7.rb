class Oo7 < Formula
  desc "D-Bus Secret Service provider (org.freedesktop.secrets)"
  homepage "https://github.com/linux-credentials/oo7"
  url "https://github.com/linux-credentials/oo7/archive/refs/tags/0.7.0.beta.tar.gz"
  sha256 "b5bc59a755936fcc87de140e6210885c7e432f68fc0e60369457fde12d021ae1"
  license "MIT"
  head "https://github.com/linux-credentials/oo7.git", branch: "main"

  bottle do
    root_url "https://github.com/xtruder/homebrew-tap/releases/download/oo7-0.7.0.beta"
    rebuild 2
    sha256 cellar: :any, x86_64_linux: "8eb306c015d3a2fdfae1b42abc753a45d0c5c89ea4b1ece1f7049bdf954430e7"
  end

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
