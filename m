From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar 23 21:08:34 2004
Subject: [Ocfs2-devel] Re: [CRASH]Oops in journal_wip on first mount
In-Reply-To: <20040324020542.GA13748@penguin.co.intel.com>
References: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
	<20040324015530.GD10672@ca-server1.us.oracle.com>
	<20040324020542.GA13748@penguin.co.intel.com>
Message-ID: <20040324030818.GA13959@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I think I somehow have a hosed tree.  I have checked out a totally new tree 
off the tip of svn, and have yet to reproduce the bug on this new checkout.

I normally nuke my pristine 2.4 tree and then recheckout, but this time I 
just did a svn update.  I'm not sure if that has anything to do with it
or if I did something to the tree that I forgot about (svn diff shows nothing??),
but my fresh build seems to work fine.

Is anyone else seeing this crash?

  --rusty

On Tue, Mar 23, 2004 at 06:05:42PM -0800, Rusty Lynch wrote:
> On Tue, Mar 23, 2004 at 05:55:30PM -0800, Mark Fasheh wrote:
> > On Tue, Mar 23, 2004 at 05:38:48PM -0800, Rusty Lynch wrote:
> > > I am seeing the following crash on my 2.4 build as of the latest svn tree.
> > > (I have not tried to check-out an older tree to see if this goes away.)
> > > 
> > > I see this on a 2.4.22 kernel while attempting to mount a volume for the 
> > > first time.  My mount segfaults, leaving some crud behind...
> > Are you sure this is a first mount? We're not supposed to be calling
> > journal_wipe on 1st mount...
> > 
> > Or is it a file system which failed the 1st mount and this is your second go
> > at a 1st mount?
> > 	--Mark
> 
> yeap.... just verified again and didn't get the exact same Oops, but the following:
> 
> 
> [root@nobody root]# mkfs -t ocfs2 -F -b 128 -g 0 -u 0 -L ocfs2 -m /oracle -p 775 /dev/sdb2
> Cleared volume header sectors
> Cleared node config sectors
> Cleared publish sectors
> Cleared vote sectors
> Cleared bitmap sectors
> Cleared data block
> Wrote volume header
> [root@nobody root]# tuneocfs -c 2 /dev/sdb2 Proceed (y/N): y
> Changes written to disk.
> [root@nobody root]# mount -t ocfs2 /dev/sdb2 /oracle 
> Segmentation fault
> [root@nobody root]# dmesg
> Unable to handle kernel NULL pointer dereference at virtual address 00000004
>  printing eip:
> c011aaa5
> *pde = 00000000
> Oops: 0002
> ocfs2 nfs lockd sunrpc e100 sbp2 ohci1394 ieee1394 keybdev mousedev hid input usb-ohci usbcore ext3 jbd aic7xxx sd_mod scsi_mod  
> CPU:    0
> EIP:    0060:[<c011aaa5>]    Not tainted
> EFLAGS: 00010046
> 
> EIP is at add_wait_queue [kernel] 0x15 (2.4.22-1.2149.nptl)
> eax: dad6c780   ebx: 00000000   ecx: dabd3f9c   edx: dabd3f94
> esi: 00000246   edi: dabd3fa4   ebp: dad6c780   esp: dabd3f38
> ds: 0068   es: 0068   ss: 0068
> Process ocfs2cmt-0 (pid: 2887, stackpage=dabd3000)
> Stack: 00000000 dad6c000 e09b0b18 00000000 00000000 00000000 dabd2000 dad6c78c 
>        dca8a900 00000000 00000000 00000000 dabd2000 00000000 00000000 00000000 
>        dabd2000 00000000 00000000 00000000 dabd2000 00000000 00000000 00000000 
> Call Trace:   [<e09b0b18>] ocfs_commit_thread [ocfs2] 0x460 (0xdabd3f40)
> [<e09c8000>] ocfs_timeout_func [ocfs2] 0x0 (0xdabd3fb4)
> [<e09b06b8>] ocfs_commit_thread [ocfs2] 0x0 (0xdabd3fe0)
> [<c010734d>] kernel_thread_helper [kernel] 0x5 (0xdabd3ff0)
> 
> 
> Code: 89 4b 04 89 5a 08 89 41 04 89 08 56 9d 8b 1c 24 8b 74 24 04 
>  lockres: lockid=512.0, this=0, master=-1, locktype=0, flags=40002001, ronode=-1, romap=00000000
> new_lock_function: set lockid=512.0, locktype=0->2, master=-1->0
> lockres: lockid=512.0, this=0, master=0, locktype=0, flags=40000401, ronode=-1, romap=00000000
> new_lock_function: set lockid=512.0, locktype=0->2, master=0->0
> lockres: lockid=1024.0, this=0, master=-1, locktype=0, flags=40002000, ronode=-1, romap=00000000
> new_lock_function: set lockid=1024.0, locktype=0->2, master=-1->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=0, flags=40000401, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=0->2, master=0->0
> lockres: lockid=1024.0, this=0, master=0, locktype=0, flags=40000400, ronode=-1, romap=00000000
> new_lock_function: set lockid=1024.0, locktype=0->2, master=0->0
> lockres: lockid=1024.0, this=0, master=0, locktype=0, flags=40000400, ronode=-1, romap=00000000
> new_lock_function: set lockid=1024.0, locktype=0->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1024.0, this=0, master=0, locktype=0, flags=40000400, ronode=-1, romap=00000000
> new_lock_function: set lockid=1024.0, locktype=0->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1024.0, this=0, master=0, locktype=0, flags=40000400, ronode=-1, romap=00000000
> new_lock_function: set lockid=1024.0, locktype=0->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1417216.0, this=0, master=0, locktype=8, flags=40004001, ronode=-1, romap=00000000
> new_lock_function: set lockid=1417216.0, locktype=8->2, master=0->0
> lockres: lockid=1482752.0, this=0, master=0, locktype=0, flags=40000401, ronode=-1, romap=00000000
> new_lock_function: set lockid=1482752.0, locktype=0->2, master=0->0
> lockres: lockid=1024.0, this=0, master=0, locktype=0, flags=40000400, ronode=-1, romap=00000000
> new_lock_function: set lockid=1024.0, locktype=0->2, master=0->0
> ocfs2: Old journal type found, converting to new style. You will no longer be able to mount with ocfs version 1.
> Unable to handle kernel NULL pointer dereference at virtual address 000000a8
>  printing eip:
> e086457b
> *pde = 00000000
> Oops: 0000
> ocfs2 nfs lockd sunrpc e100 sbp2 ohci1394 ieee1394 keybdev mousedev hid input usb-ohci usbcore ext3 jbd aic7xxx sd_mod scsi_mod  
> CPU:    0
> EIP:    0060:[<e086457b>]    Not tainted
> EFLAGS: 00010282
> 
> EIP is at journal_create_R761fb3d6 [jbd] 0xb (2.4.22-1.2149.nptl)
> eax: dad6c76c   ebx: dad6c76c   ecx: 00000001   edx: dad84000
> esi: 00000000   edi: dad6c000   ebp: 00000000   esp: dad85d40
> ds: 0068   es: 0068   ss: 0068
> Process mount (pid: 2885, stackpage=dad85000)
> Stack: 00000282 c03aa8d1 00000246 00000071 00000000 dad6c76c 00000000 dad6c000 
>        00000000 e09ae0fc 00000000 dad6c000 00000000 dabe0380 dabe0380 dabe0380 
>        00000000 e09bf8a5 dad6c76c dad85db0 00000000 00000000 00000000 00000000 
> Call Trace:   [<e09ae0fc>] ocfs_journal_create [ocfs2] 0x74 (0xdad85d64)
> [<e09bf8a5>] ocfs_check_volume [ocfs2] 0x1e9 (0xdad85d84)
> [<e09c4032>] ocfs_mount_volume [ocfs2] 0x5b6 (0xdad85dc4)
> [<e09c4312>] ocfs_mount_volume [ocfs2] 0x896 (0xdad85dd4)
> [<e09c8000>] ocfs_timeout_func [ocfs2] 0x0 (0xdad85e48)
> [<e09c2450>] ocfs_read_super [ocfs2] 0xf4 (0xdad85e84)
> [<c0149743>] get_sb_bdev [kernel] 0x1a3 (0xdad85eb4)
> [<e09dc310>] ocfs_fs_type [ocfs2] 0x0 (0xdad85ef8)
> [<c0149ab1>] do_kern_mount [kernel] 0x121 (0xdad85f00)
> [<e09dc310>] ocfs_fs_type [ocfs2] 0x0 (0xdad85f04)
> [<c015d053>] do_add_mount [kernel] 0x93 (0xdad85f24)
> [<c015d380>] do_mount [kernel] 0x160 (0xdad85f44)
> [<c015d1c9>] copy_mount_options [kernel] 0x79 (0xdad85f74)
> [<c015d7a1>] sys_mount [kernel] 0xb1 (0xdad85f94)
> [<c0109747>] system_call [kernel] 0x33 (0xdad85fc0)
> 
> 
> Code: 8b 85 a8 00 00 00 3d ff 03 00 00 0f 86 5c 01 00 00 8b 95 ac 
>  
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
