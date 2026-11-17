Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927670;
	b=1nZpfXqds1LK2pZkgj1GD7F/cQt64JKiEDcZgsJ8C6BG2kVXPYvTuqxj7y6EpRt+sDoC
	 nV0VOucHxTmHNApEtumtU39WQMagsAkB0G3YX9waVFHtyd8oko9gl1k8QPgCP/1Lh7BQu
	 0DrpAU9FlCH4U/vg1D4b8OtkKD/KTTgTLQcj8TcyYNS5fLF6sRu1PJt9G+9/BHXcMKpHY
	 0kYG5tWRc906JvxV33rz4Dh1mWQ9Fg3vH7jnZpyQpRdR4DT9hLe1Ml9d5QqIp5Tn6vIC7
	 Nc4uQvc7JJx+9wCeBvOHE4xr2hSZoSIXssTE2IwBr9yRik5lXzEu5Gz4CaGERCnIqxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927670;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
	b=mdOvD2EDOS7LXMSK7MZe9SRxMcgrUFeXnknZWrOsPcc6eO9P1BYuUYyyHcbxC6I/S9ra
	 BMPme6jkJPhyPAKRh6S+RjhYAAVr++ZbxisBCZ5qbsjYn85Bga/lXJiBB0jx0YVwtfzBK
	 xJ/WaCXyaM103OB6kaRqbOmoBJDgpcHzDD3cyxVuL7JGLzWrVwM02hh4L06nv3k8WYNey
	 10YsoQhIwurHkcjg7ZpGXEUYkqsWvgT5Xh9/dg+C1eEyooByls141TrqUMHADHo6SIUTX
	 1cOAis2Zrgea7zV7bMS9dynmIPo+BcsyuP30tCY381deqAYaB27o+kO+mhdrSPJl/vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I0CQ30ti;
	arc=none smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D500F606A31C
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 15:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D500F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I0CQ30ti
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c09dbe96b1so283859e87.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 07:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794927668; x=1795532468; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
        b=I0CQ30tiZCpGzb94Wu3cXyVchghc8wm/XnkJIrUWez9MrmY+ylowntGGqg2diwZthe
         VxnxRZF0w5XrNuXt/Xy1QF+tIHjQqMpKds8mOWFONcf0k+nCLZE5ZTGuWrNsjDlZYBmI
         N+L9TJnNgRjOD6Dw3bZ49Eha/q3Q3LOVfAD02JRyifWjbplgQJTawWop66hou1zdZIcn
         5lXAj/zl01aqI9aNnotRvsAAt8n99WB0s2xCVupPk+zUaFGSLDvcKZVoeaohNHfu+LCg
         W8MAAo2DLnF1Uo3ESFxbLsGSYmTgxlk2jpWVz5Ba5wlH+KZvHv7X9WhRpcMY9REzAQmv
         wmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794927668; x=1795532468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
        b=gD9lVJEntRRpwnHE3MClOnXPtEoQHQgvXVXXS7cXHhO/0rW9HvmwBN9QQ9UWcbMXH2
         iSqNXm7oV/dEfWRHQ8Fc85HjClZ4b5ir/UdUtcL2vBv3zmcJHSi3F14kRO68yBn3Cj2r
         koKl+WNhvigiZGExiEkW+pr20M8sXNmaLUai1rZeki83jYetaIluBsjwNwbwIgQDTFVP
         QIhIlNbk0W1fnezHRqgmIIoJW6gaI6hOh0kpTuUtXry/Rtlf6grXTW8g6So0qTnSZw56
         FKD3tMPTUI4opkqKPcincC+ISsaK9Ovi9KL4NPfaVCENKb+J5SOCxPrQRlMth3Em/+wC
         3tWA==
X-Forwarded-Encrypted: i=1; AL+hErH7S+EFGEh6gvrElaEb2CvR7O+3ROEVs4TauVdMUFkL2qlUHDYmGci/acdJEKzAbcTEZ9EUfL8VDQUotg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8NCp+XjMnQJnYs7hoXMYLr+Uq970tJKgSz/u4tzaua3q2xsDtP
	6wKPcYpcRCdFXh4sH9D4PK4pkYkG1lAEr9zaSLdNdRTF4yUepD8pYFqb9dPFTEaZe3bGDDYnusg
	/VyRT8KE=
X-Gm-Gg: AYBFou3omJv8RKyLirFTX4+sZpV77LULNE3wzUL48epuP/Wr4mGWv+eol/J6S2jdiqU
	k2VECG1fa7uYWEmaPNanANLGdPgxiYNf8ACzT4KZFcThsU7LnoB1utB/TjgA2HzbdIVKVx3j2fW
	zja3qL4YNJIQZbtuhY1EViQZFfiII2VS/AE4hrec/x1fpQpA/zySArDjPEiRB0UHeQvmnaGJ+3B
	YaS1jOurH2eZDo6CWBNcQ6IziEiiDXiEPff/deMLiQ5ft9b6Oc+i10w0yhWNqmR+cn3slbBReAn
	YBOdVHLfVYRTOF5t6gCNtzOqg+keHLb0ONo7ERB2o0BUwzmXOpiOZ/9TWUxTpaPJa/nRhD/z0S/
	CZmt+hbMHTPDldebhug1mwkPYnxHp06URVlEmqtvfAYgjopdpZkKKG9/A6XRrbQ6+gG/+hmDGTz
	qTOXY4IJ5QKr4o8C+2EGYFiRk5jjt7T3Szn4OkChdhm0o9khwFaaFguS7dPl4v616sgOWm6TfsS
	pUucRL1Ba+hUEw6dy4t8WrJbZn/npB/yqPlUtGg7D/FGxRwdGefSrGWanJVHFUL3H+QycNzAq/Z
	N/fR1g2Q9OQlpwqh7IiwLQHXAWhA7J1IwyhgfEBI5w4=
X-Received: by 2002:a05:6512:39d4:b0:5bf:a48b:7827 with SMTP id 2adb3069b0e04-5c1705f074amr6443827e87.2.1794927667382;
        Tue, 17 Nov 2026 07:01:07 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50309b2b5sm35904028c88.1.2026.11.17.07.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:01:05 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v7 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Tue, 17 Nov 2026 23:00:50 +0800
Message-ID: <20261117150053.18417-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261117150053.18417-1-heming.zhao@suse.com>
References: <20261117150053.18417-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.c  | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/aops.h  |  2 ++
 fs/ocfs2/ocfs2.h | 25 ++++++++++++++++-
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4acdbb70882c..64fcf6eb3d89 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -126,6 +126,76 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+/* ocfs2 never allocates in this function */
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
+	 * If we see this on a sparse file system, then a truncate has
+	 * raced us and removed the cluster. We treat this as a hole
+	 * and skip setting the iomap flags. The caller will set
+	 * iomap->type to IOMAP_HOLE.
+	 */
+	if (create && map->pblk == 0 && ocfs2_sparse_alloc(osb))
+		goto bail;
+
+	if (p_blkno) {
+		if (ext_flags & OCFS2_EXT_UNWRITTEN)
+			map->flags |= OCFS2_MAP_UNWRITTEN;
+		else
+			map->flags |= OCFS2_MAP_MAPPED;
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
+	return err;
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
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e3bb3cc0b25a..b4583b3170e2 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -514,7 +514,30 @@ struct ocfs2_super
 	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
 };
 
-#define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
+/*
+ * Logical to physical block mapping, used by ocfs2_map_blocks()
+ *
+ * This structure is used to pass requests into ocfs2_map_blocks()
+ * as well as to store the information returned by ocfs2_map_blocks().
+ * It takes less room on the stack than a struct buffer_head.
+ */
+#define OCFS2_MAP_NEW			BIT(BH_New)
+#define OCFS2_MAP_MAPPED		BIT(BH_Mapped)
+#define OCFS2_MAP_UNWRITTEN		BIT(BH_Unwritten)
+#define OCFS2_MAP_FLAGS		(OCFS2_MAP_NEW | OCFS2_MAP_MAPPED |\
+				 OCFS2_MAP_UNWRITTEN)
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

