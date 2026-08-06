Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AD1439006
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035568; cv=none; b=hY99NkkMGGz1MSdFDX8zkbdQE10wRT7DrlLpdmGAZiC5Zc2R/gasKPbM+RJYquzCQKCNE+zOVy/PS74XJlUILTlGQDk8QO0WY0Ge6erIoitPDSEd8Vf3nOvpeQ9ClrC++QGZxFHXZrK/YhuhFypd+CPoHxYZGsqza7dNwFsML9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035568; c=relaxed/simple;
	bh=rnhWvDAamvoYeIKRmdifnx08e4HD3+YvwIOGYnqYA4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTNMR7zjvzG5ZjAEi7EbfgcvM1+FHzM8OXWirpnvA8jDuX4yaYa8N1Rknbwc8pIDugf+m5oMR+cXucYHg7yNDxnj7dlFdcTM8OwCqGNivzCOkbOZH8aRefFINWtDA6UaE5cm9p006ZVONNVe6bvkMBJWu6LzFLY4Z5HsmZ/Jbxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8KoFB9u; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8KoFB9u"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-9673385b1efso874119241.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035566; x=1786640366; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ByrJwOVSq2vYDCfCPUNcQuCIafVp6X3bai0sLx612mw=;
        b=X8KoFB9uaVO6oV0aDDWS+KMPcr2bWdHzvzEv3jcH12QoQwGXlaF4jdqJzLXHHTTgZk
         VuSMoDlPk0IMuOTxHsyyawbQZQt73ePwtHpFHn8ZxRZoZJqC7teexvPiW8U+REKdKmiL
         5p1XRuZQ/shrD3BZPJBDos7zub3xngJjDy+TYOkvV1pCOgW5RGJjeLoKycvmKZ19iBxE
         y/wZH8W9DPZU4G5ogWty7i7Y9bqjrz/pvWN5CFns1PvGO46dxQ8epWhRhB1NMrU8TUdp
         EgD/C0NKSZtFALfFzm4tcRsLAmi+ge56JLAex3IuNVjBIoV5XqRHOwUfA0p5ASMG0YTZ
         eckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035566; x=1786640366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ByrJwOVSq2vYDCfCPUNcQuCIafVp6X3bai0sLx612mw=;
        b=N4zJzkfdlUJLm+qDj0RcFQBdCiNbWkme2cZ9fnpLKzdeeaC//BduApXPGQrY84fMYm
         VeMoiIhKSoRtUjzowi1dzHP953Dv7scrNhryhIXOSe6FvFqiRkcQyVr843at5u+kW1Xs
         B4SzXRkXjfUr+KFw/SwhnrjS61iQVB4WA0Nxz74IVhPa+BYhU+0EScrqbEcBpCbDDj9Q
         hKDS+H2ObGLAXMx6Z308/Qd5/NHh71SoC/NyhpSUyNf1X+0iqYU+iUbejD+djRMfvXxD
         DQlKglC2PLpa56/5ZoyTrrwMlM8fvLFXmJ9IfnNz2sk+BH9Cvuu73S+7++rk+PSgMLfn
         S3xQ==
X-Forwarded-Encrypted: i=1; AHgh+Roph0VoZzJGj9J9D5gyvlJA6TqvHIAzj+o1tQRtJiEYUH+p4LVNbXtXPbJI4TvTleoglfaRbe5Oxrj1sw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyXCR6c+pwcKR/nkIkcfSplImC2OZ71DocDtZ9++kXe02q1OtHp
	dkzZK9Lqqof+fQ1Jc8ROfqXotifJVeiG13715eNV/ysD+uVXsaz7QgKp
X-Gm-Gg: AR+sD10qwJ1xdsXDPM9EzQEhmsttvrURBYvj+CBaou+TbrciHmaELAVQoL+bhkg1Ca9
	twAQ9kldrypwW91ZVHu/eCMIUvlg8GCSYEhxdxg376rGz+QMkVn/cq7V88kndM5qFXlg7TyktQs
	biTRTHZ4WUJpNYfKUDdRTyFgMSNwDmRWHA2aFygJaVi/ZRkkhRJYVbndkU7dB1KCdHBSuh8ldyv
	vwcVk/LwndjYMlw9SbmxeH3t85TCZRAnwptVU+PV6Br7RK0pkfe1MqEukq6CxvTnpU9rNgyG3OQ
	OcHH4HV1Bfpw0rg/uEprSKrICpf4JxujBzZlPVDfQrGv+cCnVHLtMgWYi9fdAHGd6uIRxmIY95C
	v7VmZ31Webrr7N+LPdovJSEZ6lS0PCu8dVqvlPkfo1dVkIFZqmB3O/VpPXA3eJFWIRslICF0H6W
	cTRd8KrfL1C6Os/DJfzDV9WpieKce24xmLtTAETMPbylMdlL/3nkePrrNy6BVl4Bj8JPKo8Ah5S
	tdwJYo=
X-Received: by 2002:a05:6102:6c7:b0:631:28c1:154c with SMTP id ada2fe7eead31-760e9e4714cmr4097167137.9.1786035565908;
        Thu, 06 Aug 2026 09:59:25 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:25 -0700 (PDT)
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
Subject: [PATCH v2 07/21] buffer: detect metadata write errors with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:30 -0400
Message-ID: <2b309196b883cc8979800911a47668e225401b2c.1785951556.git.coshi036@gmail.com>
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

Both places in this file that report a metadata write error to a caller do
it by testing !buffer_uptodate() after waiting for the write.  That works
only because the write completion handlers clear BH_Uptodate when the write
fails, which is what this series is removing: a buffer whose write failed
still holds the correct data, and saying otherwise makes callers rewrite,
re-read or WARN over a buffer that was never wrong.

BH_Write_EIO is the flag that actually means "the last write of this buffer
failed", and both handlers already set it via mark_buffer_write_io_error().
Test that instead.

No behaviour change: today a failed write through bh_end_write() or
bh_end_async_write() sets BH_Write_EIO and clears BH_Uptodate together, so
the two tests agree.  They stop agreeing at the end of the series, and this
one stays right.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 570ce7f495d3..aebf74abbc49 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -618,7 +618,7 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
 		}
 		spin_unlock(&mmb->lock);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 		brelse(bh);
 		spin_lock(&mmb->lock);
@@ -2743,7 +2743,7 @@ int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
 
 		bh_submit(bh, REQ_OP_WRITE | op_flags, bh_end_write);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			return -EIO;
 	} else {
 		unlock_buffer(bh);
-- 
2.43.0

