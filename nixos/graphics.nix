{ config, pkgs, ... }:

{
  # Enable hardware acceleration for AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # AMD GPU drivers and acceleration
    extraPackages = with pkgs; [
      amdvlk # AMD Vulkan driver
      rocm-opencl-icd # AMD OpenCL
      rocm-opencl-runtime
      mesa.drivers # Mesa drivers including RADV
      libva # Video acceleration
      libvdpau-va-gl
      vaapiVdpau
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
      mesa.drivers
    ];
  };

  # Boot kernel parameters for AMD graphics
  boot.kernelParams = [
    # AMD GPU specific parameters
    "amdgpu.dc=1"
    "amdgpu.dpm=1"
    "amdgpu.si_support=1"
    "amdgpu.cik_support=1"

    # DisplayPort specific fixes
    "drm.debug=0x04"
    "video=DP-1:e"
    "video=DP-2:e"
    "video=DP-3:e"

    # Enable early KMS
    "amdgpu.modeset=1"
  ];

  # Load AMD graphics drivers early
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];

  # AMD GPU services
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable DisplayPort MST and AMD specific options
  boot.extraModprobeConfig = ''
    options amdgpu dc=1
    options amdgpu dpm=1
    options amdgpu si_support=1
    options amdgpu cik_support=1
    options drm debug=0x04
  '';

  # AMD CPU specific
  hardware.cpu.amd.updateMicrocode = true;
}
