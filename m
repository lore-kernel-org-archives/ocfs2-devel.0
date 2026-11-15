Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794757236;
	b=z79HT6u5mwqCTZPnUwKQQDi3JE1/VgD2yfyXeV/sadc2K7qFQ6NnQWwF5Lmck26OCM/R
	 Y2oU/ZId81+UWt2ql0sbRJc4llAXIQseUyxLHvvZG57Y5QHrEoCeYiwew9vFfkZ1fFxh7
	 QuFf4H0VdzSCbhBxTpLf4ahwMSetmk7W/muN9ceVJnjX7g5cKVk7oAe+OlXf2qMb5zTUd
	 ShWgdJ7R7iDx5vq+uIvw/hnkaHLNpVNwq1WuvBGDVzfq5+vSoj9HktdVW1Q5nlYXim+qh
	 ocnYzMN+ed2PhsUmecUKyGVdFjRrqd3acMz2DATePlbw3b1vEuuS7jHNcoId5YroNdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WIDQ9tRFdHhqjxum2A1cBTwDH3zwkoLcGLu1y0FCWL8=;
	b=y6DKW59UVgspFjVgL2escw5Gmq1PmAH+X/PUj26hBgrOVs/3pIU4eZXzFT6uUcVz8YfL
	 v4/IMwye43bwwVmQGWJG0WHvz9dBCB96l4itsiCZPbvcgsty+D60Cxsj3ZoJNRDjn+XiU
	 nyrEB7Ou4nXOAUulWTM13OrXxrsdJVLqZJ0yV1HStycWnvZO4/0c9RWTYRUhs5Mn4FUyo
	 xL7dKDqSfr459qovMrH5eIPy7MNjLql5f85BI4LrcODwejvKYZdlwHf/zmuPPBWc+nysK
	 SOYa7uSnheJuvLncjwOixKPb2JdMD/Rs6z0kFvsZDq3doeJ1Mq6boKZxtrsLeXky9QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UEGj1TXZ;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376B606A323
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 15:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8376B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UEGj1TXZ
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4913db60638so198489f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 07:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794757233; x=1795362033; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WIDQ9tRFdHhqjxum2A1cBTwDH3zwkoLcGLu1y0FCWL8=;
        b=UEGj1TXZ0p+reZSJGJeC479MEIEPbgfkcawvsRS5w0HGAF5/MxAKlRzDxjublivhfG
         sDIOeNNFJPbwguVoD0wXPoq1jEnHRDSw9exl4exZFbO2H1DVwRbQAhMdmS3J3rmEtwzx
         uprW5u12WjuzAsz2TNUsKqPTmX27JbKQnNAoNU6825ztKkH78sJUTi2SkEzhUTX9ru3A
         eEyaPVpgqULoJJAPOFhsKcsO48zmPOXerPSq3cXm7ppixHR9NhpnagypMA/PGPg2OUgZ
         Vsjp4zUaOApaX2d+7QabqMqKFLO4eeywqg4yrQ5Wie7JKnhRq+/uZ/TW7M/0u1qTiw/Q
         pOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794757233; x=1795362033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WIDQ9tRFdHhqjxum2A1cBTwDH3zwkoLcGLu1y0FCWL8=;
        b=qIvePgYq9zyZ6k1qN4rXcO7bumWihUsUBstQAXhX5nN/wVFAvGiDE1c1CpijfRooKv
         nOqONW/X4vWGqGcnKsZqhjdSyT1q/yBsJ3xLwdiA7mgZQX2MbyfyIRzkCxdsM9ZyL2aj
         p/viKblpLW7vXzb/INS6xaj2nvTOwxwH6kR/PU/ax/A1O9U/lK/MR5vyejwqHQrVTZ2L
         YSKlwfG2js92OffiT6pDDfiKzpa5uGHCxp0P3OCbHsU9iFa4apxYBN52hvPkhRvSngDP
         f/g+GmYWTd/394BuSwmDTQ3+9pst6N+PTioDeWTqoxCwYr+8ULIQPGReWlFFsH1zva/o
         qrRA==
X-Forwarded-Encrypted: i=1; AL+hErH5sSbNs19iU8zIazQAU3UgyS/qqb8kAms+kKXQOZaFM2bBF1/vcoylHvstQcrR7oZ0qwp0Wh9h7vd4Zw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/5DMrKFdtiUkhFRO4rcYkGaQ33tm8tnPFl5Lu46MKCpOaMw4NK
	Q+JRgNw+8/NKn48bE4WDktax2wnRtkV5WCtyZLEB3TxbHSngc4QLrVFKLF2UdB7y0jwztEkjvFY
	IVkRegWc=
X-Gm-Gg: AYBFou1UEJS/5f0VHu3BiTtkMn4IeNItew0tveaQQykEa9drRbyUlce9PV4ZznmPxwo
	85pfeDwQE99vgdZEt8U7qG9lzqNRwfyL5dY668iwrojr7PduBYqR3jA7cJoLfkWy4qN+J2MVdX4
	fgTGAM62WsEZITnXZpCSDVuxQsDlwufSvX48tao1MdusK2cQLUODSMtu0AWYtVGoQhNwZmp10FW
	m02jOt9O66KEihHtd3yy9IaOaO8fhusDAVAyJxnmd7Cv3lX6adrwu1TrUUuPWBqHTFLxWbW/92Q
	eMoSAeN3JdEIZv7lRZ6GDyoS6Uwe5ZIshGDzTPs5kV3AL0923KZffdnDRoZIYVuig1QspOGWKn6
	y20gSunsZLvX0ablSxrwwknb+T01VzNntVjcAPITVFdVEnus2WL3fuzNFQdRi5aGQYcHgMA3a8u
	kLJQXLRYfJhjSL+RZREC3sYGFnViwfV/dyGhaFsUbEHCTyaM9ic65g4MMj/TG66esK8HT9ZeZKg
	vhUxptYhltyJK8hbTw5h9dAFOR6vpeF/robKuPqI4bL7nXZq3y4vzG7l4B/8hpfpdoLYiNxRRr7
	ZeYzSBTIgzkFa7YWs1HuYx+dOVNo8EVanFvnnF0O5spGb6fZULNwOFRFCwiaOHA/
X-Received: by 2002:a05:600c:224b:b0:4bb:5ad9:50dc with SMTP id 5b1f17b1804b1-4bb5ad95277mr117929285e9.0.1794757232067;
        Sun, 15 Nov 2026 07:40:32 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm25648733eec.12.2026.11.15.07.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:40:31 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v6 3/3] ocfs2: switch dio write path from buffer_head to iomap
Date: Sun, 15 Nov 2026 23:40:11 +0800
Message-ID: <20261115154013.9379-4-heming.zhao@suse.com>
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

Converts OCFS2's DIO write path from the legacy buffer_head
infrastructure to the modern iomap framework.

The buffer_head based ocfs2_dio_wr_get_block() is replaced by
ocfs2_dio_wr_map_blocks(). Instead of one cluster per call, it now
hands iomap a mapping of as many clusters as can be described by a
single struct iomap: up to 16MB, stopped at the first cluster that is
not of the same kind as the first one (hole, unwritten, written).

Implement ocfs2_dio_write_end_io() and ocfs2_iomap_dio_end_io_write()
to handle IO completion. They convert UNWRITTEN extents, updates inode
size (EOF).

In the buffer_head path, ocfs2_dio_wr_get_block() stores dwc in
bh->b_private, enabling it to detect the first call for an IO chunk and
invoke ocfs2_add_inode_to_orphan() to protect the extent allocation.
However, iomap doesn't provide a similar private field. Therefore, moves
ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks(the buffer_head
counterpart to ocfs2_dio_wr_get_block()) to ocfs2_file_write_iter().

It is also impossible t pass The dwc to iomap_dio_ops.end_io, the iomap
->end_io callback cannot effectively distinguish between I/Os initiated
by different threads concurrently. For example, when multiple DIO write
threads operate on the same inode concurrently, the end_io callback
without the dwc context may incorrectly delete an orphan inode created
by another thread, leading to a crash. The fix is to move the orphan
inode deletion from end_io into ocfs2_file_write_iter(). In
ocfs2_file_write_iter(), inode_lock() serializes the write threads,
and IOMAP_DIO_FORCE_WAIT ensures that the function only returns after
the bio completes. This guarantees that i_size has already been
updated when ocfs2_dio_del_orphan() is called.

iomap calls ->iomap_begin() once per mapping but ->end_io() once per io,
and the latter only gets the kiocb, so the kiocb is used as the identity
of the io: ocfs2_file_write_iter() passes it in iomap_iter.private,
ocfs2_iomap_next() forwards it to ocfs2_dio_wr_map_blocks(), and each
unwritten record stores it in ue_owner with the cluster range it covers.

Doesn't like ocfs2_dio_wr_get_block(), move the zero operations from
ocfs2_dio_wr_map_blocks() to ocfs2_file_write_iter(). If do the zeroing
in ocfs2_dio_wr_map_blocks() would zero blocks that earlier mappings of
this same dio have already written, as i_size is only updated at dio
completion. this will makes xfstests generic/538 failure.

Assisted-by: LLM
Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/Kconfig |    1 -
 fs/ocfs2/aops.c  | 1445 +++++++++++++++++++++++++++++++++-------------
 fs/ocfs2/aops.h  |   35 +-
 fs/ocfs2/file.c  |  160 ++++-
 fs/ocfs2/mmap.c  |    2 +-
 5 files changed, 1197 insertions(+), 446 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index bf1678a5eb01..74bc2008ef0b 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -9,7 +9,6 @@ config OCFS2_FS
 	select QUOTA_TREE
 	select FS_IOMAP
 	select FS_POSIX_ACL
-	select LEGACY_DIRECT_IO
 	help
 	  OCFS2 is a general purpose extent based shared disk cluster file
 	  system with many similarities to ext3. It supports 64 bit inode
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6158ab6515ad..164850931217 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -117,19 +117,6 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 	return err;
 }
 
-static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
-		    struct buffer_head *bh_result, int create)
-{
-	int ret = 0;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-
-	down_read(&oi->ip_alloc_sem);
-	ret = ocfs2_get_block(inode, iblock, bh_result, create);
-	up_read(&oi->ip_alloc_sem);
-
-	return ret;
-}
-
 static int ocfs2_lock_map_blocks(struct inode *inode,
 				 struct ocfs2_map_block *map, int flags)
 {
@@ -761,11 +748,26 @@ int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 
 #define OCFS2_MAX_CLUSTERS_PER_PAGE	(PAGE_SIZE / OCFS2_MIN_CLUSTERSIZE)
 
+/*
+ * Describe a range of clusters whose extents are (or were just allocated as)
+ * unwritten, and which a direct write is going to convert once its io has
+ * finished (see ocfs2_dio_end_io_write()).
+ *
+ * The entry is linked on oi->ip_unwritten_list for as long as the dio is in
+ * flight, so that buffered writers see the clusters are already taken care of
+ * and do not zero them under the dio.  iomap gives ->end_io() nothing but the
+ * kiocb, so ue_owner is how the entries created by ->iomap_begin() are found
+ * again at end_io time: it is the kiocb which __iomap_dio_rw() was called with.
+ *
+ * ue_node is used to chain the entries on a private list: the wc during
+ * write_begin, a local list in end_io.
+ */
 struct ocfs2_unwritten_extent {
 	struct list_head	ue_node;
 	struct list_head	ue_ip_node;
 	u32			ue_cpos;
-	u32			ue_phys;
+	u32			ue_clusters;
+	void			*ue_owner;
 };
 
 /*
@@ -781,6 +783,13 @@ struct ocfs2_write_cluster_desc {
 	unsigned	c_new;
 	unsigned	c_clear_unwritten;
 	unsigned	c_needs_zero;
+	/*
+	 * Direct write only: this cluster is unwritten and this very dio
+	 * (ue_owner) is going to convert it, either because it zeroed it in
+	 * this write_begin or because an earlier ->iomap_begin() of the same
+	 * dio did.  The mapping has to be reported as unwritten.
+	 */
+	unsigned	c_dio_unwritten;
 };
 
 struct ocfs2_write_ctxt {
@@ -794,7 +803,13 @@ struct ocfs2_write_ctxt {
 	/* Type of caller. Must be one of buffer, mmap, direct.  */
 	ocfs2_write_type_t		w_type;
 
-	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
+	/*
+	 * One descriptor per cluster of the write.  Buffered and mmap writes
+	 * never span more than a page, so the inline array is enough for them.
+	 * A direct write may span many clusters, w_desc is then allocated.
+	 */
+	struct ocfs2_write_cluster_desc	*w_desc;
+	struct ocfs2_write_cluster_desc	w_desc_inline[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
 	 * This is true if page_size > cluster_size.
@@ -817,7 +832,8 @@ struct ocfs2_write_ctxt {
 	 * zero's.
 	 */
 	unsigned int			w_num_folios;
-	struct folio			*w_folios[OCFS2_MAX_CTXT_PAGES];
+	struct folio			**w_folios;
+	struct folio			*w_folios_inline[OCFS2_MAX_CTXT_PAGES];
 	struct folio			*w_target_folio;
 
 	/*
@@ -845,6 +861,17 @@ struct ocfs2_write_ctxt {
 
 	struct list_head		w_unwritten_list;
 	unsigned int			w_unwritten_count;
+
+	/* Direct write only: the dio which owns the unwritten entries. */
+	void				*w_owner;
+
+	/*
+	 * Direct write only: clusters we reserved quota and allocator bits
+	 * for, but which could not be allocated in one go (the allocator
+	 * returned a shorter contiguous chunk).  The write was shortened, the
+	 * caller maps the remainder with its next ->iomap_begin().
+	 */
+	unsigned int			w_clusters_unused;
 };
 
 void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
@@ -898,19 +925,34 @@ static void ocfs2_free_unwritten_list(struct inode *inode,
 	}
 }
 
+static void ocfs2_release_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+	if (wc->w_desc != wc->w_desc_inline)
+		kvfree(wc->w_desc);
+
+	/*
+	 * The folios in w_folios array already unlocked and
+	 * put by ocfs2_unlock_folios()
+	 */
+	if (wc->w_folios != wc->w_folios_inline)
+		kfree(wc->w_folios);
+
+	kfree(wc);
+}
+
 static void ocfs2_free_write_ctxt(struct inode *inode,
 				  struct ocfs2_write_ctxt *wc)
 {
 	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
 	ocfs2_unlock_folios(wc);
 	brelse(wc->w_di_bh);
-	kfree(wc);
+	ocfs2_release_write_ctxt(wc);
 }
 
 static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 				  struct ocfs2_super *osb, loff_t pos,
 				  unsigned len, ocfs2_write_type_t type,
-				  struct buffer_head *di_bh)
+				  struct buffer_head *di_bh, void *owner)
 {
 	u32 cend;
 	struct ocfs2_write_ctxt *wc;
@@ -919,10 +961,46 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 	if (!wc)
 		return -ENOMEM;
 
+	wc->w_desc = wc->w_desc_inline;
+	wc->w_folios = wc->w_folios_inline;
+	wc->w_owner = owner;
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
 	wc->w_first_new_cpos = UINT_MAX;
 	cend = (pos + len - 1) >> osb->s_clustersize_bits;
 	wc->w_clen = cend - wc->w_cpos + 1;
+
+	/*
+	 * Only a direct write can span more clusters than fit in a page.
+	 * It needs the folios of the first and of the last cluster at most,
+	 * see ocfs2_grab_folios_for_write().
+	 */
+	if (wc->w_clen > ARRAY_SIZE(wc->w_desc_inline)) {
+		if (WARN_ON_ONCE(type != OCFS2_WRITE_DIRECT)) {
+			ocfs2_release_write_ctxt(wc);
+			return -EINVAL;
+		}
+		wc->w_desc = kvcalloc(wc->w_clen, sizeof(*wc->w_desc),
+				      GFP_NOFS);
+		if (!wc->w_desc) {
+			wc->w_desc = wc->w_desc_inline;
+			ocfs2_release_write_ctxt(wc);
+			return -ENOMEM;
+		}
+	}
+
+	/* ref ocfs2_grab_folios_direct() comments for the logic "2 *" */
+	if (type == OCFS2_WRITE_DIRECT &&
+	    2 * ocfs2_pages_per_cluster(osb->sb) >
+			ARRAY_SIZE(wc->w_folios_inline)) {
+		wc->w_folios = kcalloc(2 * ocfs2_pages_per_cluster(osb->sb),
+				       sizeof(*wc->w_folios), GFP_NOFS);
+		if (!wc->w_folios) {
+			wc->w_folios = wc->w_folios_inline;
+			ocfs2_release_write_ctxt(wc);
+			return -ENOMEM;
+		}
+	}
+
 	get_bh(di_bh);
 	wc->w_di_bh = di_bh;
 	wc->w_type = type;
@@ -1089,7 +1167,85 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 }
 
 /*
- * This function will only grab one clusters worth of pages.
+ * Grab the folios a direct write has to take care of, w_folios is laid out as
+ * two windows of one cluster's worth of pages each:
+ *
+ *   [0, ppc)    the pages of the first cluster of the write
+ *   [ppc, 2ppc) the pages of the last cluster of the write
+ *
+ * A direct write goes to the disk directly, so the pages inside of the user
+ * range are not touched and stay NULL.  The clusters in the middle of the
+ * write are covered by the user range entirely and need nothing at all.  Only
+ * the head cluster before the user range and the tail cluster after it can have
+ * pages which are not going to be overwritten, those must be zeroed through the
+ * page cache if the cluster is new or unwritten (c_needs_zero).
+ *
+ * If the write is made of just one cluster, there is only the first window.
+ *
+ * Like for the buffered write, nothing past the end of the file is needed, the
+ * tail is then cut at max(user range end, i_size).
+ */
+static int ocfs2_grab_folios_direct(struct address_space *mapping,
+		struct ocfs2_write_ctxt *wc, loff_t user_pos, unsigned user_len)
+{
+	struct inode *inode = mapping->host;
+	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
+	unsigned long target_index = user_pos >> PAGE_SHIFT;
+	unsigned long end_index = (user_pos + user_len - 1) >> PAGE_SHIFT;
+	loff_t last_byte = max_t(loff_t, user_pos + user_len,
+				 i_size_read(inode));
+	unsigned long last_index = ((last_byte - 1) >> PAGE_SHIFT) + 1;
+	unsigned int nr_win = wc->w_clen > 1 ? 2 : 1;
+	int ret = 0, win, i;
+
+	wc->w_num_folios = 0;
+
+	for (win = 0; win < nr_win; win++) {
+		struct ocfs2_write_cluster_desc *desc =
+			win ? &wc->w_desc[wc->w_clen - 1] : &wc->w_desc[0];
+		unsigned long start;
+
+		if (!desc->c_needs_zero)
+			continue;
+
+		start = ocfs2_align_clusters_to_page_index(inode->i_sb,
+							    desc->c_cpos);
+
+		for (i = 0; i < ppc; i++) {
+			unsigned long index = start + i;
+			struct folio *folio;
+
+			if (index >= last_index)
+				break;
+
+			/* Track the slots in use, for the unlock/commit loops. */
+			wc->w_num_folios = max_t(unsigned int, wc->w_num_folios,
+						 win * ppc + i + 1);
+
+			/* The direct io target has no page cache page here. */
+			if (index >= target_index && index <= end_index)
+				continue;
+
+			folio = __filemap_get_folio(mapping, index,
+					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					GFP_NOFS);
+			if (IS_ERR(folio)) {
+				ret = PTR_ERR(folio);
+				mlog_errno(ret);
+				goto out;
+			}
+			wc->w_folios[win * ppc + i] = folio;
+			folio_wait_stable(folio);
+		}
+	}
+out:
+	return ret;
+}
+
+/*
+ * This function will only grab one clusters worth of pages, except for a
+ * direct write which gets the pages around the user range of up to two
+ * clusters, see ocfs2_grab_folios_direct().
  */
 static int ocfs2_grab_folios_for_write(struct address_space *mapping,
 		struct ocfs2_write_ctxt *wc, u32 cpos, loff_t user_pos,
@@ -1100,6 +1256,10 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	loff_t last_byte;
 
+	if (wc->w_type == OCFS2_WRITE_DIRECT)
+		return ocfs2_grab_folios_direct(mapping, wc, user_pos,
+						user_len);
+
 	target_index = user_pos >> PAGE_SHIFT;
 
 	/*
@@ -1151,11 +1311,6 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
 			folio_get(mmap_folio);
 			wc->w_folios[i] = mmap_folio;
 			wc->w_target_locked = true;
-		} else if (index >= target_index && index <= end_index &&
-			   wc->w_type == OCFS2_WRITE_DIRECT) {
-			/* Direct write has no mapping page. */
-			wc->w_folios[i] = NULL;
-			continue;
 		} else {
 			wc->w_folios[i] = __filemap_get_folio(mapping, index,
 					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
@@ -1178,6 +1333,61 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
 	return ret;
 }
 
+/*
+ * Get the physical location of a cluster and prepare the folios [fstart, fend)
+ * of w_folios, which belong to it, for the write.
+ */
+static int ocfs2_prepare_cluster_folios(struct address_space *mapping,
+					u32 *phys, unsigned int should_zero,
+					struct ocfs2_write_ctxt *wc, u32 cpos,
+					loff_t user_pos, unsigned user_len,
+					unsigned int fstart, unsigned int fend)
+{
+	int ret, i;
+	u64 p_blkno;
+	struct inode *inode = mapping->host;
+	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+
+	/*
+	 * The only reason this should fail is due to an inability to
+	 * find the extent added.
+	 */
+	ret = ocfs2_get_clusters(inode, cpos, phys, NULL, NULL);
+	if (ret < 0) {
+		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
+			    "at logical cluster %u",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
+		return ret;
+	}
+
+	BUG_ON(*phys == 0);
+
+	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *phys);
+	if (!should_zero)
+		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
+
+	for (i = fstart; i < fend; i++) {
+		int tmpret;
+
+		/* This is the direct io target page. */
+		if (wc->w_folios[i] == NULL) {
+			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
+			continue;
+		}
+
+		tmpret = ocfs2_prepare_folio_for_write(inode, &p_blkno, wc,
+				wc->w_folios[i], cpos, user_pos, user_len,
+				should_zero);
+		if (tmpret) {
+			mlog_errno(tmpret);
+			if (ret == 0)
+				ret = tmpret;
+		}
+	}
+
+	return ret;
+}
+
 /*
  * Prepare a single cluster for write one cluster into the file.
  */
@@ -1190,11 +1400,9 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
 			       loff_t user_pos, unsigned user_len)
 {
-	int ret, i;
-	u64 p_blkno;
+	int ret;
 	struct inode *inode = mapping->host;
 	struct ocfs2_extent_tree et;
-	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 
 	if (new) {
 		u32 tmp_pos;
@@ -1236,52 +1444,176 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 		}
 	}
 
+	ret = ocfs2_prepare_cluster_folios(mapping, phys, should_zero, wc, cpos,
+					   user_pos, user_len, 0,
+					   wc->w_num_folios);
+
 	/*
-	 * The only reason this should fail is due to an inability to
-	 * find the extent added.
+	 * We only have cleanup to do in case of allocating write.
 	 */
-	ret = ocfs2_get_clusters(inode, cpos, phys, NULL, NULL);
+	if (ret && new)
+		ocfs2_write_failure(inode, wc, user_pos, user_len);
+
+out:
+
+	return ret;
+}
+
+/*
+ * A direct write allocates all the clusters it needs in one go, the same way
+ * ocfs2_extend_allocation() does.  The new extent is unwritten, it is converted
+ * when the io is done, see ocfs2_dio_end_io_write().
+ *
+ * Only one call is made, which means one chunk of contiguous clusters.  The
+ * allocator may return less than we asked for.  We don't try again, that would
+ * need more credits and the chunks would not be contiguous on the disk, which
+ * the caller needs as it hands out a single mapping.  The write is just made
+ * shorter, the caller maps the rest with its next ->iomap_begin().
+ */
+static int ocfs2_dio_alloc_clusters(struct inode *inode,
+				    struct ocfs2_write_ctxt *wc,
+				    struct ocfs2_alloc_context *data_ac,
+				    struct ocfs2_alloc_context *meta_ac)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
+	enum ocfs2_alloc_restarted why = RESTART_NONE;
+	u32 cpos = wc->w_cpos, got;
+	int ret, i;
+
+	ret = ocfs2_add_inode_data(osb, inode, &cpos, wc->w_clen, 1,
+				   wc->w_di_bh, wc->w_handle, data_ac, meta_ac,
+				   &why);
+	got = cpos - wc->w_cpos;
+	if (ret == -EAGAIN && why == RESTART_TRANS && got)
+		ret = 0;
+	if (ret == -EAGAIN) {
+		/*
+		 * We reserved the metadata for it up front, we do not
+		 * expect to be here.
+		 */
+		mlog(ML_ERROR, "Inode %llu: EAGAIN (%d) during dio allocation\n",
+		     (unsigned long long)OCFS2_I(inode)->ip_blkno, why);
+		ret = -ENOSPC;
+	}
 	if (ret < 0) {
-		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
-			    "at logical cluster %u",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
-		goto out;
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		return ret;
 	}
 
-	BUG_ON(*phys == 0);
-
-	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *phys);
-	if (!should_zero)
-		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
+	if (got < wc->w_clen) {
+		/*
+		 * Cut the write short.  What is left of it is not for us to
+		 * zero anymore, the last cluster we have now is covered by the
+		 * user range entirely.  Drop the folios of the old last
+		 * cluster.
+		 */
+		wc->w_clusters_unused = wc->w_clen - got;
+		wc->w_clen = got;
 
-	for (i = 0; i < wc->w_num_folios; i++) {
-		int tmpret;
+		for (i = ppc; i < 2 * ppc; i++) {
+			struct folio *folio = wc->w_folios[i];
 
-		/* This is the direct io target page. */
-		if (wc->w_folios[i] == NULL) {
-			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
-			continue;
+			if (!folio)
+				continue;
+			folio_unlock(folio);
+			folio_mark_accessed(folio);
+			folio_put(folio);
+			wc->w_folios[i] = NULL;
 		}
+		if (wc->w_num_folios > ppc)
+			wc->w_num_folios = ppc;
+	}
 
-		tmpret = ocfs2_prepare_folio_for_write(inode, &p_blkno, wc,
-				wc->w_folios[i], cpos, user_pos, user_len,
-				should_zero);
-		if (tmpret) {
-			mlog_errno(tmpret);
-			if (ret == 0)
-				ret = tmpret;
+	return 0;
+}
+
+/*
+ * A direct write goes to the disk, it only needs the clusters allocated, the
+ * folios around the user range zeroed and the physical location of each
+ * cluster.  The latter is what the iomap mapping is made of.
+ */
+static int ocfs2_write_clusters_direct(struct address_space *mapping,
+				       struct ocfs2_alloc_context *data_ac,
+				       struct ocfs2_alloc_context *meta_ac,
+				       struct ocfs2_write_ctxt *wc,
+				       loff_t pos, unsigned len)
+{
+	struct inode *inode = mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
+	struct ocfs2_write_cluster_desc *desc;
+	loff_t end = pos + len;
+	int ret, i, win;
+	u32 phys, num;
+
+	if (wc->w_desc[0].c_new) {
+		ret = ocfs2_dio_alloc_clusters(inode, wc, data_ac, meta_ac);
+		if (ret)
+			return ret;
+		end = min_t(loff_t, end,
+			    ocfs2_clusters_to_bytes(inode->i_sb,
+						    wc->w_cpos + wc->w_clen));
+	}
+
+	/*
+	 * Fill in the physical location of the clusters, an extent covers as
+	 * many of them as it can.
+	 */
+	for (i = 0; i < wc->w_clen; ) {
+		desc = &wc->w_desc[i];
+
+		ret = ocfs2_get_clusters(inode, desc->c_cpos, &phys, &num,
+					 NULL);
+		if (ret) {
+			mlog_errno(ret);
+			return ret;
+		}
+		if (!phys) {
+			mlog(ML_ERROR, "Inode %llu: no cluster at %u after dio allocation\n",
+			     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			     desc->c_cpos);
+			return -EIO;
 		}
+		for (; num && i < wc->w_clen; i++, num--, phys++)
+			wc->w_desc[i].c_phys = phys;
 	}
 
 	/*
-	 * We only have cleanup to do in case of allocating write.
+	 * The folios are only there for the first and the last cluster,
+	 * the ones in the middle are written by the dio as a whole.
 	 */
-	if (ret && new)
-		ocfs2_write_failure(inode, wc, user_pos, user_len);
+	for (win = 0; win < (wc->w_clen > 1 ? 2 : 1); win++) {
+		unsigned int fstart = win * ppc;
+		unsigned int fend = min(wc->w_num_folios, fstart + ppc);
+		loff_t cpos_byte;
+		unsigned int local_len;
+		loff_t user_pos;
+
+		desc = win ? &wc->w_desc[wc->w_clen - 1] : &wc->w_desc[0];
+		if (!desc->c_needs_zero || fend <= fstart)
+			continue;
 
-out:
+		/* The part of the user range which is in this cluster. */
+		cpos_byte = ocfs2_clusters_to_bytes(inode->i_sb, desc->c_cpos);
+		user_pos = max_t(loff_t, pos, cpos_byte);
+		local_len = min_t(loff_t, end,
+				  cpos_byte + osb->s_clustersize) - user_pos;
 
-	return ret;
+		ret = ocfs2_prepare_cluster_folios(mapping, &desc->c_phys,
+						   desc->c_needs_zero, wc,
+						   desc->c_cpos, user_pos,
+						   local_len, fstart, fend);
+		if (ret) {
+			mlog_errno(ret);
+			if (desc->c_new)
+				ocfs2_write_failure(inode, wc, pos, len);
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
@@ -1296,6 +1628,10 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 	struct ocfs2_write_cluster_desc *desc;
 	struct ocfs2_super *osb = OCFS2_SB(mapping->host->i_sb);
 
+	if (wc->w_type == OCFS2_WRITE_DIRECT)
+		return ocfs2_write_clusters_direct(mapping, data_ac, meta_ac,
+						   wc, pos, len);
+
 	for (i = 0; i < wc->w_clen; i++) {
 		desc = &wc->w_desc[i];
 
@@ -1380,77 +1716,180 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
 	}
 }
 
+/*
+ * Find the entry which covers a cluster.  Must be called with ip_lock held.
+ */
+static struct ocfs2_unwritten_extent *
+ocfs2_find_unwritten(struct ocfs2_inode_info *oi, u32 cpos)
+{
+	struct ocfs2_unwritten_extent *ue;
+
+	list_for_each_entry(ue, &oi->ip_unwritten_list, ue_ip_node) {
+		if (cpos >= ue->ue_cpos && cpos - ue->ue_cpos < ue->ue_clusters)
+			return ue;
+	}
+	return NULL;
+}
+
 /*
  * Check if this extent is marked UNWRITTEN by direct io. If so, we need not to
  * do the zero work. And should not to clear UNWRITTEN since it will be cleared
  * by the direct io procedure.
- * If this is a new extent that allocated by direct io, we should mark it in
- * the ip_unwritten_list.
+ *
+ * A direct write never clears UNWRITTEN here, that is done when its io is
+ * finished. The clusters it is going to zero are not put to the
+ * ip_unwritten_list by this function, see ocfs2_dio_add_unwritten(), as the
+ * write might get shortened afterwards.
  */
-static int ocfs2_unwritten_check(struct inode *inode,
-				 struct ocfs2_write_ctxt *wc,
-				 struct ocfs2_write_cluster_desc *desc)
+static void ocfs2_unwritten_check(struct inode *inode,
+				  struct ocfs2_write_ctxt *wc,
+				  struct ocfs2_write_cluster_desc *desc)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_unwritten_extent *ue = NULL, *new = NULL;
-	int ret = 0;
+	struct ocfs2_unwritten_extent *ue;
 
 	if (!desc->c_needs_zero)
-		return 0;
+		return;
 
-retry:
 	spin_lock(&oi->ip_lock);
-	/* Needs not to zero no metter buffer or direct. The one who is zero
-	 * the cluster is doing zero. And he will clear unwritten after all
-	 * cluster io finished. */
-	list_for_each_entry(ue, &oi->ip_unwritten_list, ue_ip_node) {
-		if (desc->c_cpos == ue->ue_cpos) {
-			BUG_ON(desc->c_new);
-			desc->c_needs_zero = 0;
-			desc->c_clear_unwritten = 0;
-			goto unlock;
-		}
+	ue = ocfs2_find_unwritten(oi, desc->c_cpos);
+	/* A hole (c_new is 1) can not be on the list, don't trust it if it is. */
+	if (ue && !WARN_ON_ONCE(desc->c_new)) {
+		/*
+		 * Needs not to zero no matter buffer or direct. The one who is
+		 * zero the cluster is doing zero. And he will clear unwritten
+		 * after all cluster io finished.
+		 */
+		desc->c_needs_zero = 0;
+		desc->c_clear_unwritten = 0;
+		/* match its own entry */
+		if (wc->w_type == OCFS2_WRITE_DIRECT && wc->w_owner &&
+		    ue->ue_owner == wc->w_owner)
+			desc->c_dio_unwritten = 1;
+	} else if (wc->w_type == OCFS2_WRITE_DIRECT) {
+		/* This direct write will doing zero. */
+		desc->c_clear_unwritten = 0;
 	}
-
-	if (wc->w_type != OCFS2_WRITE_DIRECT)
-		goto unlock;
-
-	if (new == NULL) {
-		spin_unlock(&oi->ip_lock);
-		new = kmalloc_obj(struct ocfs2_unwritten_extent, GFP_NOFS);
-		if (new == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		goto retry;
-	}
-	/* This direct write will doing zero. */
-	new->ue_cpos = desc->c_cpos;
-	new->ue_phys = desc->c_phys;
-	desc->c_clear_unwritten = 0;
-	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
-	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
-	wc->w_unwritten_count++;
-	new = NULL;
-unlock:
 	spin_unlock(&oi->ip_lock);
-out:
-	kfree(new);
-	return ret;
 }
 
 /*
- * Populate each single-cluster write descriptor in the write context
- * with information about the i/o to be done.
+ * Is the cluster reported as unwritten to iomap?
+ * Returns true for unwritten, false for mapped.
+ */
+static inline bool ocfs2_desc_dio_unwritten(struct ocfs2_write_cluster_desc *d)
+{
+	/*
+	 * c_needs_zero: whether this mapping needs to be zeroed
+	 * c_dio_unwritten: whether the conversion is my job
+	 *
+	 * c_needs_zero | c_dio_unwritten | source place             | reports
+	 * ----------------------------------------------------------------
+	 *     0        |      0          | overwrite extent;        | MAPPED
+	 *              |                 | ocfs2_unwritten_check    |
+	 *              |                 | found others entry       |
+	 * ------------------------------------------------------------------
+	 *     1        |      0          | buffered/mmap write;     | UNWRITTEN
+	 *              |                 | transitional state before|
+	 *              |                 | ocfs2_dio_add_unwritten  |
+	 * ------------------------------------------------------------------
+	 *     0        |      1          | ocfs2_unwritten_check    | UNWRITTEN
+	 * ------------------------------------------------------------------
+	 *     1        |      1          | ocfs2_dio_add_unwritten  | UNWRITTEN
+	 */
+	return d->c_needs_zero || d->c_dio_unwritten;
+}
+
+/*
+ * iomap takes one mapping which is of one type and contiguous on the disk.
+ * Cut the clusters of a direct write at the first one which is not like the
+ * first, they are mapped by the next ->iomap_begin().  Also, the clusters to
+ * be allocated are all new or none of them is.
  *
- * Returns the number of clusters that will have to be allocated, as
- * well as a worst case estimate of the number of extent records that
- * would have to be created during a write to an unwritten region.
+ * Returns the number of clusters to be allocated.
  */
-static int ocfs2_populate_write_desc(struct inode *inode,
-				     struct ocfs2_write_ctxt *wc,
-				     unsigned int *clusters_to_alloc,
-				     unsigned int *extents_to_split)
+static unsigned int ocfs2_dio_trim_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+	struct ocfs2_write_cluster_desc *first = &wc->w_desc[0];
+	u32 i;
+
+	for (i = 1; i < wc->w_clen; i++) {
+		struct ocfs2_write_cluster_desc *d = &wc->w_desc[i];
+
+		if (d->c_new != first->c_new ||
+		    ocfs2_desc_dio_unwritten(d) !=
+				ocfs2_desc_dio_unwritten(first))
+			break;
+		/* mapped clusters */
+		if (!d->c_new && d->c_phys != d[-1].c_phys + 1)
+			break;
+	}
+	wc->w_clen = i;
+
+	/*
+	 * c_new is 0 for mapped clusters, which means they are not
+	 * allocated by this write.
+	 */
+	return first->c_new ? wc->w_clen : 0;
+}
+
+/*
+ * Record the clusters a direct write zeroed (or is going to convert) in
+ * ip_unwritten_list, until ocfs2_dio_end_io_write() converts them.  The
+ * entries are also on wc->w_unwritten_list, so that they are freed with the
+ * write context if the write fails. Once the write has succeeded, the caller
+ * detaches them from it, see ocfs2_dio_detach_unwritten().
+ */
+static int ocfs2_dio_add_unwritten(struct inode *inode,
+				   struct ocfs2_write_ctxt *wc)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_unwritten_extent *ue;
+	u32 i, j;
+
+	for (i = 0; i < wc->w_clen; i = j) {
+		j = i + 1;
+		if (!wc->w_desc[i].c_needs_zero)
+			continue;
+		while (j < wc->w_clen && wc->w_desc[j].c_needs_zero)
+			j++;
+
+		ue = kmalloc_obj(struct ocfs2_unwritten_extent, GFP_NOFS);
+		if (!ue)
+			return -ENOMEM;
+		ue->ue_cpos = wc->w_desc[i].c_cpos;
+		ue->ue_clusters = j - i;
+		ue->ue_owner = wc->w_owner;
+		INIT_LIST_HEAD(&ue->ue_ip_node);
+		list_add_tail(&ue->ue_node, &wc->w_unwritten_list);
+		wc->w_unwritten_count++;
+	}
+
+	spin_lock(&oi->ip_lock);
+	list_for_each_entry(ue, &wc->w_unwritten_list, ue_node)
+		list_add_tail(&ue->ue_ip_node, &oi->ip_unwritten_list);
+	spin_unlock(&oi->ip_lock);
+
+	for (i = 0; i < wc->w_clen; i++) {
+		if (wc->w_desc[i].c_needs_zero)
+			wc->w_desc[i].c_dio_unwritten = 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Populate each single-cluster write descriptor in the write context
+ * with information about the i/o to be done.
+ *
+ * Returns the number of clusters that will have to be allocated, as
+ * well as a worst case estimate of the number of extent records that
+ * would have to be created during a write to an unwritten region.
+ */
+static int ocfs2_populate_write_desc(struct inode *inode,
+				     struct ocfs2_write_ctxt *wc,
+				     unsigned int *clusters_to_alloc,
+				     unsigned int *extents_to_split)
 {
 	int ret;
 	struct ocfs2_write_cluster_desc *desc;
@@ -1523,11 +1962,7 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 			desc->c_needs_zero = 1;
 		}
 
-		ret = ocfs2_unwritten_check(inode, wc, desc);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+		ocfs2_unwritten_check(inode, wc, desc);
 
 		num_clusters--;
 	}
@@ -1712,10 +2147,57 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
 	return ret;
 }
 
+/*
+ * Does a direct write have folios to zero around its user range?
+ * See ocfs2_grab_folios_direct(), this has to agree with it.
+ */
+static bool ocfs2_dio_need_zero_folios(struct inode *inode,
+				       struct ocfs2_write_ctxt *wc,
+				       loff_t pos, unsigned len)
+{
+	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
+	unsigned long target_index = pos >> PAGE_SHIFT;
+	unsigned long end_index = (pos + len - 1) >> PAGE_SHIFT;
+	loff_t last_byte = max_t(loff_t, pos + len, i_size_read(inode));
+	unsigned long last_index = ((last_byte - 1) >> PAGE_SHIFT) + 1;
+	unsigned int nr_win = wc->w_clen > 1 ? 2 : 1;
+	int win, i;
+
+	for (win = 0; win < nr_win; win++) {
+		struct ocfs2_write_cluster_desc *desc =
+			win ? &wc->w_desc[wc->w_clen - 1] : &wc->w_desc[0];
+		unsigned long start;
+
+		if (!desc->c_needs_zero)
+			continue;
+
+		start = ocfs2_align_clusters_to_page_index(inode->i_sb,
+							    desc->c_cpos);
+		for (i = 0; i < ppc && start + i < last_index; i++) {
+			if (start + i < target_index || start + i > end_index)
+				return true;
+		}
+	}
+	return false;
+}
+
+/*
+ * A buffered write is cut by the caller into pieces of up to a page, and the
+ * clusters it touches have to fit in a page.
+ *
+ * A direct write is not, it may span many clusters, which are all of the same
+ * kind: all of them are to be allocated or none is, and either all of them are
+ * unwritten or none is.  How many of the clusters asked for are used is up to
+ * this function, see w_clen of the returned context.
+ *
+ * @owner is only used by a direct write, it is what ocfs2_dio_end_io_write()
+ * finds the unwritten clusters recorded for this write by.
+ */
 int ocfs2_write_begin_nolock(struct address_space *mapping,
 		loff_t pos, unsigned len, ocfs2_write_type_t type,
 		struct folio **foliop, void **fsdata,
-		struct buffer_head *di_bh, struct folio *mmap_folio)
+		struct buffer_head *di_bh, struct folio *mmap_folio,
+		void *owner)
 {
 	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
 	unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
@@ -1730,13 +2212,14 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	int try_free = 1, ret1;
 
 try_again:
-	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, type, di_bh);
+	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, type, di_bh, owner);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
 	}
 
-	if (ocfs2_supports_inline_data(osb)) {
+	/* A direct write is never inline, it is not even allowed to start. */
+	if (type != OCFS2_WRITE_DIRECT && ocfs2_supports_inline_data(osb)) {
 		ret = ocfs2_try_to_write_inline_data(mapping, inode, pos, len,
 						     mmap_folio, wc);
 		if (ret == 1) {
@@ -1749,7 +2232,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		}
 	}
 
-	/* Direct io change i_size late, should not zero tail here. */
+	/* Direct io change i_size itself, should not zero tail here. */
 	if (type != OCFS2_WRITE_DIRECT) {
 		if (ocfs2_sparse_alloc(osb))
 			ret = ocfs2_zero_tail(inode, di_bh, pos);
@@ -1782,6 +2265,18 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		mlog_errno(ret);
 		goto out;
 	}
+
+	if (type == OCFS2_WRITE_DIRECT) {
+		/*
+		 * Direct write never splits an extent here, they are converted
+		 * when the io is done. What it can do is to allocate.
+		 */
+		extents_to_split = 0;
+		clusters_to_alloc = ocfs2_dio_trim_write_ctxt(wc);
+		len = min_t(loff_t, len,
+			    ocfs2_clusters_to_bytes(inode->i_sb,
+						    wc->w_cpos + wc->w_clen) - pos);
+	}
 	clusters_need += clusters_to_alloc;
 
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
@@ -1820,13 +2315,24 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 		credits = ocfs2_calc_extend_credits(inode->i_sb,
 						    &di->id2.i_list);
-	} else if (type == OCFS2_WRITE_DIRECT)
-		/* direct write needs not to start trans if no extents alloc. */
-		goto success;
+	} else if (type == OCFS2_WRITE_DIRECT) {
+		/*
+		 * Direct write needs not to start trans if no extents alloc,
+		 * unless there are folios to zero.
+		 */
+		if (!ocfs2_dio_need_zero_folios(inode, wc, pos, len)) {
+			ret = ocfs2_dio_add_unwritten(inode, wc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+			goto success;
+		}
+	}
 
 	/*
 	 * We have to zero sparse allocated clusters, unwritten extent clusters,
-	 * and non-sparse clusters we just extended.  For non-sparse writes,
+	 * and non-sparse clusters we just extended. For non-sparse writes,
 	 * we know zeros will only be needed in the first and/or last cluster.
 	 */
 	if (wc->w_clen && (wc->w_desc[0].c_needs_zero ||
@@ -1886,11 +2392,26 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
 					  len);
+	if (wc->w_clusters_unused) {
+		/* A direct write got a shorter chunk than reserved. */
+		dquot_free_space(inode,
+			ocfs2_clusters_to_bytes(osb->sb, wc->w_clusters_unused));
+		clusters_to_alloc -= wc->w_clusters_unused;
+		wc->w_clusters_unused = 0;
+	}
 	if (ret) {
 		mlog_errno(ret);
 		goto out_quota;
 	}
 
+	if (type == OCFS2_WRITE_DIRECT) {
+		ret = ocfs2_dio_add_unwritten(inode, wc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_quota;
+		}
+	}
+
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
@@ -1973,7 +2494,7 @@ static int ocfs2_write_begin(const struct kiocb *iocb,
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ret = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_BUFFER,
-				       foliop, fsdata, di_bh, NULL);
+				       foliop, fsdata, di_bh, NULL, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_fail;
@@ -2135,7 +2656,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping, loff_t pos,
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
 
 	brelse(wc->w_di_bh);
-	kfree(wc);
+	ocfs2_release_write_ctxt(wc);
 
 	return copied;
 }
@@ -2156,132 +2677,134 @@ static int ocfs2_write_end(const struct kiocb *iocb,
 	return ret;
 }
 
-struct ocfs2_dio_write_ctxt {
-	struct list_head	dw_zero_list;
-	unsigned		dw_zero_count;
-	int			dw_orphaned;
-	pid_t			dw_writer_pid;
-};
-
-static struct ocfs2_dio_write_ctxt *
-ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
+/*
+ * Prepare the area between i_size and a direct write that starts or ends
+ * beyond it.  Must be called once per dio, before any io is issued, with
+ * i_rwsem and the rw lock held.
+ */
+int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count)
 {
-	struct ocfs2_dio_write_ctxt *dwc = NULL;
-
-	if (bh->b_private)
-		return bh->b_private;
-
-	dwc = kmalloc_obj(struct ocfs2_dio_write_ctxt, GFP_NOFS);
-	if (dwc == NULL)
-		return NULL;
-	INIT_LIST_HEAD(&dwc->dw_zero_list);
-	dwc->dw_zero_count = 0;
-	dwc->dw_orphaned = 0;
-	dwc->dw_writer_pid = task_pid_nr(current);
-	bh->b_private = dwc;
-	*alloc = 1;
-
-	return dwc;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *di_bh = NULL;
+	int ret;
+
+	if (pos + count <= i_size_read(inode))
+		return 0;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		ret = ocfs2_zero_tail(inode, di_bh, pos);
+	else
+		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, count,
+						   NULL);
+	if (ret < 0)
+		mlog_errno(ret);
+	up_write(&oi->ip_alloc_sem);
+
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+	return ret;
 }
 
-static void ocfs2_dio_free_write_ctx(struct inode *inode,
-				     struct ocfs2_dio_write_ctxt *dwc)
+/*
+ * The most a single mapping handed out for a direct write spans.
+ * It bounds the memory of the write context, one descriptor per
+ * cluster.
+ */
+#define OCFS2_DIO_MAX_MAP_BYTES	(16U << 20)
+
+/*
+ * The entries of ip_unwritten_list which belong to a direct write
+ * have been created while the write context was alive, they have to
+ * survive it: they stay until ocfs2_dio_end_io() has converted the
+ * clusters. Take them off the write context, so that it can be
+ * released.
+ */
+static void ocfs2_dio_detach_unwritten(struct ocfs2_write_ctxt *wc)
 {
-	ocfs2_free_unwritten_list(inode, &dwc->dw_zero_list);
-	kfree(dwc);
+	struct ocfs2_unwritten_extent *ue, *tmp;
+
+	list_for_each_entry_safe(ue, tmp, &wc->w_unwritten_list, ue_node)
+		list_del_init(&ue->ue_node);
+	wc->w_unwritten_count = 0;
 }
 
 /*
- * TODO: Make this into a generic get_blocks function.
+ * Map a range of a direct write, allocate the clusters if needed.
+ *
+ * Contrary to the single cluster it was before, a mapping spans as many
+ * clusters as iomap asks for, up to the first thing that makes it unfit to
+ * be handed out as one: the kind of the extent (hole, unwritten, written),
+ * a discontiguous extent, or the end of the file. The latter is the one
+ * place where the mapping is split on purpose:
+ *
+ *		   eof_blk
+ * |--------|---------|---------|---------
+ * |<-in file range-->|<-past eof range-->
  *
- * From do_direct_io in direct-io.c:
- *  "So what we do is to permit the ->get_blocks function to populate
- *   bh.b_size with the size of IO which is permitted at this offset and
- *   this i_blkbits."
+ * the part which is in the file is not NEW, it may have data which must
+ * not be zeroed. The part which is beyond it is NEW. As the file size is
+ * only changed when the io is done, both are told apart here.
  *
- * This function is called directly from get_more_blocks in direct-io.c.
+ * Whatever is unwritten and zeroed here is recorded in ip_unwritten_list
+ * for ocfs2_dio_end_io() to convert, find them there by @owner.
  *
- * called like this: dio->get_blocks(dio->inode, fs_startblk,
- * 					fs_count, map_bh, dio->rw == WRITE);
+ * @map->lblk and @map->len go in, the mapping goes out.
  */
-static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
-			       struct buffer_head *bh_result, int create)
+static int ocfs2_dio_wr_map_blocks(struct inode *inode,
+				   struct ocfs2_map_block *map,
+				   unsigned int flags, void *owner)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_write_ctxt *wc;
-	struct ocfs2_write_cluster_desc *desc = NULL;
-	struct ocfs2_dio_write_ctxt *dwc = NULL;
+	struct ocfs2_write_cluster_desc *desc;
+	struct ocfs2_map_block probe;
 	struct buffer_head *di_bh = NULL;
-	u64 p_blkno;
-	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
-	loff_t pos = iblock << i_blkbits;
-	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
-	unsigned len, total_len = bh_result->b_size;
-	int ret = 0, first_get_block = 0;
-
-	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
-	len = min(total_len, len);
-
-	/*
-	 * bh_result->b_size is count in get_more_blocks according to write
-	 * "pos" and "end", we need map twice to return different buffer state:
-	 * 1. area in file size, not set NEW;
-	 * 2. area out file size, set  NEW.
-	 *
-	 *		   iblock    endblk
-	 * |--------|---------|---------|---------
-	 * |<-------area in file------->|
-	 */
+	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
+	u64 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	u64 lblk = map->lblk;
+	u64 eof_blk = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
+	loff_t pos = lblk << blkbits;
+	loff_t len, end;
+	int ret = 0, unwritten;
 
-	if ((iblock <= endblk) &&
-	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
-		len = (endblk - iblock + 1) << i_blkbits;
+	/* Do not hand out a mapping which is over the end of the file. */
+	if (lblk < eof_blk && lblk + map->len > eof_blk)
+		map->len = eof_blk - lblk;
 
-	mlog(0, "get block of %llu at %llu:%u req %u\n",
-			inode->i_ino, pos, len, total_len);
+	map->len = min_t(u64, map->len,
+			 max_t(u64, OCFS2_DIO_MAX_MAP_BYTES >> blkbits, bpc));
 
 	/*
-	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
-	 * we may need to add it to orphan dir. So can not fall to fast path
-	 * while file size will be changed.
+	 * This is the fast path for re-write.  The range which is in the file
+	 * has nothing to allocate nor to convert if it is mapped already. What
+	 * changes the file size is done at the end of io, no matter what the
+	 * mappings were.
 	 */
-	if (pos + total_len <= i_size_read(inode)) {
-
-		/* This is the fast path for re-write. */
-		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
-		if (buffer_mapped(bh_result) &&
-		    !buffer_new(bh_result) &&
-		    ret == 0)
-			goto out;
-
-		/* Clear state set by ocfs2_get_block. */
-		bh_result->b_state = 0;
-	}
-
-	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
-	if (unlikely(dwc == NULL)) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
-
-	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
-	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
-	    !dwc->dw_orphaned) {
-		/*
-		 * when we are going to alloc extents beyond file size, add the
-		 * inode to orphan dir, so we can recall those spaces when
-		 * system crashed during write.
-		 */
-		ret = ocfs2_add_inode_to_orphan(osb, inode);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
+	if (lblk < eof_blk) {
+		probe = *map;
+		probe.flags = 0;
+		ret = ocfs2_lock_map_blocks(inode, &probe,
+					    OCFS2_GET_BLOCKS_CREATE);
+		if (ret == 0 && (probe.flags & OCFS2_MAP_MAPPED) &&
+		    !(probe.flags & OCFS2_MAP_NEW)) {
+			*map = probe;
+			return 0;
 		}
-		dwc->dw_orphaned = 1;
+		ret = 0;
 	}
 
+	/* The allocation below sleeps on locks. */
+	if (flags & IOMAP_NOWAIT) //zhm: remove??
+		return -EAGAIN;
+
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -2290,95 +2813,149 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 
 	down_write(&oi->ip_alloc_sem);
 
-	if (first_get_block) {
-		if (ocfs2_sparse_alloc(osb))
-			ret = ocfs2_zero_tail(inode, di_bh, pos);
-		else
-			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
-							   total_len, NULL);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto unlock;
-		}
+	/*
+	 * Only take what is of the same kind as what is at the start:
+	 * all of it is a hole, or all of it is unwritten, or all of
+	 * it is written, in one extent.
+	 */
+	probe = *map;
+	probe.flags = 0;
+	ret = ocfs2_map_blocks(inode, &probe, 0);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
 	}
+	map->len = min_t(u64, map->len, probe.len);
+	len = map->len << blkbits;
 
+	/*
+	 * Note, Zeroing the gap between i_size and the write is done
+	 * once per dio by ocfs2_dio_zero_eof() before the io is issued.
+	 */
+again:
 	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
 				       OCFS2_WRITE_DIRECT, NULL,
-				       (void **)&wc, di_bh, NULL);
+				       (void **)&wc, di_bh, NULL, owner);
+	if (ret == -ENOSPC &&
+	    ocfs2_clusters_for_bytes(inode->i_sb, pos + len) >
+	    ocfs2_clusters_for_bytes(inode->i_sb, pos) + 1) {
+		/*
+		 * There is not room for all of it, but maybe there is for
+		 * some, take the first cluster.
+		 */
+		len = min_t(loff_t, len, osb->s_clustersize -
+				(pos & (osb->s_clustersize - 1)));
+		goto again;
+	}
 	if (ret) {
-		mlog_errno(ret);
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
 		goto unlock;
 	}
 
+	/*
+	 * The write context says how many of the clusters are really there.
+	 * It is within what we asked for, what is mapped is up to the end of
+	 * the last of them.
+	 */
 	desc = &wc->w_desc[0];
+	end = min_t(loff_t, pos + len,
+		    ocfs2_clusters_to_bytes(inode->i_sb,
+					    wc->w_cpos + wc->w_clen));
 
-	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
-	BUG_ON(p_blkno == 0);
-	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
-
-	map_bh(bh_result, inode->i_sb, p_blkno);
-	bh_result->b_size = len;
-	if (desc->c_needs_zero)
-		set_buffer_new(bh_result);
-
-	if (iblock > endblk)
-		set_buffer_new(bh_result);
-
-	/* May sleep in end_io. It should not happen in a irq context. So defer
-	 * it to dio work queue. */
-	set_buffer_defer_completion(bh_result);
+	if (desc->c_phys == 0) {
+		ret = -EIO;
+		mlog_errno(ret);
+		if (wc->w_handle)
+			ocfs2_commit_trans(osb, wc->w_handle);
+		ocfs2_free_write_ctxt(inode, wc);
+		goto unlock;
+	}
 
-	if (!list_empty(&wc->w_unwritten_list)) {
-		struct ocfs2_unwritten_extent *ue = NULL;
+	map->pblk = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys) +
+		    (lblk & (bpc - 1));
+	map->len = (end >> blkbits) - lblk;
 
-		ue = list_first_entry(&wc->w_unwritten_list,
-				      struct ocfs2_unwritten_extent,
-				      ue_node);
-		BUG_ON(ue->ue_cpos != desc->c_cpos);
-		/* The physical address may be 0, fill it. */
-		ue->ue_phys = desc->c_phys;
+	/*
+	 * Only report the mapping as UNWRITTEN when the cluster is newly
+	 * allocated or was already unwritten and this write is the one who
+	 * is going to convert it.
+	 */
+	unwritten = ocfs2_desc_dio_unwritten(desc);
+	map->flags = unwritten ? OCFS2_MAP_UNWRITTEN : OCFS2_MAP_MAPPED;
+	if (unwritten || lblk >= eof_blk)
+		map->flags |= OCFS2_MAP_NEW;
 
-		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
-		dwc->dw_zero_count += wc->w_unwritten_count;
+	ocfs2_dio_detach_unwritten(wc);
+	/* Here returns only two types: len (success), errno (failure). */
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, end - pos,
+				     end - pos, wc);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto unlock;
 	}
-
-	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
-	BUG_ON(ret != len);
+	WARN_ON_ONCE(ret != end - pos);
 	ret = 0;
+
 unlock:
 	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
+
 out:
 	return ret;
 }
 
+/*
+ * Take the unwritten clusters recorded by the direct write @owner, off
+ * the inode's list, to a private list. They stay on the inode's list.
+ */
+static void ocfs2_dio_collect_unwritten(struct inode *inode, void *owner,
+					struct list_head *head)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_unwritten_extent *ue;
+
+	spin_lock(&oi->ip_lock);
+	list_for_each_entry(ue, &oi->ip_unwritten_list, ue_ip_node) {
+		if (ue->ue_owner == owner)
+			list_add_tail(&ue->ue_node, head);
+	}
+	spin_unlock(&oi->ip_lock);
+}
+
+/*
+ * Convert the unwritten extents of a direct write, which is finished,
+ * and change the file size if it has been extended.
+ *
+ * @head are the clusters the write has zeroed or allocated, recorded by
+ * ocfs2_dio_wr_map_blocks(). Those which are not covered by the data
+ * written, [offset, offset + bytes), are left unwritten.
+ */
 static int ocfs2_dio_end_io_write(struct inode *inode,
-				  struct ocfs2_dio_write_ctxt *dwc,
 				  loff_t offset,
-				  ssize_t bytes)
+				  ssize_t bytes,
+				  struct list_head *head)
 {
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_extent_tree et;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_unwritten_extent *ue = NULL;
+	struct ocfs2_unwritten_extent *ue;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0, batch = 0;
+	int ret = 0, credits = 0, batch = 0, pass;
+	u32 first_cpos, last_cpos;
+	u32 extents_to_split = 0;
 
-	ocfs2_init_dealloc_ctxt(&dealloc);
+	first_cpos = offset >> osb->s_clustersize_bits;
+	last_cpos = ocfs2_clusters_for_bytes(inode->i_sb, end);
 
-	/* We do clear unwritten, delete orphan, change i_size here. If neither
-	 * of these happen, we can skip all this. */
-	if (list_empty(&dwc->dw_zero_list) &&
-	    end <= i_size_read(inode) &&
-	    !dwc->dw_orphaned)
-		goto out;
+	ocfs2_init_dealloc_ctxt(&dealloc);
 
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
@@ -2391,54 +2968,102 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 
-	/* Attach dealloc with extent tree in case that we may reuse extents
+	/*
+	 * Attach dealloc with extent tree in case that we may reuse extents
 	 * which are already unlinked from current extent tree due to extent
 	 * rotation and merging.
 	 */
 	et.et_dealloc = &dealloc;
 
-	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
-				    &data_ac, &meta_ac);
-	if (ret) {
-		mlog_errno(ret);
-		goto unlock;
-	}
+	/*
+	 * Two passes over the clusters which are recorded: the first one
+	 * counts the unwritten extents, the allocators we need depend on
+	 * it. The second one converts them.
+	 */
+	for (pass = 0; pass < 2; pass++) {
+		list_for_each_entry(ue, head, ue_node) {
+			u32 cpos = max(ue->ue_cpos, first_cpos);
+			u32 cend = min(ue->ue_cpos + ue->ue_clusters, last_cpos);
+
+			while (cpos < cend) {
+				unsigned int ext_flags;
+				u32 phys, num;
+
+				ret = ocfs2_get_clusters(inode, cpos, &phys,
+							 &num, &ext_flags);
+				if (ret < 0) {
+					mlog_errno(ret);
+					goto commit;
+				}
+				num = min(num, cend - cpos);
+				if (WARN_ON_ONCE(!num)) {
+					ret = -EIO;
+					goto commit;
+				}
 
-	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
+				if (!phys || !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
+					cpos += num;
+					continue;
+				}
 
-	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
-		if (!handle) {
-			handle = ocfs2_start_trans(osb, credits);
-			if (IS_ERR(handle)) {
-				ret = PTR_ERR(handle);
-				mlog_errno(ret);
-				goto unlock;
-			}
-			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-					OCFS2_JOURNAL_ACCESS_WRITE);
-			if (ret) {
-				mlog_errno(ret);
-				goto commit;
-			}
-		}
-		ret = ocfs2_assure_trans_credits(handle, credits);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto commit;
-		}
-		ret = ocfs2_mark_extent_written(inode, &et, handle,
-						ue->ue_cpos, 1,
-						ue->ue_phys,
+				if (pass == 0) {
+					extents_to_split++;
+					cpos += num;
+					continue;
+				}
+
+				/* pass == 1 */
+				if (!handle) {
+					handle = ocfs2_start_trans(osb, credits);
+					if (IS_ERR(handle)) {
+						ret = PTR_ERR(handle);
+						handle = NULL;
+						mlog_errno(ret);
+						goto unlock;
+					}
+					ret = ocfs2_journal_access_di(handle,
+						INODE_CACHE(inode), di_bh,
+						OCFS2_JOURNAL_ACCESS_WRITE);
+					if (ret) {
+						mlog_errno(ret);
+						goto commit;
+					}
+				}
+				ret = ocfs2_assure_trans_credits(handle, credits);
+				if (ret < 0) {
+					mlog_errno(ret);
+					goto commit;
+				}
+
+				ret = ocfs2_mark_extent_written(inode, &et,
+						handle, cpos, num, phys,
 						meta_ac, &dealloc);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto commit;
+				if (ret < 0) {
+					mlog_errno(ret);
+					goto commit;
+				}
+				cpos += num;
+
+				if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
+					ocfs2_commit_trans(osb, handle);
+					handle = NULL;
+					batch = 0;
+				}
+			}
 		}
 
-		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
-			ocfs2_commit_trans(osb, handle);
-			handle = NULL;
-			batch = 0;
+		if (pass == 0) {
+			if (extents_to_split) {
+				ret = ocfs2_lock_allocators(inode, &et, 0,
+						extents_to_split * 2,
+						&data_ac, &meta_ac);
+				if (ret) {
+					mlog_errno(ret);
+					goto unlock;
+				}
+			}
+			credits = ocfs2_calc_extend_credits(inode->i_sb,
+							    &di->id2.i_list);
 		}
 	}
 
@@ -2447,6 +3072,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			handle = ocfs2_start_trans(osb, credits);
 			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
+				handle = NULL;
 				mlog_errno(ret);
 				goto unlock;
 			}
@@ -2459,6 +3085,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 commit:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
+
 unlock:
 	up_write(&oi->ip_alloc_sem);
 
@@ -2471,89 +3098,27 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		meta_ac = NULL;
 	}
 
-	/* everything looks good, let's start the cleanup */
-	if (!ret && dwc->dw_orphaned) {
-		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
-
-		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
+	/*
+	 * The orphan entry is removed by ocfs2_file_write_iter(), by the writer
+	 * that added it. Other dios on this inode may complete here while it
+	 * is still in flight, so they must not touch it.
+	 */
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
+
 out:
 	ocfs2_run_deallocs(osb, &dealloc);
-	ocfs2_dio_free_write_ctx(inode, dwc);
-
 	return ret;
 }
 
 /*
- * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
- * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
- * to protect io on one node from truncation on another.
+ * The mapping for a direct write needs the owner, ocfs2_iomap_next() fetches
+ * it from iomap_iter.private, which is the kiocb ocfs2_file_write_iter() has
+ * called __iomap_dio_rw() with.  ocfs2_dio_end_io() gets the same kiocb.
  */
-static int ocfs2_dio_end_io(struct kiocb *iocb,
-			    loff_t offset,
-			    ssize_t bytes,
-			    void *private)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-	int level;
-	int ret = 0;
-
-	/* this io's submitter should not have unlocked this before we could */
-	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
-
-	if (bytes <= 0)
-		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
-				 (long long)bytes);
-	if (private) {
-		if (bytes > 0)
-			ret = ocfs2_dio_end_io_write(inode, private, offset,
-						     bytes);
-		else
-			ocfs2_dio_free_write_ctx(inode, private);
-	}
-
-	ocfs2_iocb_clear_rw_locked(iocb);
-
-	level = ocfs2_iocb_rw_locked_level(iocb);
-	ocfs2_rw_unlock(inode, level);
-	return ret;
-}
-
-static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	get_block_t *get_block;
-
-	/*
-	 * Fallback to buffered I/O if we see an inode without
-	 * extents.
-	 */
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return 0;
-
-	/* Fallback to buffered I/O if we do not support append dio. */
-	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
-	    !ocfs2_supports_append_dio(osb))
-		return 0;
-
-	if (iov_iter_rw(iter) == READ)
-		get_block = ocfs2_lock_get_block;
-	else
-		get_block = ocfs2_dio_wr_get_block;
-
-	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-				    iter, get_block,
-				    ocfs2_dio_end_io, 0);
-}
-
 static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+		unsigned int flags, struct iomap *iomap, struct iomap *srcmap,
+		void *owner)
 {
 	int ret;
 	struct ocfs2_map_block map;
@@ -2572,10 +3137,11 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	map.flags = 0;
 
 	if (flags & IOMAP_WRITE) {
-		return -EOPNOTSUPP;
+		ret = ocfs2_dio_wr_map_blocks(inode, &map, flags, owner);
+	} else {
+		ret = ocfs2_lock_map_blocks(inode, &map, 0);
 	}
 
-	ret = ocfs2_lock_map_blocks(inode, &map, 0);
 	if (ret < 0)
 		return ret;
 
@@ -2604,10 +3170,95 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int ocfs2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			    struct iomap *srcmap)
+{
+	int ret;
+
+	if (iomap->length) {
+		ret = iomap_iter_continue(iter, iomap, srcmap, 0);
+		if (ret <= 0)
+			return ret;
+	}
+
+	ret = ocfs2_iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
+				iomap, srcmap, iter->private);
+	return ret < 0 ? ret : 1;
+}
+
 const struct iomap_ops ocfs2_iomap_ops = {
-	.iomap_begin	= ocfs2_iomap_begin,
+	.iomap_next	= ocfs2_iomap_next,
 };
 
+/*
+ * Direct I/O completion. Like the old buffer_head path
+ * ocfs2_dio_end_io(), we use the rw_lock (DLM lock) to protect
+ * io on one node from truncation on another, and drop it here
+ * once the io has completed. iomap_dio_complete() always calls
+ * this, including on the buffered-fallback (-ENOTBLK) path,
+ * so the rw_lock taken in ocfs2_file_{read,write}_iter() is
+ * released exactly once.
+ *
+ * It also is where the unwritten clusters of the write are made
+ * written, the ones ocfs2_iomap_begin() has recorded for this kiocb.
+ * The records go whatever the outcome of the io is.
+ *
+ * Mind the context. A write which needs nothing here, a plain
+ * overwrite, is completed by iomap from the bio completion, that is
+ * in interrupt context. ip_lock, which protects ip_unwritten_list,
+ * is not safe to be taken from there. That is no problem, as there is
+ * nothing recorded for such a write, and iomap defers the completion
+ * to a process context, when there is: for the unwritten extents we
+ * have mapped (IOMAP_DIO_UNWRITTEN), or for any error.
+ */
+static int ocfs2_dio_end_io(struct kiocb *iocb, ssize_t size,
+			int error, unsigned int flags, int level)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t offset = iocb->ki_pos;
+	bool recorded = error || (flags & IOMAP_DIO_UNWRITTEN);
+	LIST_HEAD(unwritten);
+	int ret = 0;
+
+	if (recorded)
+		ocfs2_dio_collect_unwritten(inode, iocb, &unwritten);
+
+	if (error)
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+
+	/* bounced back to buffered I/O, leave the rw_lock held */
+	if (size == 0 && error == 0) {
+		ocfs2_free_unwritten_list(inode, &unwritten);
+		return 0;
+	}
+
+	if (size && error == 0 &&
+	    (!list_empty(&unwritten) ||
+	     (offset + size > i_size_read(inode)))) {
+		ret = ocfs2_dio_end_io_write(inode, offset, size, &unwritten);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	ocfs2_free_unwritten_list(inode, &unwritten);
+	ocfs2_rw_unlock(inode, level);
+
+	return ret ? ret : error;
+}
+
+static int ocfs2_dio_end_io_w_pr(struct kiocb *iocb, ssize_t size,
+				     int error, unsigned int flags)
+{
+	return ocfs2_dio_end_io(iocb, size, error, flags, 0);
+}
+
+static int ocfs2_dio_end_io_w_ex(struct kiocb *iocb, ssize_t size,
+				     int error, unsigned int flags)
+{
+	return ocfs2_dio_end_io(iocb, size, error, flags, 1);
+}
+
 static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
 				int error, unsigned int flags)
 {
@@ -2622,9 +3273,18 @@ static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
 	return error;
 }
 
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr = {
+	.end_io = ocfs2_dio_end_io_w_pr,
+};
+
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex = {
+	.end_io = ocfs2_dio_end_io_w_ex,
+};
+
 const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
 	.end_io = ocfs2_dio_end_io_r_pr,
 };
+
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
@@ -2633,7 +3293,6 @@ const struct address_space_operations ocfs2_aops = {
 	.write_begin		= ocfs2_write_begin,
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
-	.direct_IO		= ocfs2_direct_IO,
 	.invalidate_folio	= block_invalidate_folio,
 	.release_folio		= ocfs2_release_folio,
 	.migrate_folio		= buffer_migrate_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 2fe3b39e02f7..232e95bf16d8 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -11,6 +11,8 @@
 
 extern const struct iomap_ops ocfs2_iomap_ops;
 extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
 
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
@@ -38,7 +40,8 @@ typedef enum {
 int ocfs2_write_begin_nolock(struct address_space *mapping,
 		loff_t pos, unsigned len, ocfs2_write_type_t type,
 		struct folio **foliop, void **fsdata,
-		struct buffer_head *di_bh, struct folio *mmap_folio);
+		struct buffer_head *di_bh, struct folio *mmap_folio,
+		void *owner);
 
 int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
 			   struct buffer_head *di_bh);
@@ -46,36 +49,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create);
+int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count);
 int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		    int flags);
-/* all ocfs2_dio_end_io()'s fault */
-#define ocfs2_iocb_is_rw_locked(iocb) \
-	test_bit(0, (unsigned long *)&iocb->private)
-static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
-{
-	set_bit(0, (unsigned long *)&iocb->private);
-	if (level)
-		set_bit(1, (unsigned long *)&iocb->private);
-	else
-		clear_bit(1, (unsigned long *)&iocb->private);
-}
-
-/*
- * Using a named enum representing lock types in terms of #N bit stored in
- * iocb->private, which is going to be used for communication between
- * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
- */
-enum ocfs2_iocb_lock_bits {
-	OCFS2_IOCB_RW_LOCK = 0,
-	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_NUM_LOCKS
-};
-
-#define ocfs2_iocb_init_rw_locked(iocb) \
-	(iocb->private = NULL)
-#define ocfs2_iocb_clear_rw_locked(iocb) \
-	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_rw_locked_level(iocb) \
-	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
 
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 39f4fa924351..b9a7133205d3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -48,6 +48,7 @@
 #include "quota.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "namei.h"
 
 #include "buffer_head_io.h"
 
@@ -135,6 +136,14 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 
 	file->f_mode |= FMODE_NOWAIT;
 
+	/*
+	 * Direct I/O is served through iomap_dio_rw() from
+	 * ocfs2_file_{read,write}_iter() rather than an a_ops->direct_IO
+	 * method, so advertise O_DIRECT capability explicitly here.
+	 */
+	file->f_mode |= FMODE_CAN_ODIRECT;
+
+
 leave:
 	return status;
 }
@@ -1195,9 +1204,9 @@ int ocfs2_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	size_change = S_ISREG(inode->i_mode) && attr->ia_valid & ATTR_SIZE;
 	if (size_change) {
 		/*
-		 * Here we should wait dio to finish before inode lock
-		 * to avoid a deadlock between ocfs2_setattr() and
-		 * ocfs2_dio_end_io_write()
+		 * Here we should wait for in-flight direct I/O to finish
+		 * before taking the inode lock, to avoid a deadlock between
+		 * ocfs2_setattr() and direct I/O completion.
 		 */
 		inode_dio_wait(inode);
 
@@ -2404,6 +2413,11 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 				struct inode *inode)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	unsigned int dio_align = bdev_logical_block_size(inode->i_sb->s_bdev);
+
+	/* Fallback to buffered I/O if we do not alignment. */
+	if (!IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(iter), dio_align))
+		return false;
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -2420,6 +2434,35 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 	return true;
 }
 
+/*
+ * Remove the inode from the orphan dir after an appending direct write.
+ * Only the writer that added the inode (under i_rwsem) may remove it;
+ */
+static int ocfs2_dio_del_orphan(struct inode *inode)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	int ret;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	if (di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)) {
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+	return ret;
+}
+
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
@@ -2437,6 +2480,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 			i_size_read(inode) ? 1 : 0);
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
+	int dio_flags = 0;
+	int orphaned = 0;
 
 	if (trace_ocfs2_file_write_iter_enabled()) {
 		struct dentry *dentry = file->f_path.dentry;
@@ -2462,8 +2507,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
-	ocfs2_iocb_init_rw_locked(iocb);
-
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2519,6 +2562,10 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 		goto out;
 	}
 
+	ret = kiocb_modified(iocb);
+	if (ret < 0)
+		goto out;
+
 	if (direct_io && !is_sync_kiocb(iocb) &&
 	    ocfs2_is_io_unaligned(inode, count, iocb->ki_pos)) {
 		/*
@@ -2527,26 +2574,90 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 		saved_ki_complete = xchg(&iocb->ki_complete, NULL);
 	}
 
-	/* communicate with ocfs2_dio_end_io */
-	ocfs2_iocb_set_rw_locked(iocb, rw_level);
+	if (direct_io && ocfs2_should_use_dio(iocb, from, inode)) {
+		if (iocb->ki_pos > i_size_read(inode) &&
+		    fault_in_iov_iter_readable(from, count)) {
+			ret = -EFAULT;
+			goto out;
+		}
 
-	written = __generic_file_write_iter(iocb, from);
-	/* buffered aio wouldn't have proper lock coverage today */
-	BUG_ON(written == -EIOCBQUEUED && !direct_io);
+		if (ocfs2_clusters_for_bytes(inode->i_sb, iocb->ki_pos + count) >
+		    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode))) {
+			/*
+			 * when we are going to alloc extents beyond file size, add the
+			 * inode to orphan dir, so we can recall those spaces when
+			 * system crashed during write.
+			 */
+			ret = ocfs2_add_inode_to_orphan(osb, inode);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto out;
+			}
+			orphaned = 1;
+			dio_flags = IOMAP_DIO_FORCE_WAIT;
+		}
 
-	/*
-	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
-	 * function pointer which is called when o_direct io completes so that
-	 * it can unlock our rw lock.
-	 * Unfortunately there are error cases which call end_io and others
-	 * that don't.  so we don't have to unlock the rw_lock if either an
-	 * async dio is going to do it in the future or an end_io after an
-	 * error has already done it.
-	 */
-	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
-		rw_level = -1;
+		ret = ocfs2_dio_zero_eof(inode, iocb->ki_pos, count);
+		if (ret < 0)
+			goto out;
+
+		const struct iomap_dio_ops *dops = rw_level ?
+			&ocfs2_iomap_dio_ops_w_ex : &ocfs2_iomap_dio_ops_w_pr;
+		struct iomap_dio *dio;
+
+		/*
+		 * The kiocb is the owner of the unwritten clusters which
+		 * ->iomap_begin() records for ->end_io() to convert, see
+		 * ocfs2_iomap_next().
+		 */
+		dio = __iomap_dio_rw(iocb, from, &ocfs2_iomap_ops,
+				     dops, dio_flags, iocb, 0);
+		if (dio == NULL) {
+			/* No I/O issued; rw_lock still held. */
+			written = 0;
+		} else if (IS_ERR(dio)) {
+			written = PTR_ERR(dio);
+			/*
+			 * -EIOCBQUEUED: async I/O; end_io will drop the lock on
+			 * completion. Any other error means no I/O started and
+			 * end_io was not called, so the cleanup path below drops
+			 * the lock.
+			 */
+			if (written == -EIOCBQUEUED)
+				rw_level = -1;
+		} else {
+			/*
+			 * Synchronous completion. iomap_dio_complete() runs
+			 * end_io, which drops the lock unless the mapping
+			 * bounced us back to buffered I/O (returns 0, lock
+			 * retained).
+			 */
+			written = iomap_dio_complete(dio);
+			if (written != 0)
+				rw_level = -1;
+		}
+
+		/*
+		 * __iomap_dio_rw() returns -ENOTBLK when it could not invalidate
+		 * the page cache for the DIO range (e.g. racing buffered/mmap
+		 * I/O on the same file, as exercised by generic/095). Fall back
+		 * to a buffered write for the remaining data, the same way
+		 * ext4/xfs do, instead of leaking -ENOTBLK to userspace.
+		 */
+		if (written == -ENOTBLK)
+			written = 0;
+		if (written == 0 && iov_iter_count(from)) {
+			written = direct_write_fallback(iocb, from, ret,
+					generic_perform_write(iocb, from));
+		}
+	} else {
+		iocb->ki_flags &= ~IOCB_DIRECT;
+		written = __generic_file_write_iter(iocb, from);
 	}
 
+	/* buffered aio wouldn't have proper lock coverage today */
+	BUG_ON(written == -EIOCBQUEUED && !direct_io);
+
 	if (unlikely(written <= 0))
 		goto out;
 
@@ -2571,6 +2682,13 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	}
 
 out:
+	/*
+	 * IOMAP_DIO_FORCE_WAIT made the dio complete synchronously, so its
+	 * end_io has already updated i_size.
+	 */
+	if (orphaned)
+		ocfs2_dio_del_orphan(inode);
+
 	if (saved_ki_complete)
 		xchg(&iocb->ki_complete, saved_ki_complete);
 
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 6c570157caf1..885583302c0d 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -90,7 +90,7 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 		len = ((size - 1) & ~PAGE_MASK) + 1;
 
 	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
-				       &locked_folio, &fsdata, di_bh, folio);
+				       &locked_folio, &fsdata, di_bh, folio, NULL);
 	if (err) {
 		if (err != -ENOSPC)
 			mlog_errno(err);
-- 
2.55.0

