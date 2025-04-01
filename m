Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5069202F90
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Apr 2025 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743517595; cv=none; b=WrJ4bRwXJ0Lu9FZzphA9A/RGssJ9oGmXmF9ncLKg1SO59rDwK3UGP12FHx6jghuNcAwK81PUgtcrIBr6DpbO3OQCyT28bAmWnbSqaBgl6RDeC4jVkakMs4/Ofw8LzceczFUO9dXXiKuMWGNamU8sIQ2+OVYr3/8y62lmve91cYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743517595; c=relaxed/simple;
	bh=uf46RinEUOvCiqVfx8KYzNvB+cZcorAoqYAF8yRTnyc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VOXnOVgSV+ph+6dkdJ3j2KJpfrGx1ofMt37ZM8KHyGyEaNlIwmPCSUNdnpSImbEmaKPM+CBDyN6j7jTX3PtYHkJV1zWJRuI3cslHstIQS8wZPPw2mHYSc2beZ7ua8aPyUUUTunI39AmBGjHL3Utmv7sfEHaBTVmZC9dQxOjiNiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tq6wWJ2X; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tq6wWJ2X"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39123ad8a9fso464474f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 01 Apr 2025 07:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743517590; x=1744122390; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sdBbkebfo2scUETi30Yr9yqQ2VOcxL1KzzzL+b14/fc=;
        b=Tq6wWJ2X6tFBpBl50JSKXqrkzkaon3zSmh3ePpGAWQFFNZ/VuqHxAyyNpz6HmYF8Nq
         xG1RhLk7JoC2QgISa4HDu+OK7UozS/7xLVfSaAKK8Cyx+O0cHQxsmh3ADFRuRsP4D131
         Mxm/umqFeuyBycsDBX4CW14Z233Y9TPz/4kXbZ+H++shR/YL5DoUPaVpI0EzncW7ptmq
         RR9Xak3pQfJ0sGZkC+pQWL+WKxOwFELXoHIVLYzaiEo4ftUzsneQN/dlUiGYRzUbxI28
         8DuzzUps2MvG0fIipOtKzV+GSHDe+nnQb3252j9SF+gtUsOLvIDd2mbw4xQmVRonj4FZ
         dtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743517590; x=1744122390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sdBbkebfo2scUETi30Yr9yqQ2VOcxL1KzzzL+b14/fc=;
        b=FP/2uiKhrOlwdCswpbKdHxPZ8QQiV4yePpBPQUeWX7OFIO9SZVTCff3VN7B10y5eNO
         zpz7YqSPTnu2PGnqP5VxnyHqCiaz4X1zml+dZMA74C6aMIools5Lzn4oEtw0ve7TBDNM
         Xw3CfSuAxKBy1mHWDDTrXwbpu/VSXNcNHeu+P9oH56pn5YdnumAiw23YMgKjDzzq/hij
         BCN+g5IvMd/BXfVxpdPIn4ZnOQHLpy1QsmBXxjvU1wut55qSeq9qPxIWuRmLFssERaLM
         Z9ELku69kzLaPVIzpSQP86iwxF0nN1NPU3dQc3kLGsyXsIGHPBm78KYaruZm4f/NRNO9
         3wzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/w7y158lEL9QFdPsUIGx3uHPh3cxOpyt84wfXf9P8CkHli7NhIlTm17VdWwo7IoUQwU3n8Z2Oss8fww==@lists.linux.dev
X-Gm-Message-State: AOJu0YzD3Lviu62akFVhv6cTl3I0rybAjagycs6SXn6TF6JVPhRRnJ8r
	F1HO0vdvcav+vrUvr58kNwzuOv+XUw2g3VGSOpcqlEaNyNPOjAMYOh4BHEoIPYQooPhlYUt1AW3
	t
X-Gm-Gg: ASbGncupzC0PLnqEYfZAilTmMvk8zOKtRmJZ2KgQ2xV6+16t00DuTsBu6VUtMmubull
	rmtlmuX1ece0JS72dk79UThaBGWCce4tFkFzswbaDGwSAJRErScgQqrPe/jeQ15UWmCjAqUiXeq
	2NOzBqxwscMQemRgQFFqXlrww/Fcqgv7GDeB+PpsWAw9FtRgEVlAgYZERTf34++OOl6uTKfCt0D
	32CWtM7YSFHRAxGF8DGZz4JJQH5xIPi0nGCbNlOjv2/Ik84TChb1pjL59T2EwhP1rdIDe/ye1kg
	39NnWUwHXq2MqeMJH3YSz3Y533BSn1ExQ0qlKm4ftnRLQXAmyo7V7SYdIks=
X-Google-Smtp-Source: AGHT+IEBip0fAQ8K0q/EhN/rjV9v+jJJsXqcgedHUNfP+/QQ6S3358EzZfKmWOVrA7j5vKwp9TnlEg==
X-Received: by 2002:a05:6000:2287:b0:382:4e71:1a12 with SMTP id ffacd0b85a97d-39c246f092fmr878553f8f.1.1743517589953;
        Tue, 01 Apr 2025 07:26:29 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af93ba1081dsm8172922a12.65.2025.04.01.07.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 07:26:29 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gautham.ananthakrishna@oracle.com
Subject: [PATCH v2] ocfs2: fixing global bitmap allocating failure for discontig type
Date: Tue,  1 Apr 2025 22:26:21 +0800
Message-ID: <20250401142623.31223-1-heming.zhao@suse.com>
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
v1 -> v2: OCFS2_AC_USE_MAIN_DISCONTIG type requires separate handling,
          with all other types proceeding as before.
---
 fs/ocfs2/suballoc.c | 10 ++++++++--
 fs/ocfs2/suballoc.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..fde75f2af37a 100644
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
@@ -2429,6 +2432,9 @@ int ocfs2_claim_clusters(handle_t *handle,
 {
 	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
 
+	if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
+		bits_wanted = min_clusters;
+
 	return __ocfs2_claim_clusters(handle, ac, min_clusters,
 				      bits_wanted, cluster_start, num_clusters);
 }
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

