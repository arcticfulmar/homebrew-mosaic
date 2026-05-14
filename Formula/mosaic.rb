class Mosaic < Formula
  desc "Local development environments for Moodle / Workplace / Laravel"
  homepage "https://github.com/arcticfulmar/mosaic"
  url "https://github.com/arcticfulmar/mosaic/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "bd36d08aab6461a49ebbb624ae8143ca7f5d71df7aa5208452ef8d3eafb2ab36"
  license "Apache-2.0"

  # Lima provides the macOS VMs, just runs the recipes, yq parses
  # mosaic.yaml at every step, coreutils gives us GNU `realpath` for
  # the `bin/mosaic` shim's symlink-resolution.
  depends_on "lima"
  depends_on "just"
  depends_on "yq"
  depends_on "coreutils"

  def install
    # Mosaic resolves MOSAIC_HOME by walking up from `bin/mosaic`'s
    # canonical path (after symlink resolution). Installing the whole
    # tree under libexec and symlinking just the bin keeps everything
    # adjacent and predictable.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/mosaic"
  end

  test do
    # `frameworks` is a no-side-effects recipe that lists profile
    # directories. Verifies the shim resolves MOSAIC_HOME, just is
    # callable, and the framework profiles ship with the formula.
    output = shell_output("#{bin}/mosaic frameworks")
    assert_match "moodle/4.x", output
    assert_match "workplace/4.x", output
    assert_match "laravel/13", output
  end
end
