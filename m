Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B344CC28B
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792334019; cv=none; b=EEQAH+slYMtjLURKOsIGWnLjbapmukFRec5d2z2ET/gFyOCHIUHAsc46CfZ6dqbKK0c+cdyq+EYtD0Tv/o+Qp6lrK7DEbFZZbXLtdhvAQE0PtVxeam73Urfe3dE8ZocQJg4xRusZ95dRoLSD6qoaLYDn3PUl6bpw/oaUg6MdzoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792334019; c=relaxed/simple;
	bh=nNTWK1m03d93431VswcV/gDk6CP93EQh2sEFpcZfCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dcnnf8ONU1e/xSiNweC+RcM8Am2RATm/S60yW793Ns2hGjJwE2wWLsYoZ8Xx8WE+DGF8a0sGqE9vw4DzU69vRu19Kl/jdXfrgmr7c6Wu/ZSxFP9ja89vEK3NHwWVk657TQkPw/qn0PzNQp/uzI+ROCQ7bpAgeEnvtIaTTNLz9q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MdEjVKPr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MdEjVKPr"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a17ce1dc00so1584775e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 07:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792334014; x=1792938814; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ikl81Ku0XQccsYW4khrRKD7VuHKvFe1sUFcKN0eCSLA=;
        b=MdEjVKPrqicpO/hRmIdouIX99FKCSS6cpTTgNjE1QC3SC+2N/2uCKzkoolSVV/BJYN
         OXZuAxrtoP1baSgVGPnSwOzuBdqLLa4rGu0hW6zNEsdP3YGWD8EQRFT55CwaPaNNqceA
         03MbLy4VT66cZE70GA9kviE41v1rsw+P/O9pdek0O23GBlTRYUAztcNjZRMGSiz2C35C
         dXVMUrecPHDkoIpdYr1IUTCzJr3nb4aMeRC0A6VvI2oyPkaleNhBNEZ7L7pJmPqef87V
         wUGsHwQ8bmJzVZSJT/UAxloYVvXQ8gy8jV8ZwP7qO6OEAOQzp+FGK14/5a1+a4/9ruyw
         WRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792334014; x=1792938814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ikl81Ku0XQccsYW4khrRKD7VuHKvFe1sUFcKN0eCSLA=;
        b=ZDg/kYK7kG/dsbs93Jqc9OYMGOnGRLpuxZsEXU+OViwGulMt2CZV6f98xWeczDBV98
         ROLF6k4GVtwjwZzls1dO2L3kUjluOux+JcdYnblcSQABGibPobvJKSoj+pc5Z0ddd/AV
         ExbIaSgLYPMHdUQqY//WxPfbTXlGHRl63PC0yZoqwbxDYfV+DDEEF/vskhTo1Hm1C8Vt
         u/M0TMi62CJc2cHmN81C4Qi6BJ0Us4o2mnRp8Taq5kdeEzSaE+NXcAIWFmPEAHw1BWJK
         nkAmG6une7qunJbsr6gXRz90gVQ7BQBKEU+Ii6vcI8FY42CI72ITkzenKURvny8VcmxE
         qyUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxrkryqdxm6qSBNWL8NIh7vGyMW5gtA2Me6FOqVaTRMn+Kn9rI+yYALgCE/1HQ7ZXBpH8dYsAysxeA58w==@lists.linux.dev
X-Gm-Message-State: AFq9FYIN4qQ9JsPibVLmievD1kXrohPrLt9fgiacZAsKX/CCWvBpKIri
	HQp/KiMrD6Ystd7Xp8bj7k6g45iWsupUzkid7Q5g2EVBpnbCkU9M3C8c3jk4KJDiBWM=
X-Gm-Gg: AYBFou1pOfHiXUU6w3OrRFc4w6SACnkajd5VagJQgwR54JfdPIRlhAENEOLbc5TVsun
	0Ce4hffU4Gs25j6SFzN3rwrrrJrCAXwB1ud1t1wgislDg9aJXs7lrajpbABG+0LHPgrJ9oDFBIq
	22R2npZ/VYryTWCNzIF20rt83SRjh+EF80Tv7zXjtphU6PG7zUObmPbsrp0Wu7x8WZel5e0mCfA
	N76/kQ055iKewr5sNFgGAyVZubglYwghUvr0Xqm5NQsBzoINgrd2zi/dmC76cWW+fmr133JkwKq
	2ypCBpBnt48e/pRm7pU5RbfvCt9AIBdARHpN4zOGdtdI2zNz+V8D2fXHMuToRQ0aQJD3W7TuWI8
	f/LaYDonnYccck/XAUtZtKyXr46RoFXPGoId4L+zqLpzwj4QY7+o5krQ2jwFh/WJXdhEwgmApgz
	yXjDScpQzLrFVS1DJMCDS7XdA65er+En1DZg5lKzEgXDvqTNQwccG097mwSDlvGVUDr/kGd1op+
	Rk6gayGjbLE1w==
X-Received: by 2002:a05:600c:3e85:b0:4a0:1e9f:64f6 with SMTP id 5b1f17b1804b1-4a1d74669e9mr89091515e9.0.1792334014475;
        Sun, 18 Oct 2026 07:33:34 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm16339501a91.11.2026.10.18.07.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:33:33 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 1/4] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Sun, 18 Oct 2026 22:33:13 +0800
Message-ID: <20261018143319.22329-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261018143319.22329-1-heming.zhao@suse.com>
References: <20261018143319.22329-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As part of migrating OCFS2 DIO read/write code paths towards the modern
and performant iomap framework, here introduces ocfs2_map_blocks() to
replace the legacy, high-overhead buffer_head based block mapping
routines.

In addition, OCFS2_MAP_* flags are defined to gridge OCFS2 internal block
mapping flags with the iomap API requirements.

Subsequent iomap integration patches will build on this core block mapping
routine. The implementation draws inspiration from ext4_map_blocks().

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c           | 83 +++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/aops.h           |  2 +
 fs/ocfs2/buffer_head_io.c | 12 ------
 fs/ocfs2/ocfs2.h          | 45 ++++++++++++++++++++-
 4 files changed, 129 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4acdbb70882c..3215e2dda2be 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -126,6 +126,89 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
+		    int flags)
+{
+	int err = 0;
+	unsigned int ext_flags;
+	u64 max_blocks = map->len;
+	u64 p_blkno, count, past_eof;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int create = flags & OCFS2_GET_BLOCKS_CREATE;
+
+	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
+		mlog(ML_NOTICE, "map_block on system inode 0x%p (%llu)\n",
+		     inode, inode->i_ino);
+
+	err = ocfs2_extent_map_get_blocks(inode, map->lblk, &p_blkno, &count,
+					  &ext_flags);
+	if (err) {
+		mlog(ML_ERROR, "get_blocks() failed, inode: 0x%p, "
+		     "block: %llu\n", inode, map->lblk);
+		goto bail;
+	}
+
+	if (max_blocks < count)
+		count = max_blocks;
+
+	map->pblk = p_blkno;
+	map->len = count;
+
+	/*
+	 * ocfs2 never allocates in this function - the only time we
+	 * need to use MAP_NEW is when we're extending i_size on a file
+	 * system which doesn't support holes, in which case MAP_NEW
+	 * allows __block_write_begin() to zero.
+	 *
+	 * If we see this on a sparse file system, then a truncate has
+	 * raced us and removed the cluster. In this case, we clear
+	 * the buffers dirty and uptodate bits and let the buffer code
+	 * ignore it as a hole.
+	 */
+	if (create && map->pblk == 0 && ocfs2_sparse_alloc(osb)) {
+		map->flags &= ~(OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE);
+		goto bail;
+	}
+
+	if (p_blkno) {
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
+			map->flags |= OCFS2_MAP_UNWRITTEN;
+		} else if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
+			/* Treat the unwritten extent as a hole for zeroing purposes. */
+			map->flags |= OCFS2_MAP_MAPPED;
+		} else {
+			/* TODO: handling other OCFS2_MAP_XX in the future */
+		}
+	}
+
+	if (!ocfs2_sparse_alloc(osb)) {
+		if (map->pblk == 0) {
+			err = -EIO;
+			mlog(ML_ERROR,
+			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
+			     (unsigned long long)map->lblk,
+			     (unsigned long long)map->pblk,
+			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			mlog(ML_ERROR, "Size %llu, clusters %u\n",
+			     (unsigned long long)i_size_read(inode),
+			     OCFS2_I(inode)->ip_clusters);
+			dump_stack();
+			goto bail;
+		}
+	}
+
+	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
+
+	if (create && (map->lblk >= past_eof))
+		map->flags |= OCFS2_MAP_NEW;
+
+bail:
+	if (err < 0)
+		return err;
+	else
+		return map->len;
+}
+
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 114efc9111e4..8dd6edd7c1a1 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -42,6 +42,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create);
+int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
+		    int flags);
 /* all ocfs2_dio_end_io()'s fault */
 #define ocfs2_iocb_is_rw_locked(iocb) \
 	test_bit(0, (unsigned long *)&iocb->private)
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 7bfe377af2df..493f2209cca5 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -23,18 +23,6 @@
 #include "buffer_head_io.h"
 #include "ocfs2_trace.h"
 
-/*
- * Bits on bh->b_state used by ocfs2.
- *
- * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
- */
-enum ocfs2_state_bits {
-	BH_NeedsValidate = BH_JBDPrivateStart,
-};
-
-/* Expand the magic b_state functions */
-BUFFER_FNS(NeedsValidate, needs_validate);
-
 int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		      struct ocfs2_caching_info *ci)
 {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 62cad6522c7a..095f7ae5dded 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -509,7 +509,50 @@ struct ocfs2_super
 	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
 };
 
-#define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
+/*
+ * Bits on bh->b_state used by ocfs2.
+ *
+ * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
+ */
+enum ocfs2_state_bits {
+	BH_NeedsValidate = BH_JBDPrivateStart,
+};
+
+/* Expand the magic b_state functions */
+BUFFER_FNS(NeedsValidate, needs_validate);
+
+/*
+ * Logical to physical block mapping, used by ocfs2_map_blocks()
+ *
+ * This structure is used to pass requests into ocfs2_map_blocks() as
+ * well as to store the information returned by ocfs2_map_blocks().  It
+ * takes less room on the stack than a struct buffer_head.
+ */
+#define OCFS2_MAP_NEW			BIT(BH_New)
+#define OCFS2_MAP_MAPPED		BIT(BH_Mapped)
+#define OCFS2_MAP_UNWRITTEN		BIT(BH_Unwritten)
+/* useless? #define OCFS2_MAP_BOUNDARY		BIT(BH_Boundary) */
+/* useless? #define OCFS2_MAP_DELAYED		BIT(BH_Delay) */
+#define OCFS2_MAP_DIRTY			BIT(BH_Dirty)
+#define OCFS2_MAP_UPTODATE		BIT(BH_Uptodate)
+#define OCFS2_MAP_NEEDS_VALIDATE	BIT(BH_NeedsValidate)
+#define OCFS2_MAP_DEFER_COMPLETION	BIT(BH_Defer_Completion)
+#define OCFS2_MAP_FLAGS		(OCFS2_MAP_NEW | OCFS2_MAP_MAPPED |\
+				 OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE |\
+				 OCFS2_MAP_NEEDS_VALIDATE |\
+				 OCFS2_MAP_DEFER_COMPLETION)
+
+struct ocfs2_map_block {
+	u64 pblk; /* physical block# */
+	u64 lblk; /* logical block# */
+	u64 len;  /* number of block */
+	unsigned int flags;
+};
+
+/* Flags used by ocfs2_map_blocks() */
+#define OCFS2_GET_BLOCKS_CREATE	(0x0001)
+
+#define OCFS2_SB(sb)	((struct ocfs2_super *)(sb)->s_fs_info)
 
 /* Useful typedef for passing around journal access functions */
 typedef int (*ocfs2_journal_access_func)(handle_t *handle,
-- 
2.55.0

