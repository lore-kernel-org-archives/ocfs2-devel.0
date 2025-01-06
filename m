Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A315DBAB
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736130887; cv=none; b=JzIe/A0j1HyWM+AJbSwdJ+QHzjZ3bsC4outWzhiJYEQg+VsvofNxaI02INLJblHYD0sM9SdPzkdeMoYmteqPv6ffi+BHl502Aq8LoHmJgLjvEaOw/vVZAZ0Dy/y7K6CC/lCdoV0C5rETLlJr5UvexcXYOktCHkiyh23Lvj0i8JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736130887; c=relaxed/simple;
	bh=5wSmjwSD0Sky88bUTtWumdzgl+HUcDVcosQJFcoVRS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CAxFUlT9QY2E7gdAIpPeWrlywaslrNY2lr24RF2nTZO4WHI/7hWW9PtD/IL2ZRfAKBPaasjxLg1TpktCgurMC/rK9fDXdauA8cBCEvXYls6CAsnyn5j7KWA5HYNfq4h9YB7bBierQSSh0OfszXeE7bOlLKxImH2IUUXrwSCIgbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KFxWEt1v; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFxWEt1v"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f441791e40so16026703a91.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 18:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736130883; x=1736735683; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQDQOQeyNY1i9hUyFgugwaELSGoEdA1ttHIguGj6Xpk=;
        b=KFxWEt1vRPet7o3tTkn5jgmKm0NjhbIGPcqhFH0pc9pQnm7MHd1vMcNZ9xrQApEMqJ
         PY184Oka9jDM13W6RdePZMUtkKHXlYUGS/sBpbkJ3vxg4lrFySxbSNcPSv2bvRpnuZL9
         ACcwxfkf2MNy9N5IMe1BB1ovIOuTZwkrLlRdwRpnCx7wRlhI9DrFsAou2A75z9z6GH4w
         ZlZLfS0CCNig6qVxbNJpLXJBzY/1wRNlr0HxyGEe/QAFEmry8fNZHwkMVahsp3xvFca3
         TazHVSVTs3UzgHSr22HnijbF4WmWlkO1II9hC1jnr+v2Mq0zFHi66aZW6UpP2kt/yUw8
         Ji1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736130883; x=1736735683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zQDQOQeyNY1i9hUyFgugwaELSGoEdA1ttHIguGj6Xpk=;
        b=P4YodbJ/E17we3Q/not5nISg7yu9FDFo3nWAqAuq9Ej22kiQaej1lhh6E2zac6O7PC
         iVtXcRKsS13pULPvKxzuA1iTSQoba6fP//lwLUsTUJbMR+w+J6vWdLeXNl2YQ7Tl6khj
         Dc2EpEhJPUmbsEQoX8rKt3VMXO/ec9NWfTXI4KZR8GkTw9YclsHKgg72eFqgDLcKTZaz
         M8odt/vrqJd9qwgdXyk2rZWwxCirDFliBBxeATaflX4o/em+rhKeaUBeKkGY3KVJe1Zl
         scSVOP/6k7ARiGnyz2KnGQ/vxInICX6eXOfosPZG2CBbXEt6UeBtzZ3RtKg7/UQXov9p
         oQxA==
X-Gm-Message-State: AOJu0YyOYnkHO2czTNH+FbUka10KtMqrTuUpn2LTZun4xTbiQ7av7RY4
	6so6hGphTkiENXyRm30NpiGtMWuTN4CNqkWoaDjaLGPiNwgY9J/5c8SI3zjLing=
X-Gm-Gg: ASbGncvzCubzNHlmcvx/E25fhyRHp/Q1lXSJvPt/BnjODRIYfoNjBlHSV+X2SZYudPi
	Q8cbel6bA81r2iriYeFXxzxUsjcKGDnfuDMR/nY3wytNrDu54GZ6GGmJWDYWDPLnmm+YC5i4bNn
	rdkIZlh7t2fHS739mg/Nhhw1jhFcONaYWx6P1WvoIBfGcigwXdi6JrHMwkcCOi1IgWMJePFWNql
	pdOvI5ZUF18c/U24SGt8YWsyvImS6FP+nX4ty4fIf50KzM+qJlC748DVw9YPGkRNBJJKr7lcHC6
	/WvvzI9itkMsig==
X-Google-Smtp-Source: AGHT+IFVwFNNssw4ZQKxskQ60+BL+mUP5vIWfiKZXvblvQpB9eRMqeFKUfQLxcnmgznoG9RILxFtjQ==
X-Received: by 2002:a05:6a00:8087:b0:725:d1d5:6d80 with SMTP id d2e1a72fcca58-72abde65a85mr74750218b3a.7.1736130883374;
        Sun, 05 Jan 2025 18:34:43 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dbafesm31001098b3a.128.2025.01.05.18.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 18:34:42 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH v5 2/2] ocfs2: Correct l_next_free_rec in online check
Date: Mon,  6 Jan 2025 10:34:32 +0800
Message-Id: <20250106023432.1320904-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250106023432.1320904-1-sunjunchao2870@gmail.com>
References: <20250106023432.1320904-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct the value of l_next_free_rec to l_count during the online
check, as done in the check_el() function in ocfs2_tools.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2cc5c99fe941..1c396c547d9d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -200,6 +200,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	return inode;
 }
 
+static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
 
 /*
  * here's how inodes get read from disk:
@@ -1547,6 +1561,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
 		mark_buffer_dirty(bh);
-- 
2.39.5

