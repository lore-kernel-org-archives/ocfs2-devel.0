Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CBD3B3C12
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035546; cv=none; b=CptjyIekLNK7oagulMHBeKZDTir2zggw+74c5zbCrjki1Z+9a+G5dPKy4rI2XkoqJ+yMalxUU1zFJyrqhTTeoB2+BMyNOgeESXSlUV2Iq93UGIyHnUhJndNhRYR6EqCRc4f3bcfA68Mvr8RDCEsLSpzqx88iIHkbt7lVBdEY6QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035546; c=relaxed/simple;
	bh=hjREzgpzo5QzVUOXcfPLZusIOE1tYvynFiHWCGrfyGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuzrohzSIT4q9rMD4uX2ph0ao6GTiz22NE6ZH2gSPz7bLdTzIE9KBBA38NWYJ3pWBu55dTwfkhjOZD0WHVf9F2yLf5NcYkfq0I4UnCiu/lnfTkVlyB4a3lEXlVnY6NvMv8vYkEck2DMmFPr5U+I3upLD/cJ2kyftzGkbNF4r16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UyT8GRhb; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UyT8GRhb"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5c375a9e76cso1468295e0c.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035543; x=1786640343; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k3JV3rYlfmcwigTL3Ipqk1+R5zcTkEoUEmgylrQxXIQ=;
        b=UyT8GRhbw/EJSbdhB7zqLsZRgYF0JF6ODsKR7myYU/NYrkv/Cs3eUv9FKLtteQjW+1
         iohZct22Mfdfy2WlwV/duPaN6Vc1YKNrQfKelqCGZQybA6A1ARXGSbTrMP3bBX75Izst
         JfbUvL+fSEYECLHwn7P+14bH6wcpTPIUOWW8MyP6mT8nkj1rmFCgiwE1KQ3l0mYhPMJ3
         7Pal8G8VcqwpiHeYXTyiFK/P9ZRU/b6B8Gefv5UNaUiZ5wEcR6yaw1uw/lSVgHqafiXE
         Uk5c/VkCCBSNZdNKVL2V/1sSTmSbnI74jViLltVKfQ8zuLZ7bj6rH9IrUw/3MRINhEO1
         yDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035543; x=1786640343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k3JV3rYlfmcwigTL3Ipqk1+R5zcTkEoUEmgylrQxXIQ=;
        b=SSfh3RhOZp1lTmePVSOpr9Fu0eY3cKiEzoi6765TSu7cEvWreCnK99eZX8tQeK+p9a
         bCMeQLCt3SdY0CXHBMdFTSDtlJeRXB9YbGDlb7l6ds/EU9E5p5Rd6r+yYfW8v2sIrPrA
         sWT3OnkxBXO+2o6q6vHiQ5UXscb4TM10hA+DlYC9JqqcAC+dHzL8k4Wa1ZBLNj56fTPg
         w6Grd5NE7PGn8nkUZvszSbk+RIySLC50lNKjl+iGZa3vf7TBeYUW+aXSlSQilvDZOHkx
         QhpmvpUAMWK3CD768VgQTA+4n4mUSEaZZFoEvsvMcugIkhWZFju07C0ZfX+CRp3x1d9k
         5uHA==
X-Forwarded-Encrypted: i=1; AHgh+RoyNWmcECnoN7AiFQw867ouB1nWIKsvze+Vx5w38ErQA3uwwG9niQxEviJ7KtHu7jt0Igp1zOkEZIW/fQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvqc1bCa+WX+g3mi13ivnrhTOVaz0dvD/JCByC35u29V73B/UV
	kuYRkrvyt8o9NssP7lYVZ72LcAVmZOkzZTVYA0XYxxAYtpiOmsiWxmlM
X-Gm-Gg: AR+sD11V+RAq4W652eT0iz1aLydvZzLwQASZR8y2xnugSqPsKTMqiqJ+776uB3AVJbu
	jmj6icFeU8c3Ey3fdCHK6R9goAyFu6otI+Hu3SOoM7vnjZFDgor5a9LJ6lzniUt29Jdu3T8iY6I
	5MVCnBDBGYBkKnwdzp6SDxEZO015ztFvnGca+VG9rZ9PjaDDooEMpwPudRZ4NJcGmk+Y1qDnwDX
	SMiRkT0dvik+KNiyJuV61eMxljenv3bIqAqtsX+OpK36QbZyv9R4ET+QQbg2HfpBGk4dRbuCuQR
	tuvBLqEu4gUjB1uZIR/Vbh6M4BjeHsF1tqPcpsW1ybGA5sv93FG8VqG+dFtNhgghbLZwONlHAmE
	9u48ICYiiE/ORFdQotJOTBpjcOsl+5aD1C3q0oPHtFMdxpBVv1nFophHAjaNMycTLAJa8dRx2q/
	yTO0Bv296/Vf2aq0zY4EEozNBNGTL/e7XiH56AlhTcI5S+bxMAKKzyUJ/CrEqxDGSXT/BV0k+hW
	vdpr2M=
X-Received: by 2002:a05:6122:8b8d:b0:5bd:ecad:8f80 with SMTP id 71dfb90a1353d-5c3f9e68046mr593111e0c.2.1786035543192;
        Thu, 06 Aug 2026 09:59:03 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:02 -0700 (PDT)
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
	Zhang Yi <yi.zhang@huaweicloud.com>,
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
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 02/21] buffer: allow a buffer_head to point at memory outside the page cache
Date: Thu,  6 Aug 2026 12:58:25 -0400
Message-ID: <bb6fab2111a48d7ba61887fc1372362576fce6e6.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
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
   returns when the folio has no mapping.

Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.

A buffer_head without a folio is a narrow thing, not a new general
capability.  Most of the buffer_head API assumes a folio and will fault or
corrupt state without one - touch_buffer(), bh_offset(), the async read
completion path, and plenty more - so it is up to whoever builds such a
buffer to keep it away from all of that.  What NULL buys us is that getting
it wrong fails loudly instead of quietly following a slab folio's
overloaded ->mapping.  It is also only valid over memory that is always
mapped: buffers over highmem have no permanent kernel virtual address,
which is why folio_set_bh() records a folio and an offset instead.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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

