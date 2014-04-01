From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 1 Apr 2014 14:36:57 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Avoid system inode ref in
 confusion by add mutex lock
In-Reply-To: <53226198.2000902@huawei.com>
References: <53226198.2000902@huawei.com>
Message-ID: <20140401143657.7cbda18c6c73abf6320fc1c7@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 14 Mar 2014 09:55:36 +0800 jiangyiwen <jiangyiwen@huawei.com> wrote:

> The following case may lead to the same system inode ref in confusion.
> 
> A thread                            B thread
> ocfs2_get_system_file_inode
> ->get_local_system_inode
> ->_ocfs2_get_system_file_inode
>                                     because of *arr == NULL,
>                                     ocfs2_get_system_file_inode
>                                     ->get_local_system_inode
>                                     ->_ocfs2_get_system_file_inode
> gets first ref thru
> _ocfs2_get_system_file_inode,
> gets second ref thru igrab and
> set *arr = inode
>                                     at the moment, B thread also gets
>                                     two refs, so lead to one more
>                                     inode ref.
> 
> So add mutex lock to avoid multi thread set two inode ref once at
> the same time.

Looks good to me.  I queued it for 3.15-rc1.

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: avoid system inode ref confusion by adding mutex lock

The following case may lead to the same system inode ref in confusion.

A thread                            B thread
ocfs2_get_system_file_inode
->get_local_system_inode
->_ocfs2_get_system_file_inode
                                    because of *arr == NULL,
                                    ocfs2_get_system_file_inode
                                    ->get_local_system_inode
                                    ->_ocfs2_get_system_file_inode
gets first ref thru
_ocfs2_get_system_file_inode,
gets second ref thru igrab and
set *arr = inode
                                    at the moment, B thread also gets
                                    two refs, so lead to one more
                                    inode ref.

So add mutex lock to avoid multi thread set two inode ref once at the same
time.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h   |    2 ++
 fs/ocfs2/super.c   |    2 ++
 fs/ocfs2/sysfile.c |    3 +++
 3 files changed, 7 insertions(+)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock
+++ a/fs/ocfs2/ocfs2.h
@@ -446,6 +446,8 @@ struct ocfs2_super
 	/* rb tree root for refcount lock. */
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
+
+	struct mutex system_file_mutex;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff -puN fs/ocfs2/super.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock
+++ a/fs/ocfs2/super.c
@@ -2100,6 +2100,8 @@ static int ocfs2_initialize_super(struct
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
+	mutex_init(&osb->system_file_mutex);
+
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
diff -puN fs/ocfs2/sysfile.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock fs/ocfs2/sysfile.c
--- a/fs/ocfs2/sysfile.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock
+++ a/fs/ocfs2/sysfile.c
@@ -113,9 +113,11 @@ struct inode *ocfs2_get_system_file_inod
 	} else
 		arr = get_local_system_inode(osb, type, slot);
 
+	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
+		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);
 
 		return inode;
@@ -129,6 +131,7 @@ struct inode *ocfs2_get_system_file_inod
 		*arr = igrab(inode);
 		BUG_ON(!*arr);
 	}
+	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }
 
_
