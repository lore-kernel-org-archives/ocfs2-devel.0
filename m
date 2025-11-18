Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAAC248F69
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 00:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425160; cv=none; b=WTRJXMZQifAWl2kHHq/o1EtKYHrKi9aM3/WMsAI+O8l2Szaq543A+zUA1mrshr/ooi9KIcmJPU2/woBSSsvCeeoRCaZuyDaBOL67sDz5LF8499FbLzU7qWDoenm5vR1qJoTQSHiX0k0h3cMbjPJAJoeqQSjhGilRfA6u7aiQvK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425160; c=relaxed/simple;
	bh=DSmw1+Vwv0HnRD3Enwa7AilcMKynWxy31iZgq6F6580=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GdfbhG6x3Jzew0/6XsZcB2eMsBzUH7AXORWvjlKt7Zv54NY5uYQmyBrK8qUSfwReIcXTCGwypwm7VeKj0GBOywyLtZ5nUzhGGV1NvEVu1vma/8zgXZFPiHN0eeSrXrRlvSpAS1qATG2oWBBDTags1JLW7cwNqii/Thgv1XVkZd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gh/d22RZ; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gh/d22RZ"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64166a57f3bso7693662a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 16:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763425157; x=1764029957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mOw6IYtde1FQUWe/T9xO6OJOvT24+LmnbLN8DYc/tME=;
        b=Gh/d22RZXQiDkU2SCE8UNnc0XrLTyUl0tZt5J7lAlFSKb5+VP3cHAXSZfRF5fFtt++
         w6nIDNFA3/SufDKhq4joirF6YfJ6yQn0O6W013MJioSUpjuHPuJTNCIBLrdbKizqIju8
         HfSiNgq5npQUTgkQmoM53EaGnyE/TspFIiic2CgtlKmMAvFShx1nAWTcFtVixZryb4uu
         PKHxYlSumlhCEsUelA9bTneZSjaHb4wWvcZ/1qvIczZ3bcWiBe1XLx2QsywS05snmbta
         vsth8ta/amwHHF8Ouo8mVekjLnXH151PJAuuMnPh8oyy9WNhlT+9ulhmOJpEIM7jKwol
         Y8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763425157; x=1764029957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOw6IYtde1FQUWe/T9xO6OJOvT24+LmnbLN8DYc/tME=;
        b=qkfAz7NZPkv35N2Fxvjn+sr096dapI00Mh4mqv76Y3/TGR2OeNZKx3d8Vxwl+UtnIu
         BX3GZzQ0ibsyJRJiyWC2tRIoFAV4Mvmeuvm/hJW5wrLaysgKMJLvQrxx46jT+LBEdMuQ
         wik1oa7/LwVV4ynxNhEUdSLRXPZg935+RersCUOgqZoafnEElHVULUiwKXxXAfAFEYtk
         GxpK6eIZkUrio/k+Hfv/MFQURW2uISE85RvFVhuMXEaFxV9amg4DIsQ+nOIqsYfJVCFZ
         9diN9LYquR8WPMyufR+UqI51K4D0vx4Yt6Aq//UTyk43YVxGoZ9P6Rvp6EZCau4YCxTU
         ViVA==
X-Gm-Message-State: AOJu0YxTxliq05zeQaM0iyE60RwKhxXCR+qcqHFsEz+dt5k7s278pEkh
	CD/ZZFdP3vwzZ/iyk2TpFUKUdAAj5BzsAZNEqYq/Bd7F5Pdzc/poU7eG
X-Gm-Gg: ASbGncsER+bPFwhY8zyhKhmNn1uIQAe8DZCkbH0kGQVJ7IDGco3X7kVVTnmPgb52pBW
	BS1ZO4K/ip9LtVOl+ZQEaT7jOVqmmDb05qK8IXvpQ9eYVJjPJJ9p54P8AlHKmvMzIFmw9DOuf3R
	6gleF5XV94dvUo5paVDlbQp1wtCxoq0RrKG6MjuRXXQSEGqNPNUmNlJonMA1FUN7z2y0i/cNu2z
	65Cuv0aw8Gdjx5eEDmiyaUGgliFezJk28OUwnpIuxKsSNPfl3Q+dsCZ1wj995Gl5WF4ZqEYPbcI
	zCl8kBxduylc742eDHy1AS34gs7F0SbeNYY1Ij5Fbxt6HUm53G6M+0HOC80Odc3ttuJx5U9l/Jl
	rabE4GtlUpMZx5a1JahKMLnbSk2SzOp4Xjk7/dKAJnN90wm0ByjpvpzKdJvOtlUZS+Z+rScleot
	8f
X-Google-Smtp-Source: AGHT+IHe0KzCc+DIGyOFPlhlYxfYHGdklwVpQeXrG5useC/dPcZwppTwyWJSrB0BBPWbH0B71uf7og==
X-Received: by 2002:a17:906:7309:b0:b45:60ad:daf9 with SMTP id a640c23a62f3a-b73677ed721mr1536042766b.3.1763425156745;
        Mon, 17 Nov 2025 16:19:16 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d08:f72:eb64:1d0d:5855:afe7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fedb2cfsm1190334166b.71.2025.11.17.16.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:19:16 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com,
	Heming Zhao <heming.zhao@suse.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [PATCH] ocfs2: Mark inode bad upon validation failure during read
Date: Tue, 18 Nov 2025 03:18:34 +0300
Message-ID: <20251118001833.423470-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A VFS cache inconsistency, potentially triggered by sequences like
buffered writes followed by open(O_DIRECT), can result in an invalid
on-disk inode block (e.g., bad signature). OCFS2 detects this corruption
when reading the inode block via ocfs2_validate_inode_block(), logs
"Invalid dinode", and often switches the filesystem to read-only mode.

The VFS open(O_DIRECT) operation appears to incorrectly clear the inode's
I_DIRTY flag without ensuring the dirty metadata (reflecting the earlier
buffered write, e.g., an updated i_size) is flushed to disk. This leaves
the in-memory VFS inode object "in limbo" with an updated size (e.g., 38639
from the write) but marked clean, while its on-disk counterpart remains
stale (e.g., size 0) or invalid.

Currently, the function reading the inode block (ocfs2_read_inode_block_full())
fails to call make_bad_inode() upon detecting the validation error.
Because the in-memory inode is not marked bad, subsequent operations
(like ftruncate) proceed erroneously. They eventually reach code
(e.g., ocfs2_truncate_file()) that compares the inconsistent
in-memory size (38639) against the invalid/stale on-disk size (0), leading
to kernel crashes via BUG_ON.

Fix this by calling make_bad_inode(inode) within the error handling path of
ocfs2_read_inode_block_full() immediately after a block read or validation
error occurs. This ensures VFS is properly notified about the
corrupt inode at the point of detection. Marking the inode bad  allows VFS
to correctly fail subsequent operations targeting this inode early,
preventing kernel panics caused by operating on known inconsistent inode states.

Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Previous-link: https://lore.kernel.org/all/20251029225748.11361-2-eraykrdg1@gmail.com/T/
---
 fs/ocfs2/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..415ad29ec758 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
+	if (rc < 0)
+		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
-- 
2.43.0

