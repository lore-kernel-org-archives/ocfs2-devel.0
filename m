Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C6137A4AF
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 08:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230791; cv=none; b=ts4nmQKZoi1nOZcccUmtmdrFNLgT0oLhk+zgRd0ecKUtcPT/K1AWQKOMhVUzzWUiMOsXqC17fjFI2RI6u3mxPhkofPBx5xwvxOB0Y2uNstsCNjo6PP782KbEPImi/pC0vSfu/8hHeMfILnWZwaV/NALVZNmFSHFh+F6dG7ndl8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230791; c=relaxed/simple;
	bh=XZ2AxGd44BGqb6s1OpcbJ9fXbkAw+J5LMr3jUSfyuU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr8+G6HNL7Eg/9X7C+51LO5choFs8k9upIgb8tzE6DRwGETQJLW5zrFOk0M4xjOVgvoRH3+tG9sv8n7YtMAa0va9rMSdL3SoHy+FIxMxDBESdXUkp530L/B0+YVrJLY1ipUmjjb96GZ386z6CTl9vA7jEdw9TGQ92QnMNWL6Wns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2gEyLep; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2gEyLep"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so15576555ad.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 May 2026 01:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778230790; x=1778835590; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUwXIfq13O1zgTkCmaAhWKKGGyYV15U86EllEIJj79E=;
        b=g2gEyLepKkSEWcVlceRg9U/oTB1AozTsAEJg1VI2lGYNhgqF1Ic6QjpKWU67mXKvdQ
         gIyXy9/FRLZW1xvspvfWn2ZDyzbMTxGQkhmW8Bsvr4oNdLxeIw/hlE1i/ACtwghHsV3c
         1HJ8VA0vF6YDEDkHMbgx91sh/+s2OTtPtMdSzOzm1KpVOvZtZ3LjCSu2sRxJEbhJ5DJD
         Roh2kBeG6Ys4wFRoD8r3xOaDACqCxxVITiHdIWNO16di5SMTLBm21iarzaOro1soHVZb
         sb8CmB+vzViuKEkCFmY02bPE3IT7d5smFSZ/m5NtrAS3WsPgwkKWaRobEsABBwECLVho
         Mj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230790; x=1778835590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EUwXIfq13O1zgTkCmaAhWKKGGyYV15U86EllEIJj79E=;
        b=W0r0QgTuU68bZ0i+lTmSL8TXdegA8nwYK9er3asJVLnKmNaQwH2x4+nd8d/hgkg7/X
         +14KuhPJmvjMVbq0qzot/rtKTzBxQwfxeHrosymXYfQqskk7+Z9YG2d6ORPUzvTAKeDC
         k2cQbXSgNQNygeZqjLKajvsaNQzBfK2AuYGZn5Fwk0o8TaJYth3ILlW1DpNytM3RYj/k
         +KNlu8o2iNxy0XXuxXv6rT1PdnlnzKtGd1c0uKSz2oWoJw8DMNMUZsESiQ3jgpnmlCd/
         oT/deKNmKGl0qoVurBBKRdR6OJZYIRmlHhwvO4Nqi0cexsPkjLus6HsZLvfUdCWj8dRH
         aZTQ==
X-Gm-Message-State: AOJu0YyWxqwgYn4M78MiNtV7eG4ynU033uy+RFxPpD4yjJ2GD5252gne
	Dz0U/x/Xx1zIa4tUsK9Ejw6rj4I3KG7FlZlJ9sCxUwdkn3ry54H3V7gq
X-Gm-Gg: Acq92OG0g3w0Th41TJCM1AQ44P2LSGbhBhqeWybdKvWd7n6eHYgs64AfwA22VYDZwqX
	hyDaaUWuXKDivOYa7fjCOlzpreJfPWP5JJ0K3p36QrvQ/TUFQvTqXsgjnAAw/OxhsrdUUpsZTdf
	YrruIWhkGvaPWBAlgyfPH7ic7VbYzqF+33wy35WuRM4rfuHbd6xpgN2ZW0wRjeZ5tFdXYrdwxb1
	CO6Pabmz47jBqxlwAWxc8q3eG9zaCemPDAxQqdmpURO3cWRd4OlK9QeO3g3U3OmJikp63PQjb18
	59uarvxQt76T0B/oIW0ehSaxW5S6qsKGf2Vh9X4ZdqWHoa/khTI0sqYeKyojSBirlQ4I1u6GhuU
	7tdLF2DGFL5K8qXC/1h0OR4hvs3dhJstJ8VU7k6452UGNXU+AvRPoo8cno+UooabXtJvrHpGKZZ
	Vly3CtkX+hRKPvwo5HJjwok7RM+OOKAxO4KkkERUtVLuiNCM00ChqQc8On2m/y0nJyLnaRFLkTx
	4JGiuUnSMZ5uJK3KoY2QoOggg==
X-Received: by 2002:a17:902:db02:b0:2b0:67a7:5c4b with SMTP id d9443c01a7336-2ba79bdcd67mr114567055ad.28.1778230789622;
        Fri, 08 May 2026 01:59:49 -0700 (PDT)
Received: from localhost.localdomain ([111.202.175.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm15526795ad.5.2026.05.08.01.59.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 01:59:49 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 2/5] ocfs2: validate inline xattr header before checking outside values
Date: Fri,  8 May 2026 16:59:11 +0800
Message-ID: <20260508085914.61647-3-gality369@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260508085914.61647-1-gality369@gmail.com>
References: <20260508085914.61647-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupt inline xattr header can make
ocfs2_has_inline_xattr_value_outside() walk xh_count from an unchecked
header while refcount-tree teardown decides whether inline xattrs still
point outside the inode body.

[CAUSE]
ocfs2_has_inline_xattr_value_outside() still computed the inline header
directly from di->i_xattr_inline_size and immediately iterated xh_count.
That is the same unchecked metadata boundary as the ibody lookup bug.

[FIX]
Reuse the shared inline-header helper before iterating xh_count. Because
this helper returns a boolean-style answer to its caller, treat a corrupt
header conservatively as "has outside values" instead of walking it.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3a5a17cdcf7e..05f6f0a886cf 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -989,11 +989,12 @@ int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di)
 {
 	struct ocfs2_xattr_header *xh;
+	int ret;
 	int i;
 
-	xh = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xh);
+	if (ret)
+		return 1;
 
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++)
 		if (!ocfs2_xattr_is_local(&xh->xh_entries[i]))
-- 
2.43.0

