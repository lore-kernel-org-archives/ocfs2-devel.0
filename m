Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E2D439006
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035551; cv=none; b=fDokQEJeNWSJxrxVtES9+rYRdijETRIdXiidEjaGg3GP4ykE6rdnmg7YIhRc8OvybskQLlKGc6XSXUaeyTBHdCTGRvyemoDbUm0vd8iu5lMf11Z1pr4YDGyNGLitf/3+Rqqa9UzlhapKL66UHYE/584jQcyXYHjIG8hyDhnCOgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035551; c=relaxed/simple;
	bh=ABYpqZ4wdvX2qJo1aEQHOIyoxUhBwtpPontmC2KZtYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh0/bXTGyZ0Ou2s2N8iXTBVIcA0z7SsEK1+naxwp2ggotiyaL2xydBYlIVZXfRrmA10Y4jHJYYkqqrnxdJfhAHBToZ6ZMl2ir1p8uOTB417TC4xVvefiEM1vythiv7Nj6Zu2BX4x6U8n87jTUSLaBW0aubKExibCWTCuHjm2/T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcAta0+/; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcAta0+/"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c2c0df0b45so820822e0c.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035548; x=1786640348; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lPJc5i9oK410kPZ6pKnGJ863FCeOeeCOTy1FxDFDZ4s=;
        b=bcAta0+/Z2S3RFXPip3xCGOIFPlVdCzD+j3E46UQduHj05M8iq3k6gr9ljxFxghQ6y
         xrWrCylbJRMrqYmjCP8lxVFrjLNdIEjne/1dNjts3V/TtjZG2a4swSYukDhVveUYpeug
         tYjeKE8f6EOipdP818atQyo9ilQ3BiyIbITBKHoiHEEDaG44sTTjOiJd9YaFndORU/MT
         ZGTVkgHDcxhh3QJdRiaWvhX3/dhh6IKRdmC5f2wg8wXZ/NZn+Ou1IioQcZj5cRstCNZj
         rkDtGHQVnnMSBtC/cA5IebTdM3XNNSHDaYT3aQ7NAv69AyAN902cEw0UW6TUh5X8awfs
         T/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035548; x=1786640348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lPJc5i9oK410kPZ6pKnGJ863FCeOeeCOTy1FxDFDZ4s=;
        b=paPk6aG/KfwGF03NK6foqmX0FhvkkPsTcuHd7/9ghDHPgEFz0rS0WWnEqMtKBhvZc4
         IL0haWazCKgjtNcsOrO/TcHbGr1hR91oy5mIJ3ARx01IyP0P1IOyLKSGgbTwiQlC4SwD
         Z4jp0g1mfm7sA9zK1m23GRhzW/roaYQGwpUgVTikL9MD+xYclHuOYIO8ScGoZcxwa9Xu
         JqvtlOImMuNQ6+vw4o5eQZBQrjRMetCKaWhE1nu4bUc2wZTKywMxLCTjBpDxzYoIi/uQ
         OQvvjjx6iUCid68GYrOw8BBQRsmMU6hcJ/blitziQqdItJrGrr9g4chvYeSM52t0MygQ
         Kzug==
X-Forwarded-Encrypted: i=1; AHgh+RqguC1CxxFUCAyr7/iN8sLgSUuHHah2l4mEtYJot62901CYc/z9Ua5hzuZjddiuQ7/umRhJTrpdji3Ecg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwKdFifpfrewE/VFT1I/LMZw5NxMCQfigtwZf7UYci6Wkha+tVn
	xaY4l38K9zVc6oSCvqFkJ3OJitK1hGviKqmFgS9fs8Y5tYqEvkRv9mmf
X-Gm-Gg: AR+sD12kYtM1cdcOObZgKZncTVv4h1aHwhQs5N2QoOTvrDtPhmK6V8U0cbZaKFJrNtP
	qFtTzEY2UNFpd/egUrlPXVSywksduOnGh2EvPa2/DwBN0uiVToaprzBmnJ7E+FPQ3j5EV88LjZ0
	hRvLpkmIjpbQP4AbIBtqSz4ios5TQSJt08It4CFRLql+1zI3e4K/fdj0553e4eiarsuveZDPNON
	2GOwO8+CuqB7/FRKLHebT6avBLXZUMC5bYHDBhi5JOgsReq3GdvKgBU9aPbKOm+Uvp/meMUP54v
	GRufz1GTkVE+uC/dxjJ6TUBUxjyj4tOOYnGGbetlpvxQFpA0cwzNEaEb7RiIHP+b8M1UeMj4vZd
	t3HhPUzcDXy1ruLKIzGt8OYiDx+sc5Ao5zotwPTJdMXGeFuD5oyournCPucxGTeUrTeFev4hGbn
	LMGN+qAhMv74JQBY5HzWn7KdL1eMBtb8lRFzgTewqnD27ixQZe9eT3ufDCKowZwrl2pc6i5o+LK
	c7XOPg=
X-Received: by 2002:a05:6122:2191:b0:5c1:2b9a:7cae with SMTP id 71dfb90a1353d-5c3d90fad18mr2103554e0c.6.1786035548364;
        Thu, 06 Aug 2026 09:59:08 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:07 -0700 (PDT)
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
Subject: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data directly
Date: Thu,  6 Aug 2026 12:58:26 -0400
Message-ID: <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
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

When a metadata buffer has to be copied out before it can be journalled,
jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather than
the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() makes
the shadow buffer point at a slab folio.

That is not something the buffer_head layer can reason about.  A slab folio
overloads ->mapping, so a shadow buffer looks like it belongs to an
address_space when it does not.  buffer_set_crypto_ctx() already has to
work around this, and it is the reason mark_buffer_write_io_error() cannot
be called on a shadow buffer today.

Point the shadow buffer at the frozen data itself instead: leave b_folio
NULL, which it already is out of alloc_buffer_head(), and set b_data.  The
previous patch taught fs/buffer.c to submit such a buffer.  folio_set_bh()
is now needed on only one path - the one that journals the page cache copy
directly - so it moves there, and new_folio, new_offset and the flag that
used to pick between them all go away.

The two commit-path checksum helpers reach the shadow buffer's contents
through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a buffer
with or without a folio.  Memory outside the page cache is always mapped,
so for those there is nothing to map or unmap.  Mapping it anyway would be
worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
kmap_local_page() hands back a one page mapping even for such memory, which
is not enough for a buffer bigger than a page.

Tested with ext4 mounted data=journal,journal_checksum on a metadata_csum
filesystem, writing files whose every block begins with the JBD2 magic so
that escaping forces the copy-out, then crashing with sysrq-b without
unmounting and replaying the journal on the next mount.  Recovery
completed, the file contents matched, e2fsck -fn was clean, and an
instrumented build confirmed the b_folio == NULL path was taken.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/commit.c            |  8 ++++----
 fs/jbd2/journal.c           | 29 +++++++++++++++++------------
 include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3029cb6f6d64..0c85af91f9b2 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
 	char *addr;
 	__u32 checksum;
 
-	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
+	addr = kmap_local_bh(bh);
 	checksum = crc32_be(crc32_sum, addr, bh->b_size);
-	kunmap_local(addr);
+	kunmap_local_bh(bh, addr);
 
 	return checksum;
 }
@@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
 		return;
 
 	seq = cpu_to_be32(sequence);
-	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
+	addr = kmap_local_bh(bh);
 	csum32 = jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
 	csum32 = jbd2_chksum(csum32, addr, bh->b_size);
-	kunmap_local(addr);
+	kunmap_local_bh(bh, addr);
 
 	if (jbd2_has_feature_csum3(j))
 		tag3->t_checksum = cpu_to_be32(csum32);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 09efa337649e..6e05dc47e20a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 {
 	int do_escape = 0;
 	struct buffer_head *new_bh;
-	struct folio *new_folio;
-	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
 	journal_t *journal = transaction->t_journal;
 
@@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 	/* keep subsequent assertions sane */
 	atomic_set(&new_bh->b_count, 1);
 
+	/*
+	 * b_frozen_data is slab memory, not page cache, so when we use it the
+	 * shadow buffer gets no folio at all: b_folio stays NULL from the
+	 * allocation and b_data points straight at the copy.  Pointing it at
+	 * the slab folio instead would hand its overloaded ->mapping to
+	 * anything that goes looking for an address_space.
+	 */
+
 	spin_lock(&jh_in->b_state_lock);
 	/*
 	 * If a new transaction has already done a buffer copy-out, then
 	 * we use that version of the data for the commit.
 	 */
 	if (jh_in->b_frozen_data) {
-		new_folio = virt_to_folio(jh_in->b_frozen_data);
-		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
 		do_escape = jbd2_data_needs_escaping(jh_in->b_frozen_data);
 		if (do_escape)
 			jbd2_data_do_escape(jh_in->b_frozen_data);
+		new_bh->b_data = jh_in->b_frozen_data;
 	} else {
+		struct folio *folio = bh_in->b_folio;
+		unsigned int offset = offset_in_folio(folio, bh_in->b_data);
 		char *tmp;
 		char *mapped_data;
 
-		new_folio = bh_in->b_folio;
-		new_offset = offset_in_folio(new_folio, bh_in->b_data);
-		mapped_data = kmap_local_folio(new_folio, new_offset);
+		mapped_data = kmap_local_folio(folio, offset);
 		/*
 		 * Fire data frozen trigger if data already wasn't frozen. Do
 		 * this before checking for escaping, as the trigger may modify
@@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		/*
 		 * Do we need to do a data copy?
 		 */
-		if (!do_escape)
+		if (!do_escape) {
+			folio_set_bh(new_bh, folio, offset);
 			goto escape_done;
+		}
 
 		spin_unlock(&jh_in->b_state_lock);
 		tmp = kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
@@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		}
 
 		jh_in->b_frozen_data = tmp;
-		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
+		memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
 		/*
 		 * This isn't strictly necessary, as we're using frozen
 		 * data for the escaping, but it keeps consistency with
@@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		jh_in->b_frozen_triggers = jh_in->b_triggers;
 
 copy_done:
-		new_folio = virt_to_folio(jh_in->b_frozen_data);
-		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
 		jbd2_data_do_escape(jh_in->b_frozen_data);
+		new_bh->b_data = jh_in->b_frozen_data;
 	}
 
 escape_done:
-	folio_set_bh(new_bh, new_folio, new_offset);
 	new_bh->b_size = bh_in->b_size;
 	new_bh->b_bdev = journal->j_dev;
 	new_bh->b_blocknr = blocknr;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 699970b4bbf2..20b8fca1abfa 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
 }
 
+/**
+ * kmap_local_bh - Map the data of a buffer.
+ * @bh: The buffer.
+ *
+ * Buffers usually live in the page cache, but a few are built over memory
+ * which is not.  Those carry no folio and b_data is already a kernel address
+ * which is always mapped, so there is nothing to do for them.  Pair with
+ * kunmap_local_bh().
+ *
+ * Return: A pointer to the buffer's data.
+ */
+static inline void *kmap_local_bh(const struct buffer_head *bh)
+{
+	if (!bh->b_folio)
+		return bh->b_data;
+	return kmap_local_folio(bh->b_folio, bh_offset(bh));
+}
+
+/**
+ * kunmap_local_bh - Unmap the data of a buffer.
+ * @bh: The buffer.
+ * @addr: The address returned by kmap_local_bh().
+ */
+static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr)
+{
+	if (bh->b_folio)
+		kunmap_local(addr);
+}
+
 /* If we *know* page->private refers to buffer_heads */
 #define page_buffers(page)					\
 	({							\
-- 
2.43.0

