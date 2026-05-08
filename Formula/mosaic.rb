class Mosaic < Formula
  desc "Local development environments for Moodle / Workplace / Laravel"
  homepage "https://github.com/arcticfulmar/mosaic"
  url "https://github.com/arcticfulmar/mosaic/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "34d2e9c1327b8094f1fb58e88092f0ac2dbac05018f872aacc40bb107cfbe18e"
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
