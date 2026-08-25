Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119F93D9DB1
	for <ocfs2-devel@lists.linux.dev>; Tue, 25 Aug 2026 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649001; cv=none; b=XbUt1jQjdOhlS4j/s2nTqia0wH8Y48AQumkHj7yUpcjV9+FRH5R8ojR2gH4/zUFvdzP8Geq2ATZeNv9WPWo7pRQ/MezFkQUHG28pMogAWc0r1cRiwPWFtJLW14G1KnPAcd8j3b6wPp85FOgumk1vchCMv+7meSr04kOK3BFyAbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649001; c=relaxed/simple;
	bh=OldWtfm4im1IYngdEspzvqKSBBtTuxVAmqCJvgx5PNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pd30wDLutPuGo3CwvXvbDZRB9LV9GkZiZAy7sMazEGXLnAlgmgJAioUJG3H+XktRurqq9nYFGceKnQd1KmbSzvvyysIRBP3lz5RtaHLjY+gYA9Vj06jmVVgPaJkJy8Nka0oXHHhCyqs5TLq5FCMxoPPLsWZArnMyAbCARlSpjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YmJJCgyI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=p9OGJMIL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YmJJCgyI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="p9OGJMIL"
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	by smtp-out2.suse.de (Postfix) with ESMTP id EAE1B1F38A;
	Tue, 25 Aug 2026 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787648994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aZDfuVjQGNAQLzSJF0ooZt5pHSN5rbMMiuOG+3QWL8A=;
	b=YmJJCgyIdcLdLB+SftO/Uk7IEsx+KUf+HWJAaiQpS7PY05RYwx7VZxjhPg9MdNPqGaxZkg
	0xsPW5ssdP7Mpg8LmWadMQH6T3mWKgHKITSeOTeTrHl60AcZARGdLtxxAAIULaCrFLlLfI
	7OOYw+oEeWfPqL5nVS5KKipdNvuTBxU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=p9OGJMIL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787648990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aZDfuVjQGNAQLzSJF0ooZt5pHSN5rbMMiuOG+3QWL8A=;
	b=p9OGJMILsprsb4InfaJChhpDvhGeF9O3TsYWYK3sp/oLlUVOyzVsRZXIgxbrwH73NvCTdj
	kCwrNTamjXce8x9wRWEwGRLdcg5W9BLsszqpPXrxiQHV9GKOb5h21bBRERoOvOgLyP4xBs
	/jt7RVSk/tMYUzjZmvN9O9i0vlkV06Q=
From: Anthony Iliopoulos <ailiop@suse.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: replace ocfs2-specific inode flags with generic ones
Date: Tue, 25 Aug 2026 11:09:13 +0200
Message-ID: <20260825090917.117327-2-ailiop@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [16.51 / 50.00];
	SPAM_FLAG(5.00)[];
	NEURAL_SPAM_LONG(3.50)[1.000];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.82)[0.940];
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
X-Rspamd-Queue-Id: EAE1B1F38A
X-Rspamd-Action: add header
X-Spam-Flag: YES
X-Spam-Score: 16.51
X-Spam-Level: ****************
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam: Yes

The ocfs2 inode flag macros are alias definitions for the generic fs
flags. Remove these redundant macros, most of which are anyway unused,
and use the generic flags directly.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/ocfs2/inode.c    | 24 ++++++++++++------------
 fs/ocfs2/ioctl.c    |  2 +-
 fs/ocfs2/ocfs2_fs.h | 24 ------------------------
 3 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 180107a11046..64d92d30aa31 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -107,16 +107,16 @@ void ocfs2_set_inode_flags(struct inode *inode)
 	inode->i_flags &= ~(S_IMMUTABLE |
 		S_SYNC | S_APPEND | S_NOATIME | S_DIRSYNC);
 
-	if (flags & OCFS2_IMMUTABLE_FL)
+	if (flags & FS_IMMUTABLE_FL)
 		inode->i_flags |= S_IMMUTABLE;
 
-	if (flags & OCFS2_SYNC_FL)
+	if (flags & FS_SYNC_FL)
 		inode->i_flags |= S_SYNC;
-	if (flags & OCFS2_APPEND_FL)
+	if (flags & FS_APPEND_FL)
 		inode->i_flags |= S_APPEND;
-	if (flags & OCFS2_NOATIME_FL)
+	if (flags & FS_NOATIME_FL)
 		inode->i_flags |= S_NOATIME;
-	if (flags & OCFS2_DIRSYNC_FL)
+	if (flags & FS_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
 }
 
@@ -125,18 +125,18 @@ void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi)
 {
 	unsigned int flags = oi->vfs_inode.i_flags;
 
-	oi->ip_attr &= ~(OCFS2_SYNC_FL|OCFS2_APPEND_FL|
-			OCFS2_IMMUTABLE_FL|OCFS2_NOATIME_FL|OCFS2_DIRSYNC_FL);
+	oi->ip_attr &= ~(FS_SYNC_FL | FS_APPEND_FL | FS_IMMUTABLE_FL |
+			FS_NOATIME_FL | FS_DIRSYNC_FL);
 	if (flags & S_SYNC)
-		oi->ip_attr |= OCFS2_SYNC_FL;
+		oi->ip_attr |= FS_SYNC_FL;
 	if (flags & S_APPEND)
-		oi->ip_attr |= OCFS2_APPEND_FL;
+		oi->ip_attr |= FS_APPEND_FL;
 	if (flags & S_IMMUTABLE)
-		oi->ip_attr |= OCFS2_IMMUTABLE_FL;
+		oi->ip_attr |= FS_IMMUTABLE_FL;
 	if (flags & S_NOATIME)
-		oi->ip_attr |= OCFS2_NOATIME_FL;
+		oi->ip_attr |= FS_NOATIME_FL;
 	if (flags & S_DIRSYNC)
-		oi->ip_attr |= OCFS2_DIRSYNC_FL;
+		oi->ip_attr |= FS_DIRSYNC_FL;
 }
 
 struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 27b6192f4b49..a0a28f3d1b7c 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -105,7 +105,7 @@ int ocfs2_fileattr_set(struct mnt_idmap *idmap,
 	}
 
 	if (!S_ISDIR(inode->i_mode))
-		flags &= ~OCFS2_DIRSYNC_FL;
+		flags &= ~FS_DIRSYNC_FL;
 
 	oldflags = ocfs2_inode->ip_attr;
 	flags = flags & OCFS2_FL_MODIFIABLE;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c501eb3cdcda..b2f6f81a3d28 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -235,30 +235,6 @@
 #define OCFS2_INDEXED_DIR_FL	(0x0008)
 #define OCFS2_HAS_REFCOUNT_FL   (0x0010)
 
-/* Inode attributes, keep in sync with EXT2 */
-#define OCFS2_SECRM_FL			FS_SECRM_FL	/* Secure deletion */
-#define OCFS2_UNRM_FL			FS_UNRM_FL	/* Undelete */
-#define OCFS2_COMPR_FL			FS_COMPR_FL	/* Compress file */
-#define OCFS2_SYNC_FL			FS_SYNC_FL	/* Synchronous updates */
-#define OCFS2_IMMUTABLE_FL		FS_IMMUTABLE_FL	/* Immutable file */
-#define OCFS2_APPEND_FL			FS_APPEND_FL	/* writes to file may only append */
-#define OCFS2_NODUMP_FL			FS_NODUMP_FL	/* do not dump file */
-#define OCFS2_NOATIME_FL		FS_NOATIME_FL	/* do not update atime */
-/* Reserved for compression usage... */
-#define OCFS2_DIRTY_FL			FS_DIRTY_FL
-#define OCFS2_COMPRBLK_FL		FS_COMPRBLK_FL	/* One or more compressed clusters */
-#define OCFS2_NOCOMP_FL			FS_NOCOMP_FL	/* Don't compress */
-#define OCFS2_ECOMPR_FL			FS_ECOMPR_FL	/* Compression error */
-/* End compression flags --- maybe not all used */
-#define OCFS2_BTREE_FL			FS_BTREE_FL	/* btree format dir */
-#define OCFS2_INDEX_FL			FS_INDEX_FL	/* hash-indexed directory */
-#define OCFS2_IMAGIC_FL			FS_IMAGIC_FL	/* AFS directory */
-#define OCFS2_JOURNAL_DATA_FL		FS_JOURNAL_DATA_FL /* Reserved for ext3 */
-#define OCFS2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
-#define OCFS2_DIRSYNC_FL		FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
-#define OCFS2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
-#define OCFS2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
-
 #define OCFS2_FL_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
 #define OCFS2_FL_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
 
-- 
2.55.0

