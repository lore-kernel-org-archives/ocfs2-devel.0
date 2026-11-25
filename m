Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621599;
	b=j6PF+iuxTRRu/57vVScjr8UiObHnLTa3zf119TQfSzb2sAzl+qcfrgWvcDlW4JxPLIxX
	 a9LL5xxx4i+fkhgutJbQ3Y/SkqZXQ55uBaMn0oFesSGFjAl3xfSNljQp3+k+5BqHfrU15
	 slXZRpKL8UKUqAiVe0+CR0IlrY5huEyu54duhTX0LDjOLsCaiVnjInROZrSuWXVpDGq0L
	 lpxGOQl2n5YXkG9ETBX1c+H5i9yTDQQZ50ftX4Df86CQKIjzC8CPvgN+zBkdXBHrJH8UQ
	 31OI3b6wgBvp/Tman9qdOmeAiB/fNmcrFCWzZY/5YcPBSRMwk0e3LRR3Q895QqMaZPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621599;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
	b=YmKgqhr0DkKuT7vUoPex/dwfxyB9oxivh+pOkJycVCQeCXXkgOxZEIrhF3zZ4rLs5/Hb
	 OK6PPia7eRDpXjvFKFUlX2vy1Stty0X+uUpj57ENVPjKlQvClZk1XP+T/8nXZaV3vZRCQ
	 PaUWPxtRSgAkCgppw0bu0dkTusJ+Eb2kXT1zGpWaPLQdfNCLBAd/d2NB6xBKmKBTV48Ql
	 zc9oTZ1Yg9slwuvXUoaFefp0MhxjVLvXgANB7G7zp5Q+Oc8nfY4Z7vIrF5F4DCUuoSXDl
	 C/gNXo5Yp1esegOq9ncdKNBjRQTlfELI2xIbZ4qxmxuY8AlrvXu8WT10AeC2XEQ831g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Qmpeo2gK;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623AF606A68D
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 15:46:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 623AF606A68D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Qmpeo2gK
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c504d4cc6b7so58119266b.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 07:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795621598; x=1796226398; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=Qmpeo2gKESLW6dixrtcQEp1McbgKM8gW1jA59nBFxIdvKOw6JDu/aHZErWwCLrptwI
         TvR0nwjc9aDEPRHLbJphVhOzjcp39JkPFogoViwrnCtflc2R71Wv8Ap0xjG7gNU+5ZgC
         WoYuzLNZ1MkrlKIAb9CDSLB1AYjJS3HVlfkp5yrNz14+uBb586aGqPgjB4H1S0zjNoYF
         doFi3KGyYaGRsG20bffFaY4riA+rDZoJmFlbjmbPBeq8GgzBEVj0WQZkZhJ/j7RW4XY7
         TG0XNmRArvd+tHaG24vFcLVe3nIgDVI/idsVTZG/SsforrjvvnyIE/WWRLRweXIw4bVL
         pcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621598; x=1796226398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=EpUivjY3X/REX5+FnEASDJMP9p97HagnB7cTugX2gd8UCJGDIqgB6Esy+iXqIszdYn
         5mejKMsRksYPFrxszmshTbDSET/ML0voKwKz4kst+MLUTGtq1XRl8FGFOU/PbN7OAzMw
         8fDM7X5rNKcX3RQIGBVLPSz4YPNj5DJ+sveX5md8c7Q8fuBHiv0WY7lDja7BUfjgvPcm
         Z2kT7/vMkqeN9PDssvsMjcCz7EOLfzJK/MYvzrrTLkPJrHKryfTW0l4/eXzGrPH8ysEX
         qDyczrkInnrqbsw5ynJzyaLoYhFgghrQq9v0cCngkU63MR+7wHgpvqOWh7Ow6WpCeyMg
         wEnw==
X-Forwarded-Encrypted: i=1; AL+hErFwXNLJaL/P9QaJnxjRIIoQS6xOgu32hF0NxSIyf6D0wf3g5Q5iQmfL4ODZHfnkN4aPloWioYvxe107zQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9u3qSbfZ6NK+2PyzEHop57OVCH/je/aNbVPYrMr33+TY2NdWpI
	kKVOZAWGBeUORGD/lIOzdeGMhf0nxoVprULFLVHV2TQgQ1LIghqvwKiTPre+BdQQ3w8=
X-Gm-Gg: AZFdTZezLjsqz2Bk6bPBaKMrl4H4uawe9TOGuGN4z78T+4dJq5c8xoJmW9gxeBHZPm4
	5D7oYMba30fKcQ/hvjqm92Bw3TmODz/poL7gVX+AyMn6vlhrTUT0q0nxGu5Jh/UJB3hK7F2ZVrP
	R8ZTu9BXnUYId9Xs8uYw2JvTEoZjfcs+HsE7I051gKupdneqinc2A/HpC0uKl7FjpOKH4hf5yWw
	bXGiOSOzcPIelOktvuZU/mRGrbD//Y9s9+ZOUDkAdCBVBr6Xy1KMbFjpwFOcs3cS0KQRzCrl8Jq
	Nu/WIOeisY6EKuqlvQV9a/X61rEc7FgfSZD28bmdxJ+3ECUcNL7fDgPmOU7kv6TmoJeS+QeVvLc
	1nVf6fAvjsg/yl/v6qijrvYl7QyilZmi/R1PkVxWg8E3NdG7oJzfPMjG+tyCKqlewh4DHG3mf3j
	X6+SQjnC0svnODXP5PxM7V+TkYEOAzdUO9KbviIuB766Fb4w7wz4SYi7A2AqRtRn2CBd8QbnuX/
	XbaZwV69DHscMlUA4xVStjbQEvt5J1dc+QHFay4KqrGjhobA6LDmTJbAUWVfHDRvxRvsMU3PUvz
	LxUMXKje984A5K6cqtvb1dho16E0ov+HcI6W9jenZq4=
X-Received: by 2002:a17:906:a11a:b0:c42:e6c8:e45a with SMTP id a640c23a62f3a-c513a5f7605mr1371431766b.3.1795621597674;
        Wed, 25 Nov 2026 07:46:37 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8707792e8sm9419677b3a.7.2026.11.25.07.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:46:36 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v12 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Wed, 25 Nov 2026 23:46:23 +0800
Message-ID: <20261125154626.22335-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261125154626.22335-1-heming.zhao@suse.com>
References: <20261125154626.22335-1-heming.zhao@suse.com>
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

In addition, OCFS2_MAP_* flags are defined to bridge OCFS2 internal block
mapping flags with the iomap API requirements.

Subsequent iomap integration patches will build on this core block mapping
routine. The implementation draws inspiration from ext4_map_blocks().

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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

