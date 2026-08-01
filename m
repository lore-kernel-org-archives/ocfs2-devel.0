Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6E63B14B7
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621689; cv=none; b=peyRtWo13dBe0c0V3aN6whruDmydcjgfUcEtzVMbzHzFoNBXlKjQpl5OD7/Z9DrWtfusO8as9untVMO87BbpMOqH4P9mS8byVQa/ewhlCpXJvLAA0r++JQT9CteQnDOZiFvPExVLkWbJKG/UNz3JtybKgAJ4UiPFrcxx1REiP8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621689; c=relaxed/simple;
	bh=B1aGoafSodbJHnZvQa4U88gzZAbdOk4anLe8al4k4+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NM8hZyLQiIDuVjUCU+f01eNurNUlXao9Z9y7SEg6DrQImYJyQkRZKqbqwg1yUdX4eqUJL1O6k2Sq1AI2asVB6OKT7NZOg5nIU6wi9SdrWx3Wy/eQgyejdDyjVqCNd+amsjFoOL8i3nPxhBSbErg434Gep1CaneRS3EsGpHS5VTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5StGMmE; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5StGMmE"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81e86df8987so30976487b3.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621684; x=1786226484; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fFKjhKiLwW7000gY04FDp9HuhYK5pnv34+ERWpP83n8=;
        b=k5StGMmExexjd5YCUONucz1DfZ0WwihyRmtU2k663dKxbRL3nE1lUKOImgZ6v8Sy4g
         iekkJL+LK/khdoC/jcpu+O+YyS+Phi+Hg8mFobfJ5yJmjVV2uAx2FZs1xrtPJFz3GoYA
         h4Ega+k9l8eR3PE5Q20Errp+SCtG40cT+cN4HQg08d2IZ79kcBimx4WKBzRVoHZnn7RO
         5Watl/kVFOKdEpP9aQHLSQNEbOTLo56vyARBLjdif40EB34VRMPoaAGo2KTvufzVr0zm
         bPiIa9vKYE4We8aEJFnUtmtG5mGoewgOnwgn4K6Q3i2/xwshNW1dNFBAGQMAqLrB6cEs
         01mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621684; x=1786226484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fFKjhKiLwW7000gY04FDp9HuhYK5pnv34+ERWpP83n8=;
        b=aRbdS2rXf+dQrBhIClJ663KOiA3nFj/K0vGSm58RBliFoPMRukS32rTiVMkjTXDTzr
         yUQeJ6geGHA9ZRcSss3O+93dZ9zxKR8V1cfBjAZbFIE3pIOwWktDJ4T/IugRme5NQVsw
         VRxrmnK5mfDOS4JA/CqRDFSylzUfXh+zCcCnAXxBZzizfp1p1wf66zFJM0EVXH+CfCfc
         svNGxYJtnHOx2zzrGPQDu6Tyz1tKkcz+7z60VUS2/ltjF2rv6Pc3cf/57crO/Jl00Hri
         A4VdTrNVskugU5POBuW5ioLLI+yHC9PTEM3ZrpST1wrcrxmYfG/0bnXj6Spc1Gp0k2gC
         Cdkw==
X-Forwarded-Encrypted: i=1; AHgh+RqDirXbTaNO6ICycd+A5JzmNDN8ukvfy4hYvz9xds0tvO/a+UKYVhMJcjU61hz6qi/Q6gAvKDXHXJlyGw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8SVkj2us85WDQEDbZBtezFtwmb9mbAljIOBnPQGlCbF0PyxB4
	qupZYIw+tt4yDbIW/UoMd8NMlYdyqGFEEX0kT/664tn1GjgXzsJdcfPx
X-Gm-Gg: AR+sD10PnE1j713TvMqjqn3SFnGrxHcX/MbgwqOBJUHhm4/09uuwTftV2T4SRWZFyQz
	B7Tg0FLcVhzi1B+p6YyjXMNEF01gsHpWSJHpzlxGx5MWW9ZoXIxkmVIp1aSB1MMuzI+hjQxg6Zs
	HKGlokc+G06ysd3wwwmsVzPxxFAl2NS/TT7CEescFkq59h7Llv9W0rVH32Bw+iDvUFJU+WfdGxm
	586XzH9tJrDB1PDtjPGdfajyg9XQ+zt9rTQ3i64XWRNGDCeXC7/lNX8s7kjKNbh/lzmK+e+BTaF
	znw0Xa6AslK2edrzn3INDZJEVITr1i325ITDlg/yCHF8uylIxNDzxIf23qlrjteOVGfqX8Nw89+
	AsdlH16QJzTDy9SELQLTsEDzTDfYmANH2JlOQ/YxKPCbp7O6cTyIR3BtBmzUVEb8A1p6T1LQtIy
	1qFH7NZfVDWUD77TOp1mTzhyiMskQtGal4v7rDXaj5qqv/fPp/4u1U0T1rkgaSpghd4enmBvI9P
	DN9CZ0=
X-Received: by 2002:a05:690c:d8f:b0:80d:a249:4854 with SMTP id 00721157ae682-81fd4b59a06mr68933057b3.17.1785621683893;
        Sat, 01 Aug 2026 15:01:23 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:23 -0700 (PDT)
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
Subject: [PATCH 10/19] exfat: check for a directory write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:54 -0400
Message-ID: <debeabce46c73ff63152dbdb67eba64d60c45c98.1785621505.git.coshi036@gmail.com>
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

exfat_update_bhs() waits for the writes it issued and then tests
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

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/exfat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 6f11a96a4ffa..dfd0bbf31c94 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -187,7 +187,7 @@ int exfat_update_bhs(struct buffer_head **bhs, int nr_bhs, int sync)
 
 	for (i = 0; i < nr_bhs && sync; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0

