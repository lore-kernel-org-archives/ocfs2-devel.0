Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674333;
	b=XtIHp9cmY87jTwppsnhC5c7qt/z4jd3GnRZX73QVEIFMyzWSQop94Sx/NnAHwT8ZRlZi
	 Ag1bAKLNPO62O0OxEYF82sD9SSJmMjQ5UhfxNid2bC05925msmC1brfH7qLO+RpR54bvj
	 Z1MTtWE2mL8AB/TB7srKt29bNx/uVSpRQDBn4ZAQHFJ9xZaSIAw69Myk/QdimaMH6VgLn
	 ZS1r0k+rwD+6rLh0Q4cTEEUVZrXNZEY7IwYbxRnU/Bc/RwnyzzN9k7kRWzIo3QMsDSs75
	 3h4Zr+XEh5twnC415lPSDtDmbTLefJa4sl/h79K3g/Z5FtYWjBzcVAhUUn+NKhxa8iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674333;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=8im1UzNMkFwAjrjrRVbJ8a8P3900EWF9/5lDbm3fB04=;
	b=RXhjcwWgsAE37fm0bdXucRvH1/ZSGlzw/7GpaKAiDD3CmQP+6WVfsAQtXxNCJlk8nNev
	 8z87KOaotfL48DgMdIMAUz35QquIO/h4vfrIBJHGKBj17ax1A6sxlfWuqBsSkJiW9RpZo
	 U3YlbcF1e+eroRBxrP+Sok/uLstI+kOm3RLvwJ01zKAz6Wwe+vpUPmIDAy4ECnuC96pBQ
	 oFhQPPinNdUUJn7AxPwZqUTQPeUKgoWSMdWGWt7bZl70CdEndydxV9lcSm99CurfRqJe8
	 6/TyOAeuXg+r76vRulJnmDVrgGxbk1JIT63UZxmnKljq+O5sgR3Ugbn5OMzR7MzsVrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eDyXJGTR;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="c/OahpSx";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFD3606A322
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 13:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCFD3606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eDyXJGTR;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=c/OahpSx
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0C1091F7C4;
	Thu, 22 Oct 2026 13:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792674330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8im1UzNMkFwAjrjrRVbJ8a8P3900EWF9/5lDbm3fB04=;
	b=eDyXJGTRvOtgZWqm/ObsnKIcYp/L+m0pmOrwVSqd2VVQZLQM7OzJ3kvA2hXH/a9iUndZQ7
	coPt56yLZRgp86t5sDXKQHN+NO+Mzu955geSx3xvCwGX0eC10ySW7T1W7ORDlROl84KHrE
	Id46NkflLM3DmV3eFwsqlRZJDQllJ7E=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="c/OahpSx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792674329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8im1UzNMkFwAjrjrRVbJ8a8P3900EWF9/5lDbm3fB04=;
	b=c/OahpSxvk3uFr63kd7tvQjVPBHv8HjfErF4JBM9HCrqIMl6dFYXjup1pRj2FW7mgoYJro
	80p3SYbDmKJQj36Mun5lNpWqYGzF4t2Yp95pm5oXMJGWlpCGWVQNBmg/jb1uoKtcEoT3FS
	8OwPyJxUXAg7j+ZpRjedRrBiDIcZMOs=
From: Anthony Iliopoulos <ailiop@suse.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ocfs2: replace ocfs2-specific inode flags with generic ones
Date: Thu, 22 Oct 2026 15:04:57 +0200
Message-ID: <20261022130457.69343-3-ailiop@suse.com>
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
X-Rspamd-Queue-Id: 0C1091F7C4
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.87 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.94)[0.979];
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

The ocfs2 inode flag macros are alias definitions for the generic fs
flags. Remove these redundant macros, most of which are anyway unused,
and use the generic flags directly.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/ocfs2/inode.c    | 24 ++++++++++++------------
 fs/ocfs2/ioctl.c    |  8 ++++----
 fs/ocfs2/ocfs2_fs.h | 27 ---------------------------
 3 files changed, 16 insertions(+), 43 deletions(-)

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
index 2d95c1e5ad8b..2d962da9ba5c 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -78,7 +78,7 @@ int ocfs2_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	flags = OCFS2_I(inode)->ip_attr;
 	ocfs2_inode_unlock(inode, 0);
 
-	fileattr_fill_flags(fa, flags & OCFS2_FL_VISIBLE);
+	fileattr_fill_flags(fa, flags & FS_FL_USER_VISIBLE);
 
 	return status;
 }
@@ -105,11 +105,11 @@ int ocfs2_fileattr_set(const struct mnt_idmap *idmap,
 	}
 
 	if (!S_ISDIR(inode->i_mode))
-		flags &= ~OCFS2_DIRSYNC_FL;
+		flags &= ~FS_DIRSYNC_FL;
 
 	oldflags = ocfs2_inode->ip_attr;
-	flags = flags & OCFS2_FL_MODIFIABLE;
-	flags |= oldflags & ~OCFS2_FL_MODIFIABLE;
+	flags = flags & FS_FL_USER_MODIFIABLE;
+	flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
 
 	/* Check already done by VFS, but repeat with ocfs lock */
 	status = -EPERM;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c501eb3cdcda..53ddeb5e762f 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -235,33 +235,6 @@
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
-#define OCFS2_FL_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
-#define OCFS2_FL_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
-
 /*
  * Extent record flags (e_node.leaf.flags)
  */
-- 
2.56.0

