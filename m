From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue Jun 15 00:42:26 2004
Subject: [Ocfs2-devel] first mount error with latest code (revision1086)
Message-ID: <B44D37711ED29844BEA67908EAF36F0315E6F9@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yeah. I can mount normally after disable tracing.
Thanx.

Aaron

-----Original Message-----
From: Sunil Mushran [mailto:Sunil.Mushran@oracle.com]=20
Sent: 2004=C4=EA6=D4=C215=C8=D5 7:48
To: Chen, Yukun
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] first mount error with latest code =
(revision1086)

Disable tracing. I guess the format change must not have accounted for
in this debug routine. Or you can comment out that call.
=20
On Sun, 2004-06-13 at 23:05, Chen, Yukun wrote:
> Hi all
> I encounter a "Segment Fault" when mount an ocfs2 partition.=20
> =20
> Steps to duplicate:
> =20
> 1.load_ocfs2
> 2.mkfs.ocfs2 -b 4 -L ocfs2 -F -m /ocfs /dev/sdc2
> 3.mount /dev/sdc2 /ocfs -t ocfs2
> =20
> Then I get "Segment Fault" with following message produced by dmesg:
> =20
> ......
> Unable to handle kernel NULL pointer dereference at virtual address =
0000002c
>  printing eip:
> e0abbc87
> *pde =3D 00000000
> Oops: 0000
> ocfs2 lp parport autofs e100 e1000 floppy sg microcode keybdev =
mousedev hid=20
> input usb-uhci usbcore ext3 jbd qla2300 qla2300_conf aic7xxx sd_mod =
scsi_mod =20
> CPU:    0
> EIP:    0060:[<e0abbc87>]    Not tainted
> EFLAGS: 00010203
> =20
> EIP is at ocfs_show_all_node_cfgs [ocfs2] 0x2b3 (2.4.22-1.2115.nptl)
> eax: 00000000   ebx: dd932600   ecx: 00000000   edx: dbb64110
> esi: ddbdb9c0   edi: ddbdb9c0   ebp: df3cc000   esp: dc4efc58
> ds: 0068   es: 0068   ss: 0068
> Process mount (pid: 5261, stackpage=3Ddc4ef000)
> Stack: df3cc000 00000000 df3cc000 e0abaeb0 dd932600 ddbdb9c0 00000000 =
00000000=20
>        dc4ee000 08230001 0000086e 00000000 ddbdb9c0 00000000 00000000 =
00001000=20
>        0000dc00 00000000 df3cc000 dfc21e80 df3cc000 dfc21f10 df3cc000 =
e0abb4c5=20
> Call Trace:   [<e0abaeb0>] ocfs_chk_update_config [ocfs2] 0x134 =
(0xdc4efc64)
> [<e0abb4c5>] ocfs_get_config [ocfs2] 0x5d (0xdc4efcb4)
> [<e0ab5ca1>] ocfs_initialize_osb [ocfs2] 0x881 (0xdc4efcd4)
> [<c011d9bf>] __call_console_drivers [kernel] 0x5f (0xdc4efce8)
> [<e0ab40d6>] ocfs_mount_volume [ocfs2] 0x232 (0xdc4efdb4)
> [<e0ab2c5c>] __ocfs_read_super [ocfs2] 0xc4 (0xdc4efe64)
> [<e0ab2e33>] ocfs_read_super [ocfs2] 0x23 (0xdc4efe94)
> [<c014b183>] get_sb_bdev [kernel] 0x1a3 (0xdc4efeb4)
> [<e0acb670>] ocfs_fs_type [ocfs2] 0x0 (0xdc4efef8)
> [<c014b4f1>] do_kern_mount [kernel] 0x121 (0xdc4eff00)
> [<e0acb670>] ocfs_fs_type [ocfs2] 0x0 (0xdc4eff04)
> [<c015ec53>] do_add_mount [kernel] 0x93 (0xdc4eff24)
> [<c015ef80>] do_mount [kernel] 0x160 (0xdc4eff44)
> [<c015edc9>] copy_mount_options [kernel] 0x79 (0xdc4eff74)
> [<c015f3a1>] sys_mount [kernel] 0xb1 (0xdc4eff94)
> [<c0109b9f>] system_call [kernel] 0x33 (0xdc4effc0)
> .......
> =20
> Any ideas for it?
> =20
> Thanx.
> =20
>=20
> Aaron
>=20
> Intel China Software Lab
>=20
> Tel:  8621-52574545 Ext.1587
>=20
> E_mail:yukun.chen@intel.com
>=20
> =20
>=20
>=20
>=20
> ______________________________________________________________________
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
