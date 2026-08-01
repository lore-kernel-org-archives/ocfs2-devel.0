Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9563CFF72
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621698; cv=none; b=Ii51yARiO+uukdvC9Ce79q3PwShWNrH+lydzEo1kcTXRM24YTJNYF7E12H2K3DnWT3M31Szmim7eonT+hPJk4GOYK3E9SXiImowPntfKNRr/X0+ztiUgFvyWVNLSKFPte6QUPd13J3bjKzGmrjHEQrHk/9cFqDDbCVLyUOqQLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621698; c=relaxed/simple;
	bh=luLrRtkts7duEn4/GPgzY7ldWmmHGqiqpJhG8wUqy44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bscvVgbA7CbwJI56gFr3ZT09eboReXlJSLJ1M0OZfCCwRJ653ZdD7ud5JMp1ZxGmbsG8RN7pyBP602OIsc2WL44eyrAK9TgfA39fdEi69jHCxHSKSXtnvnJdOUS6hG2F0UecENqOAOi5JhbgqXUPrKTtZWOyawPSdmFMv4NgsRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUrx8jJL; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUrx8jJL"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-81fc442789cso32955387b3.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621691; x=1786226491; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0pFv0xCjYx7PImBsEcBITOWzdrDyUn6BmUrT79FEDLI=;
        b=QUrx8jJLOjBH6ykZCJIgmuNv6MeUe3antSFNYo2lrPpboVzQvl4JH4oIc1eeGeIxPE
         jW6f19zdxzh8Tfwn5CHE45FxpvMaJFy+FXUyysVNbzq/6EeM6gpvqY1PtQbZVUmpqT5f
         HybV2gl71Qet4Er+fdDJMQrzePBsr9dsmBoHeJaiJIjpGcTfvJPPEZ+WNvdUJGWAnxql
         asAUlWgtdcmmzeAS6ATytAShseE6XZOfZxuiYgxj0raIaHA6MpLRHlzk6lYqVK0mfb19
         oogGJfN2D2gCxwNcoy9O/+EcST/xGB/GucZPEOjTV8RsiLLO6akJVbsvZcxITUPtjSxj
         IJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621691; x=1786226491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0pFv0xCjYx7PImBsEcBITOWzdrDyUn6BmUrT79FEDLI=;
        b=kMF+wqPTS0bioDiw4gUwoXgRZBgW1vWhQtYCAbwEyTGfceii3jL7ba13PtKKH9PQCa
         pHRiTk0g8QQmNi6J9fwHgIyIhNO+LGF/+S0JZS9/1FqbqeCDCJz5XN7Jm5C5+SHd62Di
         ruM/PgEsXmFJY/m6sNM4Itts3183biE6c/+tZnhESMzzHeKhrVjrQCEWdztidyVDF6nv
         1yUqLN+ZLfWX/KV/4hn6ZYOrMeEeeIrFgCNaW6wb/ZDFoN3RncXi1XwtZTMtdsP852t9
         Ew/JUwuMbPrtHi20ClS0WItdlbpW5qQlRz+4tc9umlApQHs/FZm6sd04uIhg1u1f+Lvh
         3xaA==
X-Forwarded-Encrypted: i=1; AHgh+Rpa9f5IwsbB3iJkO6r9TI3wMoM2bYewaumWz+DSbLlmcqmzmZMuuE83JYfzdv7SGQW1CWXKpRCbBQr31g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyX8iBL7vLHQBD/VzGRTmJeG8iDD4culPPZyEuK6qjaKoACR/2Z
	lzgUxZYVpPJ/HKsik4ExypYwejRjllyBR490+bXLF2oI01Z3w1aiWKLk
X-Gm-Gg: AR+sD10y8Es6t/LsiPkvjftnvtJ2XD4LjZFH9z9n7a1CpILf+YCGnkhIuLkY9DZ9xrb
	rGZtPP6/0HSDGDCWrIuNWr8Es0uNIozS4LhKB5UREaAy8sCrT8gd2TfdKWPms72r+Z4ht32w36h
	BhS8FFy8Eb1qhuKfX2+7gjal81HSMvnux0vW4Lgd5cOhl5TTl3AS5bNHqC+0U/pl8QQg8YCCj7a
	cHsNyHfPkvuxCZAXiTWcL4t6CpP3M3fhaboTTRTXGnDaNrtLf3EVdBmzK2Nbvj8+n7L1ayuTcOb
	9jnTAk/4AVvaMKdLf06+iUE49+KNrd1Sz6wGxPWDQ973xB3+4tbiuxaOnuugVAoHKHZGLDwGDHG
	3B23iSJ4bWYshObU+EQje9qBHkAEMBhIHYbU7bLPbOep+y1hUAWRqiOI0tCn3dRaP/NK2h8TC5D
	sDCilMcnmnIobfUpvaPKoH+0F7LfIlgPzKev1yfc8QsC03Dh6w2lrlZ5g90znYtonw2JXPCnnyx
	a4BKPk=
X-Received: by 2002:a05:690c:368a:b0:81f:64e8:cac5 with SMTP id 00721157ae682-81fd49cbf8dmr71805897b3.7.1785621690658;
        Sat, 01 Aug 2026 15:01:30 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:30 -0700 (PDT)
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
Subject: [PATCH 15/19] gfs2: check for a metadata write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:59 -0400
Message-ID: <2a0450b24c7e6c8d7a2648196f51852c45bfae33.1785621505.git.coshi036@gmail.com>
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

gfs2_ail1_start_one() and gfs2_ail1_empty_one() decide whether a buffer on
the ail reached the disk by looking at BH_Uptodate once it is no longer
busy.  That relies on the write completion handler clearing BH_Uptodate on
error, which this series removes: a buffer whose write failed still holds
the data the filesystem asked to be written, so declaring it not up to date
is wrong and makes callers re-read it.  Test BH_Write_EIO instead.  In
gfs2_ail1_start_one() the test is the positive one, so the sense has to be
inverted rather than the flag simply swapped.

This is not a pure conversion for gfs2, because gfs2 already has a private
write completion handler that behaves the way this series is heading:
gfs2_end_log_write_bh() calls mark_buffer_write_io_error() and leaves
BH_Uptodate alone.  Buffers completed through it are therefore invisible to
both tests today, and start being caught once they look at BH_Write_EIO.
That is a real behaviour change, and it is the one gfs2 wanted: a failed
log write now withdraws the filesystem instead of passing silently.

gfs2_pin() is a different case and gets a different treatment.  Its
!buffer_uptodate() test is not only a proxy for a failed write - a buffer
with no valid contents at all is equally a reason to withdraw before
pinning it into a transaction - so the write error test is added to it
rather than replacing it.

Left alone deliberately: the BUG_ON(!buffer_uptodate(bh)) in gfs2_unpin()
and the two WARN_ON()s in fs/gfs2/rgrp.c.  After this series they simply
stop firing for write errors, which is correct; turning them into
BUG_ON(buffer_write_io_error(bh)) would newly panic on an I/O error.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/gfs2/log.c  | 4 ++--
 fs/gfs2/lops.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 78bba8cc10b8..e3e0dcb1f567 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -107,7 +107,7 @@ __acquires(&sdp->sd_ail_lock)
 		gfs2_assert(sdp, bd->bd_tr == tr);
 
 		if (!buffer_busy(bh)) {
-			if (buffer_uptodate(bh)) {
+			if (!buffer_write_io_error(bh)) {
 				list_move(&bd->bd_ail_st_list,
 					  &tr->tr_ail2_list);
 				continue;
@@ -321,7 +321,7 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr,
 			active_count++;
 			continue;
 		}
-		if (!buffer_uptodate(bh) &&
+		if (buffer_write_io_error(bh) &&
 		    !cmpxchg(&sdp->sd_log_error, 0, -EIO))
 			gfs2_io_error_bh(sdp, bh);
 		/*
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6dabe73ad790..3df6e4b7e8b9 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -48,7 +48,7 @@ void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	clear_buffer_dirty(bh);
 	if (test_set_buffer_pinned(bh))
 		gfs2_assert_withdraw(sdp, 0);
-	if (!buffer_uptodate(bh))
+	if (!buffer_uptodate(bh) || buffer_write_io_error(bh))
 		gfs2_io_error_bh(sdp, bh);
 	bd = bh->b_private;
 	/* If this buffer is in the AIL and it has already been written
-- 
2.43.0

