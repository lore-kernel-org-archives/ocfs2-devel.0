Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB02DA753
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 22:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763590668; cv=none; b=BFvJCce8oYbd9yfompYnpLxUOfOA6GuvlnuN7NDXukxWevz4NMzM6XuXmP5fW4g/O1hPHmJ4Gf7t3gCMB+CTSOtMxi06JlAPWUcb5+eZt7R6/58GmHrt9h4IzfosJLldmyVycENl02Qh6uXNuHpWCviMOv0M/QK6rsqrXoq+t5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763590668; c=relaxed/simple;
	bh=5k1UUQuMdAGsweONuHo9B8fjqZf4W9pmjU2lWcjjJZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL5Y7yW9hgOJNgvFLPw+DPUM9ndZ6UOGaySFbinUZgv89ke1et6LHRS7CyEwgeJvRAiM4aLC0cjyT3L+c6bRCfAUwZU/GJ+Ikh/FdAZ5xbREFl6GFPp5g+zaKhZCvkabuLtBmmRSN1wFA6o7N1DXWsPFvkPlr676xTizfWg6KT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V9sT+f5b; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V9sT+f5b"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so329626a12.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 14:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763590665; x=1764195465; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oB9cpue9j+IEapAl0OGonRE3KO/UfgI2fUGUdvghWZk=;
        b=V9sT+f5bzz4tJzATH4camS059sXgOc5FShI6hZsSmCYfqbEix6R/Or4BNTtVobeJIm
         6/zB0ExXpHI8dZai0uNQ9ADChvfpiJt2r76IC9xwEvaN7hlbbN5BWWBkmDOcw3xET29L
         s5Lh5kFzbt0aZkDHzbGKAnKYlXkChAOpjHhLKJSaYMCUBN+6xAfmZkrh+UI0fM/xssOY
         90o3AUyNipp0vS3694B2kzmfFh0nqur1P4LD5mz044kiEz7PeKBT7FmNNJJ7kcgY3gzp
         iuiLjBy6pdVC1ACLDuCBHPq+0sbewm8eg6Ka/gosOJZNDTc45FtvMLAXxzFWY+yJF3TL
         Jiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763590665; x=1764195465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oB9cpue9j+IEapAl0OGonRE3KO/UfgI2fUGUdvghWZk=;
        b=cWGjh7FernX3H+f9IG+6xzYoYU2J+Fu8q8zx/Ba22weDfP+zuWjmukXBBbMNnTv2CX
         2qdOzjDKV3pU3GGz4qwfcOg7+5jixw/vILGw91L71gDZKQ9NqBRDFOC2agLSmBGfiqXv
         pInNNabFQ0fnAofIbWdbFypEHhvy1ZimvoZFtYR//7qc92Mqcabfdbu6GHmkr2A1GIdQ
         RZIx93zNrJL3e/nUADxXt4/SvPNcw0XpoKqBlsurRG6qWZL1b4DXEDpvgmb70x6rxrjc
         Q2IY9RfstbH2ZoHmeZKtSLxCqsriUaz/8odV4uQfLsSCNJ0wlZThwOyq61El+7IJZhy/
         nK3A==
X-Gm-Message-State: AOJu0YxNOkNgCdM6fJYFvoD1lDSZGvlw70P6kyCiI6kZNRSBQm8x1P+5
	OB+APsOwTjuIbhAPlWxvuH3nZfXucKj20p4ceuC5xb8yQZiHhKu9OmdO+MSafL8y
X-Gm-Gg: ASbGnctufX3WxCbbH27IP9rpy8b1fpX3jNcMZVcNM4jkFcsR0mu4XYgen3Rrw9iAiZz
	+DIBv7O3wuqpawRrPalKY8gHNK0c+pKNwz9IxE9+73pXH3G4bv5v7TSV3NRUFmtCP1s+hUoZYqS
	sEsq/q3Jmu+4rfQBGpjGczY4/YVhhgZo84yFbl/vyBHrEC6+TTzhkPIvK3N0d9SE2Q73dBdjNtv
	xxiITddBZaGqwV9dlOe8uvyFnVtqk4lLAdcnQKljKzr4Ba8DLjO0o81DymVQbwcQxLQU8ioSKjg
	xgkuQcXNpYDZmAx8xTYr/ao/GJJdX7qBzlOGc0guwnMxkQ7HtJ7G2rrnWBwLptKlwsPqad3p0DO
	4CDicP6ZEljrpTlY3quRcNGqjv5vosBU39NeUkBMXnG93sDQ+txA+jPPJ5KTlgm2GIcZvhkp5K9
	arn4FtCilP2A==
X-Google-Smtp-Source: AGHT+IETxP0piQQXRfYo8MJPQjBr6mx0BVDdDI6wJbMkF2fkxXCWQ66bK1gemVwC592OH5/z0h9vpw==
X-Received: by 2002:a05:6402:1ecb:b0:640:b736:6c2f with SMTP id 4fb4d7f45d1cf-6453643d0abmr850460a12.18.1763590665075;
        Wed, 19 Nov 2025 14:17:45 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d09:f53:a4ec:610:b04c:9669])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363ac8e3sm603716a12.2.2025.11.19.14.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 14:17:44 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Thu, 20 Nov 2025 01:17:24 +0300
Message-ID: <20251119221723.171746-2-eraykrdg1@gmail.com>
In-Reply-To: <20251108120133.37443-3-eraykrdg1@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.

This "zombie" inode is created because ocfs2_read_locked_inode proceeds
even after ocfs2_validate_inode_block successfully validates a block
that structurally looks okay (passes checksum, signature etc.) but
contains semantically invalid data (specifically i_mode=0). The current
validation function doesn't check for i_mode being zero.

This results in an in-memory inode with i_mode=0 being added to the VFS
cache, which later triggers the panic during unlink.

Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
make_bad_inode(), correctly preventing the zombie inode from entering
the cache.

Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
---
v2:
 - Only checking either i_links_count == 0 or i_mode == 0
 - Not performing le16_to_cpu() anymore
 - Tested with ocfs2-test
---
v3:
 - Add checking both high and low bits of i_links_count
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..c8b129db756e 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1456,6 +1456,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (!ocfs2_read_links_count(di) || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink=0 or mode=0,) detected!\n",
+		        (unsigned long long)bh->b_blocknr);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0

