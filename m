From: Shichangkuo <shi.changkuo@h3c.com>
Date: Thu, 17 Dec 2015 03:29:56 +0000
Subject: [Ocfs2-devel]  mount failed as system file //journal:0004 damaged
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF355EE07229@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, all
    I can't mount a disk with slotnum=4, other slots could mount successfully. Err msg is:
       root at cvk41:~# mount /dev/sdi /vms/gqg-1T -o preferred_slot=4
       mount.ocfs2: Invalid argument while mounting /dev/sdi on /vms/gqg-1T. Check 'dmesg' for more information on this error.

Dec 16 11:25:42 cvknode kernel: [ 5409.023779] o2dlm: Joining domain 9B244483B1C04B76A1AAEB3A5D09847B ( 1 2 4 5 6 ) 5 nodes
Dec 16 11:25:42 cvknode kernel: [ 5409.041933] JBD2: no valid journal superblock found
Dec 16 11:25:42 cvknode kernel: [ 5409.041939] (mount.ocfs2,23379,11):ocfs2_journal_wipe:1113 ERROR: status = -22
Dec 16 11:25:42 cvknode kernel: [ 5409.041971] (mount.ocfs2,23379,11):ocfs2_check_volume:2449 ERROR: status = -22
Dec 16 11:25:42 cvknode kernel: [ 5409.041974] (mount.ocfs2,23379,11):ocfs2_check_volume:2510 ERROR: status = -22
Dec 16 11:25:42 cvknode kernel: [ 5409.041978] (mount.ocfs2,23379,11):ocfs2_mount_volume:1889 ERROR: status = -22
Dec 16 11:25:42 cvknode kernel: [ 5409.043947] o2dlm: Node 3 joins domain 9B244483B1C04B76A1AAEB3A5D09847B ( 1 2 3 4 5 6 ) 6 nodes
Dec 16 11:25:46 cvknode kernel: [ 5413.076279] o2dlm: Leaving domain 9B244483B1C04B76A1AAEB3A5D09847B
Dec 16 11:25:46 cvknode kernel: [ 5413.076732] ocfs2: Unmounting device (8,128) on (node 2)

I dumped //journal:0004 with hexdump, and found the fist block (4KB) maybe changed.
//journal:0000
root at cvk41:~# hexdump -C -n 1024 -s 0x600000 /dev/dm-4
00600000 c0 3b 39 98 00 00 00 04 00 00 00 00 00 00 10 00 |.;9.............|
00600010 00 00 80 00 00 00 00 01 00 06 2d ef 00 00 00 07 |..........-.....|
00600020 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 00 |................|
00600030 9b 24 44 83 b1 c0 4b 76 a1 aa eb 3a 5d 09 84 7b |.$D...Kv...:]..{|
00600040 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 |................|
00600050 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
*
00600400

//journal:0004
root at cvk41:~# hexdump -C -n 1024 -s 0x20600000 /dev/dm-4
20600000 c0 3b 39 98 00 00 00 02 00 00 e0 d3 00 00 00 00 |.;9.............|
20600010 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
*
20600030 00 00 00 00 56 0b 0f d7 01 e5 84 c2 00 00 00 00 |....V...........|
20600040 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
*
20600400

In first block, the journal type is 02(JBD2_COMMIT_BLOCK) other than 04(JBD2_SUPERBLOCK_V2).
This disk has been idled for a long time, but I think the first block was written by formatting, and none operations could change it.
So I can't understand which operations could cause to my issue.
The attachment is a file which is dumped by " logdump slot4".

Thanks a lot!!

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
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151217/96088c84/attachment.html 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: journal4.rar
Type: application/octet-stream
Size: 1317 bytes
Desc: journal4.rar
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151217/96088c84/attachment.obj 
