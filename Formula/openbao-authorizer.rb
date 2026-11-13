class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.16/openbao-authorizer-v1.0.0-rc.16-darwin-arm64.tar.gz"
      sha256 "5b82998c46b97016fb38039411377633e3e91eea96d77cd6aff0044c420e370b"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.16/openbao-authorizer-v1.0.0-rc.16-darwin-amd64.tar.gz"
      sha256 "747b1ca387edb6c67bf420d27608bfd374228ca45263bfa89c7488e49c1e5ac7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.16/openbao-authorizer-v1.0.0-rc.16-linux-arm64.tar.gz"
      sha256 "413a4b4698456daee286ebc2b2ee6edb5fec50d497f551b200236ba460445ce9"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.16/openbao-authorizer-v1.0.0-rc.16-linux-amd64.tar.gz"
      sha256 "2d89a13dfdb85480219e35684e87fc28cc4d12d0c6b41124a96c52757f00bf19"
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
