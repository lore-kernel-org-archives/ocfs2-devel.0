Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE4C3624CF
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785982870; cv=none; b=P6unJhDYraPJrMQ1+DhiFeTMVDYvc9K8CEoEsRolZs5eMw08jAsFytUdYwTXmWh6nXKGN3tNJ2kplngYA7D7rfAmKw9xRNzf7L107xk60LrlWq0v2ekF0WMEnHWCaz80Pn+I6i2TWhH7eBCT/hHfAqas2tfkSjFYARBNJxNH/5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785982870; c=relaxed/simple;
	bh=aElr+oM8GmnVf2UqrRKSwUcnpHH/Ir6i4A3hxs7+FYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALnUtqbcSPq9ZwB4+482ndrzDE3j9IVa/W2ii5lnOdb1l+oUG+zS7D3ywMnY2e16CUVZWk6ICWJ8vbWjZe3qPhJA65S2sZW7vPUKCQaavkvmWRIVklaAV5GtmpptUuk2iyw+M4kzurixyZZ8X88PpmxIZBH1fPjuzY5lrrIMV8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+bGTpzh; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+bGTpzh"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca957432c7fso1589146a12.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 19:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785982867; x=1786587667; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9bmjwDcDA8gcdpbpxOdxxL0d4dzraqR1O53qZdgMcs=;
        b=g+bGTpzhsajK5Kmd3Os2sIqyj81T22smmewtC5ICxasnzakgeYrDWgx19KX2gMCkQm
         8iygeP+lMLaPTqQOby+cfugqWkD5axCcsJa9LuspsjmSTy9UxzKtS8MSZra2JfPcXDpH
         e0HcdZnk7r+obGqvjmFxhZM1FjyNOriqNSs5XntRJMez6dR9beT+/8JIhhjc6vUhPduO
         WuqvIyuMHFf6FcVT/dgQRfYczv4q2D61zMf+btokisrv2AATnru9CZXBiROKt+LtB8y+
         Qu4uikZe9xY60YoqVxQDF9OCxZOqjm0OeYAPcKpo5QoA0WZS39aPc6tXsWOv1LcZUG4Q
         QCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785982867; x=1786587667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t9bmjwDcDA8gcdpbpxOdxxL0d4dzraqR1O53qZdgMcs=;
        b=LoOI/R54X9VcY9cCXvwP2scvweszytqMwKbtCGgAIVKvxDgMK05rbobCuohdC0B//0
         tzknc4u54CtlSSy40N/RXBpQkKYvfqgh8sp6JEVUGPHr7GLOUe5tmYYpN79K1rordmlf
         o/9U4Y+lvxb4E4K5FAgRcqAOlebY4B8ULRKflHCvtSnqUn3rXd2miaWic/52fihDoCoc
         qpfJYdf+MbYIsuTfq3RwM2ZhFtaE1FLPk0DFWzKj9uWsXUl7GiJAQFz2eqFGIWHwhHFr
         pf/MxijjB0dVOeSf/kGh3vWpfhVoTKAktYAyFiw8K8Ba1toJZblpNAUpmQfQ0dp/EYhz
         aT/Q==
X-Forwarded-Encrypted: i=1; AHgh+RoFroOXq4s+zZ96bY+M+gpM+RTcG4+iTdoe4BvzpnsjemZVNJNwtU7mZrg3YEeqegVv+7ynrCfhehdJ2A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzD+e+NiHBXieT4B8E+gwKq3LFE3WDf8gWMI1T98tT8wxqHBHUG
	enak8+JXusEJiE+/N3GTQOFTzpCFmueb4G9FDnj5e8UlykFCOwk892f7
X-Gm-Gg: AR+sD12KjJPEjehWcTZrDu/IQjUTbqHKkCSfaGdTWNVpzS11R+yCkgK+EVujSH2EIfx
	hget9WGabWeLDz6PJuuvBk6TrDqH/j0LG0FYzGpi7JuaMwrTCsKDraEoL31a8dGOdQH+YMuxApk
	qDeBkizpok90AjPgUQkG923KTM6Ap0k5z8ZnuG+B8VYrrMwwoC5U08MBv4fF+5nfTtXj3Ido+Ex
	pUEgd9voI1G65TKi5YvezFR2PseuiOM6rJqy0em8RWRYUzEEMgg+d46JnUClFoxt70uAPvtiQRb
	sRZf3Wt2hEBfuzd1okqktnIiXjgp4fTfsYT+KSLO+jwLm0WBH2H6JtLrd8KCaK+ZYElLWska6z5
	z6VsVBnNwukcBpqUlnK4dS8abnoMLCfwBDmzWSxzWEDYcyY70KMYIlcGm1lXY/vgmNkELG5Gzo9
	NlYPIGM5pSXIC0MSkwREvO7c7KissRx9fnc9AteMGsqoG4QWT+vZ5MNzvVS4b5f/GHD9EkkyV63
	AbHPU5+0jo=
X-Received: by 2002:a05:6a00:9a9:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-84f2dfcdcb6mr12615394b3a.2.1785982867454;
        Wed, 05 Aug 2026 19:21:07 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538ba99sm323012b3a.9.2026.08.05.19.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 19:21:06 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ocfs2: fix readdir position truncation on 32-bit kernels
Date: Thu,  6 Aug 2026 10:20:44 +0800
Message-ID: <20260806022044.167962-3-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_dir_foreach_blk_el(), the directory cookie position is
rebuilt with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

`ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask

	~(sb->s_blocksize - 1)

is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
block size).  In the AND expression with the 64-bit `ctx->pos`, that
unsigned operand is zero-extended to 64 bits per the usual arithmetic
conversions, yielding 0x00000000fffff000.  The high 32 bits of
`ctx->pos` are silently cleared, even though directory size is
allowed to exceed 4 GiB.

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
position is reset back into the first 4 GiB block, making the
re-validation path re-enumerate already-returned dirents indefinitely.

This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
for all non-inline directories, so a directory large enough to cross
4 GiB reaches it.

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat, and the
fix mirrors the equivalent ext4 fix in this series.  Cast the operand
to loff_t so the mask is 64-bit before the AND:

	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

64-bit kernels are unaffected.

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/ocfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d7fc3cccf2f4..c30a86856d5b 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1917,7 +1917,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 				i += le16_to_cpu(de->rec_len);
 			}
 			offset = i;
-			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
+			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
 				| offset;
 			*f_version = inode_query_iversion(inode);
 		}
-- 
2.43.0

