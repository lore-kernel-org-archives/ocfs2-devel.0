From: Chen, Yukun <yukun.chen@intel.com>
Date: Wed Jun 16 04:22:25 2004
Subject: [Ocfs2-devel] 
	System hang issue when 2 processes on same node write to a file
	simultaneousely
Message-ID: <B44D37711ED29844BEA67908EAF36F031C39EF@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

   I meet a system hang when trying do a file-writing operation on 2
process in same node. Steps to duplicate

  

   1.load_ocfs2 

   2. mkfs.ocfs2 -b 4 -L ocfs2 -m /ocfs /dev/sdc2

   3. mount /dev/sdc2 /ocfs -t ocfs2

   4. process 1 writes to /ocfs2/testfile 1000 times at file-offset 100,
in the meanwhile, process 2 writes to the same file at the same offset.
Then system hang with the following message from dmesg:

 

##################################################3

kernel BUG at ll_rw_blk.c:1027!

invalid operand: 0000

ocfs2 lp parport autofs e100 e1000 floppy sg microcode keybdev mousedev
hid input usb-uhci usbcore ext3 jbd qla2300 qla2300_conf aic7xxx sd_mod
scsi_mod  

CPU:    0

EIP:    0060:[<c01bda27>]    Not tainted

EFLAGS: 00010246

 

EIP is at __make_request [kernel] 0xb7 (2.4.22-1.2115.nptl)

eax: 0000000c   ebx: 00000000   ecx: 00000000   edx: dc43ec80

esi: 00000001   edi: 00f0a400   ebp: df0c4414   esp: dc223de8

ds: 0068   es: 0068   ss: 0068

Process ocfs2nm-0 (pid: 5034, stackpage=dc223000)

Stack: dc43ec80 00000000 e0a96ba7 dff0be80 000000f0 c038ff98 e0a96e60
dcda7e00 

       5d700000 00000080 00000000 00000000 df0c4444 000007f9 00000000
00000001 

       0000002a 000007f9 dc43ec80 00000001 00f0a400 0000002a c01be1ea
df0c4414 

Call Trace:   [<e0a96ba7>] ocfs_bh_sem_alloc [ocfs2] 0x13 (0xdc223df0)

[<e0a96e60>] ocfs_bh_sem_lookup [ocfs2] 0x134 (0xdc223e00)

[<c01be1ea>] generic_make_request [kernel] 0xda (0xdc223e40)

[<e0a96fe5>] ocfs_bh_sem_lock [ocfs2] 0x21 (0xdc223e50)

[<c01be297>] submit_bh [kernel] 0x57 (0xdc223e68)

[<e0a9ad7f>] ocfs_read_bhs [ocfs2] 0x2b3 (0xdc223e90)

[<e0a96bbe>] ocfs_bh_sem_free [ocfs2] 0x12 (0xdc223ea0)

[<e0aa2bc1>] ocfs_volume_thread [ocfs2] 0x181 (0xdc223ee0)

[<c0109b52>] ret_from_fork [kernel] 0x6 (0xdc223fbc)

[<e0aa2a40>] ocfs_volume_thread [ocfs2] 0x0 (0xdc223fe0)

[<c010741d>] kernel_thread_helper [kernel] 0x5 (0xdc223ff0)

 

 

Code: 0f 0b 03 04 44 4f 29 c0 8b 4c 24 64 8b 15 f0 f8 3d c0 8b 41 

 ------------[ cut here ]------------

kernel BUG at ll_rw_blk.c:1027!

invalid operand: 0000

ocfs2 lp parport autofs e100 e1000 floppy sg microcode keybdev mousedev
hid input usb-uhci usbcore ext3 jbd qla2300 qla2300_conf aic7xxx sd_mod
scsi_mod  

CPU:    0

EIP:    0060:[<c01bda27>]    Not tainted

EFLAGS: 00010246

 

EIP is at __make_request [kernel] 0xb7 (2.4.22-1.2115.nptl)

eax: 00000200   ebx: 00000001   ecx: 00000001   edx: dcedf580

esi: 00000001   edi: 00f0a400   ebp: df0c4414   esp: dcedbd80

ds: 0068   es: 0068   ss: 0068

Process kjournald (pid: 5036, stackpage=dcedb000)

Stack: 00000039 00000048 00000202 00000001 00000001 00000001 00000001
df0c3000 

       00000287 00000200 00000000 00000000 df0c4444 defedc00 00000000
00000001 

       00001378 0003344c dcedf580 00000001 00f0a400 00001378 c01be1ea
df0c4414 

Call Trace:   [<c01be1ea>] generic_make_request [kernel] 0xda
(0xdcedbdd8)

[<c01be297>] submit_bh [kernel] 0x57 (0xdcedbe00)

[<c01476db>] __refile_buffer [kernel] 0x5b (0xdcedbe14)

[<c01be426>] ll_rw_block [kernel] 0xf6 (0xdcedbe28)

[<e095991c>] journal_update_superblock_R8547d76d [jbd] 0x5c (0xdcedbe50)

[<e0956842>] journal_commit_transaction [jbd] 0x10f2 (0xdcedbe6c)

[<c0119320>] recalc_task_prio [kernel] 0x90 (0xdcedbf0c)

[<c011b389>] context_switch [kernel] 0x79 (0xdcedbf44)

[<c0119e78>] schedule [kernel] 0x258 (0xdcedbf64)

[<e0958c3a>] kjournald [jbd] 0x13a (0xdcedbfb8)

[<e0958b00>] kjournald [jbd] 0x0 (0xdcedbfc4)

[<e0958ae0>] commit_timeout [jbd] 0x0 (0xdcedbfd8)

[<e0958b00>] kjournald [jbd] 0x0 (0xdcedbfe8)

[<c010741d>] kernel_thread_helper [kernel] 0x5 (0xdcedbff0)

#################################################################33

   

Any ideas about it? 

Thanx. 

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040616/fb9c2f11/attachment.htm
