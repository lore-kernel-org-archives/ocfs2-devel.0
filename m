Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795070446;
	b=vIb5SkhPWTd407tW2OBwBmKIm9AHsa2UIiJDEOppih8J2I4Qf/JR/Wt98c7t6LX45WOm
	 tB16e/i8wsglCMa8XufdIit6Vu2sj2StAGIYz1mPEIH9l/KWfjNkjL/p4Z4WJYCYfwYbC
	 nU+GPctyJioq9FhHDlcfAsEXQV88rC9D9a1Wm1Gj4cBx+4F1tm8xIgprF54gIToVqkq11
	 07M7IGOn1dFz2NVR7aAKUegbmRe9XPFkGiA9pvB8JDcOIoaLgVl/7fZMsiUlH45ayV85O
	 UpqMX+2Tfa/mZ4HEpsJnM511pdJRqny9zlFQPpXI049Wtd6lNr7JjnxYFJlYCWDyLZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795070446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
	b=ZjVUYdAjoS3lDzzzbkNxQEk8sPa9aYpwvAjlN/cAQxjSa0loDK9zYCm7LP29VEUrFdUY
	 xcbHwv1H1OLI1riBLCsyacXd1cAjl5Pw2I8cIENhccGEESRLULqxGKlR4Dv/TAiFTe+vK
	 O0ejx9nFVVQ97omAe1isZ09m57MHwQiLkcRBKGFPRd6eSDqMozPOSduzNPRtDEKLRivld
	 AmJAYpnpMcWF4qPfjIHEGM42OVrJzhm/F0WvCgKeebDHWEytHZULzKcTWPCdyLFeiksTP
	 DjHc6aoTUUSJM9VI1e3+dMHi6Rs9Jp+Hj5+wf0BGGgw3PeB2El1rnksPa0yuiWhVwJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CmIOPDaN;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E064C606A334
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 06:40:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E064C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CmIOPDaN
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb609d9bf4so2961015e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Nov 2026 22:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795070444; x=1795675244; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
        b=CmIOPDaNJGr5S+0aSryvbfvhDBZ1wIohO03Ok8GNJ25TBjYQiPq/81Yt7KPJMMd7b5
         c/JFfVuFZ09olZpSmN8tmmo8cPb93oBwe6Wz5ACqLfIZeRSfewfEbNHmb1rn5oZPEkDA
         dNYNXnfLcq/bkNHpn+z1MMriiDPMS7lr0fnRYdpQ4+BeNIiEiYqfNvCdSeArQvbeLf/v
         a0ejnIcuNj5VqsJvjAqJBfQuh8EqikJmRNRRXCr8UFeCha54O4PBnOh9EoDoPdXTqBK2
         EggMBuYE0ZQpZZ+KweOOCxnOVXiPjg6WUUfwXy0ukshutbtuiEGazm7Q5q8CXyLprT8k
         5p3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795070444; x=1795675244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
        b=dDVmG1ZypWn+CqKdhfn2rBDSQHhxBQjM55+BU/9nCOLCeAZN2wsTOTd6QrwjWN6wNq
         vo26T5tDub3X4C7JHoUJXLe6eg/ycSOZkHGKJtvTcId+zT/upNAURqQB0hXAwu6zqvBk
         mXIByWzL9IhvSUOOydu94oN7s4FzZyn8YsXwhNHAhYJOAJGG/yj6X3hKnAW59VSC37IO
         YSDQgaaH9amNgHCtGzUtQuaeVnfpL93po086NOF5hCk2UVDGVw1kLsyqzjtAi8cwA46t
         BcKl1qnMMiL2Zpi2qCQCR+o1a44hv0sAgUkf7++7gpqGn/MF0VKmgowmI1U9iqvGVz89
         l51w==
X-Forwarded-Encrypted: i=1; AL+hErHRT9DBDcQAtUZneM3QleV+cyBIU301HcrPLPKY7GzDyA2HtOL0qcXb78qOtTMeGnHFJdBLQdze1ugj0Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z/1LsOtIgcY6bctGZZRShKSLrmHfmOa8/BrxH9IlA/a0ryXFLgz
	AakDd/TO+E1fGVaNK+U6oN1qtSCFl0UQI+xi/FjTlApoiAreN0Qcnq/gOwdRUZZYa34=
X-Gm-Gg: AYBFou2m8HhaN5B1pKrxsL4J0p2rc2ImQvJyhOL9NY9gHjqWWn4xfmJA6tnJq9qTPrE
	4n6nbjKjjpVf6qIRIcTRh0UQTJNwjjrIyOhNfyowQTuIpsIUHN5OQZ13MKI5+6mJQP1ZhliTHxa
	TbA6uqUT2pr7UmboBvPbKZRJVeTV0DGq2RtrJ9eIvQcYpQFxbzn4pRm9lHOmKvCO4aA/0kyZ0ZR
	ce3IYkt8+F1Ylm5rBfeT5I/TBYPVJ3NqUZh1XKF7i8AyF232+DOioOhWExsvP5KMcUtnGPhH27f
	yKJ8GVVdRhVi9MfEO7Njl8VKroLsWFJJfr4HrfEYmnO5ZrlkQldy1kpRbzbi1QAucdKpRntI29b
	rlp16ETDKGvU9TxRx60tyS5/sZ7c4S30MQXJWIza3fiYVMIapehlNFi2K+v42RBZ/ptVzrTT5q4
	hvjdfecnz/cvnVK0TEOFAR+mepI4t0ENFSh4Lp+upuSaCAfgHp0Ww8r3DgMmqgfQTo+Sd/SNPJV
	ORd5TbAUw1K3x9/yZtg1DSqVkBz36fYhQbHGgYruW4Tg0xBWP9hmuYb0gXZy6oyxoHMEfJM5EX4
	rzkTMTj1ytHjolBE+isuok8cxt1osUYy0kNk2hTVAkapQNWw0TpN5gADUsgel2Ji
X-Received: by 2002:a05:600c:8012:b0:4ad:5ec2:d3b3 with SMTP id 5b1f17b1804b1-4bb7d7167d1mr84936215e9.1.1795070444271;
        Wed, 18 Nov 2026 22:40:44 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5ca7aa769sm2286469b3a.18.2026.11.18.22.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 22:40:43 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v8 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Thu, 19 Nov 2026 14:40:25 +0800
Message-ID: <20261119064029.11910-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119064029.11910-1-heming.zhao@suse.com>
References: <20261119064029.11910-1-heming.zhao@suse.com>
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

