Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9424449A
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Oct 2023 19:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Olr3e3hZ"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6bd96cfb99cso3120721b3a.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Oct 2023 12:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697656726; x=1698261526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YSRxwtKFFtcmGHGcUlV8tfK7rLoJNDdNW6F+5SQx19s=;
        b=Olr3e3hZaXcaM3AbywRBsJIP6mzwtL4cLbRfWdJx+2lReAoR8ByVkHIBFTfojfvz7B
         nRb01JhuqWZ6dqdU/QLL3IAPG/7D5eQ3tAd70jm5zOXklOadjEQYyjCHdSaEwzAbisPj
         Mjd+L0fmaDYlJdR1i6p0FNKcDzaX3igx6D9LEQ7QxfMeCGg92JQTWRYGnbYRB6LhqFZI
         D4dg3hpohNKRrsoyWCp/yPbxNmYYRDvYzJdQ2WLW9xmSgH5Q+hQw/XQJ+eMN1SHzu4+D
         cb7jAcG8lDM9iLR8O3sQgW5EbUBfX0nqiiME6heGr9qaZyjQZJUSwUyd/57K1d9gpwhz
         TLFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697656726; x=1698261526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSRxwtKFFtcmGHGcUlV8tfK7rLoJNDdNW6F+5SQx19s=;
        b=S/NexajPn2Hb9yEpCinS7PZih6Y8rjSzSu9eeR17bQSDpjIHxwwQthZUf7mbPj1L6s
         VHLPMrXDtevgkOs8GvNk1PIetdyyic4rImAed6Wx84ny7tGpan4ctRJyDXrkOUJgLRa+
         H+4C3gfYbYIMNP/hs+Q8tu1DRjgciG6sM6OsIvgJ8aXs2hHj2P9EaLi7F0hpLJt50KS2
         XfhakgufMr9lLTojV0qTOqyaw9L9zoGa2Wy2E4V6aBOkg37JbrXB952RhAWaWv6Wz/0/
         CblSoalYcltCJs4KD35hV7seSqxwhKdcLqKpLYiaYPGGOHEgmAZW+1A3OY43Zq0COj3K
         8VBQ==
X-Gm-Message-State: AOJu0YzUxzoZoJY12ZDbFd3CIxmk1cXJ/iIMsnocMNnBTbwZMlabceij
	47O1qfocn0xXZnK8240nVzo=
X-Google-Smtp-Source: AGHT+IEuBjjA1TB9p+S3pBa+Q9PpWrpRJ2cQu7LEZU0k6LLFb0Qhf3388S7X2v5ELENyNSTR3U6Yuw==
X-Received: by 2002:a05:6a00:21c7:b0:68e:399e:70db with SMTP id t7-20020a056a0021c700b0068e399e70dbmr34377pfj.6.1697656725619;
        Wed, 18 Oct 2023 12:18:45 -0700 (PDT)
Received: from localhost.localdomain ([43.129.178.187])
        by smtp.gmail.com with ESMTPSA id x17-20020aa79411000000b00690d4464b95sm3808100pfo.16.2023.10.18.12.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 12:18:45 -0700 (PDT)
From: Jia Rui <jindui71@gmail.com>
To: mark@fasheh.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jia Rui <jindui71@gmail.com>
Subject: [PATCH] ocfs2: replace BUG_ON() at ocfs2_num_free_extents() with ocfs2_error()
Date: Thu, 19 Oct 2023 03:18:11 +0800
Message-Id: <20231018191811.412458-1-jindui71@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BUG_ON() at ocfs2_num_free_extents() handles the error that
l_tree_deepth of leaf extent block just read form disk is invalid.
This error is mostly caused by file system metadata corruption on
the disk. There is no need to call BUG_ON() to handle such errors.
We can return error code, since the caller can deal with errors
from ocfs2_num_free_extents(). Also, we should make the file
system read-only to avoid the damage from expanding.

Therefore, BUG_ON() is removed and ocfs2_error() is called instead.

Signed-off-by: Jia Rui <jindui71@gmail.com>
---
 fs/ocfs2/alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index aef58f1395c8..d6bcf00f6843 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -967,7 +967,14 @@ int ocfs2_num_free_extents(struct ocfs2_extent_tree *et)
 		el = &eb->h_list;
 	}
 
-	BUG_ON(el->l_tree_depth != 0);
+	if (el->l_tree_depth != 0) {
+		retval = ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				"Owner %llu has leaf extent block %llu with an invalid l_tree_depth of %u\n",
+				(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				(unsigned long long)last_eb_blk,
+				le16_to_cpu(el->l_tree_depth));
+		goto bail;
+	}
 
 	retval = le16_to_cpu(el->l_count) - le16_to_cpu(el->l_next_free_rec);
 bail:
-- 
2.25.1

