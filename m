From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Mar 23 21:15:11 2004
Subject: [Ocfs2-devel] Re: [CRASH]Oops in journal_wip on first mount
Message-ID: <3ACA40606221794F80A5670F0AF15F8403AEC0D3@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes, I also met the crash on my 2.4.20 kernel.

> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com=20
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Rusty Lynch
> Sent: 2004=C4=EA3=D4=C224=C8=D5 11:08
> To: mark.fasheh@oracle.com
> Cc: ocfs2-devel@oss.oracle.com
> Subject: Re: [Ocfs2-devel] Re: [CRASH]Oops in journal_wip on=20
> first mount
>=20
>=20
> I think I somehow have a hosed tree.  I have checked out a=20
> totally new tree=20
> off the tip of svn, and have yet to reproduce the bug on this=20
> new checkout.
>=20
> I normally nuke my pristine 2.4 tree and then recheckout, but=20
> this time I=20
> just did a svn update.  I'm not sure if that has anything to=20
> do with it or if I did something to the tree that I forgot=20
> about (svn diff shows nothing??), but my fresh build seems to=20
> work fine.
>=20
> Is anyone else seeing this crash?
>=20
>   --rusty
>=20
> On Tue, Mar 23, 2004 at 06:05:42PM -0800, Rusty Lynch wrote:
> > On Tue, Mar 23, 2004 at 05:55:30PM -0800, Mark Fasheh wrote:
> > > On Tue, Mar 23, 2004 at 05:38:48PM -0800, Rusty Lynch wrote:
> > > > I am seeing the following crash on my 2.4 build as of=20
> the latest=20
> > > > svn tree. (I have not tried to check-out an older tree=20
> to see if=20
> > > > this goes away.)
> > > >=20
> > > > I see this on a 2.4.22 kernel while attempting to mount=20
> a volume=20
> > > > for the
> > > > first time.  My mount segfaults, leaving some crud behind...
> > > Are you sure this is a first mount? We're not supposed to=20
> be calling=20
> > > journal_wipe on 1st mount...
> > >=20
> > > Or is it a file system which failed the 1st mount and=20
> this is your=20
> > > second go at a 1st mount?
> > > 	--Mark
> >=20
> > yeap.... just verified again and didn't get the exact same=20
> Oops, but=20
> > the following:
> >=20
> >=20
> > [root@nobody root]# mkfs -t ocfs2 -F -b 128 -g 0 -u 0 -L ocfs2 -m=20
> > /oracle -p 775 /dev/sdb2 Cleared volume header sectors Cleared node=20
> > config sectors Cleared publish sectors
> > Cleared vote sectors
> > Cleared bitmap sectors
> > Cleared data block
> > Wrote volume header
> > [root@nobody root]# tuneocfs -c 2 /dev/sdb2 Proceed (y/N): y
> > Changes written to disk.
> > [root@nobody root]# mount -t ocfs2 /dev/sdb2 /oracle=20
> > Segmentation fault
> > [root@nobody root]# dmesg
> > Unable to handle kernel NULL pointer dereference at virtual=20
> address 00000004
> >  printing eip:
> > c011aaa5
> > *pde =3D 00000000
> > Oops: 0002
> > ocfs2 nfs lockd sunrpc e100 sbp2 ohci1394 ieee1394 keybdev=20
> mousedev hid input usb-ohci usbcore ext3 jbd aic7xxx sd_mod scsi_mod =20
> > CPU:    0
> > EIP:    0060:[<c011aaa5>]    Not tainted
> > EFLAGS: 00010046
> >=20
> > EIP is at add_wait_queue [kernel] 0x15 (2.4.22-1.2149.nptl)
> > eax: dad6c780   ebx: 00000000   ecx: dabd3f9c   edx: dabd3f94
> > esi: 00000246   edi: dabd3fa4   ebp: dad6c780   esp: dabd3f38
> > ds: 0068   es: 0068   ss: 0068
> > Process ocfs2cmt-0 (pid: 2887, stackpage=3Ddabd3000)
> > Stack: 00000000 dad6c000 e09b0b18 00000000 00000000=20
> 00000000 dabd2000 dad6c78c=20
> >        dca8a900 00000000 00000000 00000000 dabd2000=20
> 00000000 00000000 00000000=20
> >        dabd2000 00000000 00000000 00000000 dabd2000=20
> 00000000 00000000 00000000=20
> > Call Trace:   [<e09b0b18>] ocfs_commit_thread [ocfs2] 0x460=20
> (0xdabd3f40)
> > [<e09c8000>] ocfs_timeout_func [ocfs2] 0x0 (0xdabd3fb4)=20
> [<e09b06b8>]=20
> > ocfs_commit_thread [ocfs2] 0x0 (0xdabd3fe0) [<c010734d>]=20
> > kernel_thread_helper [kernel] 0x5 (0xdabd3ff0)
> >=20
> >=20
> > Code: 89 4b 04 89 5a 08 89 41 04 89 08 56 9d 8b 1c 24 8b 74 24 04
> >  lockres: lockid=3D512.0, this=3D0, master=3D-1, locktype=3D0,=20
> flags=3D40002001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D512.0, locktype=3D0->2, =
master=3D-1->0
> > lockres: lockid=3D512.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000401, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D512.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1024.0, this=3D0, master=3D-1, locktype=3D0,=20
> flags=3D40002000, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1024.0, locktype=3D0->2, =
master=3D-1->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000401, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000400, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1024.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000400, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1024.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000400, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1024.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000400, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1024.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8,=20
> flags=3D40004001, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1417216.0, locktype=3D8->2, =
master=3D0->0
> > lockres: lockid=3D1482752.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000401, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1482752.0, locktype=3D0->2, =
master=3D0->0
> > lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0,=20
> flags=3D40000400, ronode=3D-1, romap=3D00000000
> > new_lock_function: set lockid=3D1024.0, locktype=3D0->2, =
master=3D0->0
> > ocfs2: Old journal type found, converting to new style. You=20
> will no longer be able to mount with ocfs version 1.
> > Unable to handle kernel NULL pointer dereference at virtual=20
> address 000000a8
> >  printing eip:
> > e086457b
> > *pde =3D 00000000
> > Oops: 0000
> > ocfs2 nfs lockd sunrpc e100 sbp2 ohci1394 ieee1394 keybdev=20
> mousedev hid input usb-ohci usbcore ext3 jbd aic7xxx sd_mod scsi_mod =20
> > CPU:    0
> > EIP:    0060:[<e086457b>]    Not tainted
> > EFLAGS: 00010282
> >=20
> > EIP is at journal_create_R761fb3d6 [jbd] 0xb (2.4.22-1.2149.nptl)
> > eax: dad6c76c   ebx: dad6c76c   ecx: 00000001   edx: dad84000
> > esi: 00000000   edi: dad6c000   ebp: 00000000   esp: dad85d40
> > ds: 0068   es: 0068   ss: 0068
> > Process mount (pid: 2885, stackpage=3Ddad85000)
> > Stack: 00000282 c03aa8d1 00000246 00000071 00000000=20
> dad6c76c 00000000 dad6c000=20
> >        00000000 e09ae0fc 00000000 dad6c000 00000000=20
> dabe0380 dabe0380 dabe0380=20
> >        00000000 e09bf8a5 dad6c76c dad85db0 00000000=20
> 00000000 00000000 00000000=20
> > Call Trace:   [<e09ae0fc>] ocfs_journal_create [ocfs2] 0x74=20
> (0xdad85d64)
> > [<e09bf8a5>] ocfs_check_volume [ocfs2] 0x1e9 (0xdad85d84)=20
> [<e09c4032>]=20
> > ocfs_mount_volume [ocfs2] 0x5b6 (0xdad85dc4) [<e09c4312>]=20
> > ocfs_mount_volume [ocfs2] 0x896 (0xdad85dd4) [<e09c8000>]=20
> > ocfs_timeout_func [ocfs2] 0x0 (0xdad85e48) [<e09c2450>]=20
> > ocfs_read_super [ocfs2] 0xf4 (0xdad85e84) [<c0149743>] get_sb_bdev=20
> > [kernel] 0x1a3 (0xdad85eb4) [<e09dc310>] ocfs_fs_type [ocfs2] 0x0=20
> > (0xdad85ef8) [<c0149ab1>] do_kern_mount [kernel] 0x121 (0xdad85f00)
> > [<e09dc310>] ocfs_fs_type [ocfs2] 0x0 (0xdad85f04)
> > [<c015d053>] do_add_mount [kernel] 0x93 (0xdad85f24)
> > [<c015d380>] do_mount [kernel] 0x160 (0xdad85f44)
> > [<c015d1c9>] copy_mount_options [kernel] 0x79 (0xdad85f74)
> > [<c015d7a1>] sys_mount [kernel] 0xb1 (0xdad85f94)
> > [<c0109747>] system_call [kernel] 0x33 (0xdad85fc0)
> >=20
> >=20
> > Code: 8b 85 a8 00 00 00 3d ff 03 00 00 0f 86 5c 01 00 00 8b 95 ac
> > =20
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com=20
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com=20
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>=20
