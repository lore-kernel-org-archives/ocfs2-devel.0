Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0583D646E
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621700; cv=none; b=g7pmdway3ikfWfMKqccWhC0Q3SURdgFHUh6aTpC7utiY/+/DkU50NLihRqFrhFQhXiQgizhZpWZu7H3Jd/XM5cg0BHl5rgv3xq7Pvi1VvpgeFHB87G2zr7/D/8Nm+7ww9hPPuz7XrjrTQYWiR8EhvOSyTw3c1BgqfDQsWKuO8ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621700; c=relaxed/simple;
	bh=/v7VBJbAb9aO5qRUONItTpWH4owbSyqDIsLqUgwMCt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epLhpg/YvTOWrUdWtk7iQoFY6NxOdnIL38cdAXzFYGAZ6srStyWV1pJcb8jQrtAiMVxpGFnD5cj2IjsXqCtXsS84XfbXlwdUoBp6sAGIxCj/4U/6okDnzfjgZEuBsSWeY7wzDMOMAGEN4anQ05hNKthsWqzjrbdgepgvzhWEaNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pcJsVEkM; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pcJsVEkM"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81ed073fed0so31938637b3.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621696; x=1786226496; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XvLI01z2FUEK9ccgzSRudNIsKkvOOlfj4ulYih3+qTw=;
        b=pcJsVEkMsG2rqS64A1ywfpOj6+ng6OfcY6KVR5J8dxEeYdP0ph5RohGyg/EQh6ttrB
         RQasM/ebUygqlLX8qnrQeIzG5DM4IPg38fzSBa7e7OgF7uCXBWy2Pbjv1tDIyw0/pKaz
         Nwg3zMJ5yIX6m+DXpTHej2tYwiKexTNI3/321QuIWVHpB5hFOdAeXGsXArTFk6S3KGsT
         xr66sSIAib9UnZJIAUp9/JeyGJnoxcoRGfDPAdrPZgMXcfR0pbT+Sl/LFwBWVVksZFDG
         dJYvTJV4eF0/ehRyXE6PQ2P1akHzHt8AmXQ3uJBfLUOrKGUJKJMbqGtbb/sM3Rbt0M4B
         Evtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621696; x=1786226496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XvLI01z2FUEK9ccgzSRudNIsKkvOOlfj4ulYih3+qTw=;
        b=aXSsVcwMDhABmbaQ6BhijRFdcz4H8fxNGJ00Zs8togvjHB5eenvX474vQxW2J85dqf
         dhnNNHxwrtmmj5uLcWcoxzK6SJNZa4PfZa5su+Wj1lqDGn2RWFhu0s9ew1tr2P5pFLwD
         j+g4Bhwo6DwZlSkj+iLCek9nd1voXiHxLUaqnuwtX13oGldUeUYEHXVZl6h0h/kI/jqm
         eM1i56b5/mJ1aAfi0mNZwvpFKhG/MIVgCdZhAyu2R53PzYEVSGaJH6cUSxAn/f1rWGm9
         tetgoytHM+r9rMBvnat0+3bRsaJgPe7shL2OJKbf2P+M1cSTlgleUGanpDRm4yBZN9dt
         znXg==
X-Forwarded-Encrypted: i=1; AHgh+RpVmzyQ7RkCyam9s9VJnRAB+u9y/yyb5m2jkb2+9yrK/hOEEfGuD/LbYCDjWaHHEusfC3QYxC3lqXOIzQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx01l/X1TIIksvTrb4tySOcvWOfvoCvr01hLjHA1NLQm06wbbPI
	vmWsfY+e5HvXfeHAw3GEImkXCZaaDKsKk0nd9ihYrP9kYgKLlKuX97kY
X-Gm-Gg: AR+sD10iZn7RnYL9kVFl+JzLuiogryKVHhJosU6/b8C3eqwP1JdWRcBfsFDT00e54xa
	ENuVIVdXqTCvgyUsr5nBRc1WMwn+e2e7bp84xtt7fkO+Lj4Ztnuu1Cop7I813HoK1iVZG4Y0K9n
	vPNBuF42sarYlplMReqWyjRCs9jzDJO7jGPpabmTa8wfDmd7X7ePiwxsFW7WyChZgG1DN/glhcU
	38OR21Yyu1fHgsKs4RWqFvPWfcIpogIKlCNfIHphwU45qTpTst/TKHv8bcS6/lLpgYAZLFMbOnf
	WQAps59W0nq/L3vR/TkYEb9A/hFblJQnZzYvWIUpjVbaqaFyGrWzfPcV/+HsMZQpzNmsInzuXYQ
	KFsu1UX6MDyOEOnLGJjwGAZqVlSog6SRyz1JkewmXMD6okBbpJQuLItCerTaD/dAP7U8apqfytU
	6zIM+DHyKzHYHJoV+LKfau3eWqTOENp7oUyV/kJha1l9FWOPpL/F1Et5455vqJrAyS75ZHa2brl
	hTOAPBGvpzRgBuwbT4=
X-Received: by 2002:a05:690c:eca:b0:7ff:87e1:34d1 with SMTP id 00721157ae682-81fd4a5a892mr78630197b3.11.1785621696163;
        Sat, 01 Aug 2026 15:01:36 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:35 -0700 (PDT)
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
Subject: [PATCH 18/19] ext4, jbd2: report fast commit write errors with BH_Write_EIO
Date: Sat,  1 Aug 2026 18:01:02 -0400
Message-ID: <7f988ec74b5d1135d5d67771240639e57ba9e0f4.1785621505.git.coshi036@gmail.com>
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

ext4_end_buffer_io_sync() is the third completion handler in this
series that reports a failed write by clearing BH_Uptodate, and
jbd2_fc_wait_bufs() is the only thing that looks at the result.
Convert both.

They have to move in the same patch.  The handler lives in ext4 and
the wait in jbd2, but neither is used by anything else: the buffers
are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
waited for by jbd2_fc_wait_bufs().  Converting one without the other
silently disables fast commit write error reporting.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext4/fast_commit.c | 2 +-
 fs/jbd2/journal.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..8cd60c9f2272 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -213,7 +213,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio)
 	} else {
 		ext4_debug("%s: Block %lld not up-to-date",
 			   __func__, bh->b_blocknr);
-		clear_buffer_uptodate(bh);
+		mark_buffer_write_io_error(bh);
 	}
 
 	unlock_buffer(bh);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9e4cb04587b4..ffe7a22e6699 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -890,7 +890,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
 		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
 		 * buffer head.
 		 */
-		if (unlikely(!buffer_uptodate(bh))) {
+		if (unlikely(buffer_write_io_error(bh))) {
 			journal->j_fc_off = i + 1;
 			return -EIO;
 		}
-- 
2.43.0

