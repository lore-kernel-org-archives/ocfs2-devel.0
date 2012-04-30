From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 30 Apr 2012 09:49:08 -0500
Subject: [Ocfs2-devel] [PATCH] Fix warning due to dual put_bh for RO device
	mount failure
Message-ID: <CAJtY7HVGp1G790U+4bGD7M1JvDTMpyeGeKXqh8_L07SAJOYf+w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This warning is received when a RO disk, which does not report to be RO,
is mounted. Example is change in iSCSI server policy.

WARNING: at
/usr/src/packages/BUILD/kernel-xen-2.6.32.54/linux-2.6.32/fs/buffer.c:1203
[<ffffffffa065d990>] __ocfs2_free_slot_info+0x40/0x80 [ocfs2]
[<ffffffffa0668028>] ocfs2_dismount_volume+0x288/0x420 [ocfs2]
[<ffffffffa0669751>] ocfs2_fill_super+0xe1/0x2570 [ocfs2]
[<ffffffff800dea78>] get_sb_bdev+0x168/0x1c0
[<ffffffff800de1fd>] vfs_kern_mount+0x7d/0x1b0
[<ffffffff800de393>] do_kern_mount+0x53/0x120
[<ffffffff800f95fc>] do_mount+0x21c/0x250
[<ffffffff800f96f0>] sys_mount+0xc0/0xf0
[<ffffffff80007418>] system_call_fastpath+0x16/0x1b


put_bh is called multiple times if the write fails. Once in
ocfs2_write_block() and the second time in
__ocfs2_free_slot_info()->brelse which causes the warning.
This fix calls get_bh again in order to increment the bh count
to avoid the warning.

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 1424c15..3f5102c 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -213,8 +213,11 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 	spin_unlock(&osb->osb_lock);

 	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
-	if (status < 0)
+	if (status < 0) {
+		/* Increment bh count back so that it can be freed later */
+		get_bh(bh);
 		mlog_errno(status);
+	}

 	return status;
 }
