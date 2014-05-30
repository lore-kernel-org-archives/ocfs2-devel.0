From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 May 2014 22:01:42 +0200
Subject: [Ocfs2-devel] [RFC 18/32] ocfs2: convert to struct inode_time
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Message-ID: <1401480116-1973111-19-git-send-email-arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

ocfs2 uses unsigned 34-bit seconds for inode timestamps, which will work
for the next 500 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in ocfs2.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/dlmglue.c | 16 ++++++++--------
 fs/ocfs2/file.c    |  6 +++---
 fs/ocfs2/ocfs2.h   |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6bd690b..26913ae 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2010,7 +2010,7 @@ static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 
 /* LVB only has room for 64 bits of time here so we pack it for
  * now. */
-static u64 ocfs2_pack_timespec(struct timespec *spec)
+static u64 ocfs2_pack_inode_time(struct inode_time *spec)
 {
 	u64 res;
 	u64 sec = spec->tv_sec;
@@ -2050,11 +2050,11 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 	lvb->lvb_imode     = cpu_to_be16(inode->i_mode);
 	lvb->lvb_inlink    = cpu_to_be16(inode->i_nlink);
 	lvb->lvb_iatime_packed  =
-		cpu_to_be64(ocfs2_pack_timespec(&inode->i_atime));
+		cpu_to_be64(ocfs2_pack_inode_time(&inode->i_atime));
 	lvb->lvb_ictime_packed =
-		cpu_to_be64(ocfs2_pack_timespec(&inode->i_ctime));
+		cpu_to_be64(ocfs2_pack_inode_time(&inode->i_ctime));
 	lvb->lvb_imtime_packed =
-		cpu_to_be64(ocfs2_pack_timespec(&inode->i_mtime));
+		cpu_to_be64(ocfs2_pack_inode_time(&inode->i_mtime));
 	lvb->lvb_iattr    = cpu_to_be32(oi->ip_attr);
 	lvb->lvb_idynfeatures = cpu_to_be16(oi->ip_dyn_features);
 	lvb->lvb_igeneration = cpu_to_be32(inode->i_generation);
@@ -2063,7 +2063,7 @@ out:
 	mlog_meta_lvb(0, lockres);
 }
 
-static void ocfs2_unpack_timespec(struct timespec *spec,
+static void ocfs2_unpack_inode_time(struct inode_time *spec,
 				  u64 packed_time)
 {
 	spec->tv_sec = packed_time >> OCFS2_SEC_SHIFT;
@@ -2099,11 +2099,11 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	i_gid_write(inode, be32_to_cpu(lvb->lvb_igid));
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
 	set_nlink(inode, be16_to_cpu(lvb->lvb_inlink));
-	ocfs2_unpack_timespec(&inode->i_atime,
+	ocfs2_unpack_inode_time(&inode->i_atime,
 			      be64_to_cpu(lvb->lvb_iatime_packed));
-	ocfs2_unpack_timespec(&inode->i_mtime,
+	ocfs2_unpack_inode_time(&inode->i_mtime,
 			      be64_to_cpu(lvb->lvb_imtime_packed));
-	ocfs2_unpack_timespec(&inode->i_ctime,
+	ocfs2_unpack_inode_time(&inode->i_ctime,
 			      be64_to_cpu(lvb->lvb_ictime_packed));
 	spin_unlock(&oi->ip_lock);
 }
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2930e23..88deaa6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -216,7 +216,7 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt)
 {
-	struct timespec now;
+	struct inode_time now;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
@@ -242,8 +242,8 @@ int ocfs2_should_update_atime(struct inode *inode,
 		return 0;
 
 	if (vfsmnt->mnt_flags & MNT_RELATIME) {
-		if ((timespec_compare(&inode->i_atime, &inode->i_mtime) <= 0) ||
-		    (timespec_compare(&inode->i_atime, &inode->i_ctime) <= 0))
+		if ((inode_time_compare(&inode->i_atime, &inode->i_mtime) <= 0) ||
+		    (inode_time_compare(&inode->i_atime, &inode->i_ctime) <= 0))
 			return 1;
 
 		return 0;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index bbec539..11a06e7 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -213,7 +213,7 @@ struct ocfs2_orphan_scan {
 	struct ocfs2_super 	*os_osb;
 	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
 	struct delayed_work 	os_orphan_scan_work;
-	struct timespec		os_scantime;  /* time this node ran the scan */
+	struct inode_time	os_scantime;  /* time this node ran the scan */
 	u32			os_count;      /* tracks node specific scans */
 	u32  			os_seqno;       /* tracks cluster wide scans */
 	atomic_t		os_state;              /* ACTIVE or INACTIVE */
-- 
1.8.3.2
