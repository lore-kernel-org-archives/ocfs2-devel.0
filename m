From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar 23 19:56:12 2004
Subject: [Ocfs2-devel] [CRASH]Oops in journal_wip on first mount
In-Reply-To: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
References: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
Message-ID: <20040324015604.GA13687@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Small update... I just pulled an older svn tree (version 798, the version
that the OCFS_VERSION_2_BETA_2 tag was laid down), and the older version
does not have the problem.

I can then go and load the version 807 module again, and attempt to mount
the volume again to see the Oops once again. So... first time mount doesn't
seem to matter.

    --rusty

On Tue, Mar 23, 2004 at 05:38:48PM -0800, Rusty Lynch wrote:
> I am seeing the following crash on my 2.4 build as of the latest svn tree.
> (I have not tried to check-out an older tree to see if this goes away.)
> 
> I see this on a 2.4.22 kernel while attempting to mount a volume for the 
> first time.  My mount segfaults, leaving some crud behind...
> 
> [root@nobody root]# mount -t ocfs2 /dev/sdb1 /oracle 
> Segmentation fault
> [root@nobody root]# ps ax|grep ocfs
>  4368 ?        SW     0:00 [ocfs2nm-0]
>  4370 ?        SW     0:00 [ocfs2lsnr]
> 
>     --rusty
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> e0865077
> *pde = 00000000
> Oops: 0000
> ocfs2 parport_pc lp parport ide-cd cdrom autofs nfs lockd sunrpc rfcomm l2cap bluez e100 floppy sg microcode sbp2 ohci1394 ieee1394 keybdev mousedev hid input
> CPU:    0
> EIP:    0060:[<e0865077>]    Not tainted
> EFLAGS: 00010286
> 
> EIP is at journal_wipe_Re6b3bfe6 [jbd] 0x17 (2.4.22-1.2149.nptl)
> eax: 00000004   ebx: d8f6676c   ecx: 00000001   edx: 00000001
> esi: 00000000   edi: 00000000   ebp: 00000000   esp: d7471d44
> ds: 0068   es: 0068   ss: 0068
> Process mount (pid: 3272, stackpage=d7471000)
> Stack: d7471d6c 00000246 0000002a 00000000 c011d061 d8f6676c 00000cc8 d8f66000 
>        e0a12bcb 00000000 00000000 e0a33669 dae93580 d8f6676c d8f6676c 00000cc8 
>        e0a23ba4 d8f6676c 00000000 e0a3422e 00000000 e0a34715 00000001 00000001 
> Call Trace:   [<c011d061>] printk [kernel] 0x111 (0xd7471d54)
> [<e0a12bcb>] ocfs_journal_wipe [ocfs2] 0x6b (0xd7471d64)
> [<e0a33669>] .rodata.str1.1 [ocfs2] 0x2499 (0xd7471d70)
> [<e0a23ba4>] ocfs_check_volume [ocfs2] 0x4e8 (0xd7471d84)
> [<e0a3422e>] .rodata.str1.1 [ocfs2] 0x305e (0xd7471d90)
> [<e0a34715>] .rodata.str1.1 [ocfs2] 0x3545 (0xd7471d98)
> [<e0a28032>] ocfs_mount_volume [ocfs2] 0x5b6 (0xd7471dc4)
> [<e0a34a18>] .rodata.str1.1 [ocfs2] 0x3848 (0xd7471dd0)
> [<c011cd2f>] __call_console_drivers [kernel] 0x5f (0xd7471dd8)
> [<c011ce25>] call_console_drivers [kernel] 0x65 (0xd7471df4)
> [<e0a2c000>] ocfs_timeout_func [ocfs2] 0x0 (0xd7471e48)
> [<c0149ffd>] set_blocksize [kernel] 0xfd (0xd7471e6c)
> [<e0a26450>] ocfs_read_super [ocfs2] 0xf4 (0xd7471e84)
> [<c0149743>] get_sb_bdev [kernel] 0x1a3 (0xd7471eb4)
> [<e0a40310>] ocfs_fs_type [ocfs2] 0x0 (0xd7471ef8)
> [<c0149ab1>] do_kern_mount [kernel] 0x121 (0xd7471f00)
> [<e0a40310>] ocfs_fs_type [ocfs2] 0x0 (0xd7471f04)
> [<c015d053>] do_add_mount [kernel] 0x93 (0xd7471f24)
> [<c015d380>] do_mount [kernel] 0x160 (0xd7471f44)
> [<c015d1c9>] copy_mount_options [kernel] 0x79 (0xd7471f74)
> [<c015d7a1>] sys_mount [kernel] 0xb1 (0xd7471f94)
> [<c0109747>] system_call [kernel] 0x33 (0xd7471fc0)
> 
> 
> Code: f6 06 10 75 69 89 34 24 e8 7c f8 ff ff 85 c0 89 c3 75 0a 8b 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
