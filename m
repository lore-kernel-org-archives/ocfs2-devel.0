From: Chen, Yukun <yukun.chen@intel.com>
Date: Thu Jun  3 06:05:09 2004
Subject: [Ocfs2-devel] A defect  of latest code of ocfs2 on kernel 2.4.22
Message-ID: <941A6821ACE16D4BBB8A958A0EB047F746D4F3@pdsmsx404.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
   I find a defect with the latest code in a 2-nodes enviornment.
 
Step to duplicate:
on node1
   1. load_ocfs2
   2. mkfs.ocfs2 -b 4 -F -L ocfs2 -m /ocfs /dev/sdc2
   3. mount /dev/sdc2 /ocfs -t ocfs2
 
then on node2   
   4. load_ocfs2
   5. mount /dev/sdc2 /ocfs -t ocfs2
 
on node1
    6. mkdir /ocfs/foo
 
on node2
    7. fstat /ocfs/foo
 
then umount,rmmod in node1 & node2 respectively. Everything is ok until now. 
But I  fails to insert ocfs2 mod again on node2 with error message by dmesg:
 
.....
sectbits=9, clusterbits=12, dirbits=17, filebits=9, inodebits=9
ocfs2: Adding west1 (node 0) to clustered device (8,34)
the attribe of fe is 1, FILthe attribe of fe is 0, FILthe attribe of fe is 0, 
FILthe attribe of fe is 0, FILthe attribe of fe is 0, FIL<3>(4806) ERROR at 
dlm.c, 1393: DISKVOTE!!: req_lock=2, flags=40000401, offset=1532416, 
inode=1532416
(4806) ERROR at dlm.c, 1396: DISKVOTE!!: this=1, master=0, locktype=0, ronode=-
1, romap=00000000
Call Trace: 
[<dd0c5c38>]   (0xdd0c5c38)
??????.
 [<c0ed0000>]   (0xdd0c5fd0)
 
JBD: Ignoring recovery information on journal
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (8,34) on west2 (node 1)
(4840) ERROR at dlm.c, 1393: DISKVOTE!!: req_lock=8, flags=40001400, 
offset=1536, inode=1536
(4840) ERROR at dlm.c, 1396: DISKVOTE!!: this=1, master=0, locktype=0, ronode=-
1, romap=00000000
Call Trace: 
 [<c0109b9f>]   (0xdc321fc0)
???.
(4840) ERROR at dlm.c, 1393: DISKVOTE!!: req_lock=2, flags=40000401, 
offset=1565184, inode=1565184
(4840) ERROR at dlm.c, 1396: DISKVOTE!!: this=1, master=0, locktype=0, ronode=-
1, romap=00000000
Call Trace: 
[<dc321cd0>]   (0xdc321cd0)
???..
 [<c0109b9f>]   (0xdc321fc0)
 
(4840) ERROR at dlm.c, 1393: DISKVOTE!!: req_lock=2, flags=40000400, 
offset=1024, inode=1024
(4840) ERROR at dlm.c, 1396: DISKVOTE!!: this=1, master=0, locktype=0, ronode=-
1, romap=00000000
Call Trace: 
[<dc321be0>]   (0xdc321be0)
 [<c0109b9f>]   (0xdc321fc0)
??????
(4840) ERROR at journal.c, 245: Inode 2 already has a transaction!
the attribe of fe is 1, FIL<3>(4840) ERROR at journal.c, 245: Inode 2 already 
has a transaction!
ocfs2: Received dismount message for device (8,34) from west1 (node 0)
ocfs2: Unmounting device (8,34) on west2 (node 1)
kmem_cache_destroy: Can't free all objects dff0be14
Unloaded OCFS Driver module
....
 
Any idea for it?
Thanx.

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040603/f165e911/attachment-0001.htm
