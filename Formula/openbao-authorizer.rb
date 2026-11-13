class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.14/openbao-authorizer-v1.0.0-rc.14-darwin-arm64.tar.gz"
      sha256 "2e4cab63bd9ed10e8856b6af6d2f13f839f2f164b95ca66bea3fb53843cd7128"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.14/openbao-authorizer-v1.0.0-rc.14-darwin-amd64.tar.gz"
      sha256 "7275c6579a7482e67dae77cc49863ff3e47f4c256438e875cdebe99a1ab0e1da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.14/openbao-authorizer-v1.0.0-rc.14-linux-arm64.tar.gz"
      sha256 "423f3e1407c313dc328c1ca5b63a801fc658c275e31d8e55ed5b82f0b1a23573"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.14/openbao-authorizer-v1.0.0-rc.14-linux-amd64.tar.gz"
      sha256 "ccfa2c0bdc18b161bf051d8d2c491c7cc5428916d58d79aa820adc48fdcbd06b"
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
