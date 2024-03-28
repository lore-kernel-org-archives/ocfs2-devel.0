Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2089C54780
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614598; cv=none; b=aETL39Io7FWf2aB4KtJATjt44D4RrAFdOBomFzqCEOkWbjuT4FQkqwbKCz64SrvFFkPDWAfM1pf5yLjd+rXgfOllz9OBGBVSymhM/i3JpXf2tB7AM+Yk1k6v/9DuGgKrZOSNsiHH7IhkycyXJ5S/fkE1YKWlYSCZh5bIvJOlGAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614598; c=relaxed/simple;
	bh=pMtgfEi2xSLQEkg1XLU9nOS27B3mPBid+HIRAk05Yhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QWOhUTEdKJYnoWUin1pA4Q8LF2m83US3pKLrUHjF93dV4+fvXsOsJNC4FG7zyet5IcbeRmDfGDEYQOsJqax9Smi5FzYLRSMTdWq8In/ff06680JLdxViLk4xS0FO/nWyzxn9RG8IVK2XyLOegxFRLdNJOU/dRWtFGEk875Is0SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T2NsEp2N; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T2NsEp2N"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d228a132acso7626121fa.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711614594; x=1712219394; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGO+sEGNP+INreGN9YQCAzFdITaTKpc79XFXTtEA8lE=;
        b=T2NsEp2N24hYCys9/8Q4+ZllI1pc01hX4U9ZdHoZJUqih3qkwsUxKQvF3RLOjr3UdB
         /pftMevvUJTebQJmMXgmEjN4LDmWiqpDd8mjC1+RRbc6ndFirCy3Rdo/3HNHiV8V8eWH
         dHDsoK2ltriLmd6deJxRgEI+8P/fwSwweq41FZBTDwD0M9BAGG2gzLbjpHcMSJrD7gyU
         R5UmlgkXGp2qILt90y13Q489lwWn4bEakZ89ldjaRIDACSXHtm+zxFe3+O3MKvPX1euB
         n+9cwwnJv1yVt+ttoep4pIXwExHbInfWf+aL7UMN9U+Wd+iZ/uHST9iLckVCh+rNnjN6
         FCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711614594; x=1712219394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGO+sEGNP+INreGN9YQCAzFdITaTKpc79XFXTtEA8lE=;
        b=U2h+IoSVvz+/xN0W+v2u+Wb2dpFFMHl9mq97SO6uUoFh2xPBo0w1Fsh9O/QLoZ0xn8
         l5ACpGjhH1kXhXaZ1qGt5A55E4KZesuDyAhqSH7c6ReyKyKn94uHlrKzAymKfVYr/uLh
         7LPY06wgBjA7Jw5W7mOEip1mZM9V10sY9bTrDg2WNvdg4RjkIh4n7rAihtcSdX+3Lz7v
         oAAcPZY8te9Fo2krQ/3pDvofTSRj62h1YxkG9TgM+gX+9LysWb/sZOo74R+5m0q5Nrut
         YRBJ6dxtU9h1iMtd6MnF9lXYhVjjBbqHvS/7Aqk9embwYb0tyXpIKt7srEvUT38+8r4v
         KZrA==
X-Forwarded-Encrypted: i=1; AJvYcCXxhYMYUfe48jd3JwLR3Hf0cgOzZxDHXGWUBWBA0ubtE4Jw3OPuDH45ImS5ZIhCd9ExzBGLSq+jgavnZCioDXOhRj52OFlDBOV7r5Y=
X-Gm-Message-State: AOJu0YwKIHV48oYaYFs0GE9dpItpMQC3XVTPtAUnadR1qMVzRvxRxo7F
	jk7xiRdn82hOyc3zAwpTwK/v5KQUNiNFqqOo4TkSQjIHYTH7JoQekzCoeKnZSgc=
X-Google-Smtp-Source: AGHT+IH2/FSH+tTQiYWPeR7sOcwtgetnhxCXoSjpQFDM6fp1aMeZs+/OKGf0qDfN23zQqhT6pOGFqg==
X-Received: by 2002:a05:651c:4ce:b0:2d6:c61c:90c9 with SMTP id e14-20020a05651c04ce00b002d6c61c90c9mr2228237lji.53.1711614594388;
        Thu, 28 Mar 2024 01:29:54 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b001e014627baasm955120plk.79.2024.03.28.01.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 01:29:53 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v5 2/4] ocfs2: adjust enabling place for la window
Date: Thu, 28 Mar 2024 16:29:41 +0800
Message-Id: <20240328082943.20251-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328082943.20251-1-heming.zhao@suse.com>
References: <20240328082943.20251-1-heming.zhao@suse.com>
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

