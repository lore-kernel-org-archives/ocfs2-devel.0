Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1216199234
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735821953; cv=none; b=ulT2f6BGstAYO3TF5u8XRGm4feMTYd1+pNdKPbAyin3hfG1ZNJ+rQM84nL0C7uYJjFuOdiggNfiGdHmhmKhneukjSXGpttqSi8opQbenLJ1eLVrTVXToRdDIyEI06zms1C60tfNUZllp0mm6eeUxbGwJ4GHmigs7+YwRsAkbMcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735821953; c=relaxed/simple;
	bh=zEAQ6vKzKREfX175MnQvFINMkX1gOiZSY69GxUrCtVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hNWQjHRBvM4YTsGukO1WE2ra32HlMNO1L4OFkLVeUa1l61fBopoJKzfkpsX4Nsg/XoCaLlUu7FFql2kcKZTYOFp2w4hSS6w1DUTWGPS1FcGVDXQCYGCuJybXd9RX+bFNV4V/rbhUjCFt1CuKn0HyefGMoipVcWlUis/eS0yT4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gZUK/b0x; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZUK/b0x"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee46851b5eso12581097a91.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 04:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735821950; x=1736426750; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9VK6qXILh5tcRr09gUsyIzzu7IeYa/AwhNzAUo0Mf8=;
        b=gZUK/b0x8694VxQ+gnS0ie8Xa9tAGXHlpx0+eJccfSSWokRV4yn45J7T3DWnP6sCYc
         zNFBQqthm5t+jPvFXytmVqWAzngoncOCZlnEb/ahCyCuXF8JlKEeg7mudqS0vsuucC/7
         0pZuHb+O8Ef5oXXlhL+OnP40yZfVdgdjHKX1pibcWQnKHc2UFeXVO07p5znHsBy8iIff
         HsQMH7u0BveNle87/5PBsFoLMqE6s6QnJOgGVEjPIz02WbovCRE7Tnnzfk7kexcU1P8M
         EgQOuvEX7l5pN+h3SFQ1jLP0Gvb/CQiUZZSmf9pKfhtQ7L2eqJIwNF2CJMyV7G6vM5CX
         83NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735821950; x=1736426750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9VK6qXILh5tcRr09gUsyIzzu7IeYa/AwhNzAUo0Mf8=;
        b=cmfq3xg5RqzAatzQOomsEFI7ZUlZGKsoNjSz078y3MuSJmAvwz/bQSnu9QPut1UP9d
         viTyQJUnj08D7Kgls/nix7Qrm6/ECzWaKKR7JZcSMFE/b2EImBY318rIcz/kblF9nKmy
         j0A0CQ2JxOCzDGd3wM94Q5OY8I4FKA1SQynSc9x1sl9BaadVLoUzi5Rw+TfoY0x2APH3
         iVIuPRDoaxqqOQNXqD7gesjYkYu0lHSv23rOIsjZzw2c4hbGD9sQ5fwXn8EULV6WscTc
         YLfXuMvtEgls+ehNQVHm7P1Knm68ZNAmWnr1xp0vRnke6Zkbp9YIwEF+0p7PnZjUfRn9
         d4DA==
X-Gm-Message-State: AOJu0YzOxH/8cVGV2e72uSW7j2RW/4PneIWoxzdy8lPJxoAtL2got/G6
	IfcanQIvwCJB5gTfglvuYcgnY1Xob6DHgdCPWHvWpsOAKZ51/YTcdt8dx6cb9jc=
X-Gm-Gg: ASbGncu8zh3rM6saZYU+kos3r/vgyqMaiyYpGAsQTE+ZHdgfxjt8352O5wlV72mzwUY
	diZGfU2B3TYPIMmz+/6khFe8NYyBx1hlgKvEBskqA8ROT8kS3CkHsdh8SXYF6JUlIxu9r67Vmy8
	/7tjivijO0Me7u4aw4zmndRMJSRlEwyalGqaeG/wwy7IfgdTwai7jCe2gwXhNjok7CvtifvvDs5
	y/SJM8w7rAX7FVVnrpjaGMHJCGtwSDRFSa/BaFlf8L2NZmmnSdL8uTJvwbnuJqfQ+3RUl8c3oZ5
	oFc+M9UoINazFA==
X-Google-Smtp-Source: AGHT+IHSkcQbq7YULpAWPqowM2uAUWW/WEx/r9j3DT9Gq9kKrEVIdnfAVkqRwy8Y41Wa7ODJnlJt+Q==
X-Received: by 2002:a17:90a:fc4f:b0:2ea:5054:6c44 with SMTP id 98e67ed59e1d1-2f452eeb641mr57199257a91.31.1735821950499;
        Thu, 02 Jan 2025 04:45:50 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed644d87sm30977652a91.27.2025.01.02.04.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 04:45:50 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 2/2] ocfs2: Correct l_next_free_rec in online check
Date: Thu,  2 Jan 2025 20:45:39 +0800
Message-Id: <20250102124539.711325-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250102124539.711325-1-sunjunchao2870@gmail.com>
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
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
index 2cc5c99fe941..c19f40b4c876 100644
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
 
+	if (ocfs2_dinode_has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+	    le16_to_cpu(di->id2.i_list.l_count)) {
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

