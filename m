From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Wed, 9 Nov 2016 10:17:22 +0000
Subject: [Ocfs2-devel] ocfs2: A race about mle is unlinked and freed for the
	dead node, BUG
References: <mailman.3.1478635201.364.ocfs2-devel@oss.oracle.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB53771FB9FCE@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All,

when the mle have been used in dlm_get_lock_resouce, other nodes dead at the same time,
the mle that is block type may be unlinked and freed repeatedly for dead nodes.
so it is a BUG  about mle->mle_refs.refcount in __dlm_put_mle  in dlm_get_lock_resouce.
Finally, any feedback about this process (positive or negative) would be  greatly appreciated.

*** linux-4.1.35/fs/ocfs2/dlm/dlmmaster.c 2016-11-09 17:39:02.230163503 +0800
--- dlmmaster.c.update 2016-11-09 17:41:39.210166752 +0800
***************
*** 3229,3248 ****
--- 3229,3261 ----
struct dlm_master_list_entry *mle, u8 dead_node)
{
int bit;
+ int next_bit = O2NM_MAX_NODES;
BUG_ON(mle->type != DLM_MLE_BLOCK);

spin_lock(&mle->spinlock);
bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, 0);
+ if (bit != O2NM_MAX_NODES)
+ next_bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, bit+1);
+
if (bit != dead_node) {
mlog(0, "mle found, but dead node %u would not have been "
"master\n", dead_node);
spin_unlock(&mle->spinlock);
+ } else if (mle->inuse && next_bit != O2NM_MAX_NODES) {
+ /*Ignore it, the mle is used, other nodes dead now.
+ *as it is unlinked and freed for the dead node, it's a BUG*/
+ mlog(ML_ERROR, "the mle is used, but inuse %d, dead node %u, "
+ "master %u\n", mle->inuse, dead_node, mle->master);
+ clear_bit(bit, mle->maybe_map);
+ spin_unlock(&mle->spinlock);
+
} else {
/* Must drop the refcount by one since the assert_master will
* never arrive. This may result in the mle being unlinked and
* freed, but there may still be a process waiting in the
* dlmlock path which is fine. */
mlog(0, "node %u was expected master\n", dead_node);
+ clear_bit(bit, mle->maybe_map);
atomic_set(&mle->woken, 1);
spin_unlock(&mle->spinlock);
wake_up(&mle->wq);

________________________________
All the best wishes for you.
zhangguanghui

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161109/e75bd6a6/attachment-0001.html 
