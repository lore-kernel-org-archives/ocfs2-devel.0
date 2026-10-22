Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674327;
	b=IbrhWoX2AKPagT2pPipOOjbhFppYH+hq0gHK9FnShVZiM7eWjijqBoNJnDwZc78+0nvp
	 2bunTYUaklX0JAJTlhNZDHHZNaT0ZSXhQcG+Y2JPLX0t01mBQt/qlht3bnL9M4/nbliM1
	 i2BGo3QOF+AT26M7ScSkHy7MrqUH9180HbFOQ2I4vnfLR1C6gGCQHrzzDk1m0blw+YvMT
	 C5njsUSpA6Nnc+MKnVUKByx4Y7QNZD0C29acQ2tTEB+wJwbnFMNh6VH4S+ZT+LTCVqDtZ
	 6fajeiBzCr0TyyAbXQmHSTgLIVDHc5u9zXFlOWE4U957KMjzkIto6UY47sV8/VEnVuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674327;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=9QvS+Y5TyJrdLEt/K6Nto4dB43mpngYYSMgdFtwBxWU=;
	b=qH8am5p4FmjiX4aJGo5Syoh2FBX2qZ4SG65GJxR3OClf0K6ggBS2E+7o5YLKC+1WNrxO
	 Nswa1IQxXDKhw54dVmxd2itfwEI9IVaKWX1Ctcj4GnxbGEpndoAihLoDaC3mU0AgiFBKa
	 TpYMuphfdVgumCzRZ2Xw79E/DizJxOkOcHAe/8P8TC3s0QmC3tmRnrw6g+9DQtyXIA9Qv
	 +qfcE96AdXBJiyFwMSHdKOet+5s8Te2jGwuah9JXGWHIWmtO5bVl/KDhrm52VkwL2Kw0o
	 TQsNMKZUOEafNiBlYOAGDTa5e0gEWvnAD7Le4joxmVUJJNIREt5tQ29ks7n85Cmd9FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ayONN2wc;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ayONN2wc;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A85606A323
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 13:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28A85606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ayONN2wc;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ayONN2wc
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	by smtp-out2.suse.de (Postfix) with ESMTP id 6A6461F397;
	Thu, 22 Oct 2026 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792674325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9QvS+Y5TyJrdLEt/K6Nto4dB43mpngYYSMgdFtwBxWU=;
	b=ayONN2wcmwdzCXJg/dDEscSNZHaVRjcGxNH4XvvfFSV4SDWeGJkpxP30pKc1ZdClUnlpWO
	D6uiESIzfWLD3g3l6zXG1XozeYpUhjGGmAuB6s7PlFc/G15UqGa8D5Dqqg6SR/JsF9COzu
	f8syoohDZqc0GYy5A44Fe1DE51Fzu3g=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ayONN2wc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792674325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9QvS+Y5TyJrdLEt/K6Nto4dB43mpngYYSMgdFtwBxWU=;
	b=ayONN2wcmwdzCXJg/dDEscSNZHaVRjcGxNH4XvvfFSV4SDWeGJkpxP30pKc1ZdClUnlpWO
	D6uiESIzfWLD3g3l6zXG1XozeYpUhjGGmAuB6s7PlFc/G15UqGa8D5Dqqg6SR/JsF9COzu
	f8syoohDZqc0GYy5A44Fe1DE51Fzu3g=
From: Anthony Iliopoulos <ailiop@suse.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ocfs2: replace ocfs2-specific falloc ioctls with generic ones
Date: Thu, 22 Oct 2026 15:04:56 +0200
Message-ID: <20261022130457.69343-2-ailiop@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022130457.69343-1-ailiop@suse.com>
References: <20261022130457.69343-1-ailiop@suse.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A6461F397
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.87 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.94)[0.981];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	ONCE_RECEIVED(1.20)[];
	RDNS_NONE(1.00)[];
	HFILTER_HELO_IP_A(1.00)[kunlun.suse.cz];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	R_MISSING_CHARSET(0.50)[];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[kunlun.suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DIRECT_TO_MX(0.00)[git-send-email 2.56.0];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b306:2000::2:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b306:2000::2:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kunlun.suse.cz:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -2.87

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
index 62f45a1b5ca1..5ccc2a613e2d 100644
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
index 97492ee5789e..7f587dc06dab 100644
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
index 36c7c9ac8b5d..2d95c1e5ad8b 100644
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
2.56.0

