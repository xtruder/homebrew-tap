class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.11/openbao-authorizer-v1.0.0-rc.11-darwin-arm64.tar.gz"
      sha256 "fba7f97461024d6c613e26b9f86d465c580f9d32d33ad5b97e00df8ead5a4208"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.11/openbao-authorizer-v1.0.0-rc.11-darwin-amd64.tar.gz"
      sha256 "c36074e6ea667861ec62e96a07ad948769bbcbb76a96b1386dc9e272cf406e03"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.11/openbao-authorizer-v1.0.0-rc.11-linux-arm64.tar.gz"
      sha256 "3325fa1b4369bde346e4ee33ade17363a56b20c3ff36469a2c180ca25fb3042b"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.11/openbao-authorizer-v1.0.0-rc.11-linux-amd64.tar.gz"
      sha256 "2e8780f82d435db86752df59cf2ea3d75f1ec24af55bbce2125ad51e70b1564f"
    end
  end

  def install
    bin.install "openbao-authorizer", "bao-cred"
    # The name bao-cred runs under as the bao CLI's token helper.
    bin.install_symlink "bao-cred" => "bao-cred-token-helper"
  end

  def caveats
    <<~EOS
      bao-cred reads the token from BAO_TOKEN, VAULT_TOKEN, or the ~/.vault-token
      written by `bao login`. Point it at OpenBao and the authorizer with:
        export BAO_ADDR=https://openbao.example.com
        export BAO_AUTHORIZER_ADDR=https://authorizer.example.com

      To let the bao CLI get its token from bao-cred, run once:
        bao-cred token-helper --setup
    EOS
  end

  test do
    assert_match "BAO_AUTHORIZER_ADDR", shell_output("#{bin}/bao-cred --help")
    assert_predicate bin/"bao-cred-token-helper", :symlink?
    no_token = "env -u BAO_TOKEN -u VAULT_TOKEN HOME=#{testpath} #{bin}/bao-cred grants 2>&1"
    assert_match "no token", shell_output(no_token, 1)
    assert_match "server stopped", shell_output("#{bin}/openbao-authorizer 2>&1", 1)
  end
end
