From: Jan Kara <jack@suse.cz>
Date: Wed, 25 Aug 2010 20:37:36 +0200
Subject: [Ocfs2-devel] crash while creating a lot of files - jbd2
	assertion failure
In-Reply-To: <AANLkTi=qkpTn7+zvbvnjgNoXmva1sKkv5TB7Wur=R-Gb@mail.gmail.com>
References: <AANLkTi=qkpTn7+zvbvnjgNoXmva1sKkv5TB7Wur=R-Gb@mail.gmail.com>
Message-ID: <20100825183736.GC2738@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 24-08-10 20:07:25, Goldwyn Rodrigues wrote:
> Hi,
> 
> ocfs2 crashes most of the times when I try to create a lot of files on
> the filesystem. The details are:
> 
> Arch: i686 (2 processors)
> Kernel version: 2.6.35.3
> Script to reproduce:
> for i in `seq 1 1048576`; do echo $i > f.$i; done
> Reproducible: most of the times
> fs-features: indexed-dirs,local,noxattr
> 
> dmesg:
> [  336.905277] ------------[ cut here ]------------
> [  336.905286] kernel BUG at fs/jbd2/transaction.c:1060!
  Doh, this is
J_ASSERT_JH(jh, jh->b_next_transaction == transaction);
  in your kernel, right? That would be really really strange. Tristan,
if you can reproduce, it would be interesting to find out where
"b_next_transaction" points to and where "transaction" points to. There is
now way how there could be two running transactions in JBD2 so one of the
pointers must be wrong...

								Honza

> [  336.905291] invalid opcode: 0000 [#1] SMP
> [  336.905296] last sysfs file:
> /sys/devices/pci0000:00/0000:00:0e.0/host0/target0:0:0/0:0:0:0/block/sda/dev
> [  336.905301] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq
> mperf ipv6 ext2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd wmi pcspkr r8169
> mii soundcore snd_page_alloc i2c_nforce2 serio_raw microcode pata_acpi
> ata_generic usb_storage pata_amd nouveau ttm drm_kms_helper drm
> i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
> [  336.905337]
> [  336.905340] Pid: 2139, comm: bash Not tainted 2.6.35.3 #1
> EMCP73VT-PM/ET1810
> [  336.905343] EIP: 0060:[<c054da97>] EFLAGS: 00010203 CPU: 0
> [  336.905352] EIP is at jbd2_journal_dirty_metadata+0xcb/0x10d
> [  336.905355] EAX: 00000000 EBX: f4c21658 ECX: f372ac00 EDX: f5d7a9c0
> [  336.905357] ESI: f4fae700 EDI: f6207120 EBP: f312bca8 ESP: f312bc94
> [  336.905360]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  336.905363] Process bash (pid: 2139, ti=f312a000 task=f31271a0
> task.ti=f312a000)
> [  336.905365] Stack:
> [  336.905366]  df6f0d90 f372ac00 f6207120 f6ce8000 f29be000 f312bcb8
> c0591f8f 00000000
> [  336.905372] <0> 00000000 f312bd88 c05776cc 00000000 00000000 00000000
> f3127490 f31271a0
> [  336.905377] <0> f282d0c0 f312be14 000000fe 00000001 f31271a0 f3127490
> f4dc2038 f2c28000
> [  336.905383] Call Trace:
> [  336.905389]  [<c0591f8f>] ? ocfs2_journal_dirty+0x65/0xbb
> [  336.905394]  [<c05776cc>] ?
> ocfs2_prepare_dx_dir_for_insert+0x148b/0x1a24
> [  336.905399]  [<c059230f>] ? ocfs2_journal_access_dr+0x0/0x12
> [  336.905402]  [<c0577d8d>] ? ocfs2_prepare_dir_for_insert+0x128/0x793
> [  336.905406]  [<c05759bf>] ? ocfs2_check_dir_for_entry+0x9a/0xee
> [  336.905409]  [<c059a40e>] ? ocfs2_mknod+0x240/0xdb6
> [  336.905413]  [<c057848c>] ? ocfs2_is_hard_readonly+0x11/0x24
> [  336.905416]  [<c059b0be>] ? ocfs2_create+0x72/0xc8
> [  336.905421]  [<c04cd64c>] ? vfs_create+0x5b/0x76
> [  336.905424]  [<c04ce02a>] ? do_last+0x213/0x49c
> [  336.905427]  [<c04cf6d7>] ? do_filp_open+0x197/0x435
> [  336.905432]  [<c061a1a0>] ? might_fault+0x19/0x1b
> [  336.905437]  [<c04c480f>] ? do_sys_open+0x48/0xdf
> [  336.905440]  [<c04c48e8>] ? sys_open+0x1e/0x26
> [  336.905444]  [<c040311f>] ? sysenter_do_call+0x12/0x28
> [  336.905446] Code: 75 0c 8b 4d f0 3b 51 30 74 54 0f 0b eb fe f0 80 4b
> 02 20 8b 46 18 39 d0 74 15 8b 4d f0 3b 41 34 74 04 0f 0b eb fe 39 56 1c
> 74 33 <0f> 0b eb fe 83 7e 10 00 74 04 0f 0b eb fe 8b 45 f0 05 fc 01 00
> [  336.905478] EIP: [<c054da97>] jbd2_journal_dirty_metadata+0xcb/0x10d
> SS:ESP 0068:f312bc94
> [  336.905484] ---[ end trace e26abf0b4972541a ]---
> 
> Let me know if you need more information.
> 
> -- 
> Goldwyn
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
