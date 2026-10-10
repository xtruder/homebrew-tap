class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-darwin-arm64.tar.gz"
      sha256 "3f26c5674a37f377df307b4aedc738a63d7c9116ccea0fd4d3f2df420a2cc1e5"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-darwin-amd64.tar.gz"
      sha256 "9199bfd5dac70f5ba02850f317ce0b43003344d4881276c1f0d1a6bdfa03f5f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-linux-arm64.tar.gz"
      sha256 "db52141eb3545f8d90093a908850fe63e0aad884592074e53e20b91b2e25b0ff"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-linux-amd64.tar.gz"
      sha256 "8dd2eaed3849bca84391445f7f3058d692bd9032afa626ce61a472d80d8bdce4"
    end
  end

  def install
    bin.install "openbao-authorizer", "bao-cred"
  end

  def caveats
    <<~EOS
      bao-cred reads the token from BAO_TOKEN, VAULT_TOKEN, or the ~/.vault-token
      written by `bao login`. Point it at OpenBao and the authorizer with:
        export BAO_ADDR=https://openbao.example.com
        export BAO_AUTHORIZER_ADDR=https://authorizer.example.com
    EOS
  end

  test do
    assert_match "BAO_AUTHORIZER_ADDR", shell_output("#{bin}/bao-cred --help")
    no_token = "env -u BAO_TOKEN -u VAULT_TOKEN HOME=#{testpath} #{bin}/bao-cred grants 2>&1"
    assert_match "no token", shell_output(no_token, 1)
    assert_match "server stopped", shell_output("#{bin}/openbao-authorizer 2>&1", 1)
  end
end
