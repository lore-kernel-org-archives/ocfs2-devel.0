Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4165925771
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Mar 2025 06:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743056544; cv=none; b=YJxCZWRJXHhEGHtSeC95jaPZFIm8Huw8R3YCG9/h1prAYBRxZxKdAEWrpnxE3/J2j+1YrDopeJxSshE+MmJFn7eni3OFFz00eMhC/4aWxhc2GkMNEq3uHv9tCtVuFGApgn4+YC5rlxS3ab/QnKh0fup56qhjvueRnnYnYZDBU5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743056544; c=relaxed/simple;
	bh=T4o7Npfj8cfRlK+HiHE2jL+iHCod3eTKeuSvzkqtAmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ut40bCQX+haYod1XNA1OIkQwtt4Os2XwgRiRw3cVrv1xM5Of6Nx+DX6U6AihVqxVIRvOHyRciXgZD5EwBMOo6F5fCYATUWg1isQT5Q8rRLHnCxR1UxhaN0RHBbdTQU+YGFEAvzDIRmH9/OJDrsYfcFG9jiV7+ixidYo1jssBinQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=baFhKDCi; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="baFhKDCi"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39ab85402c9so7846f8f.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 23:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743056540; x=1743661340; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r3UZwovF22qijSvqeoxOLD33tI0BeZTaoA548D9DPe0=;
        b=baFhKDCisdDqlS/erQB/qte0OQu+tyqdxgVGahZ9X71xKm6nNkTn6JZ3sbRMXki3Y4
         NiF+x06mqVTzivdjGiXiW2r9fsjQUzEb+tlZgl1yGDKLQ5JUUQeQ258mEKBuxVFIgfrh
         7yGylKRCN8uVDXOvDiG/gY1W02cqR9mMvBCpJzYb+uSWKnlLDJcu65ucdCFlPL4mLzHk
         LQQs01vH4PbsZ2WcAK4+aqqJE6SknXQ6+ZxBmikL60X/UooXo6IREaVMpVW38gUeVW0P
         by/AAWtLVVln0gJmFYSJnivOuWLaO15RXeZ4WPacKEWL4mQDyag3ar9kB4sdjikrpvzo
         7Z2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743056540; x=1743661340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3UZwovF22qijSvqeoxOLD33tI0BeZTaoA548D9DPe0=;
        b=Qs4rCxWAJgFgejSGLJKFc2IVCVOEdscrGLp7Y7BLXLSGpVetW5mBhubHyqaJ0K2R3O
         d7oJK9MYtsi40/ljaoLJKisdq+Mfqet2S4Dw/QLNkWQWQRXC2eD6kDLHhG4yYiRPBbf8
         dnRIfgYI7UNFwQrQVboc00+AQBP68Xy+bBlyhFbO6Xt/R0RU529la31w3tisQN2FVbSy
         KFcJerUYBvNaXWVDdl9dtmax2U1hdu6us6UKzMc273fOLkF9ht9uE0na5DTwAsTJ9FiI
         9o1zaus8P5Rwgx3qgWMShgtpD95+BRrQ4F5sOVg40lem3SebK40QHlP5Hjz75uMHBPDm
         FJlA==
X-Forwarded-Encrypted: i=1; AJvYcCXB1mt5fkOnwPNSKy01vVX2tn5J8gCwizoDp8OM8ArdSvEMG5BjZb5E0iSGZHTVtwZSDEM8vGuV7GE64w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyLomQLxNOjnrwJVemaqAbU6kalumFA2VU1yDAUJfWYGYUebSp9
	REEyJZ7cKs1QKW/1G9lNzXo118ynWrwEg14Fath2HiXtODpB1PIxj6c/jQ9NVSD5iQzSAHGlLkC
	5
X-Gm-Gg: ASbGncs8mOQoRtYru/jdi8hz5IE6kTzdiY003RO2pReo1yEu8x2EiC09uwAt86Z1UOh
	9Ctj09Uo6gZwSBBqdNcRZeTTIcdv+S4VD65dE7XkUrmSRR8SVVRrKp0hSljwsHi2795zCFd8dLQ
	erMKlydep1kKlEmcmLFm106y55ZISYZL0Y9AWL9Y//8yLazBV3LtK8gbiA4nuQYlmM25FtKFcZq
	uBad0+dZtc/4dZVsV3n85ArEFXTrYx0OgjloPecyIXJxonhtoWIT8XGckoH1xkujNXqu0m+XPeg
	1SsyiJjaPf3ekfTRQVpAZBtpdfdnlpDb6zJQg6EOAXX8PA==
X-Google-Smtp-Source: AGHT+IFPV1X+WPIdzKvzEsnhwRDFRN40tBTiwfautnBLvhKsJ62Gnvc+1vpqvvIJ/NOs7QjBHrbz4Q==
X-Received: by 2002:a05:6000:1fa7:b0:38f:2224:73a1 with SMTP id ffacd0b85a97d-39ad2adbd01mr391838f8f.2.1743056540464;
        Wed, 26 Mar 2025 23:22:20 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73905fa97fdsm13418293b3a.26.2025.03.26.23.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 23:22:19 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gautham.ananthakrishna@oracle.com
Subject: [PATCH] ocfs2: fixing global bitmap allocating failure for discontig type
Date: Thu, 27 Mar 2025 14:22:00 +0800
Message-ID: <20250327062209.19201-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
fragmentation is high") introduced a regression. In the discontiguous
extent allocation case, ocfs2_cluster_group_search() is comparing with
the wrong target length, which causes allocation failure.

Call stack:
ocfs2_mkdir()
 ocfs2_reserve_new_inode()
  ocfs2_reserve_suballoc_bits()
   ocfs2_block_group_alloc()
    ocfs2_block_group_alloc_discontig()
     __ocfs2_claim_clusters()
      ocfs2_claim_suballoc_bits()
       ocfs2_search_chain()
        ocfs2_cluster_group_search()

Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/suballoc.c | 14 +++++++++++---
 fs/ocfs2/suballoc.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..3dea082f6e91 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -698,10 +698,12 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
 	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
 					       ac, cl);
-	if (PTR_ERR(bg_bh) == -ENOSPC)
+	if (PTR_ERR(bg_bh) == -ENOSPC) {
+		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
 		bg_bh = ocfs2_block_group_alloc_discontig(handle,
 							  alloc_inode,
 							  ac, cl);
+	}
 	if (IS_ERR(bg_bh)) {
 		status = PTR_ERR(bg_bh);
 		bg_bh = NULL;
@@ -2365,7 +2367,8 @@ int __ocfs2_claim_clusters(handle_t *handle,
 	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
 
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
-	       && ac->ac_which != OCFS2_AC_USE_MAIN);
+	       && ac->ac_which != OCFS2_AC_USE_MAIN
+	       && ac->ac_which != OCFS2_AC_USE_MAIN_DISCONTIG);
 
 	if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
 		WARN_ON(min_clusters > 1);
@@ -2427,7 +2430,12 @@ int ocfs2_claim_clusters(handle_t *handle,
 			 u32 *cluster_start,
 			 u32 *num_clusters)
 {
-	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
+	unsigned int bits_wanted;
+
+	if (ac->ac_which == OCFS2_AC_USE_MAIN)
+		bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
+	else /* ac_which == OCFS2_AC_USE_MAIN_DISCONTIG */
+		bits_wanted = min_clusters;
 
 	return __ocfs2_claim_clusters(handle, ac, min_clusters,
 				      bits_wanted, cluster_start, num_clusters);
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index b481b834857d..bcf2ed4a8631 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -29,6 +29,7 @@ struct ocfs2_alloc_context {
 #define OCFS2_AC_USE_MAIN  2
 #define OCFS2_AC_USE_INODE 3
 #define OCFS2_AC_USE_META  4
+#define OCFS2_AC_USE_MAIN_DISCONTIG  5
 	u32    ac_which;
 
 	/* these are used by the chain search */
-- 
2.43.0

