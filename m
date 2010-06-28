From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 28 Jun 2010 10:04:32 -0500
Subject: [Ocfs2-devel] [PATCH] Track negative entries v3
Message-ID: <AANLkTikSDWtoWOBEMf6gnhrjWo5eCBPHW9jqWKNF-6St@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Track negative dentries by recording the generation number of the parent
directory in d_fsdata. The generation number for the parent directory is
recorded in the inode_info, which increments every time the lock on the
directory is dropped.

If the generation number of the parent directory and the negative dentry
matches, there is no need to perform the revalidate, else a revalidate
is forced. This improves performance in situations where nodes look for
the same non-existent file multiple times.

Thanks Mark for explaining the DLM sequence.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index b4957c7..edaded4 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -40,6 +40,14 @@
 #include "inode.h"
 #include "super.h"

+void ocfs2_dentry_attach_gen(struct dentry *dentry)
+{
+	unsigned long gen =
+		OCFS2_I(dentry->d_parent->d_inode)->ip_dir_lock_gen;
+	BUG_ON(dentry->d_inode);
+	dentry->d_fsdata = (void *)gen;
+}
+

 static int ocfs2_dentry_revalidate(struct dentry *dentry,
 				   struct nameidata *nd)
@@ -51,11 +59,20 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 		   dentry->d_name.len, dentry->d_name.name);

-	/* Never trust a negative dentry - force a new lookup. */
+	/* For a negative dentry -
+	 * check the generation number of the parent and compare with the
+	 * one stored in the inode.
+	 */
 	if (inode == NULL) {
-		mlog(0, "negative dentry: %.*s\n", dentry->d_name.len,
-		     dentry->d_name.name);
-		goto bail;
+		unsigned long gen = (unsigned long) dentry->d_fsdata;
+		unsigned long pgen =
+			OCFS2_I(dentry->d_parent->d_inode)->ip_dir_lock_gen;
+		mlog(0, "negative dentry: %.*s parent gen: %lu "
+			"dentry gen: %lu\n",
+			dentry->d_name.len, dentry->d_name.name, pgen, gen);
+		if (gen != pgen)
+			goto bail;
+		goto valid;
 	}

 	BUG_ON(!osb);
@@ -96,6 +113,7 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 		goto bail;
 	}

+valid:
 	ret = 1;

 bail:
@@ -227,6 +245,12 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
 	if (!inode)
 		return 0;

+	if (!dentry->d_inode && dentry->d_fsdata) {
+		/* Converting a negative dentry to positive
+		   Clear dentry->d_fsdata */
+		dentry->d_fsdata = dl = NULL;
+	}
+
 	if (dl) {
 		mlog_bug_on_msg(dl->dl_parent_blkno != parent_blkno,
 				" \"%.*s\": old parent: %llu, new: %llu\n",
@@ -452,6 +476,7 @@ static void ocfs2_dentry_iput(struct dentry
*dentry, struct inode *inode)

 out:
 	iput(inode);
+	ocfs2_dentry_attach_gen(dentry);
 }

 /*
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index f5dd178..b79eff7 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -64,5 +64,6 @@ void ocfs2_dentry_move(struct dentry *dentry, struct
dentry *target,
 		       struct inode *old_dir, struct inode *new_dir);

 extern spinlock_t dentry_attach_lock;
+void ocfs2_dentry_attach_gen(struct dentry *dentry);

 #endif /* OCFS2_DCACHE_H */
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 39eb16a..05177ec 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3635,10 +3635,18 @@ static int ocfs2_data_convert_worker(struct
ocfs2_lock_res *lockres,
 {
 	struct inode *inode;
 	struct address_space *mapping;
+	struct ocfs2_inode_info *oi;

        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;

+	if (S_ISDIR(inode->i_mode)) {
+		oi = OCFS2_I(inode);
+		oi->ip_dir_lock_gen++;
+		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
+		goto out;
+	}
+
 	if (!S_ISREG(inode->i_mode))
 		goto out;

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index abb0a95..fa0a750 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -335,6 +335,7 @@ void ocfs2_populate_inode(struct inode *inode,
struct ocfs2_dinode *fe,
 		    else
 			    inode->i_fop = &ocfs2_dops_no_plocks;
 		    i_size_write(inode, le64_to_cpu(fe->i_size));
+		    OCFS2_I(inode)->ip_dir_lock_gen = 1;
 		    break;
 	    case S_IFLNK:
 		    if (ocfs2_inode_is_fast_symlink(inode))
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 9f5f5fc..cdc9cee 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -70,6 +70,7 @@ struct ocfs2_inode_info
 	/* Only valid if the inode is the dir. */
 	u32				ip_last_used_slot;
 	u64				ip_last_used_group;
+	u32				ip_dir_lock_gen;

 	struct ocfs2_alloc_reservation	ip_la_data_resv;
 };
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f171b51..e89bce7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -171,7 +171,8 @@ bail_add:
 			ret = ERR_PTR(status);
 			goto bail_unlock;
 		}
-	}
+	} else
+		ocfs2_dentry_attach_gen(dentry);

 bail_unlock:
 	/* Don't drop the cluster lock until *after* the d_add --

-- 
Goldwyn
