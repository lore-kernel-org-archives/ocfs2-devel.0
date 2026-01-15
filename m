Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1A82C1585
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Jan 2026 04:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768449614; cv=none; b=lUZbD/aP8jFOapPYP1SDk/b23GLqt6O4lYDyVc1WXfwl+tyJcOiATEfAOE5ICdcOYzO5qwlaLfsgjgvVUgeXJNH1LNyFLYORj7BN30P0NYdAxHCRB5pI2pSWo9B14ydEDsCqOl3gyVAKk9C8Xy7Vdw3bIma6yoJojXfHl+vI6rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768449614; c=relaxed/simple;
	bh=hvz2ebM7EOpFqS3N/v/MChB5H1STjXn1fFz+OmMe34A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e3QPE2vUT6cPRAGsC+NAN6V7X1175vKKvsqHtT7DjRAXcBspVPuJZcDHZh+ClZ7dpEkpSkCT59xaY2JvNdhrwoXKLSEORaNjGr83gk3n1kjJMCct7lt60ayg4o4HNj7NdlgD7IFfbeszAZU/qChKAO1DWkbxNmP1+ExGYvQH918=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=To9b4HMr; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="To9b4HMr"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3fe3cc80bc3so330244fac.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 14 Jan 2026 20:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768449612; x=1769054412; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Ge1Z0GFCCZOzRKO0uD2f8C3Om46pRhHWG4akWE0ONk=;
        b=To9b4HMrJLfuBsGay6+lrNdOKpsT0mjy2e3JYr8/x6NjXGOsnVBHba6tGxqvd3PhFH
         iVV+ZejBmYvw4mQjUeOW5pQC77ieUcC5ATLWsHWb7rNpkMNAYu8IwTd8ModAxrJm3DC+
         bcPyF+OWVRuFJPLlVlQby1YLp/a/62ghBimSVeRYdwi+dlIeLDXT8uU0LE9PQRZGqdjJ
         WeAHyKbpUjUKWuYtqqpRTKkna+QrdNIS+pmpQ5w6Zjs8sJmSUxSlwjdLG6d+7upimWHr
         6kZA2c34pLBBRDjD0YgHFKiwSr0YZxKSlK5PqNkfMaH0Xe3Tas/zgf2O/cza5BuOkPAy
         aNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768449612; x=1769054412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Ge1Z0GFCCZOzRKO0uD2f8C3Om46pRhHWG4akWE0ONk=;
        b=CJqBhZ0j5Ls/aO14G9H43D2vl4pQp6zmyP0U3v1fMgbItaFvccmkmkdl8rNrTP6+GY
         pAS0FBzEJRk/1M0jkaw1K1SjPkhyGEJuxFQtoKDUYiG07zzQo8iOK35rXaRk61OImpmk
         qEB14qkx/9LoZ20n6xxcI5RNBABh16Kartyfpdq/o31n7nkq0uUNqhbU+Eio8sKTT7cs
         DvPAFZV+jCePY/9vShrbbOhXSFavmrbxYu3Fjg2NUjRW1C4IklqDRpwrK+a7GCAIuqZf
         1OYo9kobvfKuuZPg1f8BHwb9whnkFq/FdEW4ODJkKXjvg2ZNdf2i6kJiXZ4l2jGifauG
         gdQQ==
X-Gm-Message-State: AOJu0YxdNoC41nTijoqVc+B9mOi+25KIyw1eBVQ8w0FgA+GCSiNJuKFF
	p+Fges9imwf7EYFjZeIMJXyedE9rD7Xq6/+t+9qfhRjPBAoLV7fIXgYD
X-Gm-Gg: AY/fxX7XQLg2hTRodRUkJbHoigrPO4UYhJx7DP/eIHYaUEWsrOywUdL9z+4o6okNW3P
	3HIOWUS+j2WJ79IcvaF8yvZP309jfY2WOLv4eUzyIKUJnAnf8IEk1mWQt5QjoS/3VfdhBOINgRF
	+LY77vlzm8nn0c2kmW+5ir2PRmtOh3htYbcdzmR3nRbw7tJuIHdbvxKt5Etw8d3RNb5GDUiCAXq
	AGdvD8q+lIndn6KeXq9WmWZ1Y42MmRLABqqR+8NIV0tQSILXlgWu0kJfunKBAkz78sKTxzog4Yb
	2VnCH0RiiyAr6HdLoAEc2L5JrFFSHbNiXnHAqzNnm8o/+NTf5C7nYYa7PBihVyECUzJR6U9PXRT
	1Cnnu5b+0zWTdO42tkO2Ar4U1RCRRNynHVAKUwLsk2nf04VopoSBBIO1YK1fWVvfjZshBU/UUnq
	a7Sdj5D2+f2KC69ct1qD1SLYAvwA7uzI/g9+ztTfwGa3A=
X-Received: by 2002:a05:6871:6608:b0:3e8:8e57:a7a2 with SMTP id 586e51a60fabf-404071d0a36mr3538579fac.53.1768449612014;
        Wed, 14 Jan 2026 20:00:12 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4a9099csm18185550fac.0.2026.01.14.20.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 20:00:11 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] ocfs2: validate max leaf clusters in ocfs2_figure_merge_contig_type
Date: Thu, 15 Jan 2026 04:00:08 +0000
Message-Id: <20260115040008.13549-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_figure_merge_contig_type', the variable 'split_rec' is used to
determine if a split extent can be merged with its neighbors. However,
the function fails to validate if the resulting merged extent would
exceed the 'et_max_leaf_clusters' limit.

In contrast, its peer function 'ocfs2_figure_contig_type' (used for
inserting new extents) explicitly performs this validation checks
against 'et_max_leaf_clusters' to prevent creating oversized extents.

This inconsistency is particularly problematic for xattr trees, where
'et_max_leaf_clusters' is set to a non-zero value (derived from
OCFS2_MAX_XATTR_TREE_LEAF_SIZE). If a merge occurs that exceeds this
limit, it creates an extent that violates the filesystem's structural
invariants, potentially leading to corruption or failure when accessing
extended attributes.

This patch adds the missing verification logic to
'ocfs2_figure_merge_contig_type'. It ensures that before indicating
CONTIG_LEFT or CONTIG_RIGHT, the combined length of the existing record
and the split record is checked against 'et_max_leaf_clusters' if the
limit is set.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 fs/ocfs2/alloc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 58bf58b68955..7d9400736791 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4424,6 +4424,12 @@ static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 				ret = CONTIG_RIGHT;
 		} else {
 			ret = ocfs2_et_extent_contig(et, rec, split_rec);
+			if (ret != CONTIG_NONE && et->et_max_leaf_clusters) {
+				if (le16_to_cpu(rec->e_leaf_clusters) +
+				    le16_to_cpu(split_rec->e_leaf_clusters) >
+				    et->et_max_leaf_clusters)
+					ret = CONTIG_NONE;
+			}
 		}
 	}
 
@@ -4470,6 +4476,12 @@ static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 		enum ocfs2_contig_type contig_type;
 
 		contig_type = ocfs2_et_extent_contig(et, rec, split_rec);
+		if (contig_type != CONTIG_NONE && et->et_max_leaf_clusters) {
+			if (le16_to_cpu(rec->e_leaf_clusters) +
+			    le16_to_cpu(split_rec->e_leaf_clusters) >
+			    et->et_max_leaf_clusters)
+				contig_type = CONTIG_NONE;
+		}
 
 		if (contig_type == CONTIG_LEFT && ret == CONTIG_RIGHT)
 			ret = CONTIG_LEFTRIGHT;
-- 
2.25.1

