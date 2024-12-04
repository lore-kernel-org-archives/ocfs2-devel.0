Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F54514885E
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 03:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733283179; cv=none; b=DnUUjpaklgxcP0gw9fY3CTQS87GHIQffXS+KsWi7HfgnnCOmLr/hfownZY2r+o8qmLgta+WjZTcxzxojt+r34P2B8JN5hrqLaFWSV067NFJ1RvefO4/fYiXnYhW/4KmMEqZtJVkACLKc+hrvLOx0r07prbAS+t9rIl6Q268WFQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733283179; c=relaxed/simple;
	bh=HETMPyYFonTIlUEtDkB4W+NGpx0pChnBvtqpUMwbz5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4kwQEjUFU3JbFWhv3C0GS8f5UFewkEVNaYZRnRzH6yzxAz4yncPnNILhfPKlWUARHRa+zeaUsEzo8+XTDF9ENCV0W8ilDBBoN67K5A9nwTaNXBGuUVdsWgpdc5eHQUz729emN+c7cAQtlIydLRZRIbqxWkM0Ib9Qi2umIRFo9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YGVrz/Tz; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YGVrz/Tz"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-434a29ecbceso7405955e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Dec 2024 19:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733283175; x=1733887975; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IyQZbBp455IiiS0cimMqLKVcykFWRydlh8NnN31mrV4=;
        b=YGVrz/TzWkSKun5uOZfI2TvjIBLl8Y8Yujv6DcjCtACg5Ku9kljgmhDWOkqyAlqAYt
         uGgkJ3pcjrHY4FVOcJhQxEuaQqBCs1dR5g3RMjtXsl9Yyka1KSvhwmbNNNN2PM6Ko8ud
         8wyYDIZMQH0yfEXj10+WPHkLAtrBYe3a6GIssnFeOwv79DgpV2PPUBTGmxcU84gFs5U4
         2/73TnScD6j1ERupJcdceKJCNjEMVCvEWf95ckwKSlIT/yTTUZyuByXc/Q8KMzpGuvs7
         zTOcpGv4z0vFyZw2ewN5DFXOeM+24dDpOluGYjB5cFXOI7APlvnvbgrZ8sCsGVh4Hbv0
         7iNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733283175; x=1733887975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IyQZbBp455IiiS0cimMqLKVcykFWRydlh8NnN31mrV4=;
        b=ulAoBmV1os/TsnGlzyV0nxxuvn5Ns4SkmbVGEweZaP1yh3Gmo0dZ0+odrrfkn+sCLs
         IbNbl2IPYAcak4DU4AJT0mb0FyJz60z2ekQxpEThLAZz+GYWQKRtYI5k/lfBjES693R1
         XplpDBCiSZh5HUUFLmYHJ3HcyStvAQEVFM1n0gs6KVmeMYoP57L6XBTNL9/AQPJgdn32
         4mLtE4qxwx9vwgPuyv1ORq/S7szkhSVrhuBegmJn5rb9QgomwcyGVrfQ4LfnrvwfKhDe
         cMrDf4FAgB+BYNj1tjKpA2VLj3uBWFaBarXQdfvYw9k9PIIaTtKtr1QyFXQNKjONBmfM
         yN6Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2QBRPEvFyjMskUqjn1xulZCqm8I+4ivoPGcpguOv4AGQYd0hXCGt1XIG7Cjyx8l2QfYfuJJLgrtbePA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxYF4E8QpcA/gkmd/hcmPMmewyowbqbrWZF4SgeBzxSF2yPyL4p
	Uj0KsoJdR8qge4nQLAgkVx/dmHxpZIAQlcp9T/n8+gsEtXLjgMpwaqDNYaNP7BM=
X-Gm-Gg: ASbGncvIZ07vPF1J4tEiPLIvIT4fP9oPSz2T62P2Mu7da6QWl7tQ1ZxpH03lxZv51yV
	wfs7dyc0tVXT533MsUNusFDrFvF8ROSpmO40fS9Hfe49tZr9sJu9WdY34txUpKAAC17ltU2BDWS
	RIlpPHkSq68PhQPBbc0NyKSGnTqztoVyNBGdj+j2SuusAtv+YQ51gvI5nMhg9TfcIUc4tjLscao
	ABgLHrBd3VRm4xdgFhyvhZneFdQbRwA5bSiU5t4lR3ZGP2DxYYjqJlE3igtgQ==
X-Google-Smtp-Source: AGHT+IE/jHB53rXLi5u7lvRJEF+CPq4Zu3rqIEuQoyRi8fGpj8biZzILxPOqXkFg+fFvWqVlPTnhJQ==
X-Received: by 2002:a5d:6dae:0:b0:385:e10a:4d98 with SMTP id ffacd0b85a97d-385fd3cfcb3mr1524139f8f.8.1733283175560;
        Tue, 03 Dec 2024 19:32:55 -0800 (PST)
Received: from localhost.localdomain ([114.254.72.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215a04dc249sm37476025ad.203.2024.12.03.19.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 19:32:54 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	gregkh@linuxfoundation.org,
	Heming Zhao <heing.zhao@suse.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
Date: Wed,  4 Dec 2024 11:32:39 +0800
Message-ID: <20241204033243.8273-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204033243.8273-1-heming.zhao@suse.com>
References: <20241204033243.8273-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
unmounting an ocfs2 volume").

In commit dfe6c5692fb5, the commit log stating "This bug has existed
since the initial OCFS2 code." is incorrect. The correct introduction
commit is 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").

Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
Signed-off-by: Heming Zhao <heing.zhao@suse.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/localalloc.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 8ac42ea81a17..5df34561c551 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,25 +1002,6 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		start = bit_off + 1;
 	}
 
-	/* clear the contiguous bits until the end boundary */
-	if (count) {
-		blkno = la_start_blk +
-			ocfs2_clusters_to_blocks(osb->sb,
-					start - count);
-
-		trace_ocfs2_sync_local_to_main_free(
-				count, start - count,
-				(unsigned long long)la_start_blk,
-				(unsigned long long)blkno);
-
-		status = ocfs2_release_clusters(handle,
-				main_bm_inode,
-				main_bm_bh, blkno,
-				count);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
 bail:
 	if (status)
 		mlog_errno(status);
-- 
2.43.0

