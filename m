From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Tue, 11 Aug 2015 07:22:01 +0000
Subject: [Ocfs2-devel] ocfs2_start_trans review
Message-ID: <2015081115215472598358@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


When storage network is unstable ?-EIO?, write ?do_sync_write?data to the storage,
it can trigger the panic in ocfs2_start_trans.ocfs2_start_trans -> ocfs2_abort ->panic?
whether there is a better way to solve this problem?
Just mark as a mistake instead of ocfs2_abort.
Finally, any feedback about this process (positive or negative) would be greatly appreciated.

   Aug 11 11:32:25 cvknode73 kernel: [678904.787906] (pool,23256,12):ocfs2_start_trans:367 ERROR: status = -30
Aug 11 11:32:25 cvknode73 kernel: [678904.825046] CPU: 12 PID: 23256 Comm: pool Tainted: GF W IO 3.13.6 #1
Aug 11 11:32:25 cvknode73 kernel: [678904.825050] Hardware name: HP ProLiant BL460c G7, BIOS I27 12/03/2012
Aug 11 11:32:25 cvknode73 kernel: [678904.825054] ffffffffffffffe2 ffff88108c945a88 ffffffff81750690 ffff88180bacfff0
Aug 11 11:32:25 cvknode73 kernel: [678904.825064] ffff88174196d000 ffff88108c945ad8 ffffffffa052f667 ffffffffffffffe2
Aug 11 11:32:25 cvknode73 kernel: [678904.825072] 0000000000001000 ffff88108c945b58 ffff88175e870000 ffff8811ada4f000
Aug 11 11:32:25 cvknode73 kernel: [678904.825087] Call Trace:
Aug 11 11:32:25 cvknode73 kernel: [678904.825103] [<ffffffff81750690>] dump_stack+0x46/0x58
Aug 11 11:32:25 cvknode73 kernel: [678904.825154] [<ffffffffa052f667>] ocfs2_start_trans+0x1d7/0x200 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825183] [<ffffffffa0505b60>] ocfs2_write_begin_nolock+0xda0/0x1c70 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825216] [<ffffffffa052b7cb>] ? ocfs2_read_inode_block_full+0x3b/0x60 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825248] [<ffffffffa051a82f>] ? ocfs2_inode_lock_full_nested+0x52f/0xc60 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825277] [<ffffffffa0516060>] ? ocfs2_should_refresh_lock_res+0x80/0x190 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825304] [<ffffffffa0506b36>] ocfs2_write_begin+0x106/0x230 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825330] [<ffffffffa05180ab>] ? __ocfs2_cluster_unlock.isra.27+0x9b/0xe0 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825342] [<ffffffff8115342b>] generic_file_buffered_write+0xfb/0x280
Aug 11 11:32:25 cvknode73 kernel: [678904.825370] [<ffffffffa051a1c5>] ? ocfs2_rw_lock+0x75/0x1b0 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825398] [<ffffffffa0527f3f>] ocfs2_file_aio_write+0x79f/0x830 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825407] [<ffffffff811c14ba>] do_sync_write+0x5a/0x90
Aug 11 11:32:25 cvknode73 kernel: [678904.825413] [<ffffffff811c1fc5>] vfs_write+0xc5/0x1f0
Aug 11 11:32:25 cvknode73 kernel: [678904.825418] [<ffffffff811c24c2>] SyS_write+0x52/0xa0
Aug 11 11:32:25 cvknode73 kernel: [678904.825426] [<ffffffff8176106d>] system_call_fastpath+0x1a/0x1f
Aug 11 11:32:25 cvknode73 kernel: [678904.825431] OCFS2: abort (device sdu): ocfs2_start_trans: Detected aborted journal

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150811/92f49f04/attachment.html 
