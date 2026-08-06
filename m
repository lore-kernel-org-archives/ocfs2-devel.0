Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED4E47D95F
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035594; cv=none; b=sa6lzFxfUVaNKVtP9wjCXeLCCVWcZs/v9v5s5SduE+P0hky0i2jk8cW7YqkYAB3oiKHzKvaJFSgBTxPM0Rl3AHFWFYruYHngPlX+ain74jxaBd/uzau1yaV4gscbflsavsEk7YWgBgrnoiedJwCcMHaVFPNOZ3//42DdFSt5eTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035594; c=relaxed/simple;
	bh=3V2E2gAPInTwE0n7u+WtHxKrTSKd6q7DUDLR8AMb2Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPipGyXZj42g7pwtmtlH0y/+Y1SXKiBEwL1DGpvi3i/VC4NpPa7HmjvpkA/gErUDloC6I+60r4B2XLvddqZLIjFiEZ0Jk4oiNg9931idwnQxxamT61KVzz2afCD9+DiEPFd7WaouzVk4niTCxWuXPwN6MAivdtiWhqZOIqm8oEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOOccBVQ; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOOccBVQ"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c27e38ee18so1234075e0c.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035592; x=1786640392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V2GNnxLBSrWkOcqqCLfBVyKRdpTurr41NHkw8NmYzAw=;
        b=SOOccBVQgnf2c0lZHH1WJvMnhfIs7euwjrfqNJ+/VC0D8L3aqIY/s6Hz27c/+zzhzA
         p10ElzBwS/xltWn1StwjSIW0AU6G/kV/p2xlvmN/OKo1cSFoX/gJ0e3QrvS4Pvjy58Ki
         siMNK34rBiOriq1SD/Z2QUtclp0Bftw0OLtFQhOsSoxLqrKMe9IgnSd9JBuyofjy/gfh
         f8OxXgxeImvV/dxoBhQ4Vt82tkGnYCSFBuXQmJpBN0REYAZHaPp/AS2CHQY9WhFmkCqa
         5jGFd3AiKlrFtv9xrd8tSecW1bK241ZMf08ltSh8tXWplxtGesvo+KQQcVQO02e16uF+
         eGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035592; x=1786640392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V2GNnxLBSrWkOcqqCLfBVyKRdpTurr41NHkw8NmYzAw=;
        b=c6BSzC7qYP4rPOvlhJHs3Otd5hvRh3kBIjzxVOI2OkYml+cjg7UHxE5rr3F2mwZKjw
         bwCVhD8mlx5UB5OcMPZ+rbtBgkLdMXBdo2t68FSMGYKkvu6dZqNrV1c4cIcbwirlb8AN
         4DE2YQedtRGXwYi7Oje18nLOafwCWL5QV2J6FaqRoSC64OJnEJ0ZCaoM8hXRYfByQGrT
         Ciwrlu3HvS4XD19EBTP3cdXqXPUBzk6vdBc3cKa7o5o3WBtemH9CnrOydFShvMiFUbvC
         5I8voEbgIdu5ZbJKHDA0H825fl8Vl19n4K4Uy5X8u553+CB0mDQa54xg+/IltGlHkw36
         7lCA==
X-Forwarded-Encrypted: i=1; AHgh+Rqb1QXG88fKZSNc9UN49Ng0BQy8yfEVUjcsSyvCV4+Sb5pHgqQSS6zxNe9wSFKzNllzd+OvBdU2DeFqCg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWzF8QvkaO6feQRbP+iiTYaiDf9H+LVPsmDBo45+qEyo01xRIW
	RhN7OTCLMgYpoEOTj9UYMTqHScEua77R3PF4lkfaIh3iTmWw2AfQOr+B
X-Gm-Gg: AR+sD11syDlpRi1oo/9qt6S6jvtBpLazSSUv6lemwZ+zHUNuD3jcm/XqmPT3h171/wI
	TcUBDAnVvWJsvJo6axKZfvz64ybSZLAsaih6+dkHkWA9rdXu6KNETPx43wQIMqplncnA9n69gMs
	sZtr/c84bXS6xuMLpBic14qmPLE8OeRAE7Khb6Zn4BwLO7H02kiYfvs4VOUCKTsGtySOiT6BNcL
	dLOa4DlbX8n+9KzEfy4DDJZT7639vEo50doYZIurTfkMgSlonCRnhAhwqeXKQ11QisDbj3wNPj4
	T+/fxyEy3nhfbZcjNfRbRRuUQF/t+/o/S+GhtMbJdwcwxq1E+jb4HKsLXVSbD5KELBA4JXkHqqM
	NafhrpiBXdVPJAG7cjDqfxHKTO9lINBR9pVmJgl+5IAQKFQ2C25FLsylUnLtCMxJ2eXW7X0eVxy
	KS/Yd1wvEw/9FevFZZDxy8PlWUgaK4gTdk6juHoGDyXre562EQgcW/8vYWLe0W7IitfABop0Cty
	R6ceIVve/HC2v5v3Q==
X-Received: by 2002:a05:6122:179f:b0:5c3:367c:c001 with SMTP id 71dfb90a1353d-5c3d923fa4bmr2401901e0c.12.1786035592033;
        Thu, 06 Aug 2026 09:59:52 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:51 -0700 (PDT)
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
Subject: [PATCH v2 12/21] fat: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:35 -0400
Message-ID: <4b6019b5a48b83c8235918b084248983a57692e1.1785951556.git.coshi036@gmail.com>
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

fat_sync_bhs() waits for the writes it issued and then tests
!buffer_uptodate() to find the ones that failed.  That relies on the write
completion handler clearing BH_Uptodate on error, which this series
removes: a buffer whose write failed still holds the data the filesystem
asked to be written, so declaring it not up to date is wrong and makes
callers re-read it.

Test BH_Write_EIO, which is what the completion handler sets and what this
code actually wants to know.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/fat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index be18f6b5819b..4a4cd0111e47 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -356,7 +356,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0

