From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue, 27 May 2008 19:29:37 -0700
Subject: [Ocfs2-devel] Filesystem fuzzing
In-Reply-To: <20080527080052.GA9193@alice>
References: <20080519100737.GA7764@alice> <48345A30.9030004@oracle.com>
	<20080527080052.GA9193@alice>
Message-ID: <483CC391.9000607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Eric,

Thanks. I've filed few bugzillas for tracking them.
I'll need to think about this.

http://oss.oracle.com/bugzilla/show_bug.cgi?id=970
http://oss.oracle.com/bugzilla/show_bug.cgi?id=971

Eric Sesterhenn wrote:
> * Sunil Mushran (Sunil.Mushran at oracle.com) wrote:
>   
>> Eric Sesterhenn wrote:
>>     
>>> i do some regular filesystem fuzzing, based on a modified version
>>> of lmhs fsfuzzer. I try to test current -git at least once a week.
>>> Most modifications are adding of new filesystems or mounting
>>> them with different options, but i also added some new tests like invoking 
>>> iozone, fsx or fsstress if available
>>>
>>> I currently test  vfat, udf, msdos, swap, iso9660, ext2,
>>> ext3, ext4, hfs, hfsplus, gfs2, ntfs, minix, qnx4, affs and bfs
>>>       
>> Please can you add ocfs2 to the mix. To make it easy, you
>> can format with "mkfs.ocfs2 -M local" to mark the volume
>> for local mount only and thus not deal with any cluster config.
>>     
>
> here is a first one:
>
> [  146.790010] (4230,0):ocfs2_read_locked_inode:475 ERROR: bug
> expression: !!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
> !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)
> [  146.790282] (4230,0):ocfs2_read_locked_inode:475 ERROR: Inode 9: system file state is ambigous
> [  146.790584] ------------[ cut here ]------------
> [  146.790717] kernel BUG at fs/ocfs2/inode.c:475!
> [  146.790848] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [  146.791224] Modules linked in:
> [  146.791381] 
> [  146.791381] Pid: 4230, comm: mount.ocfs2 Not tainted (2.6.26-rc4 #44)
> [  146.791381] EIP: 0060:[<c039bb9f>] EFLAGS: 00010282 CPU: 0
> [  146.791381] EIP is at ocfs2_iget+0x6bf/0xc90
> [  146.791381] EAX: 00000065 EBX: 000001db ECX: 00000001 EDX: 00000001
> [  146.791381] ESI: 00000000 EDI: 00000000 EBP: cbf83db4 ESP: cbf83d54
> [  146.791381]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  146.791381] Process mount.ocfs2 (pid: 4230, ti=cbf83000 task=cbf8af70 task.ti=cbf83000)
> [  146.791381] Stack: c081be00 00001086 00000000 c06f978f 000001db 00000009 00000000 c08dcddc 
> [  146.791381]        c038be6b 000000d0 ccae339e cbf83d88 00000000 cbf83db4 c038be76 00000009 
> [  146.791381]        00000000 00000009 00000001 00000000 cc33ea28 00000000 cbe14180 c7879800 
> [  146.791381] Call Trace:
> [  146.791381]  [<c038be6b>] ? ocfs2_new_dlm_debug+0x1b/0x100
> [  146.791381]  [<c038be76>] ? ocfs2_new_dlm_debug+0x26/0x100
> [  146.791381]  [<c03c556a>] ? ocfs2_fill_super+0x1f2a/0x2910
> [  146.791381]  [<c018281f>] ? get_sb_bdev+0xef/0x120
> [  146.791381]  [<c019758d>] ? alloc_vfsmnt+0xdd/0x120
> [  146.791381]  [<c019758d>] ? alloc_vfsmnt+0xdd/0x120
> [  146.791381]  [<c03bf742>] ? ocfs2_get_sb+0x22/0x30
> [  146.791381]  [<c03c3640>] ? ocfs2_fill_super+0x0/0x2910
> [  146.791381]  [<c018236a>] ? vfs_kern_mount+0x3a/0x90
> [  146.791381]  [<c0182419>] ? do_kern_mount+0x39/0xd0
> [  146.791381]  [<c01987c5>] ? do_new_mount+0x65/0x90
> [  146.791381]  [<c019894a>] ? do_mount+0x15a/0x1b0
> [  146.791381]  [<c017bab5>] ? kmem_cache_alloc+0x95/0xc0
> [  146.791381]  [<c015fcab>] ? __get_free_pages+0x1b/0x30
> [  146.791381]  [<c0196658>] ? copy_mount_options+0x38/0x140
> [  146.791381]  [<c0188dc7>] ? getname+0xa7/0xc0
> [  146.791381]  [<c0198a0f>] ? sys_mount+0x6f/0xb0
> [  146.791381]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
> [  146.791381]  =======================
> [  146.791381] Code: 09 8b c0 31 d2 89 d1 83 e0 01 09 c1 74 1d f6 05 6a
> 09 8b c0 80 75 14 a1 6c 09 8b c0 31 d2 89 d3 83 e0 01 09 c3 0f 84 56 04
> 00 00 <0f> 0b eb fe 89 f0 e8 36 96 df ff 81 fb 00 fe ff ff 0f 84 cc fb 
> [  146.791381] EIP: [<c039bb9f>] ocfs2_iget+0x6bf/0xc90 SS:ESP 0068:cbf83d54
> [  146.806059] ---[ end trace 48ff23e66ef1f905 ]---
>
> Image can be found at http://cccmz.de/~snakebyte/ocfs2.3.img.bz2
> (server is a bit flaky at the moment due to dns
> issues, just try again if you get the united domains site)
>
> Greetings, Eric
>   
