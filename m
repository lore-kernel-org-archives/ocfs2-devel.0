From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 27 Dec 2011 11:03:32 -0800
Subject: [Ocfs2-devel] [Kernel 3.1.5] [OCFS2] After many write/delete on
 ocfs2 both servers in cluster kernel oops
In-Reply-To: <BC56FD1FE65B4D08BDABF34A8DA1872B@tktelekom.net>
References: <BC56FD1FE65B4D08BDABF34A8DA1872B@tktelekom.net>
Message-ID: <20111227190330.GB30094@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marek Krolikowski <admin@wset.edu.pl>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, sunil.mushran@oracle.com

+cc: ocfs2-devel, sunil

Marek,
	Thanks for the detailed report!  Can I trouble you to file a bug
at http://oss.oracle.com/bugzilla ... oh, is that your report
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1339?
	This looks like a deadlock of some sort.  I don't think your
hardware configuration really matters here.  We'll keep looking into it.

Joel

On Tue, Dec 20, 2011 at 08:22:48AM +0100, Marek Krolikowski wrote:
> [1.] One line summary of the problem:
> After many write/delete on ocfs2 both servers in cluster kernel oops
> 
> 
> [2.] Full description of the problem/report:
> After create new ocfs2 cluster with kernel 3.1.5 after few hours
> write/delete on both servers via my own script got oops kernel on
> both servers:
> I try disable all features, change kernel to 2.6.39.4 and 3.2RC5 but
> all the time this same effect.
> I create other filesystem and working good - so looks like problem
> with OCFS2.
> 
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> 
> 
> [4.] Kernel version (from /proc/version):
> TEST-MAIL1 ~ # cat /proc/version
> Linux version 3.1.5 (root at TEST-MAIL1) (gcc version 4.4.5 (Gentoo
> 4.4.5 p1.3, pie-0.4.5) ) #1 SMP Mon Dec 19 17:16:12 CET 2011
> TEST-MAIL2 ~ # cat /proc/version
> Linux version 3.1.5 (root at TEST-MAIL2) (gcc version 4.4.5 (Gentoo
> 4.4.5 p1.3, pie-0.4.5) ) #1 SMP Mon Dec 19 17:16:06 CET 2011
> 
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information
>     resolved (see Documentation/oops-tracing.txt)
> TEST-MAIL1 ~ #dmesg
> [cut]
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> rm              D ffff88107f472c40     0 16705  22512 0x00000000
> ffff881014693810 0000000000000086 ffff881000000000 ffff88102013b040
> 0000000000012c40 ffff880471855fd8 0000000000012c40 ffff880471854010
> ffff880471855fd8 0000000000012c40 ffff881017ff8e40 0000000100000000
> Call Trace:
> [<ffffffff8148d45d>] ? schedule_timeout+0x1ed/0x2d0
> [<ffffffffa0b7d1ea>] ? dlmlock+0x8a/0xda0 [ocfs2_dlm]
> [<ffffffff8148ce5c>] ? wait_for_common+0x12c/0x1a0
> [<ffffffff81052230>] ? try_to_wake_up+0x280/0x280
> [<ffffffffa0a3b9c0>] ? __ocfs2_cluster_lock+0x1f0/0x780 [ocfs2]
> [<ffffffff8148ce80>] ? wait_for_common+0x150/0x1a0
> [<ffffffffa0a9c6bc>] ? ocfs2_buffer_cached+0x8c/0x180 [ocfs2]
> [<ffffffffa0a40bc6>] ? ocfs2_inode_lock_full_nested+0x126/0x540 [ocfs2]
> [<ffffffffa0a5922e>] ? ocfs2_lookup_lock_orphan_dir+0x6e/0x1b0 [ocfs2]
> [<ffffffffa0a5922e>] ? ocfs2_lookup_lock_orphan_dir+0x6e/0x1b0 [ocfs2]
> [<ffffffffa0a5ba1a>] ? ocfs2_prepare_orphan_dir+0x4a/0x290 [ocfs2]
> [<ffffffffa0a5e621>] ? ocfs2_unlink+0x6e1/0xbb0 [ocfs2]
> [<ffffffff811bcfea>] ? may_link+0xda/0x170
> [<ffffffff81141c8e>] ? vfs_unlink+0x9e/0x100
> [<ffffffff81145881>] ? do_unlinkat+0x1a1/0x1d0
> [<ffffffff81147b00>] ? vfs_readdir+0xa0/0xe0
> [<ffffffff8116fedb>] ? fsnotify_find_inode_mark+0x2b/0x40
> [<ffffffff81170c24>] ? dnotify_flush+0x54/0x110
> [<ffffffff81133eec>] ? filp_close+0x5c/0x90
> [<ffffffff81496912>] ? system_call_fastpath+0x16/0x1b
> 
> TEST-MAIL2 ~ #dmesg
> [CUT]
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> rm              D ffff88107f3b2c40     0 10499  23219 0x00000000
> ffff88101531f080 0000000000000082 0000000000000000 ffff88102004f080
> 0000000000012c40 ffff88088a217fd8 0000000000012c40 ffff88088a216010
> ffff88088a217fd8 0000000000012c40 ffff881012761f30 0000000115197f40
> Call Trace:
> [<ffffffff8148d45d>] ? schedule_timeout+0x1ed/0x2d0
> [<ffffffffa0b891ea>] ? dlmlock+0x8a/0xda0 [ocfs2_dlm]
> [<ffffffff8148ce5c>] ? wait_for_common+0x12c/0x1a0
> [<ffffffff81052230>] ? try_to_wake_up+0x280/0x280
> [<ffffffffa0a479c0>] ? __ocfs2_cluster_lock+0x1f0/0x780 [ocfs2]
> [<ffffffff8148ce80>] ? wait_for_common+0x150/0x1a0
> [<ffffffffa0aa86bc>] ? ocfs2_buffer_cached+0x8c/0x180 [ocfs2]
> [<ffffffffa0a4cbc6>] ? ocfs2_inode_lock_full_nested+0x126/0x540 [ocfs2]
> [<ffffffffa0a6522e>] ? ocfs2_lookup_lock_orphan_dir+0x6e/0x1b0 [ocfs2]
> [<ffffffffa0a6522e>] ? ocfs2_lookup_lock_orphan_dir+0x6e/0x1b0 [ocfs2]
> [<ffffffffa0a67a1a>] ? ocfs2_prepare_orphan_dir+0x4a/0x290 [ocfs2]
> [<ffffffffa0a6a621>] ? ocfs2_unlink+0x6e1/0xbb0 [ocfs2]
> [<ffffffff811bcfea>] ? may_link+0xda/0x170
> [<ffffffff81141c8e>] ? vfs_unlink+0x9e/0x100
> [<ffffffff81145881>] ? do_unlinkat+0x1a1/0x1d0
> [<ffffffff81147b00>] ? vfs_readdir+0xa0/0xe0
> [<ffffffff8116fedb>] ? fsnotify_find_inode_mark+0x2b/0x40
> [<ffffffff81496912>] ? system_call_fastpath+0x16/0x1b
> 
> 
> [6.] A small shell script or example program which triggers the
>     problem (if possible)
> TEST-MAIL1 ~ #cat ocfs2-test.sh
> #!/bin/bash
> while true
> do
> rm -rf /mnt/EMC/TEST-MAIL1
> mkdir /mnt/EMC/TEST-MAIL1
> cp -r /usr/src/linux-3.1.5 /mnt/EMC/MAIL1
> rm -rf /mnt/EMC/TEST-MAIL1
> done;
> 
> TEST-MAIL2 ~ #cat ocfs2-test.sh
> #!/bin/bash
> while true
> do
> rm -rf /mnt/EMC/TEST-MAIL2
> mkdir /mnt/EMC/TEST-MAIL2
> cp -r /usr/src/linux-3.1.5 /mnt/EMC/MAIL2
> rm -rf /mnt/EMC/TEST-MAIL2
> done;
> 
> 
> [7.] Environment
> TEST-MAIL1 ~ # export
> declare -x CONFIG_PROTECT="/var/bind
> /var/www/localhost/htdocs/squirrelmail/config"
> declare -x CONFIG_PROTECT_MASK="/etc/gentoo-release /etc/sandbox.d
> /etc/php/cli-php5.3/ext-active/ /etc/php/cgi-php5.3/ext-active/
> /etc/php/apache2-php5.3/ext-active/ /etc/terminfo
> /etc/ca-certificates.conf /etc/revdep-rebuild"
> declare -x EDITOR="/bin/nano"
> declare -x GCC_SPECS=""
> declare -x HOME="/root"
> declare -x INFOPATH="/usr/share/info:/usr/share/binutils-data/x86_64-pc-linux-gnu/2.21.1/info:/usr/share/gcc-data/x86_64-pc-linux-gnu/4.4.5/info"
> declare -x LANG="pl_PL"
> declare -x LC_ALL="pl_PL"
> declare -x LESS="-R -M --shift 5"
> declare -x LESSOPEN="|lesspipe %s"
> declare -x LOGNAME="root"
> declare -x LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=
> 01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
> declare -x MAIL="/var/mail/root"
> declare -x MANPATH="/usr/local/share/man:/usr/share/man:/usr/share/binutils-data/x86_64-pc-linux-gnu/2.21.1/man:/usr/share/gcc-data/x86_64-pc-linux-gnu/4.4.5/man:/usr/lib64/php5.3/man/"
> declare -x OLDPWD
> declare -x PAGER="/usr/bin/less"
> declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.4.5"
> declare -x PWD="/root"
> declare -x SHELL="/bin/bash"
> declare -x SHLVL="1"
> declare -x SSH_CLIENT="172.23.1.146 57479 22"
> declare -x SSH_CONNECTION="172.23.1.146 57479 172.17.1.251 22"
> declare -x SSH_TTY="/dev/pts/2"
> declare -x TERM="xterm"
> declare -x USER="root"
> 
> TEST-MAIL2 ~ # export
> declare -x CONFIG_PROTECT="/var/bind
> /var/www/localhost/htdocs/squirrelmail/config"
> declare -x CONFIG_PROTECT_MASK="/etc/gentoo-release /etc/sandbox.d
> /etc/php/cli-php5.3/ext-active/ /etc/php/cgi-php5.3/ext-active/
> /etc/php/apache2-php5.3/ext-active/ /etc/terminfo
> /etc/ca-certificates.conf /etc/revdep-rebuild"
> declare -x EDITOR="/bin/nano"
> declare -x GCC_SPECS=""
> declare -x HOME="/root"
> declare -x INFOPATH="/usr/share/info:/usr/share/binutils-data/x86_64-pc-linux-gnu/2.21.1/info:/usr/share/gcc-data/x86_64-pc-linux-gnu/4.4.5/info"
> declare -x LANG="pl_PL"
> declare -x LC_ALL="pl_PL"
> declare -x LESS="-R -M --shift 5"
> declare -x LESSOPEN="|lesspipe %s"
> declare -x LOGNAME="root"
> declare -x LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=
> 01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
> declare -x MAIL="/var/mail/root"
> declare -x MANPATH="/usr/local/share/man:/usr/share/man:/usr/share/binutils-data/x86_64-pc-linux-gnu/2.21.1/man:/usr/share/gcc-data/x86_64-pc-linux-gnu/4.4.5/man:/usr/lib64/php5.3/man/"
> declare -x OLDPWD
> declare -x PAGER="/usr/bin/less"
> declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.4.5"
> declare -x PWD="/root"
> declare -x SHELL="/bin/bash"
> declare -x SHLVL="1"
> declare -x SSH_CLIENT="172.23.1.146 57482 22"
> declare -x SSH_CONNECTION="172.23.1.146 57482 172.17.1.252 22"
> declare -x SSH_TTY="/dev/pts/0"
> declare -x TERM="xterm"
> declare -x USER="root"
> 
> 
> [7.1.] Software (add the output of the ver_linux script here)
> 
> TEST-MAIL1 scripts # ./ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux TEST-MAIL1 3.1.5 #1 SMP Mon Dec 19 17:16:12 CET 2011 x86_64
> Intel(R) Xeon(R) CPU X5650 @ 2.67GHz GenuineIntel GNU/Linux
> 
> Gnu C                  4.4.5
> Gnu make               3.82
> binutils               2.21.1
> util-linux             2.19.1
> mount                  support
> module-init-tools      3.16
> e2fsprogs              1.41.14
> Linux C Library        2.13
> Dynamic linker (ldd)   2.13
> Procps                 3.2.8
> Net-tools              1.60_p20110409135728
> Kbd                    1.15.3wip
> Sh-utils               8.7
> Modules Loaded         ocfs2_stack_o2cb ip_vs_wrr ip_vs nf_conntrack
> ipv6 8021q garp stp llc dm_round_robin scsi_dh_emc dlm ocfs2_dlm
> ocfs2 ocfs2_dlmfs ocfs2_stackglue ocfs2_nodemanager configfs
> dm_multipath bfa snd_pcm bnx2 snd_timer cdc_ether i2c_i801 i2c_core
> usbnet mii snd soundcore snd_page_alloc ioatdma iTCO_wdt
> iTCO_vendor_support serio_raw i7core_edac edac_core dca pcspkr
> iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi tg3 e1000 fuse
> xfs exportfs nfs nfs_acl auth_rpcgss fscache lockd sunrpc reiserfs
> btrfs libcrc32c zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor xor
> async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror
> dm_region_hash dm_log dm_mod scsi_wait_scan sl811_hcd usb_storage
> aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm
> aacraid sx8 hpsa cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas
> mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase imm parport
> sym53c8xx initio arcmsr aic7xxx aic79xx scsi_transport_spi sr_mod
> cdrom sg sd_mod crc_t10dif pdc_adma sata_inic162x sata_mv ata_piix
> ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv
> sata_via sata_svw sata_sil24 sata_sil sata_promise pata_via
> pata_jmicron pata_marvell pata_sis pata_netcell pata_pdc202xx_old
> pata_atiixp pata_amd pata_ali pata_it8213 pata_pcmcia
> pata_serverworks pata_oldpiix pata_artop pata_it821x pata_hpt3x2n
> pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_sil680
> pata_pdc2027x
> 
> TEST-MAIL2 scripts # ./ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux TEST-MAIL2 3.1.5 #1 SMP Mon Dec 19 17:16:06 CET 2011 x86_64
> Intel(R) Xeon(R) CPU X5650 @ 2.67GHz GenuineIntel GNU/Linux
> 
> Gnu C                  4.4.5
> Gnu make               3.82
> binutils               2.21.1
> util-linux             2.19.1
> mount                  support
> module-init-tools      3.16
> e2fsprogs              1.41.14
> Linux C Library        2.13
> Dynamic linker (ldd)   2.13
> Procps                 3.2.8
> Net-tools              1.60_p20110409135728
> Kbd                    1.15.3wip
> Sh-utils               8.7
> Modules Loaded         ocfs2_stack_o2cb ip_vs_wrr ip_vs nf_conntrack
> ipv6 8021q garp stp llc dm_round_robin scsi_dh_emc dlm ocfs2_dlm
> ocfs2 ocfs2_dlmfs ocfs2_stackglue ocfs2_nodemanager configfs
> dm_multipath bfa ioatdma cdc_ether usbnet snd_pcm snd_timer dca
> i2c_i801 snd bnx2 iTCO_wdt iTCO_vendor_support i7core_edac edac_core
> mii i2c_core soundcore snd_page_alloc pcspkr serio_raw iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi tg3 e1000 fuse xfs
> exportfs nfs nfs_acl auth_rpcgss fscache lockd sunrpc reiserfs btrfs
> libcrc32c zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor xor
> async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror
> dm_region_hash dm_log dm_mod scsi_wait_scan sl811_hcd usb_storage
> aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm
> aacraid sx8 hpsa cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas
> mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase imm parport
> sym53c8xx initio arcmsr aic7xxx aic79xx scsi_transport_spi sr_mod
> cdrom sg sd_mod crc_t10dif pdc_adma sata_inic162x sata_mv ata_piix
> ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv
> sata_via sata_svw sata_sil24 sata_sil sata_promise pata_via
> pata_jmicron pata_marvell pata_sis pata_netcell pata_pdc202xx_old
> pata_atiixp pata_amd pata_ali pata_it8213 pata_pcmcia
> pata_serverworks pata_oldpiix pata_artop pata_it821x pata_hpt3x2n
> pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_sil680
> pata_pdc2027x
> 
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> TEST-MAIL1 ~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 44
> model name      : Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
> stepping        : 2
> cpu MHz         : 2666.752
> cache size      : 12288 KB
> physical id     : 0
> siblings        : 12
> core id         : 0
> cpu cores       : 6
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
> pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64
> monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1
> sse4_2 popcnt aes lahf_lm arat epb dts tpr_shadow vnmi flexpriority
> ept vpid
> bogomips        : 5333.50
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management:
> [CUT]
> processor       : 23
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 44
> model name      : Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
> stepping        : 2
> cpu MHz         : 2666.752
> cache size      : 12288 KB
> physical id     : 1
> siblings        : 12
> core id         : 10
> cpu cores       : 6
> apicid          : 53
> initial apicid  : 53
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
> pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64
> monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1
> sse4_2 popcnt aes lahf_lm arat epb dts tpr_shadow vnmi flexpriority
> ept vpid
> bogomips        : 5333.19
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management:
> 
> TEST-MAIL2 ~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 44
> model name      : Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
> stepping        : 2
> cpu MHz         : 2666.394
> cache size      : 12288 KB
> physical id     : 0
> siblings        : 12
> core id         : 0
> cpu cores       : 6
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
> pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64
> monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1
> sse4_2 popcnt aes lahf_lm arat epb dts tpr_shadow vnmi flexpriority
> ept vpid
> bogomips        : 5332.78
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management:
> [CUT]
> processor       : 23
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 44
> model name      : Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
> stepping        : 2
> cpu MHz         : 2666.394
> cache size      : 12288 KB
> physical id     : 1
> siblings        : 12
> core id         : 10
> cpu cores       : 6
> apicid          : 53
> initial apicid  : 53
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
> pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64
> monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1
> sse4_2 popcnt aes lahf_lm arat epb dts tpr_shadow vnmi flexpriority
> ept vpid
> bogomips        : 5333.19
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management:
> 
> 
> [7.3.] Module information (from /proc/modules):
> TEST-MAIL1 ~ # cat /proc/modules
> ocfs2_stack_o2cb 3678 1 - Live 0xffffffffa0043000
> ip_vs_wrr 2001 12 - Live 0xffffffffa002f000
> ip_vs 126566 14 ip_vs_wrr, Live 0xffffffffa0b20000
> nf_conntrack 77276 1 ip_vs, Live 0xffffffffa05a7000
> ipv6 315785 79 ip_vs, Live 0xffffffffa0b93000
> 8021q 19111 0 - Live 0xffffffffa0183000
> garp 6985 1 8021q, Live 0xffffffffa008f000
> stp 2059 1 garp, Live 0xffffffffa000d000
> llc 5480 2 garp,stp, Live 0xffffffffa0029000
> dm_round_robin 2347 2 - Live 0xffffffffa0003000
> scsi_dh_emc 7487 4 - Live 0xffffffffa0049000
> dlm 140410 0 - Live 0xffffffffa0870000
> ocfs2_dlm 215959 1 ocfs2_stack_o2cb, Live 0xffffffffa0b5d000
> ocfs2 1087698 3 - Live 0xffffffffa0a15000
> ocfs2_dlmfs 18832 1 - Live 0xffffffffa015e000
> ocfs2_stackglue 11208 3 ocfs2_stack_o2cb,ocfs2,ocfs2_dlmfs, Live
> 0xffffffffa0117000
> ocfs2_nodemanager 217156 12
> ocfs2_stack_o2cb,ocfs2_dlm,ocfs2,ocfs2_dlmfs, Live
> 0xffffffffa09de000
> configfs 27116 3 dlm,ocfs2_nodemanager, Live 0xffffffffa02d7000
> dm_multipath 17309 2 dm_round_robin, Live 0xffffffffa0065000
> bfa 515624 4 - Live 0xffffffffa095f000
> snd_pcm 78397 0 - Live 0xffffffffa03e2000
> bnx2 75992 0 - Live 0xffffffffa079a000
> snd_timer 21141 1 snd_pcm, Live 0xffffffffa04d8000
> cdc_ether 8563 0 - Live 0xffffffffa010a000
> i2c_i801 10128 0 - Live 0xffffffffa00d5000
> i2c_core 29192 1 i2c_i801, Live 0xffffffffa0539000
> usbnet 27108 1 cdc_ether, Live 0xffffffffa0466000
> mii 5102 1 usbnet, Live 0xffffffffa0079000
> snd 63536 2 snd_pcm,snd_timer, Live 0xffffffffa06e9000
> soundcore 7444 1 snd, Live 0xffffffffa003e000
> snd_page_alloc 8132 1 snd_pcm, Live 0xffffffffa0019000
> ioatdma 49259 48 - Live 0xffffffffa01cd000
> iTCO_wdt 12226 0 - Live 0xffffffffa095b000
> iTCO_vendor_support 2878 1 iTCO_wdt, Live 0xffffffffa00fe000
> serio_raw 4352 0 - Live 0xffffffffa0956000
> i7core_edac 17774 0 - Live 0xffffffffa094d000
> edac_core 44779 4 i7core_edac, Live 0xffffffffa093a000
> dca 6700 1 ioatdma, Live 0xffffffffa020a000
> pcspkr 1886 0 - Live 0xffffffffa00b3000
> iscsi_tcp 9442 0 - Live 0xffffffffa0193000
> libiscsi_tcp 15334 1 iscsi_tcp, Live 0xffffffffa0255000
> libiscsi 44632 2 iscsi_tcp,libiscsi_tcp, Live 0xffffffffa091f000
> scsi_transport_iscsi 36811 2 iscsi_tcp,libiscsi, Live 0xffffffffa090f000
> tg3 143267 0 - Live 0xffffffffa08e4000
> e1000 145820 0 - Live 0xffffffffa08b5000
> fuse 68687 1 - Live 0xffffffffa089c000
> xfs 764761 0 - Live 0xffffffffa07b4000
> exportfs 3934 1 xfs, Live 0xffffffffa0073000
> nfs 394497 0 - Live 0xffffffffa0738000
> nfs_acl 2597 1 nfs, Live 0xffffffffa006b000
> auth_rpcgss 43042 1 nfs, Live 0xffffffffa072c000
> fscache 43963 1 nfs, Live 0xffffffffa0719000
> lockd 75497 1 nfs, Live 0xffffffffa06fe000
> sunrpc 229010 5 nfs,nfs_acl,auth_rpcgss,lockd, Live 0xffffffffa06b0000
> reiserfs 219451 0 - Live 0xffffffffa066f000
> btrfs 589407 0 - Live 0xffffffffa05c6000
> libcrc32c 1196 1 btrfs, Live 0xffffffffa005b000
> zlib_deflate 21895 1 btrfs, Live 0xffffffffa05bf000
> ext4 409404 0 - Live 0xffffffffa0542000
> jbd2 78658 2 ocfs2,ext4, Live 0xffffffffa0524000
> ext3 210941 1 - Live 0xffffffffa04e0000
> jbd 67340 1 ext3, Live 0xffffffffa04c6000
> ext2 64947 0 - Live 0xffffffffa04af000
> mbcache 6958 3 ext4,ext3,ext2, Live 0xffffffffa0126000
> raid10 26340 0 - Live 0xffffffffa04a7000
> raid456 62193 0 - Live 0xffffffffa0496000
> async_raid6_recov 6473 1 raid456, Live 0xffffffffa00f4000
> async_memcpy 1898 2 raid456,async_raid6_recov, Live 0xffffffffa0033000
> async_pq 4533 2 raid456,async_raid6_recov, Live 0xffffffffa009b000
> async_xor 3682 3 raid456,async_raid6_recov,async_pq, Live 0xffffffffa0023000
> xor 4541 1 async_xor, Live 0xffffffffa0087000
> async_tx 2878 5
> raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live
> 0xffffffffa0012000
> raid6_pq 79891 2 async_raid6_recov,async_pq, Live 0xffffffffa0481000
> raid1 25867 0 - Live 0xffffffffa0479000
> raid0 8154 0 - Live 0xffffffffa0050000
> dm_snapshot 29422 0 - Live 0xffffffffa0470000
> dm_crypt 16644 0 - Live 0xffffffffa01db000
> dm_mirror 13796 0 - Live 0xffffffffa01b5000
> dm_region_hash 10323 1 dm_mirror, Live 0xffffffffa00e0000
> dm_log 9246 2 dm_mirror,dm_region_hash, Live 0xffffffffa00ca000
> dm_mod 75518 7 dm_multipath,dm_snapshot,dm_crypt,dm_mirror,dm_log,
> Live 0xffffffffa0436000
> scsi_wait_scan 749 0 - Live 0xffffffffa0008000
> sl811_hcd 10688 0 - Live 0xffffffffa00a5000
> usb_storage 50158 0 - Live 0xffffffffa0428000
> aic94xx 79911 0 - Live 0xffffffffa0413000
> libsas 59814 1 aic94xx, Live 0xffffffffa0403000
> lpfc 564581 0 - Live 0xffffffffa0357000
> qla2xxx 369523 0 - Live 0xffffffffa02fb000
> megaraid_sas 74186 1 - Live 0xffffffffa02e2000
> megaraid_mbox 30716 0 - Live 0xffffffffa02ce000
> megaraid_mm 9579 1 megaraid_mbox, Live 0xffffffffa02c7000
> aacraid 78932 0 - Live 0xffffffffa02ac000
> sx8 14069 0 - Live 0xffffffffa02a4000
> hpsa 45153 0 - Live 0xffffffffa0293000
> cciss 107100 0 - Live 0xffffffffa0272000
> 3w_9xxx 35289 0 - Live 0xffffffffa0265000
> 3w_xxxx 28359 0 - Live 0xffffffffa025a000
> mptsas 52240 0 - Live 0xffffffffa0247000
> scsi_transport_sas 31289 3 aic94xx,libsas,mptsas, Live 0xffffffffa0238000
> mptfc 14347 0 - Live 0xffffffffa0230000
> scsi_transport_fc 48157 4 bfa,lpfc,qla2xxx,mptfc, Live 0xffffffffa021d000
> scsi_tgt 11726 1 scsi_transport_fc, Live 0xffffffffa0216000
> mptspi 16078 0 - Live 0xffffffffa020e000
> mptscsih 36316 3 mptsas,mptfc,mptspi, Live 0xffffffffa0200000
> mptbase 95142 4 mptsas,mptfc,mptspi,mptscsih, Live 0xffffffffa01e1000
> imm 10725 0 - Live 0xffffffffa01c9000
> parport 34760 1 imm, Live 0xffffffffa01ba000
> sym53c8xx 76324 0 - Live 0xffffffffa01a1000
> initio 20670 0 - Live 0xffffffffa0197000
> arcmsr 30044 0 - Live 0xffffffffa018a000
> aic7xxx 117148 0 - Live 0xffffffffa0165000
> aic79xx 128507 0 - Live 0xffffffffa013d000
> scsi_transport_spi 24324 4 mptspi,sym53c8xx,aic7xxx,aic79xx, Live
> 0xffffffffa0132000
> sr_mod 15342 0 - Live 0xffffffffa012a000
> cdrom 40595 1 sr_mod, Live 0xffffffffa011b000
> sg 29553 0 - Live 0xffffffffa010e000
> sd_mod 36634 6 - Live 0xffffffffa0100000
> crc_t10dif 1491 1 sd_mod, Live 0xffffffffa00fc000
> pdc_adma 6277 0 - Live 0xffffffffa00f7000
> sata_inic162x 8215 0 - Live 0xffffffffa00f0000
> sata_mv 28039 0 - Live 0xffffffffa00e4000
> ata_piix 23192 0 - Live 0xffffffffa00d9000
> ahci 20980 0 - Live 0xffffffffa00ce000
> libahci 23551 1 ahci, Live 0xffffffffa00c3000
> sata_qstor 6155 0 - Live 0xffffffffa00be000
> sata_vsc 4404 0 - Live 0xffffffffa00b9000
> sata_uli 3335 0 - Live 0xffffffffa00b5000
> sata_sis 4109 0 - Live 0xffffffffa00b0000
> sata_sx4 10018 0 - Live 0xffffffffa00a9000
> sata_nv 21903 0 - Live 0xffffffffa009e000
> sata_via 9479 0 - Live 0xffffffffa0097000
> sata_svw 4622 0 - Live 0xffffffffa0092000
> sata_sil24 12295 0 - Live 0xffffffffa008a000
> sata_sil 8556 0 - Live 0xffffffffa0083000
> sata_promise 11313 0 - Live 0xffffffffa007c000
> pata_via 9828 0 - Live 0xffffffffa0075000
> pata_jmicron 2699 0 - Live 0xffffffffa0071000
> pata_marvell 3273 0 - Live 0xffffffffa006d000
> pata_sis 11936 1 sata_sis, Live 0xffffffffa0061000
> pata_netcell 2492 0 - Live 0xffffffffa005d000
> pata_pdc202xx_old 5185 0 - Live 0xffffffffa0058000
> pata_atiixp 4237 0 - Live 0xffffffffa0053000
> pata_amd 11719 0 - Live 0xffffffffa004c000
> pata_ali 10460 0 - Live 0xffffffffa0045000
> pata_it8213 3935 0 - Live 0xffffffffa0041000
> pata_pcmcia 10194 0 - Live 0xffffffffa003a000
> pata_serverworks 6429 0 - Live 0xffffffffa0035000
> pata_oldpiix 3586 0 - Live 0xffffffffa0031000
> pata_artop 5498 0 - Live 0xffffffffa002c000
> pata_it821x 10439 0 - Live 0xffffffffa0025000
> pata_hpt3x2n 6180 0 - Live 0xffffffffa0020000
> pata_hpt3x3 3518 0 - Live 0xffffffffa001c000
> pata_hpt37x 12638 0 - Live 0xffffffffa0014000
> pata_hpt366 5761 0 - Live 0xffffffffa000f000
> pata_cmd64x 6762 0 - Live 0xffffffffa000a000
> pata_sil680 5756 0 - Live 0xffffffffa0005000
> pata_pdc2027x 7098 0 - Live 0xffffffffa0000000
> 
> TEST-MAIL2 ~ # cat /proc/modules
> ocfs2_stack_o2cb 3678 1 - Live 0xffffffffa0043000
> ip_vs_wrr 2001 0 - Live 0xffffffffa002f000
> ip_vs 126566 2 ip_vs_wrr, Live 0xffffffffa0b2c000
> nf_conntrack 77276 1 ip_vs, Live 0xffffffffa06e9000
> ipv6 315785 79 ip_vs, Live 0xffffffffa0b9f000
> 8021q 19111 0 - Live 0xffffffffa01d5000
> garp 6985 1 8021q, Live 0xffffffffa0079000
> stp 2059 1 garp, Live 0xffffffffa000d000
> llc 5480 2 garp,stp, Live 0xffffffffa0019000
> dm_round_robin 2347 2 - Live 0xffffffffa0003000
> scsi_dh_emc 7487 4 - Live 0xffffffffa0029000
> dlm 140410 0 - Live 0xffffffffa0870000
> ocfs2_dlm 215959 1 ocfs2_stack_o2cb, Live 0xffffffffa0b69000
> ocfs2 1087698 3 - Live 0xffffffffa0a21000
> ocfs2_dlmfs 18832 1 - Live 0xffffffffa0183000
> ocfs2_stackglue 11208 3 ocfs2_stack_o2cb,ocfs2,ocfs2_dlmfs, Live
> 0xffffffffa010a000
> ocfs2_nodemanager 217156 12
> ocfs2_stack_o2cb,ocfs2_dlm,ocfs2,ocfs2_dlmfs, Live
> 0xffffffffa09ea000
> configfs 27116 3 dlm,ocfs2_nodemanager, Live 0xffffffffa01cd000
> dm_multipath 17309 2 dm_round_robin, Live 0xffffffffa0065000
> bfa 515624 4 - Live 0xffffffffa0957000
> ioatdma 49259 48 - Live 0xffffffffa044a000
> cdc_ether 8563 0 - Live 0xffffffffa01fa000
> usbnet 27108 1 cdc_ether, Live 0xffffffffa02d7000
> snd_pcm 78397 0 - Live 0xffffffffa05a7000
> snd_timer 21141 1 snd_pcm, Live 0xffffffffa015e000
> dca 6700 1 ioatdma, Live 0xffffffffa003e000
> i2c_i801 10128 0 - Live 0xffffffffa00d5000
> snd 63536 2 snd_pcm,snd_timer, Live 0xffffffffa045e000
> bnx2 75992 0 - Live 0xffffffffa03e2000
> iTCO_wdt 12226 0 - Live 0xffffffffa0953000
> iTCO_vendor_support 2878 1 iTCO_wdt, Live 0xffffffffa00fe000
> i7core_edac 17774 0 - Live 0xffffffffa02c1000
> edac_core 44779 4 i7core_edac, Live 0xffffffffa0940000
> mii 5102 1 usbnet, Live 0xffffffffa028e000
> i2c_core 29192 1 i2c_i801, Live 0xffffffffa0931000
> soundcore 7444 1 snd, Live 0xffffffffa0262000
> snd_page_alloc 8132 1 snd_pcm, Live 0xffffffffa021a000
> pcspkr 1886 0 - Live 0xffffffffa00b7000
> serio_raw 4352 0 - Live 0xffffffffa020a000
> iscsi_tcp 9442 0 - Live 0xffffffffa0193000
> libiscsi_tcp 15334 1 iscsi_tcp, Live 0xffffffffa0255000
> libiscsi 44632 2 iscsi_tcp,libiscsi_tcp, Live 0xffffffffa091f000
> scsi_transport_iscsi 36811 2 iscsi_tcp,libiscsi, Live 0xffffffffa090f000
> tg3 143267 0 - Live 0xffffffffa08e4000
> e1000 145820 0 - Live 0xffffffffa08b5000
> fuse 68687 1 - Live 0xffffffffa089c000
> xfs 764761 0 - Live 0xffffffffa07b4000
> exportfs 3934 1 xfs, Live 0xffffffffa0073000
> nfs 394497 0 - Live 0xffffffffa0738000
> nfs_acl 2597 1 nfs, Live 0xffffffffa006b000
> auth_rpcgss 43042 1 nfs, Live 0xffffffffa072c000
> fscache 43963 1 nfs, Live 0xffffffffa0719000
> lockd 75497 1 nfs, Live 0xffffffffa06fe000
> sunrpc 229010 5 nfs,nfs_acl,auth_rpcgss,lockd, Live 0xffffffffa06b0000
> reiserfs 219451 0 - Live 0xffffffffa066f000
> btrfs 589407 0 - Live 0xffffffffa05c6000
> libcrc32c 1196 1 btrfs, Live 0xffffffffa005b000
> zlib_deflate 21895 1 btrfs, Live 0xffffffffa05bf000
> ext4 409404 0 - Live 0xffffffffa0542000
> jbd2 78658 2 ocfs2,ext4, Live 0xffffffffa0524000
> ext3 210941 1 - Live 0xffffffffa04e0000
> jbd 67340 1 ext3, Live 0xffffffffa04c6000
> ext2 64947 0 - Live 0xffffffffa04af000
> mbcache 6958 3 ext4,ext3,ext2, Live 0xffffffffa0126000
> raid10 26340 0 - Live 0xffffffffa04a7000
> raid456 62193 0 - Live 0xffffffffa0496000
> async_raid6_recov 6473 1 raid456, Live 0xffffffffa00f4000
> async_memcpy 1898 2 raid456,async_raid6_recov, Live 0xffffffffa0033000
> async_pq 4533 2 raid456,async_raid6_recov, Live 0xffffffffa009b000
> async_xor 3682 3 raid456,async_raid6_recov,async_pq, Live 0xffffffffa0023000
> xor 4541 1 async_xor, Live 0xffffffffa0087000
> async_tx 2878 5
> raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live
> 0xffffffffa0012000
> raid6_pq 79891 2 async_raid6_recov,async_pq, Live 0xffffffffa0481000
> raid1 25867 0 - Live 0xffffffffa0479000
> raid0 8154 0 - Live 0xffffffffa0050000
> dm_snapshot 29422 0 - Live 0xffffffffa0470000
> dm_crypt 16644 0 - Live 0xffffffffa01db000
> dm_mirror 13796 0 - Live 0xffffffffa01b5000
> dm_region_hash 10323 1 dm_mirror, Live 0xffffffffa00e0000
> dm_log 9246 2 dm_mirror,dm_region_hash, Live 0xffffffffa00ca000
> dm_mod 75518 7 dm_multipath,dm_snapshot,dm_crypt,dm_mirror,dm_log,
> Live 0xffffffffa0436000
> scsi_wait_scan 749 0 - Live 0xffffffffa0008000
> sl811_hcd 10688 0 - Live 0xffffffffa00a5000
> usb_storage 50158 0 - Live 0xffffffffa0428000
> aic94xx 79911 0 - Live 0xffffffffa0413000
> libsas 59814 1 aic94xx, Live 0xffffffffa0403000
> lpfc 564581 0 - Live 0xffffffffa0357000
> qla2xxx 369523 0 - Live 0xffffffffa02fb000
> megaraid_sas 74186 1 - Live 0xffffffffa02e2000
> megaraid_mbox 30716 0 - Live 0xffffffffa02ce000
> megaraid_mm 9579 1 megaraid_mbox, Live 0xffffffffa02c7000
> aacraid 78932 0 - Live 0xffffffffa02ac000
> sx8 14069 0 - Live 0xffffffffa02a4000
> hpsa 45153 0 - Live 0xffffffffa0293000
> cciss 107100 0 - Live 0xffffffffa0272000
> 3w_9xxx 35289 0 - Live 0xffffffffa0265000
> 3w_xxxx 28359 0 - Live 0xffffffffa025a000
> mptsas 52240 0 - Live 0xffffffffa0247000
> scsi_transport_sas 31289 3 aic94xx,libsas,mptsas, Live 0xffffffffa0238000
> mptfc 14347 0 - Live 0xffffffffa0230000
> scsi_transport_fc 48157 4 bfa,lpfc,qla2xxx,mptfc, Live 0xffffffffa021d000
> scsi_tgt 11726 1 scsi_transport_fc, Live 0xffffffffa0216000
> mptspi 16078 0 - Live 0xffffffffa020e000
> mptscsih 36316 3 mptsas,mptfc,mptspi, Live 0xffffffffa0200000
> mptbase 95142 4 mptsas,mptfc,mptspi,mptscsih, Live 0xffffffffa01e1000
> imm 10725 0 - Live 0xffffffffa01c9000
> parport 34760 1 imm, Live 0xffffffffa01ba000
> sym53c8xx 76324 0 - Live 0xffffffffa01a1000
> initio 20670 0 - Live 0xffffffffa0197000
> arcmsr 30044 0 - Live 0xffffffffa018a000
> aic7xxx 117148 0 - Live 0xffffffffa0165000
> aic79xx 128507 0 - Live 0xffffffffa013d000
> scsi_transport_spi 24324 4 mptspi,sym53c8xx,aic7xxx,aic79xx, Live
> 0xffffffffa0132000
> sr_mod 15342 0 - Live 0xffffffffa012a000
> cdrom 40595 1 sr_mod, Live 0xffffffffa011b000
> sg 29553 0 - Live 0xffffffffa010e000
> sd_mod 36634 6 - Live 0xffffffffa0100000
> crc_t10dif 1491 1 sd_mod, Live 0xffffffffa00fc000
> pdc_adma 6277 0 - Live 0xffffffffa00f7000
> sata_inic162x 8215 0 - Live 0xffffffffa00f0000
> sata_mv 28039 0 - Live 0xffffffffa00e4000
> ata_piix 23192 0 - Live 0xffffffffa00d9000
> ahci 20980 0 - Live 0xffffffffa00ce000
> libahci 23551 1 ahci, Live 0xffffffffa00c3000
> sata_qstor 6155 0 - Live 0xffffffffa00be000
> sata_vsc 4404 0 - Live 0xffffffffa00b9000
> sata_uli 3335 0 - Live 0xffffffffa00b5000
> sata_sis 4109 0 - Live 0xffffffffa00b0000
> sata_sx4 10018 0 - Live 0xffffffffa00a9000
> sata_nv 21903 0 - Live 0xffffffffa009e000
> sata_via 9479 0 - Live 0xffffffffa0097000
> sata_svw 4622 0 - Live 0xffffffffa0092000
> sata_sil24 12295 0 - Live 0xffffffffa008a000
> sata_sil 8556 0 - Live 0xffffffffa0083000
> sata_promise 11313 0 - Live 0xffffffffa007c000
> pata_via 9828 0 - Live 0xffffffffa0075000
> pata_jmicron 2699 0 - Live 0xffffffffa0071000
> pata_marvell 3273 0 - Live 0xffffffffa006d000
> pata_sis 11936 1 sata_sis, Live 0xffffffffa0061000
> pata_netcell 2492 0 - Live 0xffffffffa005d000
> pata_pdc202xx_old 5185 0 - Live 0xffffffffa0058000
> pata_atiixp 4237 0 - Live 0xffffffffa0053000
> pata_amd 11719 0 - Live 0xffffffffa004c000
> pata_ali 10460 0 - Live 0xffffffffa0045000
> pata_it8213 3935 0 - Live 0xffffffffa0041000
> pata_pcmcia 10194 0 - Live 0xffffffffa003a000
> pata_serverworks 6429 0 - Live 0xffffffffa0035000
> pata_oldpiix 3586 0 - Live 0xffffffffa0031000
> pata_artop 5498 0 - Live 0xffffffffa002c000
> pata_it821x 10439 0 - Live 0xffffffffa0025000
> pata_hpt3x2n 6180 0 - Live 0xffffffffa0020000
> pata_hpt3x3 3518 0 - Live 0xffffffffa001c000
> pata_hpt37x 12638 0 - Live 0xffffffffa0014000
> pata_hpt366 5761 0 - Live 0xffffffffa000f000
> pata_cmd64x 6762 0 - Live 0xffffffffa000a000
> pata_sil680 5756 0 - Live 0xffffffffa0005000
> pata_pdc2027x 7098 0 - Live 0xffffffffa0000000
> 
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> TEST-MAIL1 ~ # cat /proc/ioports
> 0000-0cf7 : PCI Bus 0000:00
>  0000-001f : dma1
>  0020-0021 : pic1
>  0040-0043 : timer0
>  0050-0053 : timer1
>  0060-0060 : keyboard
>  0064-0064 : keyboard
>  0070-0077 : rtc0
>  0080-008f : dma page reg
>  00a0-00a1 : pic2
>  00c0-00df : dma2
>  00f0-00ff : fpu
>  0170-0177 : 0000:00:1f.2
>    0170-0177 : ata_piix
>  01f0-01f7 : 0000:00:1f.2
>    01f0-01f7 : ata_piix
>  02f8-02ff : serial
>  0376-0376 : 0000:00:1f.2
>    0376-0376 : ata_piix
>  03c0-03df : vga+
>  03f6-03f6 : 0000:00:1f.2
>    03f6-03f6 : ata_piix
>  03f8-03ff : serial
>  0400-043f : pnp 00:06
>  0440-045f : pnp 00:06
>  0460-047f : pnp 00:06
>  0580-05ff : pnp 00:06
>    0580-0583 : ACPI PM1a_EVT_BLK
>    0584-0587 : ACPI PM1a_CNT_BLK
>    0588-058b : ACPI PM_TMR
>    05a0-05af : ACPI GPE0_BLK
>    05b0-05b3 : iTCO_wdt
>    05d0-05d0 : ACPI PM2_CNT_BLK
>    05e0-05ff : pnp 00:06
>      05e0-05ff : iTCO_wdt
>  0ca0-0ca1 : pnp 00:0b
>  0ca2-0ca2 : pnp 00:0c
>  0ca3-0ca3 : pnp 00:0c
>  0ca4-0ca9 : pnp 00:0b
>  0caa-0cab : pnp 00:0b
>  0cac-0ccb : pnp 00:0b
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>  1000-1fff : PCI Bus 0000:01
>    1000-10ff : 0000:01:00.0
>      1000-10ff : megasas: LSI
>  2000-201f : 0000:00:1f.3
>    2000-201f : i801_smbus
>  2020-203f : 0000:00:1d.2
>    2020-203f : uhci_hcd
>  2040-205f : 0000:00:1d.1
>    2040-205f : uhci_hcd
>  2060-207f : 0000:00:1d.0
>    2060-207f : uhci_hcd
>  2080-209f : 0000:00:1a.1
>    2080-209f : uhci_hcd
>  20a0-20bf : 0000:00:1a.0
>    20a0-20bf : uhci_hcd
>  20c0-20cf : 0000:00:1f.5
>    20c0-20cf : ata_piix
>  20d0-20df : 0000:00:1f.5
>    20d0-20df : ata_piix
>  20e0-20ef : 0000:00:1f.2
>    20e0-20ef : ata_piix
>  20f0-20ff : 0000:00:1f.2
>    20f0-20ff : ata_piix
>  2100-2107 : 0000:00:1f.5
>    2100-2107 : ata_piix
>  2108-210f : 0000:00:1f.5
>    2108-210f : ata_piix
>  2120-2123 : 0000:00:1f.5
>    2120-2123 : ata_piix
>  2124-2127 : 0000:00:1f.5
>    2124-2127 : ata_piix
> TEST-MAIL1 ~ # cat /proc/iomem
> 00000000-0000ffff : reserved
> 00010000-0009bfff : System RAM
> 0009c000-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000c7fff : Video ROM
> 000cc800-000d29ff : Adapter ROM
> 000e0000-000fffff : reserved
>  000f0000-000fffff : System ROM
> 00100000-7cb90fff : System RAM
>  01000000-01499782 : Kernel code
>  01499783-01a979bf : Kernel data
>  01b32000-01c6afff : Kernel bss
> 7cb91000-7cc54fff : reserved
> 7cc55000-7d5a2fff : System RAM
> 7d5a3000-7d652fff : reserved
> 7d653000-7f68efff : System RAM
> 7f68f000-7f6defff : reserved
> 7f6df000-7f7defff : ACPI Non-volatile Storage
> 7f7df000-7f7fefff : ACPI Tables
> 7f7ff000-7f7fffff : System RAM
> 7f800000-8fffffff : reserved
>  80000000-8fffffff : PCI MMCONFIG 0000 [bus 00-ff]
>    80000000-8fffffff : pnp 00:0a
> 90000000-fdffffff : PCI Bus 0000:00
>  90000000-900fffff : PCI Bus 0000:15
>    90000000-9007ffff : 0000:15:00.0
>  90100000-901fffff : PCI Bus 0000:1a
>    90100000-9017ffff : 0000:1a:00.0
>  90200000-904fffff : PCI Bus 0000:01
>    90200000-9021ffff : 0000:01:00.0
>  92000000-95ffffff : PCI Bus 0000:0b
>    92000000-93ffffff : 0000:0b:00.0
>      92000000-93ffffff : bnx2
>    94000000-95ffffff : 0000:0b:00.1
>      94000000-95ffffff : bnx2
>  96000000-96ffffff : PCI Bus 0000:06
>    96000000-96ffffff : PCI Bus 0000:07
>      96000000-96ffffff : 0000:07:00.0
>  97000000-978fffff : PCI Bus 0000:06
>    97000000-978fffff : PCI Bus 0000:07
>      97000000-977fffff : 0000:07:00.0
>      97800000-97803fff : 0000:07:00.0
>  97900000-979fffff : PCI Bus 0000:01
>    97900000-9793ffff : 0000:01:00.0
>    97940000-97943fff : 0000:01:00.0
>  97a00000-97afffff : PCI Bus 0000:1a
>    97a00000-97a1ffff : 0000:1a:00.0
>      97a00000-97a1ffff : bfa
>    97a20000-97a3ffff : 0000:1a:00.1
>    97a40000-97a43fff : 0000:1a:00.0
>      97a40000-97a43fff : bfa
>    97a44000-97a47fff : 0000:1a:00.1
>  97b00000-97bfffff : PCI Bus 0000:15
>    97b00000-97b1ffff : 0000:15:00.0
>      97b00000-97b1ffff : bfa
>    97b20000-97b3ffff : 0000:15:00.1
>    97b40000-97b43fff : 0000:15:00.0
>      97b40000-97b43fff : bfa
>    97b44000-97b47fff : 0000:15:00.1
>  97c00000-97c03fff : 0000:00:16.0
>    97c00000-97c03fff : ioatdma
>  97c04000-97c07fff : 0000:00:16.1
>    97c04000-97c07fff : ioatdma
>  97c08000-97c0bfff : 0000:00:16.2
>    97c08000-97c0bfff : ioatdma
>  97c0c000-97c0ffff : 0000:00:16.3
>    97c0c000-97c0ffff : ioatdma
>  97c10000-97c13fff : 0000:00:16.4
>    97c10000-97c13fff : ioatdma
>  97c14000-97c17fff : 0000:00:16.5
>    97c14000-97c17fff : ioatdma
>  97c18000-97c1bfff : 0000:00:16.6
>    97c18000-97c1bfff : ioatdma
>  97c1c000-97c1ffff : 0000:00:16.7
>    97c1c000-97c1ffff : ioatdma
>  97c20000-97c203ff : 0000:00:1d.7
>    97c20000-97c203ff : ehci_hcd
>  97c21000-97c213ff : 0000:00:1a.7
>    97c21000-97c213ff : ehci_hcd
>  97c22000-97c220ff : 0000:00:1f.3
>  fc000000-fcffffff : reserved
>    fc000000-fcffffff : pnp 00:0a
> fe710000-fe711fff : pnp 00:0a
> fe800000-fe9fffff : pnp 00:0a
> fea00000-feafffff : pnp 00:0a
> feb00000-febfffff : pnp 00:0a
> fec00000-fec003ff : IOAPIC 0
> fec80000-fec803ff : IOAPIC 1
> fed00000-fed003ff : HPET 0
>  fed00000-fed003ff : pnp 00:05
> fed1c000-fed1ffff : reserved
>  fed1c000-fed1ffff : pnp 00:0a
> fee00000-feefffff : pnp 00:0a
>  fee00000-fee00fff : Local APIC
> ff800000-ffffffff : reserved
>  ffc00000-ffffffff : pnp 00:0a
> 100000000-107fffffff : System RAM
> 7f00000000-7f00000000 : PCI Bus 0000:00
> 
> TEST-MAIL2 ~ # cat /proc/ioports
> 0000-0cf7 : PCI Bus 0000:00
>  0000-001f : dma1
>  0020-0021 : pic1
>  0040-0043 : timer0
>  0050-0053 : timer1
>  0060-0060 : keyboard
>  0064-0064 : keyboard
>  0070-0077 : rtc0
>  0080-008f : dma page reg
>  00a0-00a1 : pic2
>  00c0-00df : dma2
>  00f0-00ff : fpu
>  0170-0177 : 0000:00:1f.2
>    0170-0177 : ata_piix
>  01f0-01f7 : 0000:00:1f.2
>    01f0-01f7 : ata_piix
>  02f8-02ff : serial
>  0376-0376 : 0000:00:1f.2
>    0376-0376 : ata_piix
>  03c0-03df : vga+
>  03f6-03f6 : 0000:00:1f.2
>    03f6-03f6 : ata_piix
>  03f8-03ff : serial
>  0400-043f : pnp 00:06
>  0440-045f : pnp 00:06
>  0460-047f : pnp 00:06
>  0580-05ff : pnp 00:06
>    0580-0583 : ACPI PM1a_EVT_BLK
>    0584-0587 : ACPI PM1a_CNT_BLK
>    0588-058b : ACPI PM_TMR
>    05a0-05af : ACPI GPE0_BLK
>    05b0-05b3 : iTCO_wdt
>    05d0-05d0 : ACPI PM2_CNT_BLK
>    05e0-05ff : pnp 00:06
>      05e0-05ff : iTCO_wdt
>  0ca0-0ca1 : pnp 00:0b
>  0ca2-0ca2 : pnp 00:0c
>  0ca3-0ca3 : pnp 00:0c
>  0ca4-0ca9 : pnp 00:0b
>  0caa-0cab : pnp 00:0b
>  0cac-0ccb : pnp 00:0b
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>  1000-1fff : PCI Bus 0000:01
>    1000-10ff : 0000:01:00.0
>      1000-10ff : megasas: LSI
>  2000-201f : 0000:00:1f.3
>    2000-201f : i801_smbus
>  2020-203f : 0000:00:1d.2
>    2020-203f : uhci_hcd
>  2040-205f : 0000:00:1d.1
>    2040-205f : uhci_hcd
>  2060-207f : 0000:00:1d.0
>    2060-207f : uhci_hcd
>  2080-209f : 0000:00:1a.1
>    2080-209f : uhci_hcd
>  20a0-20bf : 0000:00:1a.0
>    20a0-20bf : uhci_hcd
>  20c0-20cf : 0000:00:1f.5
>    20c0-20cf : ata_piix
>  20d0-20df : 0000:00:1f.5
>    20d0-20df : ata_piix
>  20e0-20ef : 0000:00:1f.2
>    20e0-20ef : ata_piix
>  20f0-20ff : 0000:00:1f.2
>    20f0-20ff : ata_piix
>  2100-2107 : 0000:00:1f.5
>    2100-2107 : ata_piix
>  2108-210f : 0000:00:1f.5
>    2108-210f : ata_piix
>  2120-2123 : 0000:00:1f.5
>    2120-2123 : ata_piix
>  2124-2127 : 0000:00:1f.5
>    2124-2127 : ata_piix
> 
> TEST-MAIL2 ~ # cat /proc/iomem
> 00000000-0000ffff : reserved
> 00010000-0009bfff : System RAM
> 0009c000-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000c7fff : Video ROM
> 000cc800-000d29ff : Adapter ROM
> 000e0000-000fffff : reserved
>  000f0000-000fffff : System ROM
> 00100000-7cb90fff : System RAM
>  01000000-01499782 : Kernel code
>  01499783-01a979bf : Kernel data
>  01b32000-01c6afff : Kernel bss
> 7cb91000-7cc54fff : reserved
> 7cc55000-7d5a2fff : System RAM
> 7d5a3000-7d652fff : reserved
> 7d653000-7f68efff : System RAM
> 7f68f000-7f6defff : reserved
> 7f6df000-7f7defff : ACPI Non-volatile Storage
> 7f7df000-7f7fefff : ACPI Tables
> 7f7ff000-7f7fffff : System RAM
> 7f800000-8fffffff : reserved
>  80000000-8fffffff : PCI MMCONFIG 0000 [bus 00-ff]
>    80000000-8fffffff : pnp 00:0a
> 90000000-fdffffff : PCI Bus 0000:00
>  90000000-900fffff : PCI Bus 0000:15
>    90000000-9007ffff : 0000:15:00.0
>  90100000-901fffff : PCI Bus 0000:1a
>    90100000-9017ffff : 0000:1a:00.0
>  90200000-904fffff : PCI Bus 0000:01
>    90200000-9021ffff : 0000:01:00.0
>  92000000-95ffffff : PCI Bus 0000:0b
>    92000000-93ffffff : 0000:0b:00.0
>      92000000-93ffffff : bnx2
>    94000000-95ffffff : 0000:0b:00.1
>      94000000-95ffffff : bnx2
>  96000000-96ffffff : PCI Bus 0000:06
>    96000000-96ffffff : PCI Bus 0000:07
>      96000000-96ffffff : 0000:07:00.0
>  97000000-978fffff : PCI Bus 0000:06
>    97000000-978fffff : PCI Bus 0000:07
>      97000000-977fffff : 0000:07:00.0
>      97800000-97803fff : 0000:07:00.0
>  97900000-979fffff : PCI Bus 0000:01
>    97900000-9793ffff : 0000:01:00.0
>    97940000-97943fff : 0000:01:00.0
>  97a00000-97afffff : PCI Bus 0000:1a
>    97a00000-97a1ffff : 0000:1a:00.0
>      97a00000-97a1ffff : bfa
>    97a20000-97a3ffff : 0000:1a:00.1
>    97a40000-97a43fff : 0000:1a:00.0
>      97a40000-97a43fff : bfa
>    97a44000-97a47fff : 0000:1a:00.1
>  97b00000-97bfffff : PCI Bus 0000:15
>    97b00000-97b1ffff : 0000:15:00.0
>      97b00000-97b1ffff : bfa
>    97b20000-97b3ffff : 0000:15:00.1
>    97b40000-97b43fff : 0000:15:00.0
>      97b40000-97b43fff : bfa
>    97b44000-97b47fff : 0000:15:00.1
>  97c00000-97c03fff : 0000:00:16.0
>    97c00000-97c03fff : ioatdma
>  97c04000-97c07fff : 0000:00:16.1
>    97c04000-97c07fff : ioatdma
>  97c08000-97c0bfff : 0000:00:16.2
>    97c08000-97c0bfff : ioatdma
>  97c0c000-97c0ffff : 0000:00:16.3
>    97c0c000-97c0ffff : ioatdma
>  97c10000-97c13fff : 0000:00:16.4
>    97c10000-97c13fff : ioatdma
>  97c14000-97c17fff : 0000:00:16.5
>    97c14000-97c17fff : ioatdma
>  97c18000-97c1bfff : 0000:00:16.6
>    97c18000-97c1bfff : ioatdma
>  97c1c000-97c1ffff : 0000:00:16.7
>    97c1c000-97c1ffff : ioatdma
>  97c20000-97c203ff : 0000:00:1d.7
>    97c20000-97c203ff : ehci_hcd
>  97c21000-97c213ff : 0000:00:1a.7
>    97c21000-97c213ff : ehci_hcd
>  97c22000-97c220ff : 0000:00:1f.3
>  fc000000-fcffffff : reserved
>    fc000000-fcffffff : pnp 00:0a
> fe710000-fe711fff : pnp 00:0a
> fe800000-fe9fffff : pnp 00:0a
> fea00000-feafffff : pnp 00:0a
> feb00000-febfffff : pnp 00:0a
> fec00000-fec003ff : IOAPIC 0
> fec80000-fec803ff : IOAPIC 1
> fed00000-fed003ff : HPET 0
>  fed00000-fed003ff : pnp 00:05
> fed1c000-fed1ffff : reserved
>  fed1c000-fed1ffff : pnp 00:0a
> fee00000-feefffff : pnp 00:0a
>  fee00000-fee00fff : Local APIC
> ff800000-ffffffff : reserved
>  ffc00000-ffffffff : pnp 00:0a
> 100000000-107fffffff : System RAM
> 7f00000000-7f00000000 : PCI Bus 0000:00
> 
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> TEST-MAIL1 ~ # lspci -vvv
> 00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 22)
>        Subsystem: IBM Device 7270
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Interrupt: pin A routed to IRQ 11
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s
> L1, Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
> 
> 00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 1 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=0b, subordinate=0f, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 92000000-95ffffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 3408
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #1, Speed 5GT/s, Width x2, ASPM unknown,
> Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
> DLActive+ BWMgmt+ ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
>        Kernel driver in use: pcieport
> 
> 00:02.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 2 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=10, subordinate=14, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 3409
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #2, Speed 5GT/s, Width x2, ASPM unknown,
> Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Kernel driver in use: pcieport
> 
> 00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 3 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=15, subordinate=19, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97b00000-97bfffff
>        Prefetchable memory behind bridge: 0000000090000000-00000000900fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 340a
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #3, Speed 5GT/s, Width x16, ASPM
> unknown, Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive+ BWMgmt+ ABWMgmt-
>                SltCap: AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+
> HotPlug- Surprise-
>                        Slot #1, PowerLimit 0.000W; Interlock+ NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet- LinkState-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
>        Kernel driver in use: pcieport
> 
> 00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 7 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=1a, subordinate=1e, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97a00000-97afffff
>        Prefetchable memory behind bridge: 0000000090100000-00000000901fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 340e
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #7, Speed 5GT/s, Width x16, ASPM
> unknown, Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive+ BWMgmt+ ABWMgmt-
>                SltCap: AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+
> HotPlug- Surprise-
>                        Slot #2, PowerLimit 0.000W; Interlock+ NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet- LinkState-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
>        Kernel driver in use: pcieport
> 
> 00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer
> Registers Port 0 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [50] Vendor Specific Information: Len=ff <?>
> 
> 00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol
> Layer Registers Port 0 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:11.0 PIC: Intel Corporation 5520/5500 Physical and Link Layer
> Registers Port 1 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [50] Vendor Specific Information: Len=ff <?>
> 
> 00:11.1 PIC: Intel Corporation 5520/5500 Routing & Protocol Layer
> Register Port 1 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System
> Management Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [40] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
> Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Kernel driver in use: i7core_edac
>        Kernel modules: i7core_edac
> 
> 00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and
> Scratch Pad Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [40] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
> Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
> 
> 00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
> and RAS Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [40] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
> Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
> 
> 00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle
> Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:15.0 PIC: Intel Corporation 5520/5500/X58 Trusted Execution
> Technology Registers (rev 22) (prog-if 20 [IO(X)-APIC])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3430
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at 97c00000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3431
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at 97c04000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3432
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin C routed to IRQ 18
>        Region 0: Memory at 97c08000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3433
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin D routed to IRQ 19
>        Region 0: Memory at 97c0c000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3429
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at 97c10000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 342a
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at 97c14000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 342b
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin C routed to IRQ 18
>        Region 0: Memory at 97c18000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 342c
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin D routed to IRQ 19
>        Region 0: Memory at 97c1c000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #4 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a37
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 17
>        Region 4: I/O ports at 20a0 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #5 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a38
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin B routed to IRQ 18
>        Region 4: I/O ports at 2080 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family)
> USB2 EHCI Controller #2 (prog-if 20 [EHCI])
>        Subsystem: IBM Device 3a3c
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 19
>        Region 0: Memory at 97c21000 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Debug port: BAR=1 offset=00a0
>        Capabilities: [98] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ehci_hcd
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
> Express Root Port 1 (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=01, subordinate=05, sec-latency=0
>        I/O behind bridge: 00001000-00001fff
>        Memory behind bridge: 97900000-979fffff
>        Prefetchable memory behind bridge: 0000000090200000-00000000904fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPend-
>                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM
> unknown, Latency L0 <256ns, L1 <4us
>                        ClockPM- Surprise- LLActRep+ BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
> HotPlug+ Surprise+
>                        Slot #5, PowerLimit 0.000W; Interlock- NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Unknown, PwrInd Unknown,
> Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet+ LinkState+
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                Address: fee00000  Data: 4061
>        Capabilities: [90] Subsystem: IBM Device 3a40
>        Capabilities: [a0] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed+ WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Root Complex Link
>                Desc:   PortNumber=01 ComponentID=00 EltType=Config
>                Link0:  Desc:   TargetPort=00 TargetComponent=00
> AssocRCRB- LinkType=MemMapped LinkValid+
>                        Addr:   00000000fed1c000
>        Kernel driver in use: pcieport
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
> Express Root Port 5 (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=06, subordinate=0a, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97000000-978fffff
>        Prefetchable memory behind bridge: 0000000096000000-0000000096ffffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPend-
>                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM
> unknown, Latency L0 <1us, L1 <4us
>                        ClockPM- Surprise- LLActRep+ BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                Address: fee00000  Data: 4069
>        Capabilities: [90] Subsystem: IBM Device 3a48
>        Capabilities: [a0] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed+ WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Root Complex Link
>                Desc:   PortNumber=05 ComponentID=00 EltType=Config
>                Link0:  Desc:   TargetPort=00 TargetComponent=00
> AssocRCRB- LinkType=MemMapped LinkValid+
>                        Addr:   00000000fed1c000
>        Kernel driver in use: pcieport
> 
> 00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #1 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a34
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 17
>        Region 4: I/O ports at 2060 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #2 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a35
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin B routed to IRQ 18
>        Region 4: I/O ports at 2040 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #3 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a36
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 19
>        Region 4: I/O ports at 2020 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family)
> USB2 EHCI Controller #1 (prog-if 20 [EHCI])
>        Subsystem: IBM Device 3a3a
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 17
>        Region 0: Memory at 97c20000 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Debug port: BAR=1 offset=00a0
>        Capabilities: [98] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> (prog-if 01 [Subtractive decode])
>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Bus: primary=00, secondary=1f, subordinate=23, sec-latency=32
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Subsystem: IBM Device 244e
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface
> Controller
>        Subsystem: IBM Device 3a18
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>        Kernel modules: iTCO_wdt
> 
> 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4
> port SATA IDE Controller #1 (prog-if 8a [Master SecP PriP])
>        Subsystem: IBM Device 3a20
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 16
>        Region 0: I/O ports at 01f0 [size=8]
>        Region 1: I/O ports at 03f4 [size=1]
>        Region 2: I/O ports at 0170 [size=8]
>        Region 3: I/O ports at 0374 [size=1]
>        Region 4: I/O ports at 20f0 [size=16]
>        Region 5: I/O ports at 20e0 [size=16]
>        Capabilities: [70] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [b0] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ata_piix
>        Kernel modules: ata_generic, pata_acpi, ata_piix
> 
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
>        Subsystem: IBM Device 3a30
>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Interrupt: pin B routed to IRQ 22
>        Region 0: Memory at 97c22000 (64-bit, non-prefetchable) [size=256]
>        Region 4: I/O ports at 2000 [size=32]
>        Kernel driver in use: i801_smbus
>        Kernel modules: i2c-i801
> 
> 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2
> port SATA IDE Controller #2 (prog-if 85 [Master SecO PriO])
>        Subsystem: IBM Device 3a26
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 21
>        Region 0: I/O ports at 2108 [size=8]
>        Region 1: I/O ports at 2124 [size=4]
>        Region 2: I/O ports at 2100 [size=8]
>        Region 3: I/O ports at 2120 [size=4]
>        Region 4: I/O ports at 20d0 [size=16]
>        Region 5: I/O ports at 20c0 [size=16]
>        Capabilities: [70] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [b0] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ata_piix
>        Kernel modules: ata_generic, pata_acpi, ata_piix
> 
> 01:00.0 RAID bus controller: LSI Logic / Symbios Logic LSI MegaSAS
> 9260 (rev 05)
>        Subsystem: IBM Device 03b2
>        Physical Slot: 5
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: I/O ports at 1000 [size=256]
>        Region 1: Memory at 97940000 (64-bit, non-prefetchable) [size=16K]
>        Region 3: Memory at 97900000 (64-bit, non-prefetchable) [size=256K]
>        Expansion ROM at 90200000 [disabled] [size=128K]
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [68] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range BC, TimeoutDis+
>                DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [d0] Vital Product Data
>                Unknown small resource type 00, will not decode more.
>        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [c0] MSI-X: Enable+ Count=15 Masked-
>                Vector table: BAR=1 offset=00002000
>                PBA: BAR=1 offset=00003800
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [138 v1] Power Budgeting <?>
>        Kernel driver in use: megaraid_sas
>        Kernel modules: megaraid_sas
> 
> 06:00.0 PCI bridge: Vitesse Semiconductor VSC452 [SuperBMC] (rev 01)
> (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=06, secondary=07, subordinate=07, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97000000-978fffff
>        Prefetchable memory behind bridge: 96000000-96ffffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [78] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [80] Express (v1) PCI/PCI-X Bridge, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> BrConfRtry-
>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s,
> Latency L0 <2us, L1 <2us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [a4] Subsystem: IBM Device 0369
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
> 
> 07:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200EV
> (prog-if 00 [VGA controller])
>        Subsystem: IBM Device 0369
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 11
>        Region 0: Memory at 96000000 (32-bit, prefetchable) [size=16M]
>        Region 1: Memory at 97800000 (32-bit, non-prefetchable) [size=16K]
>        Region 2: Memory at 97000000 (32-bit, non-prefetchable) [size=8M]
>        Expansion ROM at <unassigned> [disabled]
>        Capabilities: [dc] Power Management version 1
>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 
> 0b:00.0 Ethernet controller: Broadcom Corporation NetXtreme II
> BCM5709 Gigabit Ethernet (rev 20)
>        Subsystem: IBM Device 03a9
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 28
>        Region 0: Memory at 92000000 (64-bit, non-prefetchable) [size=32M]
>        Capabilities: [48] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] Vital Product Data
>                Product Name: Broadcom NetXtreme II Ethernet Controller
>                Read-only fields:
>                        [PN] Part number: BCM95709C0
>                        [EC] Engineering changes: 220197-2
>                        [SN] Serial number: 0123456789
>                        [MN] Manufacture ID: 31 34 65 34
>                        [RV] Reserved: checksum good, 31 byte(s) reserved
>                End
>        Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
>                Vector table: BAR=0 offset=0000c000
>                PBA: BAR=0 offset=0000e000
>        Capabilities: [ac] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency
> L0s <4us, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr+ TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1,
> Latency L0 <2us, L1 <2us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>                DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Device Serial Number 5c-f3-fc-ff-fe-b6-a4-54
>        Capabilities: [110 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [150 v1] Power Budgeting <?>
>        Capabilities: [160 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Kernel driver in use: bnx2
>        Kernel modules: bnx2
> 
> 0b:00.1 Ethernet controller: Broadcom Corporation NetXtreme II
> BCM5709 Gigabit Ethernet (rev 20)
>        Subsystem: IBM Device 03a9
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 40
>        Region 0: Memory at 94000000 (64-bit, non-prefetchable) [size=32M]
>        Capabilities: [48] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] Vital Product Data
>                Product Name: Broadcom NetXtreme II Ethernet Controller
>                Read-only fields:
>                        [PN] Part number: BCM95709C0
>                        [EC] Engineering changes: 220197-2
>                        [SN] Serial number: 0123456789
>                        [MN] Manufacture ID: 31 34 65 34
>                        [RV] Reserved: checksum good, 31 byte(s) reserved
>                End
>        Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
>                Vector table: BAR=0 offset=0000c000
>                PBA: BAR=0 offset=0000e000
>        Capabilities: [ac] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency
> L0s <4us, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr+ TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1,
> Latency L0 <2us, L1 <2us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>                DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Device Serial Number 5c-f3-fc-ff-fe-b6-a4-56
>        Capabilities: [110 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [150 v1] Power Budgeting <?>
>        Capabilities: [160 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Kernel driver in use: bnx2
>        Kernel modules: bnx2
> 
> 15:00.0 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 1
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 24
>        Region 0: Memory at 97b00000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97b40000 (64-bit, non-prefetchable) [size=16K]
>        Expansion ROM at 90000000 [disabled] [size=512K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable+ Count=24 Masked-
>                Vector table: BAR=2 offset=00000000
>                PBA: BAR=2 offset=00001000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1e
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel driver in use: bfa
>        Kernel modules: bfa
> 
> 15:00.1 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 1
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 10
>        Region 0: Memory at 97b20000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97b44000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable- Count=24 Masked-
>                Vector table: BAR=2 offset=00002000
>                PBA: BAR=2 offset=00003000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1f
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel modules: bfa
> 
> 1a:00.0 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 3
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 30
>        Region 0: Memory at 97a00000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97a40000 (64-bit, non-prefetchable) [size=16K]
>        Expansion ROM at 90100000 [disabled] [size=512K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable+ Count=24 Masked-
>                Vector table: BAR=2 offset=00000000
>                PBA: BAR=2 offset=00001000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1e
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel driver in use: bfa
>        Kernel modules: bfa
> 
> 1a:00.1 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 3
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 10
>        Region 0: Memory at 97a20000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97a44000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable- Count=24 Masked-
>                Vector table: BAR=2 offset=00002000
>                PBA: BAR=2 offset=00003000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1f
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel modules: bfa
> 
> fe:00.0 Host bridge: Intel Corporation QuickPath Architecture
> Generic Non-core Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:00.1 Host bridge: Intel Corporation QuickPath Architecture System
> Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.0 Host bridge: Intel Corporation QPI Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.1 Host bridge: Intel Corporation QPI Physical 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.2 Host bridge: Intel Corporation Mirror Port Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.3 Host bridge: Intel Corporation Mirror Port Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.4 Host bridge: Intel Corporation QPI Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.5 Host bridge: Intel Corporation QPI Physical 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.0 Host bridge: Intel Corporation Integrated Memory Controller
> Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.1 Host bridge: Intel Corporation Integrated Memory Controller
> Target Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.2 Host bridge: Intel Corporation Integrated Memory Controller
> RAS Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.4 Host bridge: Intel Corporation Integrated Memory Controller
> Test Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:00.0 Host bridge: Intel Corporation QuickPath Architecture
> Generic Non-core Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:00.1 Host bridge: Intel Corporation QuickPath Architecture System
> Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.0 Host bridge: Intel Corporation QPI Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.1 Host bridge: Intel Corporation QPI Physical 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.2 Host bridge: Intel Corporation Mirror Port Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.3 Host bridge: Intel Corporation Mirror Port Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.4 Host bridge: Intel Corporation QPI Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.5 Host bridge: Intel Corporation QPI Physical 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.0 Host bridge: Intel Corporation Integrated Memory Controller
> Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.1 Host bridge: Intel Corporation Integrated Memory Controller
> Target Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.2 Host bridge: Intel Corporation Integrated Memory Controller
> RAS Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.4 Host bridge: Intel Corporation Integrated Memory Controller
> Test Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> 
> TEST-MAIL2 ~ # lspci -vvv
> 00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 22)
>        Subsystem: IBM Device 7270
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Interrupt: pin A routed to IRQ 11
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s
> L1, Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
> 
> 00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 1 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=0b, subordinate=0f, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 92000000-95ffffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 3408
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #1, Speed 5GT/s, Width x2, ASPM unknown,
> Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
> DLActive+ BWMgmt+ ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
>        Kernel driver in use: pcieport
> 
> 00:02.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 2 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=10, subordinate=14, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 3409
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #2, Speed 5GT/s, Width x2, ASPM unknown,
> Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Kernel driver in use: pcieport
> 
> 00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 3 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=15, subordinate=19, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97b00000-97bfffff
>        Prefetchable memory behind bridge: 0000000090000000-00000000900fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 340a
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #3, Speed 5GT/s, Width x16, ASPM
> unknown, Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive+ BWMgmt+ ABWMgmt-
>                SltCap: AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+
> HotPlug- Surprise-
>                        Slot #1, PowerLimit 0.000W; Interlock+ NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet- LinkState-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
>        Kernel driver in use: pcieport
> 
> 00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 7 (rev 22) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=1a, subordinate=1e, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97a00000-97afffff
>        Prefetchable memory behind bridge: 0000000090100000-00000000901fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: IBM Device 340e
>        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                Address: 00000020  Data: 0000
>                Masking: 00000000  Pending: 00000000
>        Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 256 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #7, Speed 5GT/s, Width x16, ASPM
> unknown, Latency L0 <512ns, L1 <64us
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive+ BWMgmt+ ABWMgmt-
>                SltCap: AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+
> HotPlug- Surprise-
>                        Slot #2, PowerLimit 0.000W; Interlock+ NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet- LinkState-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                DevCtl2: Completion Timeout: 260ms to 900ms,
> TimeoutDis- ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn-
> ChkCap- ChkEn-
>        Capabilities: [150 v1] Access Control Services
>                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>        Capabilities: [160 v0] Vendor Specific Information: ID=0002
> Rev=0 Len=00c <?>
>        Kernel driver in use: pcieport
> 
> 00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer
> Registers Port 0 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [50] Vendor Specific Information: Len=ff <?>
> 
> 00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol
> Layer Registers Port 0 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:11.0 PIC: Intel Corporation 5520/5500 Physical and Link Layer
> Registers Port 1 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [50] Vendor Specific Information: Len=ff <?>
> 
> 00:11.1 PIC: Intel Corporation 5520/5500 Routing & Protocol Layer
> Register Port 1 (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System
> Management Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [40] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
> Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Kernel driver in use: i7core_edac
>        Kernel modules: i7core_edac
> 
> 00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and
> Scratch Pad Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [40] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
> Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
> 
> 00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
> and RAS Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [40] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
> Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise+ LLActRep+ BwNot+
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
> 
> 00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle
> Registers (rev 22) (prog-if 00 [8259])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:15.0 PIC: Intel Corporation 5520/5500/X58 Trusted Execution
> Technology Registers (rev 22) (prog-if 20 [IO(X)-APIC])
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3430
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at 97c00000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3431
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at 97c04000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3432
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin C routed to IRQ 18
>        Region 0: Memory at 97c08000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3433
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin D routed to IRQ 19
>        Region 0: Memory at 97c0c000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 3429
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at 97c10000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 342a
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at 97c14000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 342b
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin C routed to IRQ 18
>        Region 0: Memory at 97c18000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset
> QuickData Technology Device (rev 22)
>        Subsystem: IBM Device 342c
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin D routed to IRQ 19
>        Region 0: Memory at 97c1c000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [90] Express (v2) Root Complex Integrated
> Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [e0] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: ioatdma
>        Kernel modules: ioatdma
> 
> 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #4 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a37
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 17
>        Region 4: I/O ports at 20a0 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #5 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a38
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin B routed to IRQ 18
>        Region 4: I/O ports at 2080 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family)
> USB2 EHCI Controller #2 (prog-if 20 [EHCI])
>        Subsystem: IBM Device 3a3c
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 19
>        Region 0: Memory at 97c21000 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Debug port: BAR=1 offset=00a0
>        Capabilities: [98] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ehci_hcd
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
> Express Root Port 1 (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=01, subordinate=05, sec-latency=0
>        I/O behind bridge: 00001000-00001fff
>        Memory behind bridge: 97900000-979fffff
>        Prefetchable memory behind bridge: 0000000090200000-00000000904fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPend-
>                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM
> unknown, Latency L0 <256ns, L1 <4us
>                        ClockPM- Surprise- LLActRep+ BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
> HotPlug+ Surprise+
>                        Slot #5, PowerLimit 0.000W; Interlock- NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Unknown, PwrInd Unknown,
> Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet+ LinkState+
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                Address: fee00000  Data: 4061
>        Capabilities: [90] Subsystem: IBM Device 3a40
>        Capabilities: [a0] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed+ WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Root Complex Link
>                Desc:   PortNumber=01 ComponentID=00 EltType=Config
>                Link0:  Desc:   TargetPort=00 TargetComponent=00
> AssocRCRB- LinkType=MemMapped LinkValid+
>                        Addr:   00000000fed1c000
>        Kernel driver in use: pcieport
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
> Express Root Port 5 (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=06, subordinate=0a, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97000000-978fffff
>        Prefetchable memory behind bridge: 0000000096000000-0000000096ffffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPend-
>                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM
> unknown, Latency L0 <1us, L1 <4us
>                        ClockPM- Surprise- LLActRep+ BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
> PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                Address: fee00000  Data: 4069
>        Capabilities: [90] Subsystem: IBM Device 3a48
>        Capabilities: [a0] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed+ WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Root Complex Link
>                Desc:   PortNumber=05 ComponentID=00 EltType=Config
>                Link0:  Desc:   TargetPort=00 TargetComponent=00
> AssocRCRB- LinkType=MemMapped LinkValid+
>                        Addr:   00000000fed1c000
>        Kernel driver in use: pcieport
> 
> 00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #1 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a34
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 17
>        Region 4: I/O ports at 2060 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #2 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a35
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin B routed to IRQ 18
>        Region 4: I/O ports at 2040 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #3 (prog-if 00 [UHCI])
>        Subsystem: IBM Device 3a36
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 19
>        Region 4: I/O ports at 2020 [size=32]
>        Capabilities: [50] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: uhci_hcd
> 
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family)
> USB2 EHCI Controller #1 (prog-if 20 [EHCI])
>        Subsystem: IBM Device 3a3a
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 17
>        Region 0: Memory at 97c20000 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Debug port: BAR=1 offset=00a0
>        Capabilities: [98] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> (prog-if 01 [Subtractive decode])
>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Bus: primary=00, secondary=1f, subordinate=23, sec-latency=32
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Subsystem: IBM Device 244e
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface
> Controller
>        Subsystem: IBM Device 3a18
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>        Kernel modules: iTCO_wdt
> 
> 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4
> port SATA IDE Controller #1 (prog-if 8a [Master SecP PriP])
>        Subsystem: IBM Device 3a20
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 16
>        Region 0: I/O ports at 01f0 [size=8]
>        Region 1: I/O ports at 03f4 [size=1]
>        Region 2: I/O ports at 0170 [size=8]
>        Region 3: I/O ports at 0374 [size=1]
>        Region 4: I/O ports at 20f0 [size=16]
>        Region 5: I/O ports at 20e0 [size=16]
>        Capabilities: [70] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [b0] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ata_piix
>        Kernel modules: ata_generic, pata_acpi, ata_piix
> 
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
>        Subsystem: IBM Device 3a30
>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Interrupt: pin B routed to IRQ 22
>        Region 0: Memory at 97c22000 (64-bit, non-prefetchable) [size=256]
>        Region 4: I/O ports at 2000 [size=32]
>        Kernel driver in use: i801_smbus
>        Kernel modules: i2c-i801
> 
> 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2
> port SATA IDE Controller #2 (prog-if 85 [Master SecO PriO])
>        Subsystem: IBM Device 3a26
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 21
>        Region 0: I/O ports at 2108 [size=8]
>        Region 1: I/O ports at 2124 [size=4]
>        Region 2: I/O ports at 2100 [size=8]
>        Region 3: I/O ports at 2120 [size=4]
>        Region 4: I/O ports at 20d0 [size=16]
>        Region 5: I/O ports at 20c0 [size=16]
>        Capabilities: [70] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [b0] PCI Advanced Features
>                AFCap: TP+ FLR+
>                AFCtrl: FLR-
>                AFStatus: TP-
>        Kernel driver in use: ata_piix
>        Kernel modules: ata_generic, pata_acpi, ata_piix
> 
> 01:00.0 RAID bus controller: LSI Logic / Symbios Logic LSI MegaSAS
> 9260 (rev 05)
>        Subsystem: IBM Device 03b2
>        Physical Slot: 5
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: I/O ports at 1000 [size=256]
>        Region 1: Memory at 97940000 (64-bit, non-prefetchable) [size=16K]
>        Region 3: Memory at 97900000 (64-bit, non-prefetchable) [size=256K]
>        Expansion ROM at 90200000 [disabled] [size=128K]
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [68] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range BC, TimeoutDis+
>                DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [d0] Vital Product Data
>                Unknown small resource type 00, will not decode more.
>        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [c0] MSI-X: Enable+ Count=15 Masked-
>                Vector table: BAR=1 offset=00002000
>                PBA: BAR=1 offset=00003800
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [138 v1] Power Budgeting <?>
>        Kernel driver in use: megaraid_sas
>        Kernel modules: megaraid_sas
> 
> 06:00.0 PCI bridge: Vitesse Semiconductor VSC452 [SuperBMC] (rev 01)
> (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=06, secondary=07, subordinate=07, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: 97000000-978fffff
>        Prefetchable memory behind bridge: 96000000-96ffffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [78] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [80] Express (v1) PCI/PCI-X Bridge, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> BrConfRtry-
>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s,
> Latency L0 <2us, L1 <2us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk- DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [a4] Subsystem: IBM Device 0369
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
> 
> 07:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200EV
> (prog-if 00 [VGA controller])
>        Subsystem: IBM Device 0369
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 11
>        Region 0: Memory at 96000000 (32-bit, prefetchable) [size=16M]
>        Region 1: Memory at 97800000 (32-bit, non-prefetchable) [size=16K]
>        Region 2: Memory at 97000000 (32-bit, non-prefetchable) [size=8M]
>        Expansion ROM at <unassigned> [disabled]
>        Capabilities: [dc] Power Management version 1
>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 
> 0b:00.0 Ethernet controller: Broadcom Corporation NetXtreme II
> BCM5709 Gigabit Ethernet (rev 20)
>        Subsystem: IBM Device 03a9
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 28
>        Region 0: Memory at 92000000 (64-bit, non-prefetchable) [size=32M]
>        Capabilities: [48] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] Vital Product Data
>                Product Name: Broadcom NetXtreme II Ethernet Controller
>                Read-only fields:
>                        [PN] Part number: BCM95709C0
>                        [EC] Engineering changes: 220197-2
>                        [SN] Serial number: 0123456789
>                        [MN] Manufacture ID: 31 34 65 34
>                        [RV] Reserved: checksum good, 31 byte(s) reserved
>                End
>        Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
>                Vector table: BAR=0 offset=0000c000
>                PBA: BAR=0 offset=0000e000
>        Capabilities: [ac] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency
> L0s <4us, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr+ TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1,
> Latency L0 <2us, L1 <2us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>                DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Device Serial Number e4-1f-13-ff-fe-b9-d8-78
>        Capabilities: [110 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [150 v1] Power Budgeting <?>
>        Capabilities: [160 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Kernel driver in use: bnx2
>        Kernel modules: bnx2
> 
> 0b:00.1 Ethernet controller: Broadcom Corporation NetXtreme II
> BCM5709 Gigabit Ethernet (rev 20)
>        Subsystem: IBM Device 03a9
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 40
>        Region 0: Memory at 94000000 (64-bit, non-prefetchable) [size=32M]
>        Capabilities: [48] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] Vital Product Data
>                Product Name: Broadcom NetXtreme II Ethernet Controller
>                Read-only fields:
>                        [PN] Part number: BCM95709C0
>                        [EC] Engineering changes: 220197-2
>                        [SN] Serial number: 0123456789
>                        [MN] Manufacture ID: 31 34 65 34
>                        [RV] Reserved: checksum good, 31 byte(s) reserved
>                End
>        Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
>                Vector table: BAR=0 offset=0000c000
>                PBA: BAR=0 offset=0000e000
>        Capabilities: [ac] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency
> L0s <4us, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr+ TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1,
> Latency L0 <2us, L1 <2us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>                DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Device Serial Number e4-1f-13-ff-fe-b9-d8-7a
>        Capabilities: [110 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [150 v1] Power Budgeting <?>
>        Capabilities: [160 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Kernel driver in use: bnx2
>        Kernel modules: bnx2
> 
> 15:00.0 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 1
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 24
>        Region 0: Memory at 97b00000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97b40000 (64-bit, non-prefetchable) [size=16K]
>        Expansion ROM at 90000000 [disabled] [size=512K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable+ Count=24 Masked-
>                Vector table: BAR=2 offset=00000000
>                PBA: BAR=2 offset=00001000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1e
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel driver in use: bfa
>        Kernel modules: bfa
> 
> 15:00.1 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 1
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 10
>        Region 0: Memory at 97b20000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97b44000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable- Count=24 Masked-
>                Vector table: BAR=2 offset=00002000
>                PBA: BAR=2 offset=00003000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1f
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel modules: bfa
> 
> 1a:00.0 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 3
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 30
>        Region 0: Memory at 97a00000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97a40000 (64-bit, non-prefetchable) [size=16K]
>        Expansion ROM at 90100000 [disabled] [size=512K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable+ Count=24 Masked-
>                Vector table: BAR=2 offset=00000000
>                PBA: BAR=2 offset=00001000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1e
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel driver in use: bfa
>        Kernel modules: bfa
> 
> 1a:00.1 Fibre Channel: Brocade Communications Systems, Inc. 415
> 4Gb/815 8Gb PCIe FC HBA (rev 01)
>        Subsystem: Brocade Communications Systems, Inc. Device 0014
>        Physical Slot: 3
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 10
>        Region 0: Memory at 97a20000 (64-bit, non-prefetchable) [size=128K]
>        Region 2: Memory at 97a44000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>        Capabilities: [50] MSI-X: Enable- Count=24 Masked-
>                Vector table: BAR=2 offset=00002000
>                PBA: BAR=2 offset=00003000
>        Capabilities: [60] Express (v2) Endpoint, MSI 1f
>                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency
> L0s <256ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s,
> Latency L0 <256ns, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range AB, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
> NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [180 v1] Power Budgeting <?>
>        Kernel modules: bfa
> 
> fe:00.0 Host bridge: Intel Corporation QuickPath Architecture
> Generic Non-core Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:00.1 Host bridge: Intel Corporation QuickPath Architecture System
> Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.0 Host bridge: Intel Corporation QPI Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.1 Host bridge: Intel Corporation QPI Physical 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.2 Host bridge: Intel Corporation Mirror Port Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.3 Host bridge: Intel Corporation Mirror Port Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.4 Host bridge: Intel Corporation QPI Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:02.5 Host bridge: Intel Corporation QPI Physical 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.0 Host bridge: Intel Corporation Integrated Memory Controller
> Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.1 Host bridge: Intel Corporation Integrated Memory Controller
> Target Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.2 Host bridge: Intel Corporation Integrated Memory Controller
> RAS Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:03.4 Host bridge: Intel Corporation Integrated Memory Controller
> Test Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:04.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:05.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> fe:06.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:00.0 Host bridge: Intel Corporation QuickPath Architecture
> Generic Non-core Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:00.1 Host bridge: Intel Corporation QuickPath Architecture System
> Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.0 Host bridge: Intel Corporation QPI Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.1 Host bridge: Intel Corporation QPI Physical 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.2 Host bridge: Intel Corporation Mirror Port Link 0 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.3 Host bridge: Intel Corporation Mirror Port Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.4 Host bridge: Intel Corporation QPI Link 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:02.5 Host bridge: Intel Corporation QPI Physical 1 (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.0 Host bridge: Intel Corporation Integrated Memory Controller
> Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.1 Host bridge: Intel Corporation Integrated Memory Controller
> Target Address Decoder (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.2 Host bridge: Intel Corporation Integrated Memory Controller
> RAS Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:03.4 Host bridge: Intel Corporation Integrated Memory Controller
> Test Registers (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:04.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 0 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:05.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 1 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.0 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.1 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Address (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.2 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Rank (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> ff:06.3 Host bridge: Intel Corporation Integrated Memory Controller
> Channel 2 Thermal Control (rev 02)
>        Subsystem: Intel Corporation Device 8086
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> 
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> TEST-MAIL1 ~ # cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>  Vendor: TSSTcorp Model: CDDVDW TS-L633F  Rev: IT03
>  Type:   CD-ROM                           ANSI  SCSI revision: 05
> Host: scsi4 Channel: 02 Id: 00 Lun: 00
>  Vendor: IBM      Model: ServeRAID M5015  Rev: 2.12
>  Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi5 Channel: 00 Id: 00 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi5 Channel: 00 Id: 01 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 01 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> 
> TEST-MAIL2 ~ # cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>  Vendor: TSSTcorp Model: CDDVDW TS-L633F  Rev: IT03
>  Type:   CD-ROM                           ANSI  SCSI revision: 05
> Host: scsi4 Channel: 02 Id: 00 Lun: 00
>  Vendor: IBM      Model: ServeRAID M5015  Rev: 2.12
>  Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi5 Channel: 00 Id: 00 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi5 Channel: 00 Id: 01 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 01 Lun: 00
>  Vendor: DGC      Model: RAID 10          Rev: 0428
>  Type:   Direct-Access                    ANSI  SCSI revision: 04
> 
> 
> [7.7.] Other information that might be relevant to the problem
>       (please look in /proc and include all information that you
>       think to be relevant):
> 
> 
> [X.] Other notes, patches, fixes, workarounds:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

 Brain: I shall pollute the water supply with this DNAdefibuliser,
        turning everyone into mindless slaves.
 Pinky: What about the people who drink bottled water?
 Brain: Pinky, people who pay 5 dollars for a bottle of water are
        already mindless slaves.

			http://www.jlbec.org/
			jlbec at evilplan.org
