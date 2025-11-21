Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49991337B91
	for <ocfs2-devel@lists.linux.dev>; Fri, 21 Nov 2025 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763710849; cv=none; b=GThW8gooi8/f7KXVlKNs29PtnmVtqVXNXtBrnvEPrOYstlisjg3DMtxR4aKMdy9Bctf/Cl7sVnWlYUrrih2UeumLT4X1g7eZc6r0+xBAiDg8w1OJyAY8IgdiP1nav9lnUGZYKRcM8HfpA8zBK4Q3SZS+qxxXTOBANI9Y4H5JJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763710849; c=relaxed/simple;
	bh=u3tF8zKd7NcYJDtduBDGjGpk5WLn+y3aUQFW19+tjRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPO6bo+PEVcItoPYpXRKoMXJUjgTyX5vFseON4wB22Nw63eX0JM/xPFsGoSQdnR4JY0wN9THm7Kb3i9MG4gl1iqTWdL2oxoRfMbZPIALLqhwng5m+nSwVGf5BrnPz849Wxo29qNDxVJbkDGhN81S6rmcxIzD1aoEZMZ5Kg1OIAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZS1gKgYM; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZS1gKgYM"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b2dd19681so206222f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 23:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763710845; x=1764315645; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9MWQEkUmssQH7h8+ZJJJrAiWh1kVuLIvHyNZDUo2Ps=;
        b=ZS1gKgYMT3YXtn4Sz6sabEIsVG265UgJIVj1D24L/yAOQSUyuPcxVJlwdYJDreMjJ1
         PQnfgq7q3vkU5JhrJ/jg8DcSYO/xxStXQUEr/vUnA533+6r17dIqZdXp0/r9YRrJ2w+w
         qqNV8IcYEJsNc6R4NdCMcUfZ1afVvPGhe1ZqxR5R3YHSw/QxV70S115GOfI7XjHWN9Vd
         WOgu170fYIadAu9la2vIAi9nnlMNiCC6iOWVD8D2mFuGQLfBK6AGte5gxbVmLvV8R6fE
         yRDaDsJ1M//ApSevhi/m6/ypHswGNbeA2Np7/CElZ7kdbPudiJENM50Qva+qfkKMnP+0
         9fLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763710845; x=1764315645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W9MWQEkUmssQH7h8+ZJJJrAiWh1kVuLIvHyNZDUo2Ps=;
        b=sScUwiY4jQTfom1d3bQ39Sn8HrZifk1bRAL5NhzWrPrNmXDEUKD4c/c7FZL8ypGj9c
         xc69eMhR5vI9fAMIo8j1C4PoKE421b6zT/qlODPK2SmOHCVVSsKdubVRATJdZOoeSAKb
         xfQCnr0aNatxSYODMww6GWehhAzzYxLoieUqdRc6SFa8H6hLP42ZKhfCeGMOmSssn41C
         MQyDi5QFnakVQf/0ETA1f94O9bxD1pNoTRp2YBvOpt/uvgMCR6S0rW+wm6KJEnzg/E4q
         WaP2vVqoOktXe8vxPIV6ekpLFUe/ZJBDLcRIBX/y3aDL791TB78cA5WjjZvDm5UBMG3w
         JvLA==
X-Forwarded-Encrypted: i=1; AJvYcCV85xqbIhBiMlWO0rL9Zoj+JRSm+Fe5B5KPWVRaRqsgKsdjKScSx9qAN5mrDNccNNsVQNrgi86SBa/rKw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2Y2OB8hFlMLT5FIgNc2PhbN4hBv3gI74LOA3OIXOU863Hx5Hg
	exrl8qB7XJFkeM15U9YCWeEBFkgX5UmYIaWLCLGxtamHxIhq+rB2iOUTbZ9MvMoBj1WWh2WG5LM
	+Fz9gWnI=
X-Gm-Gg: ASbGncsOzqCS2+7qUzBBEnOil9TyBdiy6YB4dk9YCimQ3FPcMbypCM1eBIy8ZbD/t7j
	3DnlE1YnSP9Lsq8ehGXeMbAqkMujyU0no3F6IirKaVcl72J6bHZwnFAcb7b5lEuZ/ztRpnKjZCR
	9aHrkhwc5TGYexhSTUz3j4qZv5kL67/XnNlUJkUbOutYQciz1LGbdHpXX7zuWfSlUFxSDP9+dDX
	c7x1jp2gP4WgrIUPgGPostJkosx2WI23rZ65TpIt4H2GgvBI08myrgkKMC1a1qHRtru01VbIbJv
	Zk9oYBfy7tkkdHaOK+lbMbCwYzMN82HfoTHN/T9uxFhe1ANQBqkbGDTKfBAoj6rE8mwnZJco0Qh
	etCGI1nk3+mrZPSxb4gC9hZsNUsiWX4sIgKzjkekOFhWHlf1uvL2dYPECnCKH7qlfI/jdzpXZdT
	QkSot+0X6jI+bCPYS+/xhMHtED
X-Google-Smtp-Source: AGHT+IGPfilu/kbgZV9dVq6wCfMGv8hTMKmEAShf3TykDi7bNAfE5BRENmfv20DM+MDzIz2SzorcxA==
X-Received: by 2002:a05:600c:46c4:b0:477:5ca6:4d51 with SMTP id 5b1f17b1804b1-477c01bdd6cmr8525255e9.3.1763710845317;
        Thu, 20 Nov 2025 23:40:45 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023fba8sm5081295b3a.41.2025.11.20.23.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:40:44 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v4 2/2] ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
Date: Fri, 21 Nov 2025 15:40:25 +0800
Message-ID: <20251121074030.12014-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251121074030.12014-1-heming.zhao@suse.com>
References: <20251121074030.12014-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After ocfs2 gained the ability to reclaim suballocator free block
group (BGs), a suballocator block group may be released. This change
causes the xfstest case generic/426 to fail.

generic/426 expects return value -ENOENT or -ESTALE, but the current
code triggers -EROFS.

Call stack before ocfs2 gained the ability to reclaim bg:

ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
 ocfs2_get_dentry
  + ocfs2_test_inode_bit
  |  ocfs2_test_suballoc_bit
  |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
  |   |                             //the bg block was always found.
  |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
  |
  + if (!set) //because the above *res is 0
     status = -ESTALE //the generic/426 expected return value

Current call stack that triggers -EROFS:

ocfs2_get_dentry
 ocfs2_test_inode_bit
  ocfs2_test_suballoc_bit
   ocfs2_read_group_descriptor
    + if reading a released bg, validation fails and triggers -EROFS

How to fix:
Since the read BG is already released, we must avoid triggering -EROFS.
With this commit, we use ocfs2_read_hint_group_descriptor() to detect
the released BG block. This approach quietly handles this type of error
and returns -EINVAL, which triggers the caller's existing conversion
path to -ESTALE.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index de2f09217142..a126d83ddb1c 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
-	int status;
+	int status, quiet = 0, released;
 
 	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
 				      (unsigned int)bit);
@@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 
 	bg_blkno = group_blkno ? group_blkno :
 		   ocfs2_which_suballoc_group(blkno, bit);
-	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
-					     &group_bh);
-	if (status < 0) {
+	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
+					     &group_bh, &released);
+	if (released) {
+		quiet = 1;
+		status = -EINVAL;
+		goto bail;
+	} else if (status < 0) {
 		mlog(ML_ERROR, "read group %llu failed %d\n",
-		     (unsigned long long)bg_blkno, status);
+				(unsigned long long)bg_blkno, status);
 		goto bail;
 	}
 
@@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 bail:
 	brelse(group_bh);
 
-	if (status)
+	if (status && (!quiet))
 		mlog_errno(status);
 	return status;
 }
@@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
  */
 int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 {
-	int status;
+	int status, quiet = 0;
 	u64 group_blkno = 0;
 	u16 suballoc_bit = 0, suballoc_slot = 0;
 	struct inode *inode_alloc_inode;
@@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 
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
@@ -3253,7 +3261,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	iput(inode_alloc_inode);
 	brelse(alloc_bh);
 bail:
-	if (status)
+	if (status && !quiet)
 		mlog_errno(status);
 	return status;
 }
-- 
2.43.0

