Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774253D9DC9
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035581; cv=none; b=P5SWm8yBVsA00e7A8wfztGB4RmWFIVEtpa6ll2KqOGpWud7b4EJdSg7b21L97FV+JYhXYhv8ghRfDs+79U/f9YfjPw6w3ys9lzgU+1QSg8MYl3513uf//nqmR4gMZ9UWO2XoLja4TtKBdcIPYoSzlg6befC3Z1nUjC31b+3kQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035581; c=relaxed/simple;
	bh=tpriWxWOl+J6JwWfTTr6TdF9jz0JsOXJvxWyKOuU9Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FalOqfn/YKaIvwdPDxlY7XJfsx1Hpu1dJEcJFOtqi1/aKuDwGpOj01k3dOAAJDGUQPBihJ3qZmeSxyO4GUTnG+VkekM/mn52Gs38reVfKqyW3D80B9pTv3g6AJqef7SpxPatwfsj5QVZFnRp19fvzjtyJY4W+YWLBhXP5rMWsA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cL5J0DGw; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cL5J0DGw"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5c276bfce7eso1726597e0c.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035579; x=1786640379; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=duwKRHlWbKUb/BOL4rfzAJNO2P4dXrVaNM+8BQLZ4gY=;
        b=cL5J0DGwY8j364XPISNMM/Ap9DL2DUzSviXDlE4KPTm8+HeOtsY8BWXzgAUQOhz92c
         wobfTj+VRrXx6KW+BeO3C/iLPNFwiQ5dMItdV2RkLnboCaYVMi5IDfvCddyy+CLNKbAJ
         DXRMF7V0zqfAc9QVHN4xYpparQ1jGx2a8BEQZYYNLshTAAElcN5zJpVB6yCo+8L2fc1a
         0s2508nBu7ewxZaFZgBxStnZmIVn4FE20fEZ7Yg44caDncp3KnLRBfWGISmG5qvD5RLQ
         mxQB8Yak0d2x530SXLU9sDVqH3UpsgYtXWk6ewBTKk8KDAPKwKAyQlaTyYU1DvmZIhJj
         998g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035579; x=1786640379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=duwKRHlWbKUb/BOL4rfzAJNO2P4dXrVaNM+8BQLZ4gY=;
        b=VPt6X5umJF/9xD6NRSRLxdw5R+OieuydGM6q1ZQ74VsrkJaqtB2VTlOsHs2+geD7yd
         4tI3oTi4gtxCsXIwC0r9aiXPNlhpValXjDcGmqIGC4ShGR6Q8BEwmQfnGf7BwR0YT+Mc
         m6W5Wtk3rVqHURfIcMB/0rnNveApij7JPSXik/gGAA2UIPiwvp3ALMOp+jbK7ErZsBLf
         3wNGZAZ9yXxGs6vH6llHW8aGhlJYXKCbJSTMwz9nOHechhU1R0gAW9IH5+S4YpQyaw2r
         Xc6F5IJKJtHHCEZmrhAL3jQZme47ZVHONTZCJGDrRdfTTFgRdhA2a6PNB+kXEepLpEQn
         dSZQ==
X-Forwarded-Encrypted: i=1; AHgh+RpqNyJZ2fEYqKKXPGT+427dI9xjoykhtDGbqMSCPh8fwbLf9jcBAaKUeW/YOyEw52+o4ERu09emuqsIPA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJga3UfArlhEx7znsQTCHifJ2UJMULxV0oU7kH5zZz9yPgAozB
	UB0swLTbSsKFvtGP+vA26VWGNNfOyEu6ZU/ZB5zhWubf216Emsjnb0ro
X-Gm-Gg: AR+sD13JT/mFt29jUZObPPwSU7fRhsaJaVPpMeYu3WX31RSqDcrCc1dz9IpzyTnImzI
	BY0e58aI/5LJtgu/Grv9C4KgDj6eoSm9ZTjOwP3Sr2LF2AZkcDGEJZlsY4bPW32X68X3qAT1rMd
	YSo68Qgra1rp50VTqKb+QHCiSpoRC829nH0rEbF1ACcqcuwibIgtGIiYtpodnTtPhQxHyQxOXy3
	I023bkuzMyH0lBAIgfH9ClwSNuYI/ctoqhaDpp1386LVODax7839NJ8LuvXqNoW6MNAN5bfFDEI
	vzNbJvzik/rJGnrWffIMOoKCKFZLzgTFcufaABEDwU4PEJt3ygo5PPxjsH64llcjGhkcNqCVcJu
	2uwPIxF0ZYPJPbcqibyy4Pa00OETkhHW9fInKQdsn4cRv3cPr8cNa2EpcgOd9Y0VU0QdJiGOn2f
	y0a6Ba/nNowaiSEznpFx1NA4j4wywYu9/+vBpxNWmHEXM8EnG9gv1zUnKZRVroEfqN60W9t64Pf
	Mp1IeCktmxXvcrbZw==
X-Received: by 2002:a05:6122:3d0e:b0:5bd:b27c:bace with SMTP id 71dfb90a1353d-5c3d926476emr2526056e0c.14.1786035579340;
        Thu, 06 Aug 2026 09:59:39 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:38 -0700 (PDT)
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
Subject: [PATCH v2 09/21] ext2: check for an xattr block write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:32 -0400
Message-ID: <fcc530fffd0f1e18e8cd1a3974bc0ccc5b4c4b66.1785951556.git.coshi036@gmail.com>
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

ext2_xattr_set2() spots a failed synchronous write by testing BH_Req
together with !BH_Uptodate.  That relies on the write completion handler
clearing BH_Uptodate on error, which this series removes: a buffer whose
write failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so the pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index be63f89402a3..39005ec23fe5 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -769,7 +769,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		if (IS_SYNC(inode)) {
 			sync_dirty_buffer(new_bh);
 			error = -EIO;
-			if (buffer_req(new_bh) && !buffer_uptodate(new_bh))
+			if (buffer_write_io_error(new_bh))
 				goto cleanup;
 		}
 	}
-- 
2.43.0

