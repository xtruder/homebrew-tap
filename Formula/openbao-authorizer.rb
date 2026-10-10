class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-darwin-arm64.tar.gz"
      sha256 "864a8b4d45500b7169fff2feda7b0097effafac622b8202c061ab77027b71666"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-darwin-amd64.tar.gz"
      sha256 "24f7126cea67ddab4eb2c1e820366b0c9834bf14a246b7ff1ea19eb1cfb84eb4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-linux-arm64.tar.gz"
      sha256 "873b5abd7dbc8bf7925c36529ab9ba5e4caf5760a3a8c800e537b8b21f52258c"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.4/openbao-authorizer-v1.0.0-rc.4-linux-amd64.tar.gz"
      sha256 "523c85ff9052fbe2ed64aa92156c5ec5b30e83e1704e95604cc12cb7c4c62ad9"
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
