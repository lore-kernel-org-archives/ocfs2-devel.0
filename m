From: Eric Sesterhenn <snakebyte@gmx.de>
Date: Tue, 27 May 2008 08:29:53 -0000
Subject: [Ocfs2-devel] Filesystem fuzzing
In-Reply-To: <20080527080052.GA9193@alice>
References: <20080519100737.GA7764@alice> <48345A30.9030004@oracle.com>
	<20080527080052.GA9193@alice>
Message-ID: <20080527082941.GA16223@alice>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <Sunil.Mushran@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

* Eric Sesterhenn (snakebyte at gmx.de) wrote:
> * Sunil Mushran (Sunil.Mushran at oracle.com) wrote:
> > Eric Sesterhenn wrote:
> >> i do some regular filesystem fuzzing, based on a modified version
> >> of lmhs fsfuzzer. I try to test current -git at least once a week.
> >> Most modifications are adding of new filesystems or mounting
> >> them with different options, but i also added some new tests like invoking 
> >> iozone, fsx or fsstress if available
> >>
> >> I currently test  vfat, udf, msdos, swap, iso9660, ext2,
> >> ext3, ext4, hfs, hfsplus, gfs2, ntfs, minix, qnx4, affs and bfs
> >
> > Please can you add ocfs2 to the mix. To make it easy, you
> > can format with "mkfs.ocfs2 -M local" to mark the volume
> > for local mount only and thus not deal with any cluster config.
> 
> here is a first one:

...

> Image can be found at http://cccmz.de/~snakebyte/ocfs2.3.img.bz2
> (server is a bit flaky at the moment due to dns
> issues, just try again if you get the united domains site)

[  253.538562] (4238,0):ocfs2_populate_inode:277 ERROR: ip_blkno 10 !=
i_blkno 34314!
[  253.538861] ------------[ cut here ]------------
[  253.538995] kernel BUG at fs/ocfs2/inode.c:484!
[  253.539125] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  253.539356] Modules linked in:
[  253.539356] 
[  253.539356] Pid: 4238, comm: mount.ocfs2 Not tainted (2.6.26-rc4 #44)
[  253.539356] EIP: 0060:[<c039bf71>] EFLAGS: 00010206 CPU: 0
[  253.539356] EIP is at ocfs2_iget+0xa91/0xc90
[  253.539356] EAX: 00008600 EBX: 00000000 ECX: 00008600 EDX: 0000860a
[  253.539356] ESI: cbfc0a78 EDI: cbbcb120 EBP: cbb1fdb4 ESP: cbb1fd54
[  253.539356]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  253.539356] Process mount.ocfs2 (pid: 4238, ti=cbb1f000 task=cbb89fa0
task.ti=cbb1f000)
[  253.539356] Stack: 00000001 cbb1fda4 00000000 00000000 cbb1fd88
00000296 c038be6b c08dcddc 
[  253.539356]        c038be6b 000000d0 cf306d3e cbb1fd88 00000000
cbb1fdb4 c038be76 0000000a 
[  253.539356]        00000000 0000000a 00000001 00000000 cbddb208
00000000 cbbcb120 c9f1f800 
[  253.539356] Call Trace:
[  253.539356]  [<c038be6b>] ? ocfs2_new_dlm_debug+0x1b/0x100
[  253.539356]  [<c038be6b>] ? ocfs2_new_dlm_debug+0x1b/0x100
[  253.539356]  [<c038be76>] ? ocfs2_new_dlm_debug+0x26/0x100
[  253.539356]  [<c03c5594>] ? ocfs2_fill_super+0x1f54/0x2910
[  253.539356]  [<c018281f>] ? get_sb_bdev+0xef/0x120
[  253.539356]  [<c019758d>] ? alloc_vfsmnt+0xdd/0x120
[  253.539356]  [<c019758d>] ? alloc_vfsmnt+0xdd/0x120
[  253.539356]  [<c03bf742>] ? ocfs2_get_sb+0x22/0x30
[  253.539356]  [<c03c3640>] ? ocfs2_fill_super+0x0/0x2910
[  253.539356]  [<c018236a>] ? vfs_kern_mount+0x3a/0x90
[  253.539356]  [<c0182419>] ? do_kern_mount+0x39/0xd0
[  253.539356]  [<c01987c5>] ? do_new_mount+0x65/0x90
[  253.539356]  [<c019894a>] ? do_mount+0x15a/0x1b0
[  253.539356]  [<c017bab5>] ? kmem_cache_alloc+0x95/0xc0
[  253.539356]  [<c015fcab>] ? __get_free_pages+0x1b/0x30
[  253.539356]  [<c0196658>] ? copy_mount_options+0x38/0x140
[  253.539356]  [<c0188dc7>] ? getname+0xa7/0xc0
[  253.539356]  [<c0198a0f>] ? sys_mount+0x6f/0xb0
[  253.539356]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  253.539356]  =======================
[  253.539356] Code: 89 da 89 f0 e8 61 ec ff ff 85 c0 0f 88 e6 f7 ff ff
8b 55 e0 8b 4b 54 8b 45 dc 31 d1 8b 53 50 31 db 31 d0 09 c1 0f 84 d1 f7
ff ff <0f> 0b eb fe 8b 83 b8 00 00 00 89 c2 0f b6 c8 c1 ea 0c 25 00 ff 
[  253.539356] EIP: [<c039bf71>] ocfs2_iget+0xa91/0xc90 SS:ESP
0068:cbb1fd54
[  253.554755] ---[ end trace 8befff9d4b19c14a ]---

Image can be found here:
http://www.cccmz.de/~snakebyte/ocfs2.4.img.bz2

Greetings, Eric
