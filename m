From: Marek Krolikowski <admin@wset.edu.pl>
Date: Fri, 9 Dec 2011 12:37:46 +0100
Subject: [Ocfs2-devel] OCFS2 oops in dmesg
Message-ID: <17B8EB8E427941FBA850DFDA3F90E592@tktelekom.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello
Sorry for my bad lang. but i don`t speak native english.
I try find a solution on ocfs2-users but noone can`t help me.
I use Linux Gentoo with kernel 3.1.4 and ocfs2-tools-1.6.4
I use 2x IBM server with 2xHBA connected via FC to switch to EMC Storage.
When i boot system i see 4 HDD disc because i got 4 links from server to EMC storage so this is normal.
I use Multipath to create 1 ?virtual HDD? from this 4 name is /dev/dm-0
I create a filesystem via command:
mkfs.ocfs2 -N 2 -L MAIL --fs-feature-level=max-features /dev/dm-0

After this i mount on both servers this fs to /mnt/EMC and start testing.
I write a little script to write/read all the time on both servers:
MAIL1 ~ # cat terror2.sh
#!/bin/bash
while true
do
rm -rf /mnt/EMC/MAIL1
mkdir /mnt/EMC/MAIL1
cp -r /usr /mnt/EMC/MAIL1
rm -rf /mnt/EMC/MAIL1
done;

MAIL2 ~ # cat terror2.sh
#!/bin/bash
while true
do
rm -rf /mnt/EMC/MAIL2
mkdir /mnt/EMC/MAIL2
cp -r /usr /mnt/EMC/MAIL2
rm -rf /mnt/EMC/MAIL2
done;


After 2 hours i receive in dmesg information:
Dec  8 17:16:18 MAIL1 klogd: o2dlm: Node 1 joins domain 9FFBEABB12AF4F43A195B6839EF32EB6
Dec  8 17:16:18 MAIL1 klogd: o2dlm: Nodes in domain 9FFBEABB12AF4F43A195B6839EF32EB6: 0 1
17:20  i start test and:
Dec  8 19:17:17 MAIL1 klogd: kworker/u:3     D ffff88107f2d2c40     0  8965      2 0x00000000
Dec  8 19:17:17 MAIL1 klogd:  ffff881014b2c080 0000000000000046 ffff8810207347d0 0000000000012c40
Dec  8 19:17:17 MAIL1 klogd:  ffff8809e4d43fd8 0000000000012c40 0000000000012c40 0000000000012c40
Dec  8 19:17:17 MAIL1 klogd:  ffff8809e4d42000 0000000000012c40 ffff8809e4d43fd8 0000000000012c40
Dec  8 19:17:17 MAIL1 klogd: Call Trace:
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff8149154d>] ? schedule_timeout+0x1ed/0x2e0
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa0a84132>] ? dlmconvert_master+0xe2/0x190 [ocfs2_dlm]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa0a8588f>] ? dlmlock+0x7f/0xb70 [ocfs2_dlm]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81490e7a>] ? wait_for_common+0x13a/0x190
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81053f80>] ? try_to_wake_up+0x280/0x280
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa0953928>] ? __ocfs2_cluster_lock.clone.21+0x1d8/0x6b0 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff810f5c02>] ? release_pages+0x202/0x230
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa0953ebc>] ? ocfs2_inode_lock_full_nested+0xbc/0x4a0 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa0962bcf>] ? ocfs2_wipe_inode+0x11f/0x6a0 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa0960b63>] ? ocfs2_query_inode_wipe.clone.9+0xc3/0x370 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa09633c4>] ? ocfs2_delete_inode+0x274/0x3e0 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81053f0f>] ? try_to_wake_up+0x20f/0x280
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa09449b0>] ? ocfs2_dentry_attach_lock+0x5a0/0x5a0 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa096354b>] ? ocfs2_evict_inode+0x1b/0x40 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff8114f47c>] ? evict+0x8c/0x180
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa09442c2>] ? __ocfs2_drop_dl_inodes.clone.2+0x32/0x60 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffffa09449d9>] ? ocfs2_drop_dl_inodes+0x29/0x90 [ocfs2]
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81076e5f>] ? process_one_work+0x11f/0x440
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81077b6b>] ? worker_thread+0x15b/0x330
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81077a10>] ? manage_workers.clone.21+0x120/0x120
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff81077a10>] ? manage_workers.clone.21+0x120/0x120
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff8107c8a6>] ? kthread+0x96/0xa0
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff8149ccb4>] ? kernel_thread_helper+0x4/0x10
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff8107c810>] ? kthread_worker_fn+0x1a0/0x1a0
Dec  8 19:17:17 MAIL1 klogd:  [<ffffffff8149ccb0>] ? gs_change+0x13/0x13
Dec  8 19:19:17 MAIL1 klogd: kworker/u:3     D ffff88107f2d2c40     0  8965      2 0x00000000
Dec  8 19:19:17 MAIL1 klogd:  ffff881014b2c080 0000000000000046 ffff8810207347d0 0000000000012c40
Dec  8 19:19:17 MAIL1 klogd:  ffff8809e4d43fd8 0000000000012c40 0000000000012c40 0000000000012c40
Dec  8 19:19:17 MAIL1 klogd:  ffff8809e4d42000 0000000000012c40 ffff8809e4d43fd8 0000000000012c40
Dec  8 19:19:17 MAIL1 klogd: Call Trace:
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff8149154d>] ? schedule_timeout+0x1ed/0x2e0
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa0a84132>] ? dlmconvert_master+0xe2/0x190 [ocfs2_dlm]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa0a8588f>] ? dlmlock+0x7f/0xb70 [ocfs2_dlm]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81490e7a>] ? wait_for_common+0x13a/0x190
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81053f80>] ? try_to_wake_up+0x280/0x280
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa0953928>] ? __ocfs2_cluster_lock.clone.21+0x1d8/0x6b0 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff810f5c02>] ? release_pages+0x202/0x230
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa0953ebc>] ? ocfs2_inode_lock_full_nested+0xbc/0x4a0 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa0962bcf>] ? ocfs2_wipe_inode+0x11f/0x6a0 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa0960b63>] ? ocfs2_query_inode_wipe.clone.9+0xc3/0x370 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa09633c4>] ? ocfs2_delete_inode+0x274/0x3e0 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81053f0f>] ? try_to_wake_up+0x20f/0x280
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa09449b0>] ? ocfs2_dentry_attach_lock+0x5a0/0x5a0 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa096354b>] ? ocfs2_evict_inode+0x1b/0x40 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff8114f47c>] ? evict+0x8c/0x180
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa09442c2>] ? __ocfs2_drop_dl_inodes.clone.2+0x32/0x60 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffffa09449d9>] ? ocfs2_drop_dl_inodes+0x29/0x90 [ocfs2]
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81076e5f>] ? process_one_work+0x11f/0x440
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81077b6b>] ? worker_thread+0x15b/0x330
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81077a10>] ? manage_workers.clone.21+0x120/0x120
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff81077a10>] ? manage_workers.clone.21+0x120/0x120
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff8107c8a6>] ? kthread+0x96/0xa0
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff8149ccb4>] ? kernel_thread_helper+0x4/0x10
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff8107c810>] ? kthread_worker_fn+0x1a0/0x1a0
Dec  8 19:19:17 MAIL1 klogd:  [<ffffffff8149ccb0>] ? gs_change+0x13/0x13

I was thinking this is a multipath problem but i do this same on /dev/sdb /dev/sdc /dev/sdd /dev/sde exacly this same effect.
I check statistic on FC switch and there is no errors/problem with communication.

Please help if possible.
Thanks
Marek
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20111209/f31b4276/attachment.html 
