Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D049238F654
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621685; cv=none; b=mJLwrLfa10ypQ+bVkNckT75DaIlwSgXO7OYy9noh8yUT8pKmi+gPQCJFUjkHmC+ajvO9RQOu8ghq8O8xJt1N9R89dMps8LWYReC5Lyur+1Rwnz8ndvw3ogNqYndd9YIdUG4zFvk2Vo8KHbkUK1QnSFNH1DJ2oHYtR5EEpBouev4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621685; c=relaxed/simple;
	bh=rmASDDjzyu7ORP+REJJAPqpbg4Lkmrb9SobBQ2fdR4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsVTMCCBYOqDZAsDahdn24SQEoFn0lrxIr7++BmIMbAhYRuK5nlhWf8cOSp/677p8s96OIc8Z92f7qYfMvDTSiNRSgCLFivQMk2bJZT+2IRyRBkAeEeTq9WUGyl1tf3zmM/szcF5VpyP5o+iALZQpaLDqP98f2D6t5a1MAKMi9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=isyW+sg4; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="isyW+sg4"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8143daf89c7so20626407b3.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621680; x=1786226480; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CmPK9JWvOViXyoDvMWnuptWNftqO/5jbHBuyoy5p9Iw=;
        b=isyW+sg4exUe0eJuoaiW1IG3vvGFE7BuzcE5fB7mmZ+segKul8vWhmoQFyCM1rLE9A
         tznsrrqV4k5aKG5qeq9cMq/HN0hJzNTfMwCjjEpNdgpKc8zv1C35wrqLjp9JhDSYMgLu
         i2bDZ7rvnGGd5IQjYkJDV1OgquFK+UncJC+fasbpDTOOwo2z2Wtrss+7PghJctVkbtXq
         QwW8rIA60spW6MHQIbvp1A8ePv9hYgK8Ql2pHI1Lp8thZH0RIXOJqdOk8rda8h++Iy75
         fEw+pJ/aWyd7uiZSiXQDqyWKmFvs/dAtFG8EKvLeZqaAeKGqjwVO1fk2xbVgHI7o2bHK
         GNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621680; x=1786226480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CmPK9JWvOViXyoDvMWnuptWNftqO/5jbHBuyoy5p9Iw=;
        b=fyPrH18sI4/eQXb/ucWrkV+z2SmRt4K2sXVMsAObaSyHuynnF0h9NP1ThH50eDlPHi
         816HFVy7SQk6mycAlpI+15Sy7nksskpZsASP1YcFXhhxodrNxmDoXJRLzjb7ehqRaWua
         +wgSwSCVs54oqnwPl0MDL5FJHfoFw5pGOytC3bT+EqVr75LGa8gFo0h5qpR+o3oo/hkK
         YKpCF8cBpo3WRd0pL6J4w9picNC5A3lYiZSzxyDHE9+M4q3RGC2Uow/7XwbIj+kfXbOF
         OXlSnbhG6EDJ8/A+OdVqL+lvTlzOJKlHMGMVN8Xfol3YROK3QMYP7ywU4iiTEOI4Jz7b
         3wgQ==
X-Forwarded-Encrypted: i=1; AHgh+RoaGEnJgzKd/q7hfTnH2czvOschAWrJpLS3ZyKPnByq6Gzr6/pcKwbFWlUVSQp75gfgKxt4G2m9W+x90w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7aoYYP5kFWXGoQP1Dp1cdogCpXArP7PLmWKw3nKo6UzWDYZ60
	kgaQh2p/FehAOa+txAERm4gAYmwPOVRIcVYtOFpbIG/zFDxHBDMPHGhM
X-Gm-Gg: AR+sD10joSPt3kq4cZ1r8MZ2awZmmSmiHx45k9aVgCQ/kuILvE5Acj68Gnl8s3F7Ati
	Zn4DzdmRejyOoXjDg0+pYCZeG0swn2MtZkFbCNN4AymfeODZe3TKWJPkBKuOsp8N+TSKjjBt2OT
	YG+xSupNxQL6tIfbZk4HZjx0sgJrxkBjNgI2DXP1+0VYM3poKua1X0IwXJd2CAJiwNh4vQF0ora
	bDD14uo/j7EFGV+fWciNH6V7ihT3THoOmu4MCx+U7bEWTquMgRW0ol/UvGN7MqLJ4ZzIXW6uRhk
	hdSmIM7IXHLm+dDMb6eaZSAeYc7CHY5cXPN+fa18dvR64N4XMP6CE8P7GU1NjHqW1B2tEXzrDmc
	5NWSgFoWGUMbD7FG5fqgle89nEB7jXPTpr2wslCZE/cpCJjpCA9uyT7nnwAOJ5ikdbfN12Zy/ln
	zm5r/izbAw94oDSa4F6cnEf0AE5j0KRIVPo+N9LWzQub39GbAq3+R7JoyC7ShuedtU64vl/AKEp
	KkuVWA=
X-Received: by 2002:a05:690c:dcb:b0:81e:d009:1956 with SMTP id 00721157ae682-81fd4a21566mr79336867b3.12.1785621679620;
        Sat, 01 Aug 2026 15:01:19 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:19 -0700 (PDT)
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
Subject: [PATCH 07/19] adfs: check for a directory write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:51 -0400
Message-ID: <b688ce1ef8805684f8c529b8934406ddf6e34da5.1785621505.git.coshi036@gmail.com>
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

adfs_dir_sync() spots a failed write by testing BH_Req together with
!BH_Uptodate.  That relies on the write completion handler clearing
BH_Uptodate on error, which this series removes: a buffer whose write
failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so the pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/adfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 11afa9e157aa..b8cc6a697a05 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -191,7 +191,7 @@ static int adfs_dir_sync(struct adfs_dir *dir)
 	for (i = dir->nr_buffers - 1; i >= 0; i--) {
 		struct buffer_head *bh = dir->bhs[i];
 		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 	}
 
-- 
2.43.0

