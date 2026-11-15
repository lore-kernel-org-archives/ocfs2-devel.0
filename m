Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794757226;
	b=qrlQvvq+ryus6a+GoV6C4YPN/K196jnmNKcoiMzeD1JrZ0o3ilqjs0w9VPtSb9/nGur0
	 Rnc4xeIyaFTkNpBsiGt6VwJYRWLwzrEP7F4l3cE8ZbP6FLfzQOUTHHFwLGuA46BslBiIx
	 mkGhZSlEKTAAUdVtYFHoOYu3Ll4JFuLAgFPQkw2RN8HC2NH8bVOnUvI2aMsn2GiAnVaPX
	 BgpIDyqUTf2XFVW48r8+3mXWdvBi0J2O7jDi1mEpP34Hji5k9k0G41EjNu5rfLk5A0EMC
	 WYKKNwYNVktu4PY/zM68HRFvfP0p5APuxcxAt90Mv5V9HBxINKFKJCLEW9iSfnfZlbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iMcQeXCC5dK/90RDGmPK+cz1RN8S/CIlOueNakUR0SQ=;
	b=YIEarXKvzSKkdjW6aZ0OtZCvt5Luuw4l84KQ3emtWYyFQ+X4QMG2iy9tPPwAlqULBGEg
	 KFiSRWL8jthJp9tuZeVb8oaOQtBDWYVcEse/+6P0tjFROtA40JEd1MHUhdz9WFdqf5wrQ
	 pQMpeaZvQKMGMD2b563JZYArSxHeNuTarHfgqJRHjWbyycqdkrQWFEWklqucWFrY1R391
	 eERPgYlPXBqXNSJ1r3BaEh00gGF1P4peUQhgbhT1LIp3AjWSLkzTd54rjTMsi+Vb1OL/Y
	 vDr0kUtpFLJenHRx4P6gqB2KyFVcvmWg5vepHcCIoQX7WsCWY9P3mdmp8oLJ5+7Bufg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Vr+KUzAE;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C38C606A327
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 15:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C38C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Vr+KUzAE
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-49a3521d4d0so124587f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 07:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794757224; x=1795362024; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iMcQeXCC5dK/90RDGmPK+cz1RN8S/CIlOueNakUR0SQ=;
        b=Vr+KUzAEgs3QxYjPymy6IXAjKNgwmCmBNcCS1vk7iKkAPF8Qjb+614S/LfpMRb02aj
         sp1qZ8JwmwfzlLBCxWu1NAzp33zFYmzeAuFR7KDIU+23ZQFhNmhL/MtgyFyES08sAFln
         +HrfFcyXt6EhF6G7hRZL8dS/eGRX3gEs2Pak6Wri782pPpFtStSI9Z6ZGMCVU8a8Bb8N
         bkUNd65HPE/VlovHnQCgv7PLmIh113+ng+aEnHuHzcZDLuaePJ/0PdLgP/UpH50tiXHx
         PDMipj4X0NRVpE5p0Rz97dXF95/iV6PVh2Wcgo6U/YT9NIX9LykzjhOZ0oVVrkDoAYaE
         6tyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794757224; x=1795362024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iMcQeXCC5dK/90RDGmPK+cz1RN8S/CIlOueNakUR0SQ=;
        b=f8cXv6Fr3qR97zpnHWNF0FQAJfPACa56guz/jtpE6NvSohkxzlG1VXPJYYhqUN5nHy
         lBoT/5cmhcMYmQi00Qo3JRLn6utEooDqCQ2WaIVaffwlK22N1UjbwdwV0VW0J8o8my7Q
         zFg8+gHTQUiihLzLlFOngoceTcA0NAqpK0yfs1rdU8N3BodqhP6XZoi8nJmmn2MchNW5
         e8JUNhma1KdRDD8/RigXGTLJVKMvMtjJyvMrrIz03a6Dcy5A1JMWY3Qe2RpcjLPFieTr
         DFwMZnSpvBr2SRwM7QbkkHIvAxo426XjQsqVYUr3PfJw9LfW5d4/XviZoDAIwktdQ0l0
         s0rg==
X-Forwarded-Encrypted: i=1; AL+hErH4myOohIEM/erIhmuTgoS5kK7xnVWqWYfABdxi6aFKP9m1MwietjEmx9XmjKjG4jjkrrm3CmplBe49nA==@lists.linux.dev
X-Gm-Message-State: APuU4Z8AYLa+mXsatxFZyOLsUeZiAXPQjX4SjgGCL8kPMMvqw2PoJvGc
	hctxMztdka5HFczRlRD5lTQGbacKS8KFHE1gHg6m7r0pXnaiHfvJHKg6KcRG4RoOVhQ=
X-Gm-Gg: AYBFou0Nq7Cfx6ApvLEkiLpLIiYkWXwqcDnRABuxDdP9NpPx8IUXIP93cDWSBtWWl2F
	3dvZRfux8OAcTcKwOtGKwAYm7V8mSX65lPLepvQbhuT4hRJEkK2R2PUVauvrqKdkDuHIDqt+QeI
	Z1s/hndbKouhT1g937Q5ygsW8+QVD82teVjTP0kUxFJ/w/lPJhptpBV1bbketnp6XzkkXPA+oQI
	yoj2hHfiXETsX9ypZQpfm0/wjJR6JunmCQYp5W52c8J3TGf1f9T+jZdAVAHCMQyUKjYvM26Qbcv
	Ro9Miu2R2Y8tfOms4E9r38mXK2tTQeMMh5h+mZ6jfn/Xmb9VmfXyIAiNNiLhzWv3pyouKQ8hJn3
	AYpOlHdo1/UylqOWp+Tm7zhiVl2jEk+lL0YCEJ6DWEZMOsDA2IMOZC7ezK/WVCmKZnCemOacU89
	T/VOMoDqBWDJ0b3QR5Em2h6YlIi/vRaiqPsQe3PNU3HOt2KKV/M0zUWSvKVKKfc6gNKeVCTs7yL
	v14cODHaMyYZCJZb+c9b4jMvZNEJXny3MDx16qJ5E9MpiPCEXymkeMTtJjamvK4cZ0tAshDoky9
	OHbupsFNv6aVSo3TqGtT0J17uLG6S0kzzHnGrk+AsAg=
X-Received: by 2002:a05:600d:6409:20b0:4bb:6fb4:586d with SMTP id 5b1f17b1804b1-4bb6fb45a20mr16864805e9.0.1794757224374;
        Sun, 15 Nov 2026 07:40:24 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm25648733eec.12.2026.11.15.07.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:40:23 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v6 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Sun, 15 Nov 2026 23:40:09 +0800
Message-ID: <20261115154013.9379-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261115154013.9379-1-heming.zhao@suse.com>
References: <20261115154013.9379-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/aops.h  |  2 ++
 fs/ocfs2/ocfs2.h | 25 ++++++++++++++++-
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4acdbb70882c..28a13246e9fa 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -126,6 +126,78 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
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
+	/* Treat the unwritten extent as a hole for zeroing purposes. */
+	if (p_blkno) {
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
+			map->flags |= OCFS2_MAP_UNWRITTEN;
+		} else {
+			map->flags |= OCFS2_MAP_MAPPED;
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

