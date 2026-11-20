Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795154433;
	b=brWVjxeZyYLtZVpQc5fW7yp+/2/3v9xiYIfsb3slEPKDcqGZ9nmlyS1jAxiTcvXHQsX3
	 y6+gS8Dtc+ZryvKK2Ubd5OipcLj2VwekALyAUoe2ZcFClDDm8vYHqegyZLy2igGuof6iZ
	 FinRdn1mRmSKLG9YZ36IP0OicrKHKE8Fyvlrw3WcMCNFunqxI+kA+oqzggfM/mov0e1y9
	 9ASgfjG+HlOX8pjGoy7SNbtdN+dh4s2Wj1T4j3fXNFrsCVM/oAzryw5XmVnatqqOe2+ZI
	 gzU0iMShtczWJxgDr/KCdkqFXnrAaUr6f8ZeojZZRXSavb5D6vIgC8FFJT4zlIm6Qxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
	b=WH7En19KiZOM6XWqhfCUUPcCOKppzTKRig+zupTqFKJJOfJDtb4eXuk/Afwd++7dftOE
	 8HjljCMfdITir1oV3qd8j5KQqvTLrAzNm0MrTlXWHj58dJjkZwxryqaNlPhEFn32G0EFZ
	 MLDmXWy/bSpjgcrsdMo7rrIUVhPqQRlxwYv6MMmME+e26CkrVb7x5zj/jPFsSnfpj/ZPz
	 aRYeM9v/tPRRVEwS3vP/TYqN+g37KyNTZFrHf8JXED+t/agHOIRomenCTKgzIrIEaHjOr
	 MTAbXwks6hQXEfaYJ+ml8iSDs2sy/rmglv1BgnPTHMhs+9WtKbMttVAXrfeu6+Jp0IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Fb6gzgiR;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770E9606A33B
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 06:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 770E9606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Fb6gzgiR
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c50c2be615dso1851666b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 22:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795154431; x=1795759231; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
        b=Fb6gzgiRMH6xFYGH8DSvPC6hVsETKjKs+PES37Lu+RhjahhJxIgAXZjBDmFSXgksyk
         gjDqo+31VYke5rWnZcMXt9GouhtDRvXd0NR7wlsE047IKDxCL4xl8bCj17ZchEZNGIpu
         A1LVfsyNfAgcAydfTgCggTY2lRznjGLZoKHO8qxZ0TkytbuAiZQqL86qXtph8mfoldV7
         M3qgJ4t7Qeuv9P0U30DdM+5Dw0lRyyV4JgyurdQ1UY3mVMhdUkDQSpsuVDRaPI3igO35
         tD7DG6NNzcw4rQ8GlO+MsRqzVtmkaBtbuIK2OS+O6TJIQaWCdigSc3mJnZ4nS+QOeEd2
         s+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795154431; x=1795759231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HslZ026Sqb2wA5Yz5eYmxBepFwcsw9Bo6wmDwgf0aso=;
        b=fLxVQxs+eH7ITIjSO9nqIH0oVfZ6BHFskVHLsqPoJkO4HINm2SMdgz8rx3f1ljs9s3
         7ki21idBByB1VDU/taIPhKY9cgfTnxYm4tefIigSuhdTo+HiHHjzFDd+1ztS8JXl1Jq5
         xExK61MnqESTrtkhvdgL+uFIyZthtOlPv2l9wQpcCi7829pkd0DPnadrxpSXQtP+ck4X
         cavTnhXD69Cu25AaGhleqlgydLQx71t3OeszEWqgKg6Ia71bDbcsbkmeJYKU3jyzZHJz
         ie3jMv4u8vAiacuB65sHvXpapXBgp1cUaQmWT2Ly8EcHw0KmqbXtmT0wvox/nXjyv9od
         JrYA==
X-Forwarded-Encrypted: i=1; AL+hErG76sgRxfWIoHLJomvrX7NjOg/0XdhKnrLrzkx+it6orbeBFEqcgz7vs1Ikc8ajatTtQ68/I7BQPAOmrg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/GUwVgBI/OMRAKgEpmN3W8lwOACD1uk9372owejo1f90JCLI44
	nJGtBkKci/14dZ3av6wCGxl7ABp1FMTeEKvx0yJfFiBtV75qgYF1q+Ljh+4d8QHL3jQ=
X-Gm-Gg: AZFdTZf2QaV/8EkUkVbImkww1fBxZALQH5isQs8mfuflAasEOQGV5mU/4+YN2w9Tlc+
	8xy/8UqhgubfuFGOvLPLWXZVc9bwuVvfmYA5jeaAmhHIF1/RMLW0ufvkqB0b3CK89t4BJsREvCG
	hOFi0VOOMxbVj/TrDUWssLPx4fSoyMY5S3vapYF/N5JKcde3uNJCOF6Mv4LKv/2HU6L4PnNRVYn
	Oy95/Md5pLXgaDJZy/b7UCzkRZg4N34ChNHk50m3YG9w78gBG8dupNNk4K854z6PxrfLSkA4h3x
	Ljnalz+AXKT7KiTyxNkItuTwWoWUnerI/RDKCS5iZmjQH4TAGwLOfWOTabSKAOd3UbARifkhKbP
	nXVLml3GfeFmMSzh83NOxJIjixhg3hBt6hceuiz9VkYMKSmUaw87BOSr+SJbRg3/lDABg6wf9Dp
	q5Q5eCYcQuK8qcvbpxCmTllaRC1MCFqHg4OJYKmdkD7beCvwOmaX0lOkESuuw4W29BWH/0IcwOx
	s064Pvc+gPqTfVHdw9NwlXsdixviwOquZHj3Z8sk1nqEypJv6rvtXkDMa4OcBa2dIptFQXIUywQ
	q6E7fCr21Dn0H3E8KhYpsVlmU5CLTp4sT8e920ughfc=
X-Received: by 2002:a17:906:3e41:b0:c46:ae89:cd3c with SMTP id a640c23a62f3a-c513a3971a7mr168113466b.1.1795154430829;
        Thu, 19 Nov 2026 22:00:30 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f571sm918597b3a.34.2026.11.19.22.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 22:00:29 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v9 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Fri, 20 Nov 2026 14:00:11 +0800
Message-ID: <20261120060014.12087-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261120060014.12087-1-heming.zhao@suse.com>
References: <20261120060014.12087-1-heming.zhao@suse.com>
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

