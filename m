Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE65472539
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 12:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018903; cv=none; b=UOQKiKH6GRo5iEfC2jPW7AwL3vY28Q3z2yxRQGDgqOkwwi9lDTVuJfe+Gzb8w6y7vY7hSNOQ6GC9RIXGd/2UQUiJbXYomhmHLrrdLCeL/IvnUaQY3BfNCp6wrtvY5Aje9Z0EXbunAGg914aNwY9IpSP+kIiCn1J4BUOcF9U62+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018903; c=relaxed/simple;
	bh=PN2WzJemERPS4iPxoVMtpcEMd1yZCcCbbbQBtJYQ0vM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F4I58V15+1hw5atk7ExLGcJK7dnAO/EOuTl98hWzXANo++RkWXkX9b2dcXujDI0TljrWbfHutwWhoaMKr39jepEyG2ELygwIuPq6AC82PfFlO6K28zjYSNWfms/sSIuQs+HnLoQSq5UEHeao6qybSFRh/lQ5kZC5UHgb8p4JpmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lc2D1aKe; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lc2D1aKe"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso19802215ad.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 05:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786018901; x=1786623701; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ekdV8BchbmbJWa6PZjnzaWfvyI9TuAOg7wpTh12WMck=;
        b=Lc2D1aKeIX9WMumKDZYwW/1ldDik8CnlLvBBCeEExCH4zSAlmwzWdoVYYbCxRfrF6x
         KQsUUTc0psYmPsNaSaO5LVOrMWFaL9MHEnBQiSWYmrbFZ0lLrRNGQF9u+pkQXSFHcmnq
         VOiyYERghDLlgs2reZIpsx+LRzmipTT+W0NUvrg4tml/cqcuWlxpRn738GQCKfwGg+9a
         G8nhrSY8ZSES0ASxondMz/HTsq9QXNz5PlLhEzWW0S4QW2ShN2qTVaEObt9JqiAgevt1
         0Emv13hksFPKrQGR3MVM89IT7VbFPwMKhoVrpjYfsH8gNkYLMbMwr/eDGXJ7EZLBqhWG
         YecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018901; x=1786623701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ekdV8BchbmbJWa6PZjnzaWfvyI9TuAOg7wpTh12WMck=;
        b=Fs4+lN/shyLelzZO/OCwGNmWmX+QmIcFikkNOLLTNJmbGJHsDj9l3uUmr+4paPStzi
         a3AOCcS3spsdC1gnUnSCI9VuCjwHrzXCCV863l4d9+E5gGPskZJGIf6gP7/emPnlFBjA
         YkqnW/eBdE4MHYPQgrt1kA7H7YyrmZCaBEQMMo20xKwWR7UhtS33Th2nsmFx0gW2RhLo
         h00AfLUQTB4q4zV/z/DPkwy5SEr4icDWv55JvZeq68MQ99A55XRvahanx2M7/Ohr++2S
         IF2fvO6PM4id8cZcAs9UlCUZ9mPu/+mm3uCkxyZQZjS252+I45N60T2mLoeVBhYRUuhr
         FU4A==
X-Forwarded-Encrypted: i=1; AHgh+Rowq9WjHnOUrJ4f0fnZchdGUGe6S5xC8AWh8oQaRUFXQs+gioWFFm8ASJPBWgG4WKY5gRLSRSHszrfNaA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyqdZwJvYY6p20tresp/TuGDytd7KeMUszRol+0dBT2O1dnVRSm
	9OqED3J652/ubufG06qLWRJF3E2uzYVeyq3d+iUl3sJkZCGMLL9Wt0yI
X-Gm-Gg: AR+sD12CP+jswMJLc1s7axERlyhVCcC8K9kqdCRL+lMjXux/U0GQxJRRhkMCPqHEK4H
	2TfPbhpQ3mmdPKibYiGk6f5bqJMaj3q4G7BMCa1siKUSRCyCBgyE0h8jXb4qcHk7PJgDblfqY2A
	R1pcAKjbaMY1suvxvMNhfQ0T9U1xo71KMZ8ei36JW/Ti8HF0FN4+Uc/1aQY3C/zEul5xpNFkUHh
	6nUL+SBaeVoMVuSuLqVaZxlUkmEMorX0kN8LkfSzppcJ4kcMcq2lMNuC0lOR9Ovph319FFV2Aaj
	V4R+SfIVlMvCdAK1+F1cV69X7V9lRLkimlPQLdY6OspwXWJwPAYt9sdSNAVorzaL0oQOK8u28RL
	Rg7V14s9qW1yiJbQ3/rMvaZPSZu7n41nNU5kH8sWmJoaMl69u/x9lskRjpykkCYZm0uZY/zbOD5
	Bw0fn4fvU6x9Y8c+Tu5yRozCV7hqTscIMcZ0ys14hWkK/m/cMpaQRV8iMFMA/dQXiwe5m1B0s3
X-Received: by 2002:a17:903:1b46:b0:2bf:7b62:a038 with SMTP id d9443c01a7336-2d0ca7fa860mr175702675ad.9.1786018901279;
        Thu, 06 Aug 2026 05:21:41 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa49325bsm30970765ad.40.2026.08.06.05.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:21:40 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] ocfs2: bound-check dir entries in the readdir re-validation scan
Date: Thu,  6 Aug 2026 20:21:33 +0800
Message-ID: <20260806122133.956847-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the inode version changed since the last readdir(),
ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
relocate the current position:

	for (i = 0; i < sb->s_blocksize && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

The loop dereferences de->rec_len (at byte offset 8 within the entry)
guarded only by i < sb->s_blocksize.  `offset` is derived from ctx->pos,
which userspace controls via lseek() on the directory fd, so i can reach
the last bytes of the block; reading de->rec_len then reads a few bytes
past the s_blocksize-sized block buffer (an out-of-bounds read).

The main emit loop below already guards this via ocfs2_check_dir_entry(),
which rejects entries too close to the buffer end before touching de.
Apply the same lower bound to the re-validation scan so that a full
minimal directory entry is known to fit before de is dereferenced.  For a
consistent directory this changes nothing: entries are at least
OCFS2_DIR_REC_LEN(1) bytes, so no valid entry starts in the excluded tail.

Found by the sashiko review tool; fix approach suggested by Joseph Qi.

Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/ocfs2/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d7fc3cccf2f4..3b606b4c04dd 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1903,7 +1903,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize &&
+			     i < offset;) {
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
 				 * dirent test each time round this
-- 
2.43.0

