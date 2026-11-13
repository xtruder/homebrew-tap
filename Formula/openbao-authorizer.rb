class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.15/openbao-authorizer-v1.0.0-rc.15-darwin-arm64.tar.gz"
      sha256 "c852157d3efb856473ecb08df0c31e97b3b8eedeb742b6c6117882e7af2d2eaf"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.15/openbao-authorizer-v1.0.0-rc.15-darwin-amd64.tar.gz"
      sha256 "15e817e5c6e53b35adc86b64a73bfb0a573bd4a755f6f51290769cec819ef9de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.15/openbao-authorizer-v1.0.0-rc.15-linux-arm64.tar.gz"
      sha256 "aacf2f61e47b932df3137de9fcf60a8c82b3456c3f8f32ab9f459090b8ee3fa7"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.15/openbao-authorizer-v1.0.0-rc.15-linux-amd64.tar.gz"
      sha256 "c8196b575449a1ca5df510c745ff0fe987230f08474aef043171eb065b2b0b1a"
    end
  end

  def install
    bin.install "openbao-authorizer", "bao-cred"
    # The names bao-cred runs under as the bao CLI's token helper and as
    # git's gpg.ssh.program.
    bin.install_symlink "bao-cred" => "bao-cred-token-helper"
    bin.install_symlink "bao-cred" => "bao-cred-ssh-keygen"
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
    assert_predicate bin/"bao-cred-ssh-keygen", :symlink?
    no_token = "env -u BAO_TOKEN -u VAULT_TOKEN HOME=#{testpath} #{bin}/bao-cred grants 2>&1"
    assert_match "no token", shell_output(no_token, 1)
    assert_match "server stopped", shell_output("#{bin}/openbao-authorizer 2>&1", 1)
  end
end
