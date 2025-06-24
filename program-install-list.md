# Installed Programs

These are all the programs I need installed for the system to function the
way I desire. They are installed while installing Arch via Ansible.

## System Programs

### Foundational
- base 
- linux 
- linux-firmware 
- sudo 
- grub 
- efibootmgr 
- dosfstools 
- os-prober 
- mtools 
- base-devel 
- networkmanager 

### Wayland / WM / DisplayMgr
- virtualbox-guest-utils #FLAGGED FOR REMOVAL#
- wayland 
	- wlroots0.18 
	- pywlroots 
	- python-pywayland 
	- python-cffi 
	- python-xkbcommon 
	- python-dbus-next 
	- xorg-xwayland
- ly 
- qtile 


## User Programs

### Function / PKG Mgr
- git 
- yay [git]

### Term / Shell
- kitty 
- zsh
    - starship prompt
- otf-fira-mono-italic-git [yay]

### Text Editor
- vim 
- neovim
    - vim-plug [git]

### Other
- waypaper
- rofi 
- pcmanfm 
- firefox 
- btop 
- htop
- qutebrowser  #FLAGGED FOR REMOVAL#
- librewolf [yay]
