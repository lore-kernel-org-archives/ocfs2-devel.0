Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1230F7F0
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765525522; cv=none; b=e5MYQJnErcQJ3ihQzRFOVN6prWwcJTGp0DM9Ff2rzgufIZI2nlc8K/STrAUuyn3DonJ2bXWx/myXFARnaEeSZptMZQ15ZZDVh+0DtDjq8slyvmx72ir5MMowMd9MjLIOVtRt3vw64+0GSKe2CQsF8iV8J65k+idrmTRfEDOYDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765525522; c=relaxed/simple;
	bh=k0Da8MpybI0CYQLClcHeD9cgrvdH2g3rxNuqSdol5Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5kbuYOVu59iPK9UpjiiVhKhOVGr4P3T45pRL0RSKII7nPZrEGD/E2Wwp0yI2/5dSG2bEioa2nCTFd4HZHvwJplUjLNGq5S5mB5IwnUh09CGBVZnX4SEM4XsfBXnCVJEMKGO9YHGspOPIsoJSPJck2t4XR1hzJK2FfwZOEPMQeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XpYs8xeJ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XpYs8xeJ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779f9696e7so870435e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765525518; x=1766130318; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjqsA3Rk0Xp0l1r6js0wRRyT/FYUpiPjVmpKyrwUjoc=;
        b=XpYs8xeJJJG6eL8ITSIIYlvVHiIzIhFPgCxoGU6+7H21P0Y6qHTZ+hRxJAqw+5rpW0
         6uOyDqKArBf++o4qACtwwInrfabyCL24ui9ZEbXu4k8u+QlTRPaebnYfW9cFDybN1I4A
         QGapkesUztisrFc/pf33y6notIvVbD+jl0fg5FhuWqeDBnerq3abz0YCWQIZfL29FGJO
         OkRNXgi4jNUedGWeEK4urA20qQBfX+EyQDrbjIuHmpuoFr7kG1cwyVPw/sogWae8NTFW
         zqZuDGYl4MQ5dQYrN1ND7ExwWdIjHhizXdxysYkC3d1FbujNo3gNJ+iT3VyZ4owHvvnA
         bIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765525518; x=1766130318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MjqsA3Rk0Xp0l1r6js0wRRyT/FYUpiPjVmpKyrwUjoc=;
        b=MBj5knzeGf4YLpiH0WJIB9P1SI0mTs/pEVBOj/J/Ok/r3DUeZdoyKQosyu/iu8GjCn
         M1g4ykbJmlh/D+JjXerc11ihrVSdudRXvkgA443OC99lFzGhxbzAYBsGAbyGwKgifqq7
         Q5sAsHoegL38jrBcZYAt4JKyI0oe0TyCrWe55Hex6cNSPIdAb6WTyT+Oy3zJdOQP3ZPC
         3XoSibDg+7QJDf9PweZ9BbITUFvk2KxicqheWXEHcrym8JuPTerVUwhEEMXugrbDJMiB
         Phr4tU/wlYu2oCO8BV+7sy6v6GiNnJ9NiRBj9zlIZ7BWrNrxKIIzjSHDZxwF9PAxBu8G
         8Nnw==
X-Forwarded-Encrypted: i=1; AJvYcCUk6w0q476N8AHWePutmUSKcNX7/gdDrWczy57Xgo5CMZ0+D6s3YWua1fnGpKZTEvlopcNfDu3sHqBj8g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzJugtSKqk2l3RAGRMkSDrWfx2/q5KbxWV68kduq4AQIcwJGxsA
	4xGCwcV1XTh/A7n5KDTMJBATUCsukTVWewYIZZAJSW8hAMBsUiyV3PGHkCkP3GDkCGU=
X-Gm-Gg: AY/fxX5svN2XNYstTZTUbjJ6WDUTN9ueeVgqaJhNT+TezM+GEA6BGAzgvq0IoGC83Rd
	LR9lA8SWZoI4lJzivTLug+YfKCsZyX+WKMkZ/QhjdrWpPxk+HQBeBmmysDSOBcw5Tl1Yur81q4B
	mCizZ0zB/P9JC9X47HhlH+dz8FW9e7sLsDO99LkwF4KvVgHhT8Hy8aSVyVYxVrSb6ds0+aaBHj8
	oWwAa70euo3Xgk01/lNHdei7VEk5g+Q4yJhEuJ4iUNvaA5y6efuHRg0n3zPsci5C+FYl2u3f1Cn
	G6jdQJsj8ZOwcy5iGVnRFK7hU1BtOYvrg4fJ+VRud/MyXVSE1K5ptOzaKfaAWb/KAuzGjm6q3F3
	k7KIuuCyeo4xE6vamln5GfLiMdKGZFYFbUeeFO/1bF8TNH25FK/eZQP6JiD4V8iLrGCetxW6G3k
	Mrk++xnnvKYfE=
X-Google-Smtp-Source: AGHT+IEjuwAfIHrDjNbY3jvvOm9cGk1SelVLWKi9CsNogqTqb7sT5nmS5zEZUcqgR+NfnkAOy6BG1A==
X-Received: by 2002:a05:600c:4f84:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-47a8f9187c7mr6616485e9.3.1765525518589;
        Thu, 11 Dec 2025 23:45:18 -0800 (PST)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38adcsm45916975ad.30.2025.12.11.23.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 23:45:17 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v6 2/2] ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
Date: Fri, 12 Dec 2025 15:45:04 +0800
Message-ID: <20251212074505.25962-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251212074505.25962-1-heming.zhao@suse.com>
References: <20251212074505.25962-1-heming.zhao@suse.com>
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
 fs/ocfs2/export.c   |  6 ++++--
 fs/ocfs2/suballoc.c | 26 +++++++++++++++++---------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index b95724b767e1..9c2665dd24e2 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -74,8 +74,9 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 			 * nice
 			 */
 			status = -ESTALE;
-		} else
+		} else if (status != -ESTALE) {
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
 		goto unlock_nfs_sync;
 	}
 
@@ -162,8 +163,9 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	if (status < 0) {
 		if (status == -EINVAL) {
 			status = -ESTALE;
-		} else
+		} else if (status != -ESTALE) {
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
 		parent = ERR_PTR(status);
 		goto bail_unlock;
 	}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 9a19f5230c8c..9b0ae1bc445b 100644
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
@@ -3168,9 +3168,13 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 
 	bg_blkno = group_blkno ? group_blkno :
 		   ocfs2_which_suballoc_group(blkno, bit);
-	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
-					     &group_bh);
-	if (status < 0) {
+	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
+					     &group_bh, &released);
+	if (released) {
+		quiet = 1;
+		status = -ESTALE;
+		goto bail;
+	} else if (status < 0) {
 		mlog(ML_ERROR, "read group %llu failed %d\n",
 		     (unsigned long long)bg_blkno, status);
 		goto bail;
@@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 bail:
 	brelse(group_bh);
 
-	if (status)
+	if (status && !quiet)
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
+		if (status == -ESTALE)
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

