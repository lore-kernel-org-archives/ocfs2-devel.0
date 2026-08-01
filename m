Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096D7381B04
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621672; cv=none; b=m1G5EY30gulZ02i5lR92Cr1lrbTAg2bCg+GivDn87xrF5zLvL+23JBxiQpwz8MT44qN8xHsUVICXhAF38fY/9BgdKD2XeXfeSnMFUmc9qK0h5vnQUQEWSdROZycfbK+A8o2Saj/wWlkgSt6Jn4frtuP9KkJQKm6vGoZlNGw6PMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621672; c=relaxed/simple;
	bh=dHCSXwhqSp5ZYzPgeTI83J3l93w1hXqXrOBDQtAfTkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdhNpLeUlyDAnhR0vtXX/FrIPpNdWlxdRL2FzlT/O2WKVlQXkK5qNfNbLBAU7JDcjwgBAKaUi6P008G/SyKdEPlEfEEeqC8fDqQtef1s9wK/rNbovnqlixLRpKoP3YxnABPTFgMieyYoZ20ZnXkfMp19leTZ47ZLjwG3yu9bGOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f007liow; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f007liow"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-667971437d6so2875894d50.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621670; x=1786226470; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/+4h8mFnc0QJGTHkSaUWdLQ44MjYcXD2X7Z3kRsV/c=;
        b=f007liowRKL51rsSdPYfKpl3kGGrMsKrN4MUPj3LuOYW3KiOPJbWBMWqeGi/vM1x4n
         4NFFxNKHBOEkkFDf06x769I9qDkclOMgzVpElT4aUY+P7fGEuS801QbmJlE3SXAm764r
         gtI7lCbfOXet660GtUVoY9ZAVZzgODC4r0ej4Y6z3ELNck47T2w7e9XJ7Q8PoXfRgI2D
         3z+I0CPMIrPewRrRzW1Lmz20/lpf1e6NUJPPLwl54J3zvONNF/uTirMjH66ZkCiV6O3c
         d//2ubxpP88Gh5HIk0N9RkFi42WUCTl7riuNGA8VlrK66UwURQIyFP3XHv3Ks2qFxKfK
         ZmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621670; x=1786226470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/+4h8mFnc0QJGTHkSaUWdLQ44MjYcXD2X7Z3kRsV/c=;
        b=XTOAJQcwOc3etAdMGdZN8sAu+E942WNkp215Ps33yidHBRr3xkLAnN+mzl/mmMekvM
         1m4LzW9MOPddn3rEb7i4RmG2HV5MIYnc2zSI6T5DzbPeyUx3euefRybvdcjKx1VnwsTy
         XIIN/lUv0L18+AZkMTD1VCgMiLop0uLsP1RjDd4os3Vqa8ScbvOH1s3dwTJHqc0yIqLX
         II/uRVJ+b+uUhjjTcD5egpbAdyiFFvNG2kfi/IvuqzLYhYrdd4slsLZdaO7ugvLL00HF
         LFSDxeIwwaARU7BjxPw2fJvsbOOF8khwmYkabjBor7EYOfqirNuTRL0SW0pWxkI8RTyE
         53rA==
X-Forwarded-Encrypted: i=1; AHgh+RqNAVzdB3AwB7MZLg442lA4plalKSLYtFs6kJV0xSx+DPbscUMrl24pDKZZoKZXG8YDT0C1n9IjNKVE5A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxTK7CGqRBRdde4q+t9tLuZtoknDHOPUW0oIqzP+2YFbm4thF1O
	321l1o7O5oAfsTyQgI40RVTmx+XS8/LH27rRS6Usj2NiDlO8Z0QnYvEn
X-Gm-Gg: AR+sD11SDG74j0L3wjwH7A0WamN8xumz5Nx8vXoh9WNdibJnLSe1gkLxcufUXT55WB4
	u1vncn1/Sgo7hm+lphm0dUxze6KFzMsQ9YGR41GSxZiS+D1hV6pLl30on5Rgi0t2wjf20FApD6Z
	buIGFq6k1VhytiKNxqvXtE9rkpANG18dMuya8qXpZEqns+/iHxyJt6zExsyDfuoDvLiSIjMTZqc
	15WS7s8nCc0QaoG5BVgonEwhClVC6ZAbPPVAoirCCyXZoGdGYO5pKdI7xhJAUV/TLRNIsq58Hot
	dcGzTIAVPGbH1ntCZwj2TtThQcppvQ9yrbhsny1BpIclR9aSh+31XOs1W92du+aGySSF/Vud+uK
	A6HmgpcXch30CRRenmZlFallhBI7SnKeVSetTxebhcFxDiEydP4hJZm4/pUL0khqgOqy2mUKyrI
	L9Oj2J94FsxtUuFl2J24JJszNgXAOhgYCT2WePYKMzJrVosvgR2/LPxcqeA1igOHYApmFYRxU83
	JzQKEX0hmj1ct+iymEhFyafMNGkTw==
X-Received: by 2002:a05:690c:6203:b0:80d:c2cc:f673 with SMTP id 00721157ae682-81fd4b72857mr77020067b3.20.1785621669974;
        Sat, 01 Aug 2026 15:01:09 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:09 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 02/19] buffer: allow a buffer_head to point at memory outside the page cache
Date: Sat,  1 Aug 2026 18:00:46 -0400
Message-ID: <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

jbd2 builds a temporary buffer_head to write out the frozen copy of a
metadata block, and that copy lives in slab memory.  Today jbd2 points the
temporary buffer at the slab folio backing it.  A slab folio's ->mapping is
not an address_space, so anything that follows bh->b_folio->mapping there
gets garbage rather than NULL; mark_buffer_write_io_error() does exactly
that, and we are about to start calling it on this buffer.

Rather than teach every such helper about slab folios, allow bh->b_folio to
be NULL and let b_data point straight at the memory.  Code that needs the
folio has to check.  There are two places in this file:

 - __bh_submit() adds the data by virtual address using
   bio_add_virt_nofail(), and skips the cgroup accounting: a buffer that is
   not in the page cache has no owning folio to attribute writeback to.

 - buffer_set_crypto_ctx() returns early.  fscrypt has no interest in a
   buffer that is not part of a file mapping, which is why it already
   returns when folio_mapping() comes back NULL.

Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.

This is deliberately not a general capability.  Buffers over highmem have
no permanent kernel virtual address, which is why folio_set_bh() records a
folio and an offset instead of an address.  A folio-less buffer_head is
only valid over memory that is always mapped, and must not be passed to
bh_offset().

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index be8b57a635cd..04fcc34e4fa6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1099,12 +1099,16 @@ EXPORT_SYMBOL(__bforget);
 static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
 				  gfp_t gfp_mask)
 {
-	const struct address_space *mapping = folio_mapping(bh->b_folio);
+	const struct address_space *mapping;
 
 	/*
 	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
-	 * for a non-pagecache page.  fscrypt doesn't care about these.
+	 * for memory that is not in the page cache at all.  fscrypt doesn't
+	 * care about these.
 	 */
+	if (!bh->b_folio)
+		return;
+	mapping = folio_mapping(bh->b_folio);
 	if (!mapping)
 		return;
 	fscrypt_set_bio_crypt_ctx(bio, mapping->host,
@@ -1142,7 +1146,11 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_write_hint = write_hint;
 
-	bio_add_folio_nofail(bio, bh->b_folio, bh->b_size, bh_offset(bh));
+	if (bh->b_folio)
+		bio_add_folio_nofail(bio, bh->b_folio, bh->b_size,
+				     bh_offset(bh));
+	else
+		bio_add_virt_nofail(bio, bh->b_data, bh->b_size);
 
 	bio->bi_end_io = end_bio;
 	bio->bi_private = bh;
@@ -1152,7 +1160,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
-		wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
+		if (bh->b_folio)
+			wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
 	}
 
 	blk_crypto_submit_bio(bio);
-- 
2.43.0

