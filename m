Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EDF31E83D
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Sep 2026 03:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357791; cv=none; b=UC9+2Jv8MSJm6yBSpp/w6H3IOCoVuLgKFNRNZsm2C7+066UkcWgTnCt06U0gSLjIhoNGBa8vVdfrnkuH5koCUw+d/evEbHBOS7La281b5VbBxlz18/q/1EnbDjtdZnJZiX8cm0k4dj1VYYMX2lWnRMR4xJskNI0bdk1/XmMSgEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357791; c=relaxed/simple;
	bh=q9WE6+wjyeX7fXhtEn7zhcbfhcZOIuWB1HXG6rwgnXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcJj7ukB86KWZwi26RTg2P0sJncmCApjFzQu6mTqEiduC22aSCN5IkrB1amje11pTuvYxZGPLTNpcjagh7cUj45vsqultZwQDQ03olbAZsemL83pN8Z/Eaz4WZ/dS6vXUOVvXjLZySjk4UUjVxp0O5mon0vXFuXWJPNOdBV8++I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GnHS19Cv; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnHS19Cv"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so20805145ad.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 13 Sep 2026 20:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789357789; x=1789962589; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kio+heX6pPEISSE575Nmco9JmkqcOqgMUE8R7TgDTQA=;
        b=GnHS19Cv2SNROu/3PdHwzh2OkcrhxQGHQlS86UvSXvB95iwiS4ubB21IhkN51DVUc4
         NL7LL+SfWuSDXPy4CGRXohx2aRrHpdil2NdrwtzuejRLWH56aNAkZpPJcSzsNm1IhHXQ
         5c2BUs9BSS5kzDyU3OSJ1Ij/beSVWmbicUWJP4ifIp+/iiJAtpb5DMBBnPV/woJ5BnWl
         4Zww6LTr4OcxDkYj4IjWYdDtLGThWWOsoYRFxDX1Wiwku4vMccITe3tcVdabVQ4jiIWc
         OwSGOfWAyuwajqiEq0JGQ6HoihfPzzlcrLtH+//0uUdneQ0fBlg+ZbN8tEsTiwMZXqQu
         wW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789357789; x=1789962589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kio+heX6pPEISSE575Nmco9JmkqcOqgMUE8R7TgDTQA=;
        b=ThXk/UJ0jF+0DPFMDVkeiOBhiERaQ4l7nHmWiRjdg+ESvBb8vTz8/QrgG288/eKVtn
         zbjEnFZAUo52SER333K0jTHmz/YvNXTgmro/f8AIZz3W2pBOaNtYLLf++Hxg/nQsDW4J
         SHvjHTPcoS/BzVKvpwgwlHtWC1yx7j6T2takor6tNAVE6ATtpRCDW6uajGr7tOJVhDSZ
         pTrRp9jvxTdCYKICeP33VSxp0baxXIgXNM1Wcw9c4XPcXPPG8KkmHkwLZnu7omsJ+t0Q
         9G2kHd0flWaxtf7GmyJ9I/mG29Ie3mVSn4vAnFLI/Ag5RugjOOqxWttDJOhTcwCusqmT
         l0Wg==
X-Forwarded-Encrypted: i=1; AKwUvBwdBp2Aie5sStGlSLNMQAuOhNNV20EFbAwpKoSj4Y4qCGCKp/F4eLumcVDipihGCUYpb5l1uCp9mrJNCA==@lists.linux.dev
X-Gm-Message-State: AFuF++kdSUZkQ1TpcXnTqOUxwvzFZA4rYlnIBgBhfXDjwaH4X8xL5ezl
	xX1SpyPwsFxtKvKdoXDlzMRFGaqcxo7IKKlsLeScbChS6dO8G2Bsk4T1
X-Gm-Gg: AYBFou3kyfrKsA+tfDSj4qvG0u4tlRU455YBXiQvyCACD4BMsL4XnYPUjgoPMvqTkQj
	C9FoLxLA6LisrY8A0S0zhWbV/50lIbx7C9CgUgCulj/SIGKwranb6GLO6xoTMqMNaMdexixj8X6
	0Z15hTR/rzpVoRGsErRjET59m1yXr5Xh6SNGqRTxXweLcBZ1+7NDCm3bHNTPs/3nOn3hw6aMdc7
	Pb1I9JC6lH2IC38C29dJwUoIk/Rx8my9M4rFxgeaT/6ILzeiWGwCsuEnS47XvTXtVxT/bOodFmg
	y/gVTHgzgNMPjoDSY8T2Kvjs12RMMOcyaMgpf4iG/YbopWsBdl3BhTarBoKbHlgZ/iQRDdptb4U
	C3INFeP+AlbI16jJb33maCVoqpDmhce/jzZIyuwEe66/DjSIlFaOHEmuWdz4Os49cSSp/86XbLT
	jh0fAajWGiVqE8TMUsTpEykhOHoQeTgudEECt0Z9WEuGi6qilxdzSCQQxhcCce9wQ7eKrfQmEnY
	oISzvYU4A==
X-Received: by 2002:a17:903:b8e:b0:2d6:ee34:c043 with SMTP id d9443c01a7336-2dd5f16afcemr63293405ad.11.1789357788987;
        Sun, 13 Sep 2026 20:49:48 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([115.25.44.221])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfce707sm41361815ad.55.2026.09.13.20.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 20:49:48 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	syzkaller@googlegroups.com,
	r772577952@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: fix chunk number of the first chunk in a local quota file
Date: Mon, 14 Sep 2026 11:49:40 +0800
Message-ID: <20260914034940.4070970-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com>
References: <CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The local quota file in OCFS2 is divided into chunks, and each chunk
begins with a header block holding a bitmap of the quota entries that
chunk has handed out.  Chunks are numbered from zero, and that number is
used to convert the file offset of an entry back into a bit position in
the bitmap. ocfs2_local_quota_add_chunk() appends a new chunk to the
in-memory list and numbers it one past the chunk that was last:

	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
				   struct ocfs2_quota_chunk,
				   qc_chunk)->qc_num + 1;

The predecessor is looked up after the new chunk is added to the list,
so if the list was empty, the prev pointer is the list head itself.  The
head is the dqi_chunk member of struct ocfs2_mem_dqinfo and is not a
chunk, so reading qc_num through it lands 16 bytes past the start of the
head, on the dqi_gqinode pointer that follows it.  The first chunk of
the file is then numbered with the lower half of a kernel pointer
instead of 0.

The list is empty when the local quota file header claims the file has
no chunks.  ocfs2_local_read_info() takes dqi_chunks from that header
without validating it, so an image with dqi_chunks == 0 takes this path
when the first quota entry is allocated.

ocfs2_create_local_dquot() turns the bad number into a file offset with
ol_dqblk_off(), which shifts a 32-bit block number left by the block
size bits, so the top bits of such a large block number are lost.
ocfs2_local_release_dquot() turns the offset back into a bit index with
ol_dqblk_chunk_off(), using the full chunk number, so the lost bits push
that index far outside the bitmap, and clearing it corrupts unrelated
memory.

Compute the chunk number before putting the chunk on the list, and use 0
when the list is empty.

Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Closes: https://lore.kernel.org/lkml/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude Code:claude-opus-5
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/ocfs2/quota_local.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..d351cda9211f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1071,10 +1071,13 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		goto out;
 	}
 
+	if (list_empty(&oinfo->dqi_chunk))
+		chunk->qc_num = 0;
+	else
+		chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
+					   struct ocfs2_quota_chunk,
+					   qc_chunk)->qc_num + 1;
 	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
-	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
-				   struct ocfs2_quota_chunk,
-				   qc_chunk)->qc_num + 1;
 	chunk->qc_headerbh = bh;
 	*offset = 0;
 	return chunk;
-- 
2.43.0

