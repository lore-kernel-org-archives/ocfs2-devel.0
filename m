Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ECD3E0758
	for <ocfs2-devel@lists.linux.dev>; Tue, 25 Aug 2026 09:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787648983; cv=none; b=RdxMujTS9YE+knysHuH6JP2bcKwXBlP4SH9x4XOA8TpQ4zscExTtLLrtC5K2t4HZ0JF8QgHn+n3V2sQ9YSV/9GWFqXmbIMNb3ED6M7js6BApnEbLG79Vsa7BnoO0uaS3Yd+9wSq+KWU1ubQqrAZRAItmp9KrQY9LNjIaJvc0qeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787648983; c=relaxed/simple;
	bh=fnCWQuBV/Luoq2GcooMGzUu96K2Qf234RbRwzGuuzYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rc6y6/eTf/NaoqFQ361SJemm4q9IqZnTriNqV5uSokty3JLUevEHUoVVv0dQ2YnulS5oIb0KVdupnWTQ8cDzStCtD/RlbjWb6RfSwWyIQPZuF06zcxSS1+BaX/cK8wMY7RvPyiqIPoACqX6dHYOd4xq0KYvasEAERwOGs5nN5H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fRKgL3w/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mfjmTiar; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fRKgL3w/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mfjmTiar"
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	by smtp-out2.suse.de (Postfix) with ESMTP id A04E71F7B2;
	Tue, 25 Aug 2026 09:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787648974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jPzBCS8VOv/sop77NkzPm8nlfdtOiTXsxrBjfJogto4=;
	b=fRKgL3w/pmYQaR0DkndgVCSKeglP1AkVMeHyMwFTyc8mU2ecqAETU9+F13nkzYdvZYcimx
	yZUz1y8KDp8QC/Dl3VQ7CePtrka/ixVL+sWnt9d/aj/gQIutiH+tE+/LoLTMr7ItCdG2fp
	r7j5GSawZCpndabxuCKR+wCkgiqw9q8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mfjmTiar
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787648970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jPzBCS8VOv/sop77NkzPm8nlfdtOiTXsxrBjfJogto4=;
	b=mfjmTiarpQ4ogPPqB0SnF0oXU6RSzNAzex7YV3KdQfpaFw+Rj1F4sPv97gfaZcXBFn7nXw
	eu8HoSkQGNq6hrnGkshAFSi81rlW6Mran8tCWzb5JR6thUwq+5EAZIzWbcoXiVewXxBPKt
	1fssYqdXlZECgrbFz42YTVTqB+g2Bhk=
From: Anthony Iliopoulos <ailiop@suse.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: replace ocfs2-specific falloc ioctls with generic ones
Date: Tue, 25 Aug 2026 11:09:12 +0200
Message-ID: <20260825090917.117327-1-ailiop@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [16.52 / 50.00];
	SPAM_FLAG(5.00)[];
	NEURAL_SPAM_LONG(3.50)[1.000];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.83)[0.942];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	RDNS_NONE(2.00)[];
	ONCE_RECEIVED(1.20)[];
	HFILTER_HELO_IP_A(1.00)[kunlun.suse.cz];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[kunlun.suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	SPAMHAUS_XBL(0.00)[2a07:de40:b306:2000::2:from];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_FIVE(0.00)[5];
	DIRECT_TO_MX(0.00)[git-send-email 2.55.0];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kunlun.suse.cz:helo,suse.com:email,suse.com:mid,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[]
X-Spamd-Bar: ++++++++++++++++
X-Rspamd-Queue-Id: A04E71F7B2
X-Rspamd-Action: add header
X-Spam-Flag: YES
X-Spam-Score: 16.52
X-Spam-Level: ****************
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam: Yes

Replace custom ocfs2 space reservation structures and ioctl definitions
with the generic file space allocation interfaces.

Those were originally copied from xfs in commit b25801038da5 ("ocfs2:
Support xfs style space reservation ioctls") for compatibility reasons,
which were eventually lifted to vfs and made generic. As such there is
no reason to carry around the redundant definitions any longer, they can
be dropped at this point.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/ocfs2/file.c        | 26 +++++++++++++-------------
 fs/ocfs2/file.h        |  4 +++-
 fs/ocfs2/ioctl.c       | 19 ++++++++++---------
 fs/ocfs2/ocfs2_ioctl.h | 26 --------------------------
 4 files changed, 26 insertions(+), 49 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..a6997651f3c4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1944,7 +1944,7 @@ int ocfs2_remove_inode_range(struct inode *inode,
  */
 static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 				     loff_t f_pos, unsigned int cmd,
-				     struct ocfs2_space_resv *sr,
+				     struct space_resv *sr,
 				     int change_size)
 {
 	int ret;
@@ -2008,8 +2008,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	}
 	size = sr->l_start + sr->l_len;
 
-	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64 ||
-	    cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) {
+	if (cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64 ||
+	    cmd == FS_IOC_UNRESVSP || cmd == FS_IOC_UNRESVSP64) {
 		if (sr->l_len <= 0) {
 			ret = -EINVAL;
 			goto out_inode_unlock;
@@ -2026,8 +2026,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	switch (cmd) {
-	case OCFS2_IOC_RESVSP:
-	case OCFS2_IOC_RESVSP64:
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
 		/*
 		 * This takes unsigned offsets, but the signed ones we
 		 * pass have been checked against overflow above.
@@ -2035,8 +2035,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		ret = ocfs2_allocate_unwritten_extents(inode, sr->l_start,
 						       sr->l_len);
 		break;
-	case OCFS2_IOC_UNRESVSP:
-	case OCFS2_IOC_UNRESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
 		ret = ocfs2_remove_inode_range(inode, di_bh, sr->l_start,
 					       sr->l_len);
 		break;
@@ -2090,16 +2090,16 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 }
 
 int ocfs2_change_file_space(struct file *file, unsigned int cmd,
-			    struct ocfs2_space_resv *sr)
+			    struct space_resv *sr)
 {
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int ret;
 
-	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
+	if ((cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64) &&
 	    !ocfs2_writes_unwritten_extents(osb))
 		return -ENOTTY;
-	else if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) &&
+	else if ((cmd == FS_IOC_UNRESVSP || cmd == FS_IOC_UNRESVSP64) &&
 		 !ocfs2_sparse_alloc(osb))
 		return -ENOTTY;
 
@@ -2122,9 +2122,9 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
 {
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_space_resv sr;
+	struct space_resv sr;
 	int change_size = 1;
-	int cmd = OCFS2_IOC_RESVSP64;
+	int cmd = FS_IOC_RESVSP64;
 	int ret = 0;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -2141,7 +2141,7 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
 	}
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		cmd = OCFS2_IOC_UNRESVSP64;
+		cmd = FS_IOC_UNRESVSP64;
 
 	sr.l_whence = 0;
 	sr.l_start = (s64)offset;
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 41e65e45a9f3..bf23ec683c0d 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -10,6 +10,8 @@
 #ifndef OCFS2_FILE_H
 #define OCFS2_FILE_H
 
+#include <linux/falloc.h>
+
 extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
 extern const struct file_operations ocfs2_fops_no_plocks;
@@ -64,7 +66,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
 			     struct buffer_head *bh);
 
 int ocfs2_change_file_space(struct file *file, unsigned int cmd,
-			    struct ocfs2_space_resv *sr);
+			    struct space_resv *sr);
 
 int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 				   size_t count);
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index cbe59d231666..27b6192f4b49 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -11,6 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/compat.h>
 #include <linux/fileattr.h>
+#include <linux/falloc.h>
 
 #include <cluster/masklog.h>
 
@@ -857,12 +858,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int status;
 
 	switch (cmd) {
-	case OCFS2_IOC_RESVSP:
-	case OCFS2_IOC_RESVSP64:
-	case OCFS2_IOC_UNRESVSP:
-	case OCFS2_IOC_UNRESVSP64:
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
 	{
-		struct ocfs2_space_resv sr;
+		struct space_resv sr;
 
 		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
 			return -EFAULT;
@@ -971,10 +972,10 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
-	case OCFS2_IOC_RESVSP:
-	case OCFS2_IOC_RESVSP64:
-	case OCFS2_IOC_UNRESVSP:
-	case OCFS2_IOC_UNRESVSP64:
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
 	case OCFS2_IOC_GROUP_EXTEND:
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
index 2de2f8733283..30244c94239b 100644
--- a/fs/ocfs2/ocfs2_ioctl.h
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -10,32 +10,6 @@
 #ifndef OCFS2_IOCTL_H
 #define OCFS2_IOCTL_H
 
-/*
- * Space reservation / allocation / free ioctls and argument structure
- * are designed to be compatible with XFS.
- *
- * ALLOCSP* and FREESP* are not and will never be supported, but are
- * included here for completeness.
- */
-struct ocfs2_space_resv {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start;
-	__s64		l_len;		/* len == 0 means until end of file */
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserve area			    */
-};
-
-#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct ocfs2_space_resv)
-#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct ocfs2_space_resv)
-#define OCFS2_IOC_RESVSP		_IOW ('X', 40, struct ocfs2_space_resv)
-#define OCFS2_IOC_UNRESVSP	_IOW ('X', 41, struct ocfs2_space_resv)
-#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct ocfs2_space_resv)
-#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct ocfs2_space_resv)
-#define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
-#define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
-
 /* Used to pass group descriptor data when online resize is done */
 struct ocfs2_new_group_input {
 	__u64 group;		/* Group descriptor's blkno. */
-- 
2.55.0

