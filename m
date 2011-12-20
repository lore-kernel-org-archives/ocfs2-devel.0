From: =?UTF-8?Q?Marek_Kr=C3=B3likowski?= <admin@wset.edu.pl>
Date: Tue, 20 Dec 2011 18:28:35 +0100
Subject: [Ocfs2-devel] [Kernel 3.1.5] [OCFS2] After many write/delete on
	ocfs2 filesystem both servers in cluster got oops kernel
In-Reply-To: <20111220172113.GE3964@phenom.dumpdata.com>
References: <1BBB44BD245F4BF5B368220BCEBA9541@tktelekom.net>
	<20111220172113.GE3964@phenom.dumpdata.com>
Message-ID: <9A999E313E1B455E91A0A0894BC7F8B2@SERWER>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org

Hello thanks for info but if u check i open a threat there:
ocfs2-devel - 
http://oss.oracle.com/pipermail/ocfs2-devel/2011-December/008441.html
ocfs2-users - 
http://oss.oracle.com/pipermail/ocfs2-users/2011-December/005534.html
And i contact with Sunil Mushran and he say this is a kernel problem so i 
report here too.



-----Oryginalna wiadomo??----- 
From: Konrad Rzeszutek Wilk
Sent: Tuesday, December 20, 2011 6:21 PM
To: Marek Krolikowski ; ocfs2-devel at oss.oracle.com
Cc: linux-kernel at vger.kernel.org
Subject: Re: [Kernel 3.1.5] [OCFS2] After many write/delete on ocfs2 
filesystem both servers in cluster got oops kernel

On Tue, Dec 20, 2011 at 09:10:13AM +0100, Marek Krolikowski wrote:
> [1.] One line summary of the problem:
> After many write/delete on ocfs2 both servers in cluster got oops kernel

You might want to look in the MAINTAINERS file to see who to
email.. And it looks to be  ocfs2-devel at oss.oracle.com, so added that
to your CC.
>
>
> [2.] Full description of the problem/report:
> After create new ocfs2 cluster with kernel 3.1.5 after few hours
> write/delete on both servers via my own script got oops kernel on
> both servers:
> I try disable all features, change kernel to 2.6.39.4 and 3.2RC5 but
> all the time this same effect.
> When i kill on both server this script -  still there is a high Load
> Average +2.00 and ~10Mbit/s Bandwitch between servers.
> After run "TOP" i see what take so much resources:
> 23557 root      20   0     0    0    0 D   24  0.0  15:35.63 kworker/u:3
> 1458 root      20   0     0    0    0 S   17  0.0   4:27.58 kworker/u:2
> 32246 root      20   0     0    0    0 S   15  0.0   5:46.31 kworker/u:1
> 2933 root      20   0     0    0    0 S   14  0.0   3:09.25 kworker/u:0
> Of Course i create other filesystem and working good - so looks like
> problem with OCFS2.
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
> declare -x 
> INFOPATH="/usr/share/info:/usr/share/binutils-data/x86_64-pc-linux-gnu/2.21.1/info:/usr/share/gcc-data/x86_64-pc-linux-gnu/4.4.5/info"
> declare -x LANG="pl_PL"
> declare -x LC_ALL="pl_PL"
> declare -x LESS="-R -M --shift 5"
> declare -x LESSOPEN="|lesspipe %s"
> declare -x LOGNAME="root"
> declare -x 
> LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01!
> ;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
> declare -x MAIL="/var/mail/root"
> declare -x 
> MANPATH="/usr/local/share/man:/usr/share/man:/usr/share/binutils-data/x86_64-pc-linux-gnu/2.21.1/man:/usr/share/gcc-data/x86_64-pc-linux-gnu/4.4.5/man:/usr/lib64/php5.3/man/"
> declare -x OLDPWD
> declare -x PAGER="/usr/bin/less"
> declare -x 
> PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.4.5"
> declare -x PWD="/root"
> declare -x SHELL="/bin/bash"
> declare -x SHLVL="1"
> declare -x SSH_CLIENT="172.23.1.146 57479 22"
> declare -x SSH_CONNECTION="172.23.1.146 57479 172.17.1.251 22"
> declare -x SSH_TTY="/dev/pts/2"
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
> async_xor 3682 3 raid456,async_raid6_recov,async_pq, Live 
> 0xffffffffa0023000
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
>
> [7.5.] PCI information ('lspci -vvv' as root)
> Can`t paste here because message size exceeding 100 000 characters.
> If need it i can upload somewhere.
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
