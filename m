Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F6B2D7B8
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 08:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711527720; cv=none; b=ffuiLYCCf9O4k2+O8giI40PgxLGDtY6DspzqCR5NALMstj2eeWr+/KAXvDMter+kryQmbm2z3NcbdlhV/LYm42FviJd/qOqm/kcXhBC4OFWIIy9L1+7KinssCFsowco7ITEWof8tJcIx9cOhssokddRIFg2KE4rNURsQYiGit8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711527720; c=relaxed/simple;
	bh=VfofPeXTNsuvRmYwRCOp8XUJOUDKtLzxpLDj9kA4z3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pxu5ALxsgO+vvwSSoKhHQleZw1XW7kSjD7DNUYQDqWdU5Nra46u9To+Z5Ep4RhGhY5RYEbqMpykwatFoH1YuzJnTyPrgW7jwJ2WU1wbC+yzwyTvNwTiR3HXhKFQgCowcMv1zsMw45Z4xZRVHntHAniNwYbF2RopLK27LMh/lrKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F9qrFXR8; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F9qrFXR8"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d6a1af9c07so87767901fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 01:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711527717; x=1712132517; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wzs9n6tbS/gF7JkxIfJeOaPjAATBWrXKYmGB2wfXofA=;
        b=F9qrFXR8LLxQbUrxnAoTdsCmZEws1ul98zKWfFYCEJPY6NYAV1zpyft/2SULxn/3vD
         Yd9HDN7iePQs+a+zffHBPfQrhxN9+zEOwRNzz4LT8sM7zmY0fzzKrN5CysvnXbVfjwUs
         38iMbcVDJTMDHFFLJ+v5Ep9k+EMSCKKdWPa41Yvy8oLvVo2wtpnoIt5XkNX++YPobbk6
         sd6v9DfOZLOhsJgSgu4DGo53j1+f9VCTX1rQU6eQeAZHL2lDeRsMML5d8r3TKP4YhZTo
         jUu7Qvao1YifEaOWiJbHiRsK/p0xrXQUIDB/WIxh58JbAGZZ5TphO/ukQ1iM32XsUBqt
         4TLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711527717; x=1712132517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wzs9n6tbS/gF7JkxIfJeOaPjAATBWrXKYmGB2wfXofA=;
        b=BVH2oS9dMP6v0Dvlfx7ABAM7vP7yGNVnvXXQG66uEcon/om9/Pwy3Ug9VSu5hu7WTL
         PaCpW7d+puSxta+deq/z0JaNGUsVyPXYb5lSDzCWCR859OgaV9ykhY+qP10aAWdaCS1J
         5bwPnDLZhd5BoQ2bhb9lPTfytVe+4qJ0i8mlIlvN51yxGv0SsY2LnydGsfbP4WIlT6XH
         0beakQtSbr+5/rge+Rv40WKpEnAxRYgW2fWTLa5azUDYykk1/YtyZe6zuJIfZ/vvh9Ut
         ++81PScV7TtLh0TP2bC1JlJAfmueKvJpgBD287zgAs2EPWb7X84zw3GZg7vBO2B84yz0
         WsQg==
X-Forwarded-Encrypted: i=1; AJvYcCWpzlPH+fNiD5r/rYt1WTJaKplmm/8gzlodTH8RGHppAZdj8FY6RPUNCTLO+PHcamNCla2OIY+VC/Tde8t1gRXRWnFkbJK4lSR8CsY=
X-Gm-Message-State: AOJu0YzYOwxve2zVXBsqfbim1LSr674X+KOmhFKsitjBNhivhDrZBJ8n
	UBEYBrGHg/fo2bbtghzmyiXTYHxuOqV///dFjg0t9u+inHT/EKrTpcLBKM+D8DI=
X-Google-Smtp-Source: AGHT+IFB+QsfQQ7x7fmXvyPNug4YOoLHrbWBsdub5ZjSiuBleMNHJU7lgAlHkIuIr+nxofEfAiK/Ag==
X-Received: by 2002:a05:651c:19a5:b0:2d4:78ac:1168 with SMTP id bx37-20020a05651c19a500b002d478ac1168mr2478538ljb.32.1711527716932;
        Wed, 27 Mar 2024 01:21:56 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id x2-20020a056a00188200b006ea858ea901sm3423022pfh.210.2024.03.27.01.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 01:21:56 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v4 2/3] ocfs2: adjust enabling place for la window
Date: Wed, 27 Mar 2024 16:21:45 +0800
Message-Id: <20240327082146.6258-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240327082146.6258-1-heming.zhao@suse.com>
References: <20240327082146.6258-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After introducing gd->bg_contig_free_bits, the code path
'ocfs2_cluster_group_search() => ocfs2_local_alloc_seen_free_bits()'
becomes death when all the gd->bg_contig_free_bits are set to the
correct value. This patch relocates ocfs2_local_alloc_seen_free_bits()
to a more appropriate location. (The new place being
ocfs2_block_group_set_bits().)

In ocfs2_local_alloc_seen_free_bits(), the scope of the spin-lock has
been adjusted to reduce meaningless lock races. e.g: when userspace
creates & deletes 1 cluster_size files in parallel, acquiring the
spin-lock in ocfs2_local_alloc_seen_free_bits() is totally pointless and
impedes IO performance.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/localalloc.c | 15 ++++++++-------
 fs/ocfs2/suballoc.c   |  9 ++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c803c10dd97e..2391b96b8a3b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -212,14 +212,15 @@ static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
 void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 				      unsigned int num_clusters)
 {
-	spin_lock(&osb->osb_lock);
-	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
-	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
-		if (num_clusters >= osb->local_alloc_default_bits) {
+	if (num_clusters >= osb->local_alloc_default_bits) {
+		spin_lock(&osb->osb_lock);
+		if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
+		    osb->local_alloc_state == OCFS2_LA_THROTTLED)
 			cancel_delayed_work(&osb->la_enable_wq);
-			osb->local_alloc_state = OCFS2_LA_ENABLED;
-		}
-	spin_unlock(&osb->osb_lock);
+
+		osb->local_alloc_state = OCFS2_LA_ENABLED;
+		spin_unlock(&osb->osb_lock);
+	}
 }
 
 void ocfs2_la_enable_worker(struct work_struct *work)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6fd67c8da9fe..4163554b0383 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1374,6 +1374,7 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	unsigned int start = bit_off + num_bits;
 	u16 contig_bits;
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
 
 	/* All callers get the descriptor via
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
@@ -1423,6 +1424,7 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 		if (contig_bits > max_contig_bits)
 			max_contig_bits = contig_bits;
 		bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
+		ocfs2_local_alloc_seen_free_bits(osb, max_contig_bits);
 	} else {
 		bg->bg_contig_free_bits = 0;
 	}
@@ -1589,13 +1591,6 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 		 * of bits. */
 		if (min_bits <= res->sr_bits)
 			search = 0; /* success */
-		else if (res->sr_bits) {
-			/*
-			 * Don't show bits which we'll be returning
-			 * for allocation to the local alloc bitmap.
-			 */
-			ocfs2_local_alloc_seen_free_bits(osb, res->sr_bits);
-		}
 	}
 
 	return search;
-- 
2.35.3

