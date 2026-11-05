Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872198;
	b=fHZTO24+7/JGPmu/7igL1R02W+6axaO3RyvNG/Ixw9vYsP+/Uw/3s8fxgO69GdVJoCoj
	 YgXfhhcx0h8krLnWYVWOoGM+siQXZdooNmkjCY5liEV6OLZKh3FLXFsn+d3V4WjCTyb1k
	 8TRlKGPkN682ocNGf5ySjYLa6lIeDT4EhDQA/ryuOryhHK90IvRFkNu7fdEG4GriT6BrT
	 ewvFNQddp2u0hP++N/10SC3FsM1xVSmeEMkQ7FNSZ0kXRq9WUF4Z486bFvkcbvtc0HjWV
	 QvpQFiY9iu8ufNEEbuVTP5GQEwP41vBUvA8IVGjwxao6s9TiFU6qmjW+GkoDOvS+KpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872198;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SX2iWgwwTTnfuBkVYLRjLx6wOTnegLABFMy8vXMq74M=;
	b=LHtCg+S8SJ43kOQ9mZRI1zr+P+cggBRYzQNM/o8bEo6q1rhcoXkfC+b9hCJ2y7Mxz9/C
	 FM7Tl3ct2KM4NvViRHhiOZmKxhrC+z+OKcyDVHBNKLbGhxfDjw7kx9aILVzwfYmQUqP6/
	 Pm9IcCHcmnVWypS5bHDDeVGTHkXy7E5pmooLxpaXIBV2cyoCPJYNB8konkCsNbIrLBBeU
	 EX9YNWpOYAZhSTsNaLk7+s31uozgWuDqI8bdgQi+Dr3kjwEKNXHTzufuWqNaqc2JM66Rm
	 weUNZ5tVmtxlT7NXHOq9KCq9YtQIpdSbLUrroRld0rCl0D9egTJXquWZd3Na54brGeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=p8xzellJ;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6196260A5BD2
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6196260A5BD2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=p8xzellJ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872195; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=SX2iWgwwTTnfuBkVYLRjLx6wOTnegLABFMy8vXMq74M=;
	b=p8xzellJ3Vln4GU5eh9uRy6v9tQ46VoLSGXhPCbSkx7h2oFnG42ubhPsLBuV0TE5jdEmbbL6m9HgC/yD2LZwCqLNddplfiAGqEJ5Ax8lm5s7QAXuEzi0tc4SP1D++tmLEHJPrHjM9xEmhLclXZZaYp/bhQevuNBnXkFepDkw+w0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZh4_1793872194;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZh4_1793872194 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:54 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 29/30] ocfs2: check dinode refcount location in online filecheck
Date: Thu,  5 Nov 2026 17:49:25 +0800
Message-Id: <20261105094926.3203416-30-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
References: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wire the OCFS2_HAS_REFCOUNT_FL without i_refcount_loc predicate into the
filecheck validator.  A reflink-capable inode with no refcount tree
location cannot be reflinked or have its refcount tree removed cleanly.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e0fc68ff997a..0f7391c9f30b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2185,6 +2185,14 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (ocfs2_dinode_has_refcount_without_loc(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: inode #%llu has refcount flag but no i_refcount_loc\n",
+		     (unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 bail:
 	return rc;
 }
-- 
2.39.3

