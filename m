From: Ashish Samant <ashish.samant@oracle.com>
Date: Thu, 15 Sep 2016 17:06:44 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix double put of recount tree in
	ocfs2_lock_refcount_tree()
Message-ID: <1473984404-32011-1-git-send-email-ashish.samant@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_lock_refcount_tree, if ocfs2_read_refcount_block() returns error,
we do ocfs2_refcount_tree_put twice (once in ocfs2_unlock_refcount_tree
and once outside it), thereby reducing the refcount of the refcount tree
twice, but we dont delete the tree in this case. This will make refcnt
of the tree = 0 and the ocfs2_refcount_tree_put will eventually call
ocfs2_mark_lockres_freeing, setting OCFS2_LOCK_FREEING for the
refcount_tree->rf_lockres.

The error returned by ocfs2_read_refcount_block is propagated all the way
back and for next iteration of write, ocfs2_lock_refcount_tree gets the
same tree back from ocfs2_get_refcount_tree because we havent deleted the
tree. Now we have the same tree, but OCFS2_LOCK_FREEING is set for
rf_lockres and eventually, when _ocfs2_lock_refcount_tree is called in
this iteration, BUG_ON( __ocfs2_cluster_lock:1395 ERROR: Cluster lock
called on freeing lockres T00000000000000000386019775b08d! flags 0x81) is
triggerred.

Call stack:

(loop16,11155,0):ocfs2_lock_refcount_tree:482 ERROR: status = -5
(loop16,11155,0):ocfs2_refcount_cow_hunk:3497 ERROR: status = -5
(loop16,11155,0):ocfs2_refcount_cow:3560 ERROR: status = -5
(loop16,11155,0):ocfs2_prepare_inode_for_refcount:2111 ERROR: status = -5
(loop16,11155,0):ocfs2_prepare_inode_for_write:2190 ERROR: status = -5
(loop16,11155,0):ocfs2_file_write_iter:2331 ERROR: status = -5
(loop16,11155,0):__ocfs2_cluster_lock:1395 ERROR: bug expression:
lockres->l_flags & OCFS2_LOCK_FREEING

(loop16,11155,0):__ocfs2_cluster_lock:1395 ERROR: Cluster lock called on
freeing lockres T00000000000000000386019775b08d! flags 0x81

------------[ cut here ]------------
kernel BUG at fs/ocfs2/dlmglue.c:1395!

invalid opcode: 0000 [#1] SMP  CPU 0
Modules linked in: tun ocfs2 jbd2 xen_blkback xen_netback xen_gntdev ..
sd_mod crc_t10dif ext3 jbd mbcache

RIP: e030:[<ffffffffa082137c>]  [<ffffffffa082137c>]
__ocfs2_cluster_lock+0x31c/0x740 [ocfs2]
RSP: e02b:ffff88017c0138a0  EFLAGS: 00010086
Process loop16 (pid: 11155, threadinfo ffff88017c010000, task
ffff8801b5374300)
Stack:
 ffff88017bd25880 0000000000000081 000000017c013920 ffff88017c013960
 000000000000001d 0000000000000001 ffff88017bd258b4 0000000000000000
 ffff880172006000 00000000a07fa410 ffff88017bd202b4 0000000000000000
Call Trace:
 [<ffffffffa08227de>] ocfs2_refcount_lock+0xae/0x130 [ocfs2]
 [<ffffffffa0846b89>] ? __ocfs2_lock_refcount_tree+0x29/0xe0 [ocfs2]
 [<ffffffff81509dde>] ? _raw_spin_lock+0xe/0x20
 [<ffffffffa0846b89>] __ocfs2_lock_refcount_tree+0x29/0xe0 [ocfs2]
 [<ffffffffa084d47d>] ocfs2_lock_refcount_tree+0xdd/0x320 [ocfs2]
 [<ffffffffa084de3b>] ocfs2_refcount_cow_hunk+0x1cb/0x440 [ocfs2]
 [<ffffffffa084e159>] ocfs2_refcount_cow+0xa9/0x1d0 [ocfs2]
 [<ffffffffa08291c7>] ? ocfs2_prepare_inode_for_refcount+0x67/0x200 [ocfs2]
 [<ffffffffa0829275>] ocfs2_prepare_inode_for_refcount+0x115/0x200 [ocfs2]
 [<ffffffffa081f394>] ? ocfs2_inode_unlock+0xd4/0x140 [ocfs2]
 [<ffffffffa082969b>] ocfs2_prepare_inode_for_write+0x33b/0x470 [ocfs2]
 [<ffffffffa0822620>] ? ocfs2_rw_lock+0x80/0x190 [ocfs2]
 [<ffffffffa082c150>] ocfs2_file_write_iter+0x220/0x8c0 [ocfs2]
 [<ffffffff81112c67>] ? mempool_free_slab+0x17/0x20
 [<ffffffff8119f2b1>] ? bio_free+0x61/0x70
 [<ffffffff811adece>] ? aio_kernel_free+0xe/0x10
 [<ffffffff811adb1e>] aio_write_iter+0x2e/0x30

Fix this by avoiding the second call to ocfs2_refcount_tree_put()

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
---
 fs/ocfs2/refcounttree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 92bbe93..a9d4102 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -478,7 +478,6 @@ again:
 	if (ret) {
 		mlog_errno(ret);
 		ocfs2_unlock_refcount_tree(osb, tree, rw);
-		ocfs2_refcount_tree_put(tree);
 		goto out;
 	}
 
-- 
1.9.1
