class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.19/openbao-authorizer-v1.0.0-rc.19-darwin-arm64.tar.gz"
      sha256 "07f9a574b586ea2d10a4e46f94862bb91941d96d3ac52afa2065b7449d7af151"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.19/openbao-authorizer-v1.0.0-rc.19-darwin-amd64.tar.gz"
      sha256 "73a4d3cbd1c2e64a9c7a768030ce2a69741ab32dcf08a4fbd1d275afb8e8ef33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.19/openbao-authorizer-v1.0.0-rc.19-linux-arm64.tar.gz"
      sha256 "0fde18295a8bc3229bb59d71265dae07d6e8644e70fb521e93516bee93ed06df"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.19/openbao-authorizer-v1.0.0-rc.19-linux-amd64.tar.gz"
      sha256 "21852fdbf70b7cb5acf9ed826eade972ff6f3dad0e1aa7cc15439924cb53079c"
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
