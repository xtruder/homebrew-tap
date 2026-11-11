class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.10/openbao-authorizer-v1.0.0-rc.10-darwin-arm64.tar.gz"
      sha256 "eb61a3822cb498863649548ea6badc92b08246e546f72e94868aaf35b5c3755c"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.10/openbao-authorizer-v1.0.0-rc.10-darwin-amd64.tar.gz"
      sha256 "f8a747646b680a61d82cf31e3b1f43f9c3f7fd4e6cb9c5609547e80f2300f5a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.10/openbao-authorizer-v1.0.0-rc.10-linux-arm64.tar.gz"
      sha256 "cb544f0c4a0294f82a25b09f51f131e5def01f56cb01e145fe132e5be56c78dc"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.10/openbao-authorizer-v1.0.0-rc.10-linux-amd64.tar.gz"
      sha256 "60f4eca7fabef2b7167a464cef49670977f7b4507e1febcce6ba2b0b165134c8"
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
