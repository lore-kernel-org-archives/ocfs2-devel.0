From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 31 Oct 2018 14:26:32 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix dead lock caused by
	ocfs2_defrag_extent
In-Reply-To: <20180902091455.23862-1-lchen@suse.com>
References: <20180902091455.23862-1-lchen@suse.com>
Message-ID: <20181031142632.c523108bc137caa8cb1c6282@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Larry Chen <lchen@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joseph Qi <jiangqi903@gmail.com>, Changwei Ge <gechangwei@live.cn>


Folks, could we please review this patch for upstream inclusion?

Thanks.


From: Larry Chen <lchen@suse.com>
Subject: ocfs2: fix deadlock caused by ocfs2_defrag_extent

ocfs2_defrag_extent may fall into deadlock.

ocfs2_ioctl_move_extents
  ocfs2_ioctl_move_extents
    ocfs2_move_extents
      ocfs2_defrag_extent
        ocfs2_lock_allocators_move_extents

          ocfs2_reserve_clusters
            inode_lock GLOBAL_BITMAP_SYSTEM_INODE

	  __ocfs2_flush_truncate_log
            inode_lock GLOBAL_BITMAP_SYSTEM_INODE

As backtrace shows above, ocfs2_reserve_clusters() will call inode_lock
against the global bitmap if local allocator has not sufficient cluters. 
Once global bitmap could meet the demand, ocfs2_reserve_cluster will
return success with global bitmap locked.

After ocfs2_reserve_cluster(), if truncate log is full,
__ocfs2_flush_truncate_log() will definitely fall into deadlock because it
needs to inode_lock global bitmap, which has already been locked.

To fix this bug, we could remove from ocfs2_lock_allocators_move_extents()
the code which intends to lock global allocator, and put the removed code
after __ocfs2_flush_truncate_log().

ocfs2_lock_allocators_move_extents() is refered by 2 places, one is here,
the other does not need the data allocator context, which means this patch
does not affect the caller so far.

[lchen at suse.com: rename ocfs2_lock_allocators_move_extents() to ocfs2_lock_meta_allocator_move_extents(), add some comments]
  Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_20180902091455.23862-2D1-2Dlchen-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=K8aRgOiMescamJW-IuHq-cW4mWedGQv2JTT-2KPy1RI&s=3fQHFtwgixirPeQ5Px4fRBnd_UcSx3rvSsLKLidwESo&e=
Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_20180827080121.31145-2D1-2Dlchen-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=K8aRgOiMescamJW-IuHq-cW4mWedGQv2JTT-2KPy1RI&s=PQOJREyeElsg_1IlINdSGefNqA6w_cUrI1ezdVxyi7o&e=
Signed-off-by: Larry Chen <lchen@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |   40 +++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/move_extents.c~fix-dead-lock-caused-by-ocfs2_defrag_extent
+++ a/fs/ocfs2/move_extents.c
@@ -162,7 +162,7 @@ out:
  * in some cases, we don't need to reserve clusters, just let data_ac
  * be NULL.
  */
-static int ocfs2_lock_allocators_move_extents(struct inode *inode,
+static int ocfs2_lock_meta_allocator_move_extents(struct inode *inode,
 					struct ocfs2_extent_tree *et,
 					u32 clusters_to_move,
 					u32 extents_to_split,
@@ -192,13 +192,6 @@ static int ocfs2_lock_allocators_move_ex
 		goto out;
 	}
 
-	if (data_ac) {
-		ret = ocfs2_reserve_clusters(osb, clusters_to_move, data_ac);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
 
 	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el);
 
@@ -257,10 +250,11 @@ static int ocfs2_defrag_extent(struct oc
 		}
 	}
 
-	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, *len, 1,
-						 &context->meta_ac,
-						 &context->data_ac,
-						 extra_blocks, &credits);
+	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
+						*len, 1,
+						&context->meta_ac,
+						&context->data_ac,
+						extra_blocks, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -283,6 +277,21 @@ static int ocfs2_defrag_extent(struct oc
 		}
 	}
 
+	/*
+	 * Make sure ocfs2_reserve_cluster is called after
+	 * __ocfs2_flush_truncate_log, otherwise, dead lock may happen.
+	 *
+	 * If ocfs2_reserve_cluster is called
+	 * before __ocfs2_flush_truncate_log, dead lock on global bitmap
+	 * may happen.
+	 *
+	 */
+	ret = ocfs2_reserve_clusters(osb, *len, &context->data_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock_mutex;
+	}
+
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -600,9 +609,10 @@ static int ocfs2_move_extent(struct ocfs
 		}
 	}
 
-	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
-						 &context->meta_ac,
-						 NULL, extra_blocks, &credits);
+	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
+						len, 1,
+						&context->meta_ac,
+						NULL, extra_blocks, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
_
