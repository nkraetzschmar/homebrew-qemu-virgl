class QemuVirgl < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  url "https://github.com/qemu/qemu.git", using: :git, revision: "99fc08366b06282614daeda989d2fde6ab8a707f"
  version "20211212.1"
  license "GPL-2.0-only"

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "nkraetzschmar/qemu-virgl/libangle"
  depends_on "nkraetzschmar/qemu-virgl/libepoxy-angle"
  depends_on "nkraetzschmar/qemu-virgl/virglrenderer"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "spice-protocol"
  depends_on "vde"
  depends_on "zstd"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  # The following patches add 9p support to darwin.  They can
  # be deleted when qemu-7 is released.
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/e0bd743bb2dd4985791d4de880446bdbb4e04fed.diff"
    sha256 "9168d424f7bcabb74fdca35fd4d3db1279136ce03d656a2e0391aa4344244e49"
  end
  patch do
    url "https://raw.githubusercontent.com/baude/homebrew-qemu/798fdd7c6e2924591f45b282b3f59cb6e9850504/add_9p-util-linux.diff"
    sha256 "e2835578eeea09b75309fc3ac4a040b47c0ac8149150d8ddf45f7228ab7b5433"
  end
  patch do
    url "https://raw.githubusercontent.com/baude/homebrew-qemu/798fdd7c6e2924591f45b282b3f59cb6e9850504/remove_9p-util.diff"
    sha256 "ccf31a8e60ac7fc54fd287eca7e63fe1c9154e346d2a1367b33630227b88144d"
  end
  patch do
    url "https://raw.githubusercontent.com/ashley-cui/homebrew-podman/e1162ec457bd46ed84aef9a0aa41e80787121088/change.patch"
    sha256 "af8343144aea8b51852b8bf7c48f94082353c5e0c57d78fc61e7c3e4be3658b9"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/f41db099c71151291c269bf48ad006de9cbd9ca6.diff"
    sha256 "1769d60fc2248fc457846ec8fbbf837be539e08bd0f56daf6ec9201afe6c157e"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/6b3b279bd670c6a2fa23c9049820c814f0e2c846.diff"
    sha256 "bde6fa9deffeb31ca092f183a9bffc1041501c2532a625f8875fa119945049b8"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/67a71e3b71a2834d028031a92e76eb9444e423c6.diff"
    sha256 "60f38699e2488f854c295afbfea56f30fce1ebc0d2a7dcddf8bedba2d14533b1"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/38d7fd68b0c8775b5253ab84367419621aa032e6.diff"
    sha256 "b89ed2a06d1e81cb18b7fab0b47313d8a3acc6be70a4874854c0cc925fc6e57f"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/57b3910bc3513ab515296692daafd1c546f3c115.diff"
    sha256 "4bbd1f2d209f099fb2b075630b67a3d08829d67c56edcb21fc5688f66a486296"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/b5989326f558faedd2511f29459112cced2ca8f5.diff"
    sha256 "5c53c4cc28229058f9fac3eed521d62edf9b952bf24eb18790a400a074ed6f0b"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/029ed1bd9defa33a80bb40cdcd003699299af8db.diff"
    sha256 "a349c6de07fcf8314a1d84cacc05c68573728641cc5054d0fc149d14e1c9bed8"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/d3671fd972cd185a6923433aa4802f54d8b62112.diff"
    sha256 "f40dd472ec4dcbf6f352338de85c1aba5a92a3b9f0a691f8ae51e298e2b5a273"
  end
  patch do
    url "https://raw.githubusercontent.com/NixOS/nixpkgs/8fc669a1dd84ae0db237fdb30e84c9f47e0e9436/pkgs/applications/virtualization/qemu/allow-virtfs-on-darwin.patch"
    sha256 "61422ab60ed9dfa3d9fe8a267c54fab230f100e9ba92275bc98cf5da9e388cde"
  end

  # waiting for upstreaming of https://github.com/akihikodaki/qemu/tree/macos
  patch :p1 do
    url "https://raw.githubusercontent.com/knazarov/homebrew-qemu-virgl/87072b7ccc07f5087bf0848fa8920f8b3f8d5a47/Patches/qemu-v05.diff"
    sha256 "6d27699ba454b5ecb7411822a745b89dce3dea5fccabfb56c84ad698f3222dd4"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-slirp
      --enable-curses
      --enable-libssh
      --enable-vde
      --enable-virtfs
      --enable-zstd
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --extra-cflags=-I#{Formula["libangle"].opt_prefix}/include
      --extra-cflags=-I#{Formula["libepoxy-angle"].opt_prefix}/include
      --extra-cflags=-I#{Formula["virglrenderer"].opt_prefix}/include
      --extra-cflags=-I#{Formula["spice-protocol"].opt_prefix}/include/spice-1
      --extra-ldflags=-L#{Formula["libangle"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["libepoxy-angle"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["virglrenderer"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["spice-protocol"].opt_prefix}/lib
      --disable-sdl
      --disable-gtk
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args << "--enable-cocoa" if OS.mac?

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-aarch64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-alpha --version")
    assert_match expected, shell_output("#{bin}/qemu-system-arm --version")
    assert_match expected, shell_output("#{bin}/qemu-system-cris --version")
    assert_match expected, shell_output("#{bin}/qemu-system-hppa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-i386 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-m68k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblaze --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblazeel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64el --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mipsel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-nios2 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-or1k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv32 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-rx --version")
    assert_match expected, shell_output("#{bin}/qemu-system-s390x --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4eb --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-tricore --version")
    assert_match expected, shell_output("#{bin}/qemu-system-x86_64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensaeb --version")
    resource("test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
