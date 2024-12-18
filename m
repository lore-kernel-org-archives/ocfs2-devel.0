Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656B52E630
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 02:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734490002; cv=none; b=pwggp+CBTm16N3QsT9DxIbiVphar4X1XQtLZpEXPZndn3v0HNF+RDBZTGe8KzXEU1tAZtW7cE2OlXQzkdBmlVLeDHLPWHUmFkr8aYX8/0o6XAHThKYqMjeYilb03g2JfYAwV1bA9r0ml+hK4ACzeavcgEVF1aRyhr4sSDDWGuiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734490002; c=relaxed/simple;
	bh=aVjAWPmpN5pMiHLjySSPOEhNa9jU4GgCs+y70Hqy8Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iOCM9Ftd9Wpt/TWkNgE93n9VIgQGyMomPK5coLzTUZS11ROwdU+u8JsIYRLPRtqCK941RR/DUituYbSmdxnAJ3X1ycPtz7YHYNzIdIQy53b6Vfu69M99mcySPUpQ4Z9UKPO62vXtSMR+UXCuplFoJCrSodktBX+I6SCnF+dLlQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LzHeaXaS; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LzHeaXaS"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7b702c3c021so358080485a.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Dec 2024 18:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734489998; x=1735094798; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/cwwt4OI5Akrv0c4PDqrh8w/sebwzMk0b3k7QNSWx64=;
        b=LzHeaXaSzyDgHEbBVSkYVk0EUlPRpUMqBdeYyXrZdfpzq93RcjFqdCcFyHipTAkCgH
         06SFCt6L31BwikEN+ci6OW2fzfKI4yuJzfuBOIRK8DnH1FY6Gj8ST3j8RWQkSzk7xIJ3
         bNg9PnvOrVfzpxXNVtweg+tHHdGW+aiHgUuOJWVHEHW3b03uAbO23AZUKb0PpCw+as6T
         KRcjFgn6bOxIv8/yhNd7rBTzobnEj3cEEifpNZBqULjGBEo11mJCjedxqudohYYHitNQ
         7LypNpnwuMWvG8zEnuRsYSmrN7Mvmn4BOOiXkYbLYlNpJtwJUuLgN+cpgneHC5+fjcEb
         5eGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734489998; x=1735094798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/cwwt4OI5Akrv0c4PDqrh8w/sebwzMk0b3k7QNSWx64=;
        b=ck9rgGP+eKmHPx8Km5XZHK+2TToFyGdP90P/+nOdTylA9HCDV+KP2/uM0pjapIPNrk
         mjXthBfXT9nN4xttEOVE1HGxCMUGpMVEuxJlX1Ykmdnju7w6t27G3pON9tEmDIK/k9r/
         gf/RC+JfQOdbSzQgwLAe/6lJvegT+iGZeWhj51kC9RgOaySK8n/NshJv9rd+ro4/5nbd
         02SsRnMZcgUdiIpRDFmQ/rcgIvgyE3IIBZ1ENpIUWMMmni60nnn8+6WdFLLB3flPBaqo
         rWVGPzhqwkjLKwek4whFDmuBHLJMgcN5TZZDJagHwCXNEWyCfIVvzl/ELkGk/ugfrTz+
         XhgA==
X-Forwarded-Encrypted: i=1; AJvYcCWY1FSYo0X8Hzb/I40ordI7WM4xilFNJl5lo/jE0bMRU3rasGMHOv8eGXo4lhm3gzT2d8rNvQuAfxSUnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1L1EbGCytRhrCybtopWVi3VoIuYbZNP9Qqo/PEYJb/DVminvw
	v3aWI/7eCJjM/7q9rkqQn2IwDNl0nPWlQOIvz++JWhBNGPjG318e
X-Gm-Gg: ASbGncuveV5k2rI/kF6LXN6pJkyPtLbq58CzRcsD1fvzwI1ND6cW5pAYJ54WmwGOCw2
	TAehAICoIUXulGfxITirqutTA+k5YVJPwcvR3OXIMZ+D8tfAQxjFE3wlu6Q447Zde3rMd1QIXXi
	MNhjYUW+xIMMw+kaJ728KC9tw/1AoXTx20QR8600K3C2T7IV5AmwFNGV0J3pM+gA1enm6NUOEpn
	L+GPmm8ikHqlfGIDGfaesWNMaKkwkrPbhuP+GZZ+N7R9m+B0BCw5RH7mHi8PwoAODKdUyjg/Ojz
	RG/hZadkwl5LK3P2RfBMfibnJrT65DXIbNc=
X-Google-Smtp-Source: AGHT+IGrm4K99f6E1qzjgjS0RtGpY627b+HpPcNmVGE0n6AniA7Und5/IRrLba8Gcb27VOFTgzvwYA==
X-Received: by 2002:a05:620a:29c9:b0:7b6:d70a:86df with SMTP id af79cd13be357-7b86374931dmr185835985a.27.1734489998314;
        Tue, 17 Dec 2024 18:46:38 -0800 (PST)
Received: from localhost.localdomain (d24-150-189-55.home.cgocable.net. [24.150.189.55])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7b7047d4a20sm378840485a.39.2024.12.17.18.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 18:46:38 -0800 (PST)
From: Dennis Lam <dennis.lamerice@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Dennis Lam <dennis.lamerice@gmail.com>,
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Tue, 17 Dec 2024 21:39:25 -0500
Message-ID: <20241218023924.22821-2-dennis.lamerice@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting ocfs2 and then remounting it as read-only, a
slab-use-after-free occurs after the user uses a syscall to
quota_getnextquota. Specifically, sb_dqinfo(sb, type)->dqi_priv is the
dangling pointer.

During the remounting process, the pointer dqi_priv is freed but is
never set as null leaving it to to be accessed. Additionally, the
read-only option for remounting sets the DQUOT_SUSPENDED flag instead of
setting the DQUOT_USAGE_ENABLED flags. Moreover, later in the process of
getting the next quota, the function ocfs2_get_next_id is called and
only checks the quota usage flags and not the quota suspended flags.

To fix this, I set dqi_priv to null when it is freed after remounting
with read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.

Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Tested-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6731d26f.050a0220.1fb99c.014b.GAE@google.com/T/
---
Changes in v2:
- replaced dquot suspended check with !sb_has_quota_active instead
- link to v1: https://lore.kernel.org/lkml/20241215035828.106936-2-dennis.lamerice@gmail.com/

 fs/ocfs2/quota_global.c | 2 +-
 fs/ocfs2/quota_local.c  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 2b0daced98eb..096b799d60a0 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -893,7 +893,7 @@ static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
-	if (!sb_has_quota_loaded(sb, type)) {
+	if (!sb_has_quota_active(sb, type)){
 		status = -ESRCH;
 		goto out;
 	}
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 73d3367c533b..2956d888c131 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -867,6 +867,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
+	info->dqi_priv = NULL;
 	return status;
 }
 
-- 
2.47.0

