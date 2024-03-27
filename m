Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DBE134C6
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 06:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711519772; cv=none; b=vGFs9ETyg9e/cGhE/gM3WymS5+jL5G2B3IOxzNe0qWn5Vm4zG2d7nL6FykqeECFyeWRljZOyCWC5lfDIQcZlfbAyYFE1FEwoigxqSwpAwWfb24/WdqKNJdmsQRyALdvAulSXeFPU9z7YOtfXHwEn41TPEpLMqFImil5JVx7FAHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711519772; c=relaxed/simple;
	bh=VfofPeXTNsuvRmYwRCOp8XUJOUDKtLzxpLDj9kA4z3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R9UPLFciOJ/ZtZV1OodEegbkfLMi67bifgPl/DjyS+iKC9x1/r/RNjCmHLMC1TYctIUmu2ZImNPEu7zbgxDW/5vQtsuC3tC9AE4Fw05BgvlrZNZzmhawjq5NTVtIL/BPp2Znyi41NDLQP1NnKuSBtv1HWTpQz1TOZEf3z7oW+UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BthlLotx; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BthlLotx"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d485886545so110271961fa.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 23:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711519768; x=1712124568; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wzs9n6tbS/gF7JkxIfJeOaPjAATBWrXKYmGB2wfXofA=;
        b=BthlLotx0sHha8Bgm6EaNIAxOHI4g8owTVNvrzSztCOFWAyO37MtC9iBNRZBwx6hGG
         eSh5gEjuVUy2CVbyNmH8QVApo+85oZkYve9xnQc3XIlDs37mySCCv85l87uqR2u1Wp/j
         zEQwaAsILqpCEVft0kPpz0W3lKrY0SUs9yxtpvuVbxyJGgsvnWaBFLyxoKEojwTSQyNE
         aPA3Cb4Je117aS++u23pw6MtfqdkgHbQ2NWAaqSNKBe7sFXXBhZiVVBViXjRGKi0txlq
         f11AJzGrP5/NF/kZWmCWw8YdjsNbTeguM3SEQGzexjI2pW2/6h0YPYvGQqwMi5VHauHv
         bW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711519768; x=1712124568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wzs9n6tbS/gF7JkxIfJeOaPjAATBWrXKYmGB2wfXofA=;
        b=kNMsT2Xcx9pqtpgIX5zPUAsLikl9PM7QIe6S5NpCtfsBTbT8M/v1npfNIX1YvkohDb
         mRTIL6J3OKfm5yc6/B+8s4vlbdtJlriZYzbq6JBf6w7SAbP4W4vrkknYFktHg0Qi3R9m
         8t7JJw4gfmJljT2RlpvRDPyjQoFiFDCoxWeked+p1AioskfIHo5zhp2MeYPJo46Oge3B
         yUZviMCb4moEZ2/qBHhPhkF1yBu2VGyHTS1hZvMD/TEUsstaZtJ79g88hBzn63HoRiaC
         uD0yiG4VhN4nt6I6VPrFonri/mHblb82rmh/mA+L3+dLRM322cBM6RebDIpkoT2FXQvc
         2n8g==
X-Forwarded-Encrypted: i=1; AJvYcCXJX6w+FUAFuq0hZOVac5BkAbbNZ30mmBOkjwnjVQzke26u55QPdI+Z9W6S6trSXzROqqQxgvUldQfrvS1tRYLbWhjbeVFsgEFcebg=
X-Gm-Message-State: AOJu0Yy1Z1AOA4pasvAMjs0AMdNtvSj9Qf1Qz2FKbnEIpJhNO8wGSqTD
	tTs962R75e7CTV1/FBuYMTEzShyWbC5dvTLxn6tpHeecMlHFewomt3YIfLrlA2I=
X-Google-Smtp-Source: AGHT+IEooZYM/4FcR78dzYRjQTYQXbJcxDxE/wyBEOl1o92Xri3okPjhH1sAPlxAj3Dl7f8i1jTMlw==
X-Received: by 2002:a2e:9018:0:b0:2d6:f698:7eca with SMTP id h24-20020a2e9018000000b002d6f6987ecamr1062482ljg.5.1711519767875;
        Tue, 26 Mar 2024 23:09:27 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id s1-20020aa78281000000b006eacefd8fabsm93445pfm.64.2024.03.26.23.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 23:09:27 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH 2/3] ocfs2: adjust enabling place for la window
Date: Wed, 27 Mar 2024 14:09:13 +0800
Message-Id: <20240327060914.2583-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240327060914.2583-1-heming.zhao@suse.com>
References: <20240327060914.2583-1-heming.zhao@suse.com>
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

