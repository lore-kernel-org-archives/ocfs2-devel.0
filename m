Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863186;
	b=kITemHk9PmbFdnIoaLvoqEyU2Q3ah4yt1BCVrz0P3gsqVTAXUBsd6wsNe6dSMR8TQrku
	 fOJX0+yPDMyhmXDW/yPdfLHhsCU0Z7rWu6aVLpJAOzBGjO0SDoAhUrEQWhaGGScQJHxcW
	 YW5fiAjRbLzcQAcRNenEvcIvkEoESPyCYnwN2ApPtzt/aSb9EEe3pQUmEE1Z+NvhYBxfI
	 z5uiUVJX2uIBZAscEu+K9YCUP1qpFMDPCUriHlGIgAxqWEDdhZn4tCOshOddx0Cd2rxH2
	 N7Pph+Z9YPWpSmYanhld+KSDAowUobDTyQmQ0vsD00shDTAlv4BkOcD+mp8BC/vjsFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TYRXvMF603odb8S2MAHHkubTkD5yjsXtdo4fKKhyzs=;
	b=3HaIJOFknz/dRjqdqorFhAteTZU6OCIr9tvU+UsVNiv5lB6EYgaHdGncxuiiVATZf0k4
	 VwM9CcLW4CO5bpC178rvitDKCmRIidHkbL1EISjt8coYJfTlG5A1fxk791SxIrXkfb2zF
	 UUgksypK3guuPyMXVh9VJX549OzWdpnTqTClpsu9ZC0PjCLVacmwjSlZJpqh1THAsfp9E
	 e5dcWMqSkt1tSddZiEz7qvd6qZ2SBFq+qLCOAgF1iCrVX3T1OGwI9FEcC/ZBV54ZmX/MD
	 i5KN/SiKJHttvtR8j9q1UTHVY0g2y7GMnp7lC7X/jQJvGk3+/rkhCiv7EYiJewc8zlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AqWNWjSf;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F45606A329
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 07:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45F45606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AqWNWjSf
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a610c7e61cso1443235e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Nov 2026 23:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793863185; x=1794467985; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TYRXvMF603odb8S2MAHHkubTkD5yjsXtdo4fKKhyzs=;
        b=AqWNWjSfF4ydH60EWeGptdHttM1ByWVJpoN6PRXriITfsK0HdD3liJOT68Htpbfwey
         LSWDQAKHEhwyuwQCKhc2pQrqViggY9wrTJGVSka0gcnV8RoraikIHxKh5n/jgPAD/vyM
         43OoD2KW3VHm4LHGBZKEmibrZL1P6Oa5V9GHc5L1tUlU8CS0OjDtcH2oSaXCZtykkdhZ
         wEH2cZo+dJlYPpGgpsdDhDFkHUni+sRrDWjjROtjulhZqRw6as/9l7s24QBR6G1zpNyX
         zZnhcBaMb1bY40dqPaZIMkz2MDLxWHZKsBw8LvIvpzdAXYHR1/NjtOp6JGUbNEG+0DA3
         4Qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793863185; x=1794467985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TYRXvMF603odb8S2MAHHkubTkD5yjsXtdo4fKKhyzs=;
        b=jDz8YNSRbHsm/YdsNL20RkarTFkCnURsCK/Odv+w2dtVOCfPpmW8LQOcLFqmeglhzb
         l7Kob0n1jf0GwUx9Z6/wFJY3aEFHbXTVU5stjKHgrX/Kvm4784EadnUqJytarXf2EsVd
         +7g9EeK2Mctm62qkmERQ+MExpKkpF3PlqslNf5Uw/5w9jxG+2S7QgXtUcbItOV66QK5q
         A+IaBEKydIS68WUCw4qIW8XS05rXokSvDfLVOrgnSZVsCAGCedsKyp7Zgm2Xq1eatcdx
         RC39+YYostHen7DK6h44J40xkQ1grpwg3t1q92pMXfQuDkGLAltjn3Fwpy43TwiwUomf
         yw2A==
X-Forwarded-Encrypted: i=1; AKwUvBy4u6vRvh1gvh1BTDRHg+9DuqBhYTwAr9zSulJ1O9utJisUOsvcthj7zgPdUFlO/8OG/yKTcxe+9Zzj7A==@lists.linux.dev
X-Gm-Message-State: APuU4Z/4OOI/+FXqwiJtq0zhoglcC1+wDxYEktt5YxdFlDjhm6tAbjNp
	RlYuHR0KbJEMsm1Cdoi9hf4104BKOtn/fOnJwePMpsRumvrhHtUMLZGKGQRIbIYjavc=
X-Gm-Gg: AYBFou2NDVD0leRvjxrWCIOFfqG7C7Hzo1nZEQrxnsidM3jR3iZTl0szWEaIdmOK8+t
	AuT1InvLM19pGg3+pHJDHm13DwrJzrAis/7KExhcD68BescKjxljkP2SIVoDQ+eTTngybdUDLQp
	GHQDOeKgcsphgBscMlFLS7or179kSFIwHL4ipJExXlIM3+jzmBU5Cbysqkt3AwL4j+8p1K8I+rE
	bjBm4/60aYWWCQBeAammTUfVmeh0OQAoKf87W0f5xRlAl4C4CekaPbPH5tTyfANpD7lvYrjUQJ8
	mIOwM4FTzuIUTs4Er+iisaXs2vWsXHFH5LyLvj50AvniHvY7HIc4WanRZS+Kfv8FTgya9/Cg9T6
	s67rAjOlC3uOvVL0GAd9uavekLbzknOuwvLXSxwvamOY1Y7oL1k+RTYa/2VoZy3tjnnGyOWh+u1
	Fl2/OwoRyYs/fQTop1/xsxEwg+8/rVwmYmkHstCf4zVV0yQjeNwSQDXHDj7wOal0hcmHLHCTsSB
	wQ9znHHWsMeNHA7tVQIBdhNxCwPE5JOUQQf5E4hJlXJeVVa6EoZsC8TvN9J5iArUXQ8aGv5JH4R
	ewBfbIUEOl+OuWMah8TUtqH1zlLVYWZddFOztQrzPKPHbHtWSNrVUMHkra0S4XC6
X-Received: by 2002:a05:600c:3146:b0:4b6:2242:d0d5 with SMTP id 5b1f17b1804b1-4b62242d351mr3802415e9.0.1793863184646;
        Wed, 04 Nov 2026 23:19:44 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b86fbesm14687084c88.1.2026.11.04.23.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 23:19:43 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v5 1/4] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Thu,  5 Nov 2026 15:19:25 +0800
Message-ID: <20261105071930.16399-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261105071930.16399-1-heming.zhao@suse.com>
References: <20261105071930.16399-1-heming.zhao@suse.com>
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
index 4acdbb70882c..0f7502de9b8d 100644
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
+	if (p_blkno) {
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
+			map->flags |= OCFS2_MAP_UNWRITTEN;
+		} else {
+			/* Treat the unwritten extent as a hole for zeroing purposes. */
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

