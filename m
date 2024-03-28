Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EAA7D081
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 12:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711630338; cv=none; b=jPnC1Ba0pSRFqOOxa/hHgRofTln7+DXFffV0DHXuJVXrh7oufDH4O0uY/bYyD18I73CUtFB4bDK8oGlmZAFVahHzE84Qjqe4vi429DBhg5m88ceDb/kNoBOBqmTClHjRe6co1qxeEfMqgMvNrSdzKp1Hbsgw4klfEsUqL3vFdrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711630338; c=relaxed/simple;
	bh=nTuHhvt8CyqP9dpP/QY6dNmL9bTXzerA/Fpc5OSxcx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gOiLP9mrY26Cxbold2aLPxSDFk/8SoZcbJKklIT1WvFU96bj59f9NWD5VzDukS4D5/YvqeiqivefKE3PV7hjiHgzWoeTtZ63kOijvSybxGY3KaPB76o18VFI9h4DPl0uDHurm1Rkbba8LGwr//EO7jOHa41dVCFjrqyZLqQMMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dHjAkc+L; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dHjAkc+L"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d700beb60bso18266081fa.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 05:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711630334; x=1712235134; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33lTEKlfYZ+4TVHmeUJgqqIAct6UiE+Fxnnd1gmXmXk=;
        b=dHjAkc+L2DGsSPpLwRrTtRcfNvAHoAsgPPq2gWmqlb8TQTLm31Sp8BUB8Kzf+86vuZ
         SVX7mzREC8bBMxxlbuWd9HQXfMCzKJTHVy5v1fZ1uzqv09cj/MAh1gb7TL9r+z8L2Id8
         OP/04dzJ3qxzxZe8gR07mVNV5KpTqmWSEdtqwDdtCmt05jwolWlxx9Wap03EXLHAAXpo
         EzoqHUVDDGX7Z5cvCekjPxFKvBORqca0Y3ExaundRXvaqbcrQfwJ7PSC3N9zX/MQbJoo
         Rx4XcpPZe9dpSW2YNLb7wpHHtk3YrzzDBsyA7bFxUvqFp5r5f5K0SWy8DSP3qkmKsBXM
         7KYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711630334; x=1712235134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33lTEKlfYZ+4TVHmeUJgqqIAct6UiE+Fxnnd1gmXmXk=;
        b=FV1YyMwzZQRhRPLXRQ41XZEKS1rQAl03A/xiWsd3iy+QJ7xMgX7MLZUV9CeKS9YqB7
         AEofqsVyGGn0MAmbf2R+dI0fCWZsEL6G9hevwyv2jSp46I1h6IuymgX5ecBympNguk+a
         AdWdGFHIkis8n933W4Rd0WK+qUxl4DlvfG1RTmFRTasfM0p2AbWoK8a/dhoep1zj768+
         Lk/znkFVrc2fRalfovqrJZ8bidoky8N1v7OJNQTx4HSejUwtdWDqlCLO8dLSo0UiTo/M
         r3/7BqZkYb4rt7cLMDHPy26VQTyGqXsoIPGpDex3AAlff5Mzwt+2TrCmn6DfEVisBSJq
         j3fA==
X-Forwarded-Encrypted: i=1; AJvYcCXFqLUkwirwrHhR3JxMl9go16vcgiCYx3evOs+vDCjQoTTwvI+NARGVKSlYRJ5B2JyhCqpifM7/oZ1VXOBRVkjd8c4F5K/CXVkTdEg=
X-Gm-Message-State: AOJu0YwwgE73qEGSXIqmWre+4mX0ChSFBj/O1Our3vTwxQOMuQexWuk2
	bySHpQooWyQ3a2o11IGotJN8aXmRoh8rx0fWg8RcjqVhy8zTX1oph45d1KDP7KobdgW6xGi72PX
	l
X-Google-Smtp-Source: AGHT+IFBf7+5jszUYdZnh8cChm333YO+YoCZlX4lhrnYkXeIcVtglJp6v2BT23cNGWXsiItsCDCJ6w==
X-Received: by 2002:a2e:9018:0:b0:2d6:fa7a:a670 with SMTP id h24-20020a2e9018000000b002d6fa7aa670mr2645728ljg.33.1711630333876;
        Thu, 28 Mar 2024 05:52:13 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id mo4-20020a1709030a8400b001dd8d298693sm1485010plb.23.2024.03.28.05.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 05:52:13 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v6 2/4] ocfs2: adjust enabling place for la window
Date: Thu, 28 Mar 2024 20:52:01 +0800
Message-Id: <20240328125203.20892-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328125203.20892-1-heming.zhao@suse.com>
References: <20240328125203.20892-1-heming.zhao@suse.com>
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
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v5:
put 'osb->local_alloc_state = OCFS2_LA_ENABLED' into the if block

v4: first verion
---
 fs/ocfs2/localalloc.c | 11 ++++++-----
 fs/ocfs2/suballoc.c   |  9 ++-------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c803c10dd97e..b893ef56accd 100644
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
+		    osb->local_alloc_state == OCFS2_LA_THROTTLED) {
 			cancel_delayed_work(&osb->la_enable_wq);
 			osb->local_alloc_state = OCFS2_LA_ENABLED;
 		}
-	spin_unlock(&osb->osb_lock);
+		spin_unlock(&osb->osb_lock);
+	}
 }
 
 void ocfs2_la_enable_worker(struct work_struct *work)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 1a7b53fd468d..fc80cb3dbcd1 100644
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

