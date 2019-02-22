class Ccls < Formula
  desc "C/C++ language server"
  homepage "https://github.com/MaskRay/ccls"
  if MacOS.version <= :el_capitan
    url "https://github.com/MaskRay/ccls.git",
           :tag      => "0.20180812",
           :revision => "06aa25233567ae16a58a6f5237aacfd9e02aa29d"
  else
    url "https://github.com/MaskRay/ccls.git",
           :tag      => "0.20181225.8",
           :revision => "d275ed570d7ea26dd8d762b8d82bc4e295971154"
  end
  head "https://github.com/MaskRay/ccls.git"

  option "with-build-debug", "Configures ccls to be built in debug mode"
  option "without-system-clang", "Downloading Clang from http://releases.llvm.org/ during the configure process"
  option "with-asan", "Compile with address sanitizers"

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  def install
    build_type = build.with?("build-debug") ? "Debug" : "Release"
    system_clang = build.with?("system-clang") ? "ON" : "OFF"
    asan = build.with?("asan") ? "ON" : "OFF"

    args = std_cmake_args + %W[
      -DSYSTEM_CLANG=#{system_clang}
      -DCMAKE_BUILD_TYPE=#{build_type.capitalize}
      -DASAN=#{asan}
    ]

    ENV.prepend_path "PATH", Formula["cmake"].opt_bin
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    mkdir_p build_type
    system "cmake", *args, "-B#{build_type}", "-H."
    system "cmake", "--build", build_type, "--target", "install"
  end

  test do
    system "#{bin}/ccls", "--version"
  end
end
