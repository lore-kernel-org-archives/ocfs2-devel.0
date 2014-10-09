From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 9 Oct 2014 09:23:52 +0000
Subject: [Ocfs2-devel] Hi,
	is there any way to restore the corrupted disk? Thanks.
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC764F7@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All

As we test the OCFS2, the disk is corrupted with dd command manually and so some meta data is lost.
We restore the data, there is about 1M meta data can't restored.
How can we restore the data from disk?
So from 00100000 to 00207000, the meta data is lost.
Is anywhere on the disk backup this meta data?
Thanks

fsck.ocfs2 -r 6 /dev/sdd
fsck.ocfs2 1.6.3
[RECOVER_BACKUP_SUPERBLOCK] Recover superblock information from backup block#268435456? <n> y
fsck.ocfs2: Bad magic number in inode while initializing the DLM

fsck.ocfs2 -fpy /dev/sdd
fsck.ocfs2 1.6.3
fsck.ocfs2: Bad magic number in inode while initializing the DLM


00002180  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00200000  00 00 00 00 00 40 00 00  00 00 00 00 00 00 00 00  |..... at ..........|
00200010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00207000  49 4e 4f 44 45 30 31 00  f7 50 ac 08 ff ff 07 00  |INODE01..P......|


The disk layout is as below:
root at H3CRDS14-RD:~# hexdump -C /dev/sdd |more
00000000  02 02 02 02 02 02 02 02  74 68 69 73 20 69 73 20  |........this is |
00000010  61 6e 20 6f 63 66 73 32  20 76 6f 6c 75 6d 65 00  |an ocfs2 volume.|
00000020  02 02 02 02 02 02 02 02  02 02 02 02 02 02 02 02  |................|
*
00000080  02 02 02 02 02 02 02 02  74 68 69 73 20 69 73 20  |........this is |
00000090  61 6e 20 6f 63 66 73 32  20 76 6f 6c 75 6d 65 00  |an ocfs2 volume.|
000000a0  02 02 02 02 02 02 02 02  02 02 02 02 02 02 02 02  |................|
*
00000230  74 68 69 73 20 69 73 20  61 6e 20 6f 63 66 73 32  |this is an ocfs2|
00000240  20 76 6f 6c 75 6d 65 00  02 02 02 02 02 02 02 02  | volume.........|
00000250  02 02 02 02 02 02 02 02  02 02 02 02 02 02 02 02  |................|
*
00000280  02 02 02 02 74 68 69 73  20 69 73 20 61 6e 20 6f  |....this is an o|
00000290  63 66 73 32 20 76 6f 6c  75 6d 65 00 02 02 02 02  |cfs2 volume.....|
000002a0  02 02 02 02 02 02 02 02  02 02 02 02 02 02 02 02  |................|
*
00002000  4f 43 46 53 56 32 00 00  f7 50 ac 08 ff ff ff ff  |OCFSV2...P......|
00002010  00 00 00 00 00 00 30 00  00 00 00 00 00 00 00 00  |......0.........|
00002020  00 00 00 00 00 00 00 00  00 00 00 00 31 00 00 00  |............1...|
00002030  00 00 00 00 00 00 00 00  ad 60 38 51 00 00 00 00  |.........`8Q....|
00002040  ad 60 38 51 00 00 00 00  00 00 00 00 00 00 00 00  |.`8Q............|
00002050  02 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00002060  f7 50 ac 08 00 00 00 00  00 00 00 00 00 00 00 00  |.P..............|
00002070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000020c0  00 00 5a 00 00 00 14 00  00 00 00 00 00 00 00 00  |..Z.............|
000020d0  ad 60 38 51 00 00 00 00  00 00 00 00 03 00 00 00  |.`8Q............|
000020e0  50 12 00 00 01 00 00 00  01 02 00 00 00 00 00 00  |P...............|
000020f0  02 02 00 00 00 00 00 00  0c 00 00 00 14 00 00 00  |................|
00002100  20 00 00 00 9e 53 a1 c8  00 01 00 00 00 00 00 00  | ....S..........|
00002110  74 61 72 67 65 74 31 30  31 00 00 00 00 00 00 00  |target101.......|
00002120  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00002150  03 5b a0 58 db fc 4e a7  81 c1 31 4a f5 ae 3c a3  |.[.X..N...1J..<.|
00002160  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00002170  00 00 00 00 00 00 00 00  00 01 00 00 00 00 00 00  |................|
00002180  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00200000  00 00 00 00 00 40 00 00  00 00 00 00 00 00 00 00  |.....@..........|
00200010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00207000  49 4e 4f 44 45 30 31 00  f7 50 ac 08 ff ff 07 00  |INODE01..P......|
00207010  00 00 00 00 00 00 30 00  00 00 00 00 00 00 00 00  |......0.........|
00207020  00 00 00 00 00 03 00 00  a4 81 01 00 91 04 00 00  |................|
00207030  ad 60 38 51 00 00 00 00  ad 60 38 51 00 00 00 00  |.`8Q.....`8Q....|
00207040  ad 60 38 51 00 00 00 00  00 00 00 00 00 00 00 00  |.`8Q............|
00207050  07 02 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00207060  f7 50 ac 08 00 00 00 00  00 00 00 00 00 00 00 00  |.P..............|
00207070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
