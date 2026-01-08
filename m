Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638AC4FAED4
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Jan 2026 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882005; cv=none; b=eAiLnRhCY+oiyq1ARb3OR9MRXCJkbba+L6403bRGzJ4VaAoH7tJ08uQ5hYVGCV98s2sL1NbS72UsNUs6/M3a7HBYY6GzTsw2oUYgzcTzt3yKiV8+cU/Qs4Ln8HJh0XmjLz61xtLfZA6yFVsQEDfSH8qVhkJYpIpazPFZ807S6RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882005; c=relaxed/simple;
	bh=HaEnV4ehoraqs2JDYMtCzb/1LxR89HWES5hD+j3POUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdujd4hXREPrgsOo1Pi9eEZto5S331qKE7yztazGDL8e8+SxDfsNB3+1yhw0JRqCh2n9XOw21ZzASIyDXm/vY6M1ESDasS+04NfTC5RrACb5HRvtqsqibGxA/L3jZGUo7QYo6f6kvjWhSOs82RFjmUkJ7PGvSagkK3g57/abgpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fe64lhn/; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fe64lhn/"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b843e8a4fbfso357958366b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Jan 2026 06:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767882001; x=1768486801; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFU8Ih7hrSkurdKWhD1ijhVh4ZiAsNV6HLiabVokPfk=;
        b=Fe64lhn/pfmB/dcUTwJ0CVM7q3TuIO9a6lTwIq9n9TzgMER+7/KWKijRtODMRRfNDN
         wIdBa7jtLThIvikzYPwMW8fhb9ScFhoTlPSciFO7QC0QNd810fr2BpiEDnDRh+Snz3r2
         2kRt3zCz9I3WBn6xZAuZtA9GLrTS//2OoFNMiRl3qFFY6wbv76BPui/LfRpmDINM3ErD
         9wPZ/fhiAu+6MJCkJTDAjfPKTnVZpo3RNlI/eK8sBpnNiR0+Qwla5ouFKIFHIIo+EuzN
         lIuabNir81v3qOkK4J4akBfk6j5cloiYMtE69MOd41nSEEAPr0lsa1XK5tw13BlTkVFA
         lNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767882001; x=1768486801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XFU8Ih7hrSkurdKWhD1ijhVh4ZiAsNV6HLiabVokPfk=;
        b=vjwBbvBHNAiwNTlO1K8J6x7Vwkzg4+MtxFi8lydrMUBNhIvb3bPXAApfmDqy7BIcn0
         mCAUBN+DBGhxHjeZqXkR7n2dc2coNn4H4WRo1ISNM/6AQa4CjstV1xXAr7eHX1keXwJi
         fjgXdnLwq2IfsuC4NsMuOwbCwYYRP7Wndl0G2ozQ4R3dMP2xAArBCEwIdPe/anAbagIT
         GfMBUKJnWatkaCpRcuDafheiMXmrvLywdYoFxNhr8c/Ba5JaOrn+rlql5AUgv4S0R1kr
         G1SeD2/loPPnxe1sQg4U1EjW2u9eXc6fgT94LsbYxplee+RxAJ+pkZyJMinZQI/2NtoH
         8FXQ==
X-Gm-Message-State: AOJu0YyFA6Fc0ZLoIRUD72J577B9r37eV8sy+rMKFDrkZcegw3cod9PD
	+yZFvFc9ANglsebuoZKd90SbGEqcLNFmtjzSr3kIxsSXIgtQcx1zGNPF/Yivj4wW
X-Gm-Gg: AY/fxX6g06YEs2x9PBUQImmRseF2tw+pLAA5OeVdcINR9w3aYKG0+pCByC+P8tJwH9e
	sjiwf8RcnerfFc7BY7qOo61pGA1DX7pxsapQP+QA6AWhq22sJzmxejYGe4VvQ3WwAjYoShxlwMZ
	0eWR8Hyf9F8Z/ypLQfvkN/1HAbDndhTtelK2uY+HZv4N2Cduhssz+StEOMQCJ0rSfE3e8l6jXSp
	k4LA8rR4YHBDbzb4JJmhB1brw1M0PKdcLT99j8d2EOCdhE5J03lP+WCkWj/D92UenpQqTur5Yml
	sg/7QcSKOA7cd9FAk8ttNU/koiUX/7/wnEr6CWif8hFMnancoHJyqt2MRlGvoZRStvJ8bRMygPL
	DGun2Z7QR9+RxpMcFxahuWRCEyvS8QoEt3cGotxzOjQo3w9tLtnkSOS0jJyvBoHnqDp0p/6Eitq
	UEvVlu5Vt6Ddf2BA==
X-Google-Smtp-Source: AGHT+IFdshrgPVcptLCLWBEfjJcbNevKZB5kL0eUZhIYHdklA2hZ6/zmV6PqAkBXH1owpYsRHn2iFQ==
X-Received: by 2002:a17:907:9704:b0:b83:13c3:d495 with SMTP id a640c23a62f3a-b8445345cafmr632272866b.37.1767882000645;
        Thu, 08 Jan 2026 06:20:00 -0800 (PST)
Received: from prometheus ([85.11.110.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a235c0fsm818034766b.9.2026.01.08.06.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:19:59 -0800 (PST)
From: Szymon Wilczek <swilczek.lx@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	akpm@linux-foundation.org,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
Date: Thu,  8 Jan 2026 15:19:31 +0100
Message-ID: <20260108141931.67110-1-swilczek.lx@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251227174251.121668-1-swilczek.lx@gmail.com>
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move ocfs2_extend_no_holes() and ocfs2_start_trans() to execute before
ocfs2_lock_global_qf() to fix a circular locking dependency reported
by syzbot.

The issue occurs because ocfs2_start_trans() acquires sb_internal (via
sb_start_intwrite) while already holding quota file locks (ip_alloc_sem
and sysfile_lock_key). This conflicts with freeze/dismount paths that
acquire sb_internal first, creating the following circular dependency:

  sb_internal -> sysfile_lock_key -> ip_alloc_sem (freeze/dismount)
  ip_alloc_sem -> sysfile_lock_key -> sb_internal (quota acquire)

Fix this by reordering the operations:
1. Speculatively extend quota file (uses need_alloc estimate)
2. Start transaction
3. Acquire global quota file lock
4. Perform quota operations
5. Release lock
6. Commit transaction

This ensures sb_internal is acquired before quota file locks, matching
the expected kernel lock order.

Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug\?extid\=51244a05705883616c95
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
---
 fs/ocfs2/quota_global.c | 49 +++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index e85b1ccf81be..95bb901820cf 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -821,13 +821,35 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
 				  type);
 	mutex_lock(&dquot->dq_lock);
+
+	/*
+	 * Speculatively extend quota file before acquiring any locks or
+	 * starting transaction to avoid lock inversion. sb_start_intwrite
+	 * (via ocfs2_start_trans) ranks above quota file locks.
+	 */
+	if (need_alloc) {
+		WARN_ON(journal_current_handle());
+		status = ocfs2_extend_no_holes(gqinode, NULL,
+			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
+			i_size_read(gqinode));
+		if (status < 0)
+			goto out;
+	}
+
+	handle = ocfs2_start_trans(osb,
+				   ocfs2_calc_global_qinit_credits(sb, type));
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto out;
+	}
+
 	/*
 	 * We need an exclusive lock, because we're going to update use count
 	 * and instantiate possibly new dquot structure
 	 */
 	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
-		goto out;
+		goto out_trans;
 	status = ocfs2_qinfo_lock(info, 0);
 	if (status < 0)
 		goto out_dq;
@@ -843,29 +865,12 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
 	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
-	if (!dquot->dq_off) {	/* No real quota entry? */
+	if (!dquot->dq_off)	/* No real quota entry? */
 		ex = 1;
-		/*
-		 * Add blocks to quota file before we start a transaction since
-		 * locking allocators ranks above a transaction start
-		 */
-		WARN_ON(journal_current_handle());
-		status = ocfs2_extend_no_holes(gqinode, NULL,
-			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
-			i_size_read(gqinode));
-		if (status < 0)
-			goto out_dq;
-	}
 
-	handle = ocfs2_start_trans(osb,
-				   ocfs2_calc_global_qinit_credits(sb, type));
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		goto out_dq;
-	}
 	status = ocfs2_qinfo_lock(info, ex);
 	if (status < 0)
-		goto out_trans;
+		goto out_dq;
 	status = qtree_write_dquot(&info->dqi_gi, dquot);
 	if (ex && info_dirty(sb_dqinfo(sb, type))) {
 		err = __ocfs2_global_write_info(sb, type);
@@ -873,10 +878,10 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 			status = err;
 	}
 	ocfs2_qinfo_unlock(info, ex);
-out_trans:
-	ocfs2_commit_trans(osb, handle);
 out_dq:
 	ocfs2_unlock_global_qf(info, 1);
+out_trans:
+	ocfs2_commit_trans(osb, handle);
 	if (status < 0)
 		goto out;
 
-- 
2.52.0

