Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809A93C2BB0
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621698; cv=none; b=suDGjZl4saNnEDP8aYQLYkI1WYRID/RgcyxWbbrQDfmLQTRkw5su3VvQMST9MdKU8xXswj6sqgI7xL/eJPPXYj/fYFuifnSdGNJq1fDBogeDpkAdBPeBKEiuZyJ004K77CwcXjAe5Xnmu2zGGzk3D+P9y5GpLLv2qbyRuDFB0Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621698; c=relaxed/simple;
	bh=2bZmsqZVVuc9CfGIc+LM2Z9Btw3Dvkpcm1xyNQyplYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRprCU2UCKvbkL88bDkNoYGkzWTq3vTYzPwNbyr6rQbibqswdrpvN+7MdMIPg6GrgaoxcExdaOOv0irYNxAKaM8hkpsY9J1s9goC9rhJtSZFFvivsY6PZ7Ee5mPfZE98XJ+L1wdxxHzhPU9lM3kQXDiQeD9yZ6b8CT2V+D9Hf58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lo3paSGL; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lo3paSGL"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66893db7bccso3301629d50.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621695; x=1786226495; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qElo3yzh2qeHSY0scU/mBgdij9EIQBJHv2xpttY7cac=;
        b=Lo3paSGLfyFCr1898iTqmJy4uUObmryr4VZyCzXrDkAvpXC1ELXVVTsAXHU74mwlX4
         zPJeX2IEruBpOZ4NQkXxP1E/tJF/IkJfrhrSeAku6P9RxIAhRyLqcE9AMCH4lbQhySHQ
         87ynRe1kncIOb/6ZGpj4+8AgulJmnHuTNM0eOmeGLi3aECGPX88JhOOjGW19f9y2MoRA
         y1MNufP7WRyDmdxctzuuFJg2qCah/LJoelu2bcKG4c62e2ywB8VFFRQyOXsmaQriQPid
         GxMQJkM5ega9XZnIwyAtEP+jzt+xG/hkserFMcayhOXx0vzkr3560nn676ZK1anMj6Vb
         gaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621695; x=1786226495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qElo3yzh2qeHSY0scU/mBgdij9EIQBJHv2xpttY7cac=;
        b=ozWjf6WEiQJh8Co4Co72JBH8D7q1NAikxrE2ZsfEk7rQXCzZUB649IQ5Nnnh2cijvW
         qvKZRI1rNgMv3WJd9RBA9/JEhVeibGmLLyP/lle2eKp58QyWobJaVE8mgboXiAqmC88O
         tMQCzkv4gyMXeVC/2UPWheSa8uirUspLmBQ0By+sZtgfI1s4dky+pNmxCHd9aiO7msHn
         gta6DOMD8Bm7qqeI9pBssXvVzqLw/oR02XK0IsJJk1JA9zyyoW55L6aZQ7b6UA7BlzYz
         dCAKCEl1hQcniRzJJAJf/Wdh0EwPOtUfjmYSkA0HGtBg/pivwXs5AUipNNS2RRIY3fZA
         dapA==
X-Forwarded-Encrypted: i=1; AHgh+RoXi+aFZ79DCazV5Bx60dseS7uy+T0ATOidgWrSQIR/acFfgDIng84ZXFkSpCZ1TVBfz4OZI155UR8TAQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywls9TlY1PFUkLpNMbVLWa/C7rZRJ5HXcB3IgAvcwsfGQZHDFdV
	/tTG8rG86xiVC9yDcGIjkx2Y/737aMFG81PFIHyynJJbkzfkXqI1w5d/
X-Gm-Gg: AR+sD10JxhhMueCZ/Q/2xl/ZdYVB/YcpW+GNhIV1oOfZL48X4aS0/Bt2r2TKpOpDUcb
	+jkSd6YFWb51wNQ4//0EdiLTHkCDcpdoeOE9udOxH2Hn/uZAalreN81tN0KDrLRSJVjqmbJ3OfC
	3DXIMdCkPu2LfxMZ8FB0kE2xyP02iPvj8uqjXukPGAhAbwDR0ret/W+S5NH/64kbYZXYOgx2DM7
	YSdypuW+xyOyy2cVR9KDO+Q5Jn7icv5xnm739idulxhhYYwyjb7CDD2LuD6bq0zrY67BQCoQEwT
	wql60OyFMxn/bVnuu/Q3SjfR3EAJrRM0J4MxGsuydhf0wXPnA+V3LCUGBtwkAdTDsHuV9DRCV+K
	PCNbZmUqZr32mivaBIRGr4uQCsbhiTaNLpAKQz0UlAsEpHe8hRMlx4F23rJHolTlL3eK92ESFC1
	PrqW1KtGNixIplZlYB0BInoQ6MSgQp9apa71FGIV8Li0KiMMdrB8KConzYo5pLffNM5yKRfQe1p
	bXMEvs=
X-Received: by 2002:a05:690c:9981:b0:81e:a471:e8b0 with SMTP id 00721157ae682-81fd4b3e2d0mr70199667b3.21.1785621695043;
        Sat, 01 Aug 2026 15:01:35 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:33 -0700 (PDT)
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
Subject: [PATCH 17/19] jbd2: assert on a failed write, not on a buffer that is not up to date
Date: Sat,  1 Aug 2026 18:01:01 -0400
Message-ID: <8aa2ee674d147d3630f73f7b53fef7781f2aeccc.1785621505.git.coshi036@gmail.com>
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

jbd2_freeze_jh_data() asserts that the buffer it is about to copy out is up
to date.  Once this series stops clearing BH_Uptodate on write error, that
assertion stops firing for the case it was written for, because a buffer
whose write failed stays up to date - which is the point: the in-memory
copy being frozen is still the data the filesystem wants written.

Assert on the condition that still means something went wrong.  The message
loses its "Possible", because BH_Write_EIO is not a guess.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5cc7d097b2ac..fdabe34a7e22 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head *jh)
 	char *source;
 	struct buffer_head *bh = jh2bh(jh);
 
-	J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
+	J_EXPECT_JH(jh, !buffer_write_io_error(bh), "IO failure.\n");
 	source = kmap_local_folio(bh->b_folio, bh_offset(bh));
 	/* Fire data frozen trigger just before we copy the data */
 	jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
-- 
2.43.0

