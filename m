From: vde at ykoctpa.ru <vde@ykoctpa.ru>
Date: Wed, 24 Jun 2015 12:15:02 +0500
Subject: [Ocfs2-devel] OCFS2 errors in log EVEN just after FSCK
Message-ID: <2132073.zUxpZVA18y@dmitry.home>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is 2-node cluster with master-master DRBD and OCFS2 filesystem, kernel 
4.0.4

Some time ago I found such errors in log (on both nodes)

Jun 24 06:43:05 node1 kernel: [31704.810029] (php-
fpm,30917,1):ocfs2_orphan_del:2331 ERROR: status = -2
Jun 24 06:43:05 node1 kernel: [31704.810034] (php-
fpm,30917,1):ocfs2_orphan_del:2362 ERROR: status = -2
Jun 24 06:43:05 node1 kernel: [31704.810037] (php-
fpm,30917,1):ocfs2_remove_inode:653 ERROR: status = -2
Jun 24 06:43:05 node1 kernel: [31704.810041] (php-
fpm,30917,1):ocfs2_wipe_inode:798 ERROR: status = -2
Jun 24 06:43:05 node1 kernel: [31704.810044] (php-
fpm,30917,1):ocfs2_delete_inode:1050 ERROR: status = -2
Jun 24 06:44:27 node1 o2hbmonitor: mount debugfs at /sys/kernel/debug
Jun 24 06:45:09 node1 kernel: [31828.939394] 
(kworker/u8:1,25619,1):ocfs2_orphan_del:2331 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.939399] 
(kworker/u8:1,25619,1):ocfs2_orphan_del:2362 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.939402] 
(kworker/u8:1,25619,1):ocfs2_remove_inode:653 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.939406] 
(kworker/u8:1,25619,1):ocfs2_wipe_inode:798 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.939409] 
(kworker/u8:1,25619,1):ocfs2_delete_inode:1050 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.943074] 
(kworker/u8:1,25619,1):ocfs2_orphan_del:2331 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.943078] 
(kworker/u8:1,25619,1):ocfs2_orphan_del:2362 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.943081] 
(kworker/u8:1,25619,1):ocfs2_remove_inode:653 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.943084] 
(kworker/u8:1,25619,1):ocfs2_wipe_inode:798 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.943087] 
(kworker/u8:1,25619,1):ocfs2_delete_inode:1050 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.951077]  
(kworker/u8:1,25619,1):ocfs2_orphan_del:2331 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.951081] 
(kworker/u8:1,25619,1):ocfs2_orphan_del:2362 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.951083] 
(kworker/u8:1,25619,1):ocfs2_remove_inode:653 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.951087] 
(kworker/u8:1,25619,1):ocfs2_wipe_inode:798 ERROR: status = -2
Jun 24 06:45:09 node1 kernel: [31828.951089] 
(kworker/u8:1,25619,1):ocfs2_delete_inode:1050 ERROR: status = -2

and so on. FSCK (ocfs2_tools 1.8.4) every time found and fix lots of "orphaned 
cluster" errors but after mount this starts again.

in namei.c I found that this starts from ocfs2_find_entry  - so there is some 
filesystem errors leaved even after fsck 

WBR,
Dmitry V.
