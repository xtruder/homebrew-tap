class OpenbaoAuthorizer < Formula
  desc "Human approval of OpenBao access requests, with the bao-cred client"
  homepage "https://github.com/xtruder/openbao-authorizer"

  on_macos do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.17/openbao-authorizer-v1.0.0-rc.17-darwin-arm64.tar.gz"
      sha256 "677dfafcf92cbfb6eb3d5b24b1f98891e7a2da299f65b3ac9af53c017d8628aa"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.17/openbao-authorizer-v1.0.0-rc.17-darwin-amd64.tar.gz"
      sha256 "df0fa8b1ec5e680ad066b879e15db97e9fdd294778bc70eaadb4cc2e285f8c03"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.17/openbao-authorizer-v1.0.0-rc.17-linux-arm64.tar.gz"
      sha256 "b26202e8bedfbd4cd11a5f4c09c4f99a0fd9d5d5c0c51b7e17fde6ca357c65e5"
    end

    on_intel do
      url "https://github.com/xtruder/openbao-authorizer/releases/download/v1.0.0-rc.17/openbao-authorizer-v1.0.0-rc.17-linux-amd64.tar.gz"
      sha256 "3118a5dc2ddb7b737f76bc9b285172b1325899a09b83423e9ee55566ac9cb31e"
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
