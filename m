Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B653B14F9CC
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 03:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735874931; cv=none; b=i+aeihKkol9gMd+5cikbU/xhtVvidQg81mium9dpokNVeyj2UYy0bAkrNueNAcY0wCPCdClvxZ3H6NmSTq1AUJEjYxDxUOlRA6kSWgo1oqlmI74Hi42a838xXb6ioQwuoSGYZYoPmopD+ZR4hjKi63vhXmF2TMJUG02hFgDhs88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735874931; c=relaxed/simple;
	bh=HF6CLTSBia3PN8p7gsra1zbLOkYyiHLUcVSbx56CRyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LX2UmnOlWUAZgv68JC/E+YwTRuPWd142exClewZ8gjzVRH7UY9cb+lBbafoX7CHU6AAIMb7pXXl9L4LYHPQB9jUJiSs5+/laOjM4tkJiKoj8Q5fCN/oJtleF9W/4OId/ukJypU3dMzvvE0Pn839z5jIsShTRcFRstsJllYQnQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSGIKl4o; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSGIKl4o"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee709715d9so13251035a91.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 19:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735874928; x=1736479728; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPw/+eEI6q85PypD7ZdL/BIEur4VeNZSSSnVlY4IS0E=;
        b=mSGIKl4oymtdDLnw/HxzYrXVTgTB9A+5Budzi2RlJ6rx1krMs4Pwz3jzw/AU0/l8cJ
         dVrzbJor5ZVLJjC9NCapZD86NE6IfgmhDTGmK4pl0y6jXS22d3uy+EpkkGbOrIjOp9A3
         40KbmAbssZTlOMlM/8rvBxLYl6r1+FfXV0xpNOEAF1MfxO0eWwfqbczIKvkOkkdQw56+
         1FQ3kDeIMq1JL5jA6uOxJrUkCB+km9ysMD5MG503uqjnQ5I7swTjFn4+DWCfwhfuzSdy
         BN8fEYTF2MQsK0TgF042CLrdB68NJifqznOvyo0Ku9TTQ4d2SsKAsjvEp2RS5jXLAqVI
         UnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735874928; x=1736479728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPw/+eEI6q85PypD7ZdL/BIEur4VeNZSSSnVlY4IS0E=;
        b=XcToRlkrei6rxZVF7fCP7snu05eJgk+Rs0NKZv1RyvK/xaESk8nMk8MxChxYS24gZN
         WSz9pNV0jV9ojRVAoklMcf0jhC8wpdt1Jz8AxcWDbK238VsJqwOFMvUtj3mwgURWmg4F
         dOCl1TSaD8kiDeo48WrenViegN819UNy15bAqzYPGxQEWr5zg1bCwQqyzaSHgqXcEoDC
         XSH+kXZkhlkD/dnaGwIVKiWtZtq7ZeAwQsBx7WontUdZmiEUQNRP+npHApT9XqMMPKdI
         s2ddkU8GfrUcO0Wisj8GitbD2dBZGnIcRBFSIjlJ2gnZ5AHuKIqGMdEBVehgwBEFhkJ+
         BmHw==
X-Gm-Message-State: AOJu0YzR+rIzbC+YOykWnaAakHr6sTdRrcG7fmYUFctASjMA5J10FITX
	HTMXbjgYbI1RpNCA3c7ZNtjMLWAgCcTpIenAbJAOIbaGmfIbWEDh2p8RpgDKmmrhSg==
X-Gm-Gg: ASbGncuL6U/SdA4vKzHYho47ssXKllnDdW2tcXIJGvYsw7SDPXqeq/s0Cuk2iLbd/+9
	ADzuTh56se6x9PD7GzKp4vfNbRBfFd2Y4y5aKlqWUgUYNU+tGfRJrRRd6bRqtfkSOxJ6T/s7Nm7
	GhsP0MSbXQy0bakpCyLWG/tE51KyVKBcL6PQY1u3o/PrRonBMPIXE6MpB4JRsBhHi6yhOOu8pNB
	MDgrGrn8uwDwKEiF4dVWt7dR26y2aBK13Sj82Hx6vreWTCL+CpVQP2AydGBt5L7Y5Q+PjEht4f5
	aXDNUdN+1Oahow==
X-Google-Smtp-Source: AGHT+IG2H66oFfWraOKFVtXPIllnGugDg3hmy4cJYKt/IGUYuMCzC/6RyuPmaaVkn9M3D4+E6PfXMQ==
X-Received: by 2002:a17:90b:54c6:b0:2f4:434d:c7f0 with SMTP id 98e67ed59e1d1-2f452e22c43mr88191962a91.12.1735874928019;
        Thu, 02 Jan 2025 19:28:48 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96eb40sm235622415ad.86.2025.01.02.19.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 19:28:47 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH v2 2/2] ocfs2: Correct l_next_free_rec in online check
Date: Fri,  3 Jan 2025 11:28:37 +0800
Message-Id: <20250103032837.815858-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250103032837.815858-1-sunjunchao2870@gmail.com>
References: <20250103032837.815858-1-sunjunchao2870@gmail.com>
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

