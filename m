Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C428E8
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735909959; cv=none; b=lcjgM7gCfMvOhuDTcCxm52MhdypL9Zl9WrsdOh9v07iQDb+v6ri+ygvfajGJlnzsyHE998OEa3ductYAzzq1xmWJOdUq/NYNMZCtvezr7OzULxjTXQ0dnhDcyG2uLR7Y7X0RUuCpnWIwtFhBEZJCfAYhO9fuHonM/rYb5NOZExI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735909959; c=relaxed/simple;
	bh=5wSmjwSD0Sky88bUTtWumdzgl+HUcDVcosQJFcoVRS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DfH/P7/BMaEaSn3spnK2QH4AEoE2iCZw9JKUnoCwbUaYJI9TEOy+QYFR3zCvC4Sfsxu253q565fhDdxzyTUEg0aFzj+sd29OzcalRHK9AmhcAyWexU+80Z95OORN0qvdXFn641mtvLeOfBDoUYgCXAN5yCgulpkNArRDe8cye0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOUiCq8L; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOUiCq8L"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21644aca3a0so92464665ad.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 03 Jan 2025 05:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735909956; x=1736514756; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQDQOQeyNY1i9hUyFgugwaELSGoEdA1ttHIguGj6Xpk=;
        b=SOUiCq8LLez2PNrgD297TH5o5dT1ZzwJ/nfMd/ePjkg82hqXvQqtCR3LY9nZQRNfoP
         uSPJmNAg4b7HgSOwiqNb27JDMHoQuM6LlB7VA03D5O702bEg2abG4GYK3y4B/SjQ+tbS
         qeuHZuIr5qI8CTyHoQsZDwSOrAuFJxv39j/3FZZT6RpKFF0knHeLnms4dGGsPiOboWGX
         EsrdLzTmVKR1YfDHa20pABm9RkIWkXLtM2ZfexZfMKzUX9bWAMjfSSlEKxaCwzSDO6Fo
         r3Yb25O81/ByouozvJPgoadDbUiIE6tIuuhkfyjRaOXQgBVYD6Goabk2z0kaqvJHlvw1
         0kyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735909956; x=1736514756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zQDQOQeyNY1i9hUyFgugwaELSGoEdA1ttHIguGj6Xpk=;
        b=vouN6bIRvW3hmKc2O3DbuI1CmOWtQQWOyi+noHiTsxrtzqVpek1zi42VbWwvGlkHua
         BuWUR0IcUY+befjn4YS5qF81k9ywcQbpz45pow6UwDjIQMGv8acvfh/z9bhX8KLmNtRT
         HhaouAlT4++eZqEoEvvOqh64mLHs1NqtQDNWiXyzGWQGTHGUEQ8vDmH0hKODIythyvNE
         GyQXeNmRrrO9CMuQIFyQiYdCe3h1L3P7yjrxyU+Vt75p5ptMy0szekcwCz04FHNjnAbi
         tUN4+UP+bMW+io3VnKuoSdfTdB/+7aTDLd/SJOHMofiKK+cv8UqlVDix19st6D6I9NlY
         /DoQ==
X-Gm-Message-State: AOJu0YykI59x0v6Dsl7zqBI10Te51LWPkP/WJQaEsZwMxUx8hfX6LpMv
	loTWuH0bRXjbbeeKJkf1SoIQuU455gYAC4XNKd5ENoNE1tzI/drkwhgOi6Eta9Ryqw==
X-Gm-Gg: ASbGncsfZ81fzOqAhIEwsM0F4cw0NQjs5zLiBjN2xQiOCkQcQdFn8bY7L2hP0OmePgV
	owxobAE0aCwSxBgLwiT4BN3p/NBtvl/fkHQ6f9AYdovj3uw4jwJCY58/qyfCReWasPEdKi0NExv
	hdK/i8TpndwoFzqe3TO4MW7QIREcAiHkTYYee4sg54fygMzLw4DOpDYIyhzsZqit9I7T/Ef3pSP
	G+UX545StZ8cAbA0j94VVPNJQoXydfdQjtm+eWZCg5adwv/06WgcHGIYrr82il20f3UaBWtupKu
	VI11LmYRjbWFjQ==
X-Google-Smtp-Source: AGHT+IG3fdokmT4lMZkgBvA745Cwa+hvBLsh/p09OWQ3aR8q09kYp75rx6VKlzVCD5GrD/PgHUMGDA==
X-Received: by 2002:a05:6a21:3998:b0:1e0:bedf:5902 with SMTP id adf61e73a8af0-1e5e0458e8cmr71539144637.6.1735909956470;
        Fri, 03 Jan 2025 05:12:36 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da75sm20323932a12.36.2025.01.03.05.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 05:12:36 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH v4 2/2] ocfs2: Correct l_next_free_rec in online check
Date: Fri,  3 Jan 2025 21:12:26 +0800
Message-Id: <20250103131226.1262042-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250103131226.1262042-1-sunjunchao2870@gmail.com>
References: <20250103131226.1262042-1-sunjunchao2870@gmail.com>
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

