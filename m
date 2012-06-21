From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 21 Jun 2012 03:46:32 +0000
Subject: [Ocfs2-devel] echo 0 > /proc/sys/kernel/hung_task_timeout_secs and
 others error, Part II
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC1F9D@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The first problem is as below:
One issue is the files copied to the device but it can't be list on node2, using ls -al the mounted directory.
But using debug.ocfs2 on node2, it is ok to list the files copied. After remount of the device on node2, the file can be list.

The second is that:
Node1 is in the ocfs2 cluster, but using debug.ocfs2, and mounted.ocfs2 -f command, can not list the node1 info.
The node2, node3 are list. And using debug.ocfs2, list the slotmap information, there is not node1.
But the heartbeat information on disk is ok.

Ant there are lot of "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" error message in the log.

We format the device with 32 node using the command:
mkfs.ocfs2 -b 4k -C 1M -L target100 -T vmstore -N 32 /dev/sdb

So we have to delete the ocfs2 cluster, reboot nodes, and rebuild the ocfs2.
After all node joins into the cluster, we copy data again, and there are "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" message still.

Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.006781] INFO: task cp:22285 blocked for more than 120 seconds.
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.016123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034724] cp              D ffffffff81806240     0 22285   5313 0x00000000
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034729]  ffff881b952658b0 0000000000000082 0000000000000000 0000000000000001
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034739]  ffff881b95265fd8 ffff881b95265fd8 ffff881b95265fd8 0000000000013780
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034751]  ffff880fc16044d0 ffff881fbe41ade0 ffff882027c13780 ffff881fbe41ade0
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034762] Call Trace:
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034769]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034777]  [<ffffffff8165c35d>] rwsem_down_failed_common+0xcd/0x170
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034808]  [<ffffffffa059d399>] ? ocfs2_metadata_cache_unlock+0x19/0x20 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034815]  [<ffffffff8165c435>] rwsem_down_read_failed+0x15/0x17
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034826]  [<ffffffff813188d4>] call_rwsem_down_read_failed+0x14/0x30
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034833]  [<ffffffff8165b754>] ? down_read+0x24/0x2b
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034859]  [<ffffffffa0553b11>] ocfs2_start_trans+0xe1/0x1e0 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034878]  [<ffffffffa052ab35>] ocfs2_write_begin_nolock+0x945/0x1c40 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034903]  [<ffffffffa054cb90>] ? ocfs2_inode_is_valid_to_delete+0x1f0/0x1f0 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034927]  [<ffffffffa053fa9c>] ? ocfs2_inode_lock_full_nested+0x52c/0xa90 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034939]  [<ffffffff81647ae2>] ? balance_dirty_pages.isra.17+0x457/0x4ba
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034959]  [<ffffffffa052bf26>] ocfs2_write_begin+0xf6/0x210 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034968]  [<ffffffff8111752a>] generic_perform_write+0xca/0x210
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034991]  [<ffffffffa053d9b9>] ? ocfs2_inode_unlock+0xb9/0x130 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.034998]  [<ffffffff811176cd>] generic_file_buffered_write+0x5d/0x90
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035023]  [<ffffffffa054c601>] ocfs2_file_aio_write+0x821/0x870 [ocfs2]
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035032]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035043]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035052]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035058]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035064]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035070]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
Jun 20 20:42:01 H3CRDS11-RD kernel: [17509.035077]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b

Is there some better advice or practice? Or is there some bug?

The information of the OS is as below and all the four node are installed same. :
3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

The host information as below:
# free
             total       used       free     shared    buffers     cached
Mem:     132028152  104355680   27672472          0     171496   69113032
-/+ buffers/cache:   35071152   96957000
Swap:     34523132          0   34523132

Cpu information:
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                24
On-line CPU(s) list:   0-23
Thread(s) per core:    2
Core(s) per socket:    6
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 44
Stepping:              2
CPU MHz:               2532.792
BogoMIPS:              5065.22
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              12288K
NUMA node0 CPU(s):     0,2,4,6,8,10,12,14,16,18,20,22
NUMA node1 CPU(s):     1,3,5,7,9,11,13,15,17,19,21,23


Thanks


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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120621/1f8b51c4/attachment-0001.html 
