class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.3/openbao-authorizer-v1.0.0-rc.3-darwin-arm64.tar.gz"
      sha256 "f18a070101a0ad0856d466d8b59c6886c196db739bd9899ac19975cb5466973d"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.3/openbao-authorizer-v1.0.0-rc.3-darwin-amd64.tar.gz"
      sha256 "c415a319ce72552614eb86b31602dc9621002dc78eeae24142f56211daf7321c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.3/openbao-authorizer-v1.0.0-rc.3-linux-arm64.tar.gz"
      sha256 "94611674aaf76c8a38400309c886929afaabdb8891c5bef323a57d05237e7d2e"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.3/openbao-authorizer-v1.0.0-rc.3-linux-amd64.tar.gz"
      sha256 "8a25b2584747c2064c60e7b4fae18d165a4d8cbc651faaf49ab5d0b1259ca0d1"
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
