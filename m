Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1540147728A
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Sep 2026 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787336; cv=none; b=txSz+ThRfnEAYcuXWaqrU3kT7xgDkOdKaWu7Qm4X9CksoSdICjzZQslydFJbdgLdJJiXZBWCpqigFEdvPrG4zte8alBDJeFNL2mQTeGtxr2dofv3bEY8Ypz0crZqjHhIfDjxjnnKWJvLaSHtNbmItWQjJN2dC0nrYXxlR40LENA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787336; c=relaxed/simple;
	bh=NU+eZSzEsrnjCal8oIlsrDjpb9U7xXSSdQQ4LiKYAH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUnnPZ5yLA2q/oykONbDGujhc1MtS/yKEsyQ5gFpvhPA7TDZCP/feHTp6Ie45SgEoD43+7oVm+1sfbUG8csol+IKsrb437uNASvAc4QoxohjL7L5pIwVBk/mhQMT/WNjqAuaprAVg0ExLzj6MNcVt+Apjnf25lU6n9Rcrg0EA/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=niix3k7H; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="niix3k7H"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49cdc81f40eso26041875e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Sep 2026 06:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788787328; x=1789392128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ViElzflaszjSFY7ZUxClX7Wwc/oOQXR/RJoA4DtKYyY=;
        b=niix3k7HCp2ZkAItNayCmzafu8e+tVVdhpaDU/77ad7c2+qAUDwfIRGNe/TViVO2OI
         0PZjKyjPmaFWpMkeISRAxGtmeVEYOVcRFPgfZzSAPC4JJ+n6trsHI8qFbw3CRuv8Ymci
         Ioq/2zbufrIEd8GLffngSh/ZUSAsAILgFaeZjd5UjJtcwokb7DSrsCXihduk7FmxGUvt
         ss0Nb1fUouOS5xJj3CNd5DAAjly4aui5lWsUYkZJd7Zs/bUPFBy4ILzbD4F72h12mFoP
         Zo6uIQ/k32ugLhro9pswIPMSXZvufUIEx3ISVA8lDhZdaUrVXtGX9Do9mIpky2qKbOmZ
         rUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788787328; x=1789392128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ViElzflaszjSFY7ZUxClX7Wwc/oOQXR/RJoA4DtKYyY=;
        b=jRYSwGpYlPUuLTHvfYd7u59GFLoynr8xJgWI39oN4cAsyY2YUFGiaQeSjZmEdj5TCh
         d2ZFQ3o4U6nNTO6/KqPiaSP/Iprg25G6COMTVH4ZAMTpWtZ/ohnEt0ZIt60esl5hv+OX
         fYO2Lq4MqldCjsZ8rNJ/TQP8Cb8NC89LfXLRrJrgJNhua1wiiQQSegNodSed7hJ8Bj0N
         rbniZOR17PACYh2Ispkb/Byf3bAHPvXShLqJ3Y0058LNMiKTHmdB7kmg/LeFNcn12Upp
         yiy4jl6bhT+cJA8OtRo12Q0tftYq5bIESa+KsaQ0rhPJQvJA3L36GgB4y68uu2dIyAGB
         I5JQ==
X-Forwarded-Encrypted: i=1; AKwUvBwaMKOO7SmMYoMnVNRWQxTE5ZVfWqd9mj9Cou09tqCkDhln+z63Xmo5ah6oVc2WRmPfmmRXyBAgMuamog==@lists.linux.dev
X-Gm-Message-State: AFuF++nfTJ5v/jYSPbbKzYCxzb4WlNrHE2tOI+udZ6hg0PdZXa8AxKMD
	aePKZGF5VuIYwhPsijluOEx1NjhlobVCtdtj3kf4PqzLyeYzV++qPP9mi4a3SXMdiyE=
X-Gm-Gg: AYBFou3fIUg/8VnvjJfoA7vcNVc58OZOepUxp0JEp7qQOUgI7WuhmneaKU+IKcmZfVt
	v+vcwaia1DYp9zgILp5tCE0gYJIo3C2mjH4vAKI1/96JDUnyd3/txFh4dqLBdwrYuNVvy7idjQA
	j19hbpqpWXaVZP5DnityfFdKiay6wqVzb5oCvRp1bbsj9nhBAaRVAytBmEh9GErqEXWOR2Gdt9B
	Wh3CpDmHJH5Y047zmoZ+O61dd6io6zLEGRwMn1Mdy3cWzDUzXeheEnko8Av5SavOQd2SJACDWS2
	WGkMyilqCxsydxOUBgq+GPqRHuMdAY0YuhyjyU0CPIaQIQ2KJg37AlFQTCxH1tAE5pz7Iud21VD
	1GLxUFMpecqJhnSOxg6TW8Rf5IErcsxJAGklQL70GlnslK+SfuckZblqLN5ocpoKJQepFnzKk6F
	WbgnetETjGXwD8YwPvRbayjLmgPkRUmLLZLIVIWF9/89tyry+96qTinV0XHdGCoPF3rMfwNuNHN
	bTh5OijgXw3fgenjNWsRQnvMvi+HtEpLLhLkrfGIM0eqicmsfgtEI6MXe1PerjBZcoDSg8rQJY5
	ulnEDMg2bHeJu3Z7nBQaEle0ivUYDPHjzcrntN2EgV0fP/+r+xqw/bOmetfnxrNsXYaU3MPoXMt
	gBOH7ITfdb5Wga4Z9Kw==
X-Received: by 2002:a05:600c:3f12:b0:49c:c8de:96a9 with SMTP id 5b1f17b1804b1-49cf7fdd2dfmr448928055e9.2.1788787327897;
        Mon, 07 Sep 2026 06:22:07 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm27458397f8f.8.2026.09.07.06.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:22:07 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>,
	oe-kbuild-all@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH] ocfs2: remove unnecessary ret variable in ocfs2_calc_xattr_init()
Date: Mon,  7 Sep 2026 15:22:00 +0200
Message-ID: <20260907132202.48834-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <202609040247.8B3lmoqX-lkp@intel.com>
References: <202609040247.8B3lmoqX-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
ocfs2_init_acl()") removed the only code that could change ret in
ocfs2_calc_xattr_init(). The variable is now always zero, so remove it
and return zero directly.

This fixes the reported Coccinelle warning without changing behavior.

Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
 fs/ocfs2/xattr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35bcbb0ff607..ab3b645983c9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -640,7 +640,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 			  int *want_clusters, int *xattr_credits,
 			  int *want_meta, struct ocfs2_acl_state *acl_state)
 {
-	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
@@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 	}
 
 	if (!(s_size + a_size))
-		return ret;
+		return 0;
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -729,7 +728,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,

base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
-- 
2.53.0

