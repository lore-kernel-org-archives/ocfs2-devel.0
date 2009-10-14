From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Oct 2009 20:08:55 +0200
Subject: [Ocfs2-devel] [PATCH 1/5] Do not reinitialize already initialized
	quota info
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <1255543739-23844-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tunefs can call ocfs2_init_fs_quota_info() and ocfs2_read_global_quota_info()
several times when several features are to be enabled / disabled. Check
whether we haven't already initialized the info / read the info from disk
and don't do anything in such case so that we don't lose references to
inodes or even overwrite cached information in memory with an old one from
disk.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/ocfs2/ocfs2.h        |    1 +
 libocfs2/quota.c             |    8 ++++++++
 tunefs.ocfs2/feature_quota.c |    2 +-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
index 992d2f2..d7be734 100644
--- a/include/ocfs2/ocfs2.h
+++ b/include/ocfs2/ocfs2.h
@@ -129,6 +129,7 @@
 
 /* Flags for global quotafile info */
 #define OCFS2_QF_INFO_DIRTY 1
+#define OCFS2_QF_INFO_LOADED 2
 
 typedef void (*ocfs2_chb_notify)(int state, char *progress, void *data);
 
diff --git a/libocfs2/quota.c b/libocfs2/quota.c
index a995b41..e36b12f 100644
--- a/libocfs2/quota.c
+++ b/libocfs2/quota.c
@@ -508,6 +508,9 @@ errcode_t ocfs2_init_fs_quota_info(ocfs2_filesys *fs, int type)
 	char fname[OCFS2_MAX_FILENAME_LEN];
 	errcode_t ret;
 
+	if (fs->qinfo[type].qi_inode)
+		return 0;
+
 	ocfs2_sprintf_system_inode_name(fname, sizeof(fname),
 		global_type, 0);
 	ret = ocfs2_lookup(fs, fs->fs_sysdir_blkno, fname, strlen(fname),
@@ -563,6 +566,9 @@ errcode_t ocfs2_read_global_quota_info(ocfs2_filesys *fs, int type)
 	errcode_t ret;
 	struct ocfs2_global_disk_dqinfo *info;
 
+	if (fs->qinfo[type].flags & OCFS2_QF_INFO_LOADED)
+		return 0;
+
 	ret = ocfs2_malloc_block(fs->fs_io, &buf);
 	if (ret)
 		return ret;
@@ -574,6 +580,8 @@ errcode_t ocfs2_read_global_quota_info(ocfs2_filesys *fs, int type)
 	ocfs2_swap_quota_global_info(info);
 	memcpy(&(fs->qinfo[type].qi_info), info,
 	       sizeof(struct ocfs2_global_disk_dqinfo));
+	fs->qinfo[type].flags |= OCFS2_QF_INFO_LOADED;
+
 	return 0;
 }
 
diff --git a/tunefs.ocfs2/feature_quota.c b/tunefs.ocfs2/feature_quota.c
index b734d49..2da3cbe 100644
--- a/tunefs.ocfs2/feature_quota.c
+++ b/tunefs.ocfs2/feature_quota.c
@@ -101,7 +101,7 @@ static errcode_t create_quota_files(ocfs2_filesys *fs, int type,
 			 type2name(type));
 		return ret;
 	}
-	fs->qinfo[type].flags = 0;
+	fs->qinfo[type].flags = OCFS2_QF_INFO_LOADED;
 	fs->qinfo[type].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
 	fs->qinfo[type].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
 	fs->qinfo[type].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
-- 
1.6.0.2
