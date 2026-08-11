Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3DC396D1C
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 02:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786416244; cv=none; b=tR7Ucfyl8ynDa1/EucrlbJ5GY131gFdAqJQJlMW3O1EbN/g6egPZC89TG6BEJeM0LT57kj+Yu38RhiEzqjy+vFd9PSASzoseBuRSUSiqX8LhVICtH/VxfUOHeZb0WcAAXCprav0QXg+RUObkmfo+IpzIyOo2uifTdPzohPPcs50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786416244; c=relaxed/simple;
	bh=Zuczg2SkP/5ojRcZFRKQ4ku4YS+3+DzDOBTJc2/A9Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWAen3KFSLEBKdvtJphm4kvGBBTEUIQP6J9SZZ57XefQLnhsR40obix89a8jCauYcup+Jhw38z8hpkIrTT/V0wLRTBHjaL5jj/eR4u6jCjv4UZYjaNRobG3UJftc7PB6qNdtB8Y83U86EvmQI7Qvwgz6N54piLuGqsG+c4StCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TML2o1bA; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TML2o1bA"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ceab75934dso29530225ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Aug 2026 19:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786416236; x=1787021036; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uFGDd6MJX6QKx/u+FjV9oJmCytT4Rq2gvVt/3A3Rh9w=;
        b=TML2o1bAD38cUq8e6NLR0MP6uFY9ny/wvov+s/TKGJb5/+p2i1Y2gX2qqJ5mVHOFLm
         0MAFcBWONNK1KltMTecphu0VI/X3W3jJ5Q6BjZ3FnttPLvMHFuyY9dukshH9uKKaP4k9
         vSMnrZKDNuBFoclHGwybt89IwelM2Zij57zGpp0NiR5NJiF4gvzpoQqpuXrrkHk2qkh0
         7CgovLEvb3XsjL+kNzO5ufMCkq95v4LEoPoLOui/I5Qu2Ru82vUMELhHNmEvmcSp7tI6
         cHylL8c8NxyhkKZ+G28+VHhsF4youo62abF5qAEw22RLGJ5RY+Wnh6OU4X0ElH0u9iZf
         gi1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786416236; x=1787021036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uFGDd6MJX6QKx/u+FjV9oJmCytT4Rq2gvVt/3A3Rh9w=;
        b=W625uxsBdiNGE5Z0KJhxJi3CHg2ereG5xXC/wE7aLtiQlFOfuhWtY97Xc2RBTmSkpO
         fFOGrFcVM/vJs7xwnUbU/xY/HepVXAVSxZiCdSuORLmpzs0UFJPAgjvSp/XmJZIKnQNe
         AZlUdPeriF6n5OxsxNNNa3UfOP7kH1y6nuSScL4ZoSL3gJZxBac3AiGdWpsFFviPLs4F
         EmJR4W/5Rwt1EnfrpJAWjd2gU0KIHtlbU0J3H9H0RG3xHVtC9C+LiZ/ePIv0if6ZfLhb
         l5OwkQHqqBS+WKnZxDROZ2zrX8DnC41hP81SNzlTbEZw9iSZnd1w+se8ldwmgY/El/gp
         T5yA==
X-Forwarded-Encrypted: i=1; AHgh+RrmNWtEKKWZgZ2NWkVh+8E60Xh3SW1o+/flwWWoUpiOBAJy1RoWQuG6k6eddfxxNddQffj+nZA5qsPIQw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyOTmsiZvBnW/ecTSoVjvknXwDKL0akpLnM/mXFu045yuI4M7A6
	tI67jq92yftCu7Y+Zqx11I0X3TPjpIdPvgJsM5JsZ+ZQ5iUUnIZHCrWS
X-Gm-Gg: AR+sD11wcLxr0Jr47O1rexOlfR7LbwrgaWkCtMkTUfZGlRehuxRxrsx6LEkdUqGSEdF
	NPfdTkuyDQ4Z/MefMFxBsRiNT2Lq/v9MT/7vT53ODMB6b+kdZH2IcDC/eRM5O+mYrQKOVgHtF/h
	fb6LKK16MsKVfYqY+95ZzXVUHrDr0MDTpfWREd8pGsSQ6TxBqHrCRuV7Lpx4SzfI9d+V61sf5Uh
	cIv9dwE80XwO79cfanlW9Zfn31EVaKKcYomtRe49ykgpXO62Pk2oDhrQLL/TZZBH4PKZGJZ7I1P
	5u6uQazVlRlVg/60z0LrgZPXG/adqmRQBWJTQ0WO9/I/577aO0X9Tl+9kYOS6YKjmkxmW0XqL4F
	uLzLAd/xrZZdFs7yGpwRNCTdkdDHEEmEFXJ9vO4lbz/qdU/C0PsiOfNdBPkaMNdazpXOIuIC8Sz
	85fp2zqKIql+8Dx6KcgvQT3UALaFnh2CXRHlQtRSBbuMHmoWnGro7eDbutzD8LFeywLbBKPWEKf
	Iu2iJU78Zw=
X-Received: by 2002:a17:902:d54f:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2d3178b48fbmr2660065ad.12.1786416236033;
        Mon, 10 Aug 2026 19:43:56 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3160f47easm464165ad.64.2026.08.10.19.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:43:55 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH v2 2/2] ocfs2: bound-check dir entries in the inline-data re-validation scan
Date: Tue, 11 Aug 2026 10:43:37 +0800
Message-ID: <20260811024337.3972976-3-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
References: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_dir_foreach_blk_id() re-scans the inline data area the same way
ocfs2_dir_foreach_blk_el() re-scans a directory block, and is missing the
same two bounds:

	for (i = 0; i < i_size_read(inode) && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(data->id_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

ocfs2_validate_inode_block() keeps i_size inside the inline area:

	if (le16_to_cpu(data->id_count) >
	    ocfs2_max_inline_data_with_xattr(sb, di))
	if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count))

and that area runs to the end of the inode block, so for a full inline
directory data->id_data + i_size is the end of di_bh->b_data.  A bogus
rec_len leaves i in the last OCFS2_DIR_REC_LEN(1) - 1 bytes of it, and
de->rec_len, at byte offset 8 within the entry, is then read past the
block.

The emit loop below hands i_size_read(inode) to ocfs2_check_dir_entry(),
which refuses both an entry that close to the end and one whose rec_len
runs past it.  Apply the same two bounds to the re-validation scan, reading
i_size once into a local as ocfs2_check_dir_entry() takes it as @size.

Unlike the extent case there is no mask to corrupt here: an unbounded i
only sets ctx->pos past i_size, which ends the readdir early rather
than moving it to the wrong place.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/ocfs2/dir.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 39ce60874e17..863c69dec7da 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1812,7 +1812,12 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < i_size_read(inode) && i < offset; ) {
+			loff_t size = i_size_read(inode);
+
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= size &&
+			     i < offset;) {
+				unsigned int rec_len;
+
 				de = (struct ocfs2_dir_entry *)
 					(data->id_data + i);
 				/* It's too expensive to do a full
@@ -1821,10 +1826,11 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 				 * least that it is non-zero.  A
 				 * failure will be detected in the
 				 * dirent test below. */
-				if (le16_to_cpu(de->rec_len) <
-				    OCFS2_DIR_REC_LEN(1))
+				rec_len = le16_to_cpu(de->rec_len);
+				if (rec_len < OCFS2_DIR_REC_LEN(1) ||
+				    i + rec_len > size)
 					break;
-				i += le16_to_cpu(de->rec_len);
+				i += rec_len;
 			}
 			ctx->pos = offset = i;
 			*f_version = inode_query_iversion(inode);
-- 
2.43.0

