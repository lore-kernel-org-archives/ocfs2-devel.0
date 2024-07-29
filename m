Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F9413213C
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 08:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722240309; cv=none; b=MDxwhVbHDoS732iq+HKFqfHz+eL0vTVChm+EDgCf/MBb8zaqbYoaOLIfGjlofpKGGMscstWE3y61cy7o05fzNIHjkmqm61YcvQb2TUNcUmSuCu+1bb4Y8WfuOELzMdw3xnrieEAfE3FsW9lKPWEcF+NdXCGFrSJLjiaqtYWdulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722240309; c=relaxed/simple;
	bh=F0vFUSJqSa+C33CrxRqRH+/e1N3zbEo+TRYNrBMalNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b/+TP5G4cS4K1mYo7XImC79eRaX4KXg1lAmQGWm1Ps+8I2Elvdk0y17/4NJYKHkyjkN2jQV4WbilvgQRfKfrhzbAjfuxbBIxmFEsaqql0lIkYAwjIT3C9XsxpQLH/pIJUtNsjk8w1ej5L0mmm3/1WsmgWtg4iNf9QYlo26ingjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yo7JdzBB; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yo7JdzBB"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3687ea0521cso1525125f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 01:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722240305; x=1722845105; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llV60w+jXJDdprJxDJlx6FAmU6OB3IKD4Og7jQdjrng=;
        b=Yo7JdzBBTCODQaRLZ3XDaRReImdA3+CQZu4fUvZdpwW1qqzR8WRn/URB73Uv0sRX4c
         imzOkkOP0phWsLCB0RDnKK50ebij2BsClTMbHc/nJfsVDfk4/bPKLuP8M78l0PROH2DS
         1Wsm9R0TjKn9n5kT7B1W9RYYR/z5pqbbNDgFUV5inCge1fZRxPDQvwyYgImnwVHy9QRX
         0edxoFXRZRK6VxxQNfZqE6Y/pYSMFmS/vVhxHhekRxncTJ7KkN6uscXf86hcVhGckXRI
         wp8dA4RUV3r106Z6W7QnqBiBFLU/4XSzMLCtjLQ7P+r/IRh4t6OfcnXi1uRJVSVNB3rQ
         f4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722240305; x=1722845105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llV60w+jXJDdprJxDJlx6FAmU6OB3IKD4Og7jQdjrng=;
        b=roEfE3spBTWZGc6A9Z9WNkH4NXfW9eOV4rcn8kPnj1TXr6Nqsx7iiB2i/lb4B8W50J
         RYy/2O6qvi+mlVGqQgDl3si09AcRhoyc7ag9HYdp008wbkJaVRy8vy+NtqIxgsh6Xqc9
         /NT3hNfuEA5X+VSNwg5cSuttYGI+iRzRedQO9cSB8C0B6n8xGL/xXvE7V35ehbXWcxEi
         Kpv8eZkfK74MfZVH1DlCoJ/kcipV17HwgfqhfNhTjPWlEjdQwHt3uORdaAR4k1C/Cvdy
         3d+LSXnO4hQOoyI6DVXigwFMczBS+qCKm/m5SRYEh1Q+9ONyb3VUJlRRRNeWtyzWiOhS
         K7dg==
X-Forwarded-Encrypted: i=1; AJvYcCVPlBL9DCPG8rYyKse1eesYH8Ux17CwJBcswMnnfAXIiRdezrrufNMTck4++hda8uwx5oy0gbB7ANlYEw+GDLhgFeRTShh7O0Hq//4=
X-Gm-Message-State: AOJu0YwDOZJVOVKOmr0o6UscDrGiJgh4v+qLAhTfM6tG4rpdqx3hwH0H
	VIdDe9xBOinSTLNC13GHVInr1IU7HqxyhBgCqkQfsrRUL5wgYUnvopp60nXL3CiV2Xz6xBwum+G
	f
X-Google-Smtp-Source: AGHT+IHNfPHHn6kuChlfCUttTnKX0DfrTk1S1dn9KLrFlx9NeAhqXvbAZRWF4dsXfIXlRgO0frrN5Q==
X-Received: by 2002:a5d:5184:0:b0:367:90cc:fe8b with SMTP id ffacd0b85a97d-36b5d07afd6mr5571674f8f.27.1722240305305;
        Mon, 29 Jul 2024 01:05:05 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7edd813sm76560305ad.170.2024.07.29.01.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 01:05:04 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 2/3] ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
Date: Mon, 29 Jul 2024 16:04:53 +0800
Message-Id: <20240729080454.12771-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240729080454.12771-1-heming.zhao@suse.com>
References: <20240729080454.12771-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After ocfs2 has the ability to reclaim suballoc free bg, the
suballocator block group may be released. This change makes xfstest
case 426 failed.

The existed code call stack:

ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
 ocfs2_get_dentry
  ocfs2_test_inode_bit
   ocfs2_test_suballoc_bit
    ocfs2_read_group_descriptor
     + read released bg, triggers validate fails, then cause -EROFS

how to fix:
The read bg failure is expectation, we should ignore this error.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/suballoc.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 1b64f4c87607..dc421f55ed8f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3037,7 +3037,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
-	int status;
+	int status, quiet = 0;
 
 	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
 				      (unsigned int)bit);
@@ -3053,11 +3053,16 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 
 	bg_blkno = group_blkno ? group_blkno :
 		   ocfs2_which_suballoc_group(blkno, bit);
-	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
+	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
 					     &group_bh);
 	if (status < 0) {
-		mlog(ML_ERROR, "read group %llu failed %d\n",
-		     (unsigned long long)bg_blkno, status);
+		if (status == -EIDRM) {
+			quiet = 1;
+			status = -EINVAL;
+		} else {
+			mlog(ML_ERROR, "read group %llu failed %d\n",
+					(unsigned long long)bg_blkno, status);
+		}
 		goto bail;
 	}
 
@@ -3067,7 +3072,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 bail:
 	brelse(group_bh);
 
-	if (status)
+	if (status && (!quiet))
 		mlog_errno(status);
 	return status;
 }
@@ -3087,7 +3092,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
  */
 int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 {
-	int status;
+	int status, quiet = 0;
 	u64 group_blkno = 0;
 	u16 suballoc_bit = 0, suballoc_slot = 0;
 	struct inode *inode_alloc_inode;
@@ -3129,8 +3134,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 
 	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
 					 group_blkno, blkno, suballoc_bit, res);
-	if (status < 0)
-		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	if (status < 0) {
+		if (status == -EINVAL)
+			quiet = 1;
+		else
+			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	}
 
 	ocfs2_inode_unlock(inode_alloc_inode, 0);
 	inode_unlock(inode_alloc_inode);
@@ -3138,7 +3147,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	iput(inode_alloc_inode);
 	brelse(alloc_bh);
 bail:
-	if (status)
+	if (status && !quiet)
 		mlog_errno(status);
 	return status;
 }
-- 
2.35.3

