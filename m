Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C92221FD0
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765546614; cv=none; b=pbQNyjdk5NumLywRPnwGGPQzhb59RuC2euuxCkXxsXQ1V+27JcLnd9GaU09qk6CKXblPApVoQxczzfj/6W9qoxAGULrq/6vcof87aNO8odbmjT0pZ5MhvTbgh5c7/cM8dIekpqSKKZeeXt5FDHaQSnwIcI3PLynoafz6Nh6bX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765546614; c=relaxed/simple;
	bh=oUVNkrpx7zGOPrn75O3G+b0+ixWvCa6iP1b4lVbP63k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X1PN4XsucEuJkS5zkb9ky/ZiVQNfCjvr5EFzEzOlLdtMdDOoPleTgh91Va+SGLzdnHpzSv+TJnbldbRmTq7jOCytyb+FbGQEQHjcrWnEzmumslfLnrwJr0krWLpYJP9Jl5CVuqbqZs0TAZhCVfA4KWiVcfoJOWMm//wPtW/UWAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V0suu7O7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V0suu7O7"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29806bd47b5so7775385ad.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765546612; x=1766151412; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4p8vNUMqVWCHBF8mIG+eTyca2IsDA2YUIUiwr2/tQxk=;
        b=V0suu7O7ZB44BRdlYA1tXuL7Q6MP5Xt9avKMTuGOYAoAcDc1dYuBbWTtlD997Wn9wo
         Atxn9tGTYcBhlyYDgCu6vNEGY/90g1+6SCHQfcgkrr12pzjwbf/LxImCE77UV6+dXubF
         GnSGzF/0lfudbaJX2xmUyYuaLhtKfcwiFKLBQeS3hZWO0vXUndFXZ6GF2A7DpM39PL/C
         rDztBhjqBSq908PUiBepakIJYZPzu1aX8lf2IpG/qlW6ir6jzExtTTiHXFO5EWXkQ+Tp
         PjhjOFE1dBpVDf3kI/5XUeaoocwwLy6sE/gEyI22thrC4e6dDXRZw69Ywc32pXNwlDxL
         zXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765546612; x=1766151412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4p8vNUMqVWCHBF8mIG+eTyca2IsDA2YUIUiwr2/tQxk=;
        b=ozm/2H3j466jSJOLSZhRqb2yl9IIZ6TwNqNiruveQ2hj+XRMpoEOjKSmiHWTRJn/sz
         dYjGvFvHEnZsGHEX8oJzIz40lIROvfSEO14IBUZHw+2gUY6oNcteVFVmiVepkExq2nxx
         D9+AizjucNotA0/S93cK9mUW+9M0jAlMsESY8apaKFuoH1eGTuMNLLRO5Z3PCvjh5TR5
         Qq4rygMpa7BdTYIsBjvO3A+y8j583FQIIghMionQrMyHQrghQZG0noJGuoUDw6UOr2uz
         OU7fQ5D3Z+ma24qo7pV2ETNpoQUL4FlwrRV3AM4QxmMyRbfioYFSZasT4/qJQiIUQmIf
         VzUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbA/TtMSomTTuDos5/pC75pCWxG8RoiUAlfdmuqgxNra1ff5KmJ+5U+7E77nOa5VbhsteY+v0tLkKOEw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3RGtExIplvsEhFzgcGjhGoztG5uQ19vHZ66QTRwgQ0PeQyvpk
	Mq56bvwo+850Ne1Vpcj4E31Ty26MiqNCUDFOO5sY6dyaB52RtvJyF9qO
X-Gm-Gg: AY/fxX41VGUzLLWUhT567lG09lj3fSRROhE3tTxGG75wL3hESoRewiIsy+smLZPppkc
	Oz7diC7HnhP7zkpPZukVnNQiLTXKA42anKI5eu3wQWaBuFATaBNNNC4eNZ8RrvIyvto8EMkJ4AN
	JtEQFwU6lKD4LniMfJE1YRq21qqVSpvzbmEHdY9XUVy6ytKkPj72ULLubgOW2ypgxBN31wyijWv
	MVHt2YZfmjlNpV/BLYH9d+kkQwBF12HPl3yafC2fsupQH1KPc4pq0+cQIrEspgB5okjk1+JHaxT
	X5k9h9xW7DCfLyvfoGrCDKqQ7XG/Mp1iYaRs6NqNl71BDg87j/cbDVN1wLCWEGtB5M9q+vU0w/l
	jWXoslraIkuTMfcVxIaFkTVywERnuVfdQYAzZDa9BDIfStOxVjmet2Sj31Ww7aelBYx2N8gPS7k
	N8E3vgmWJFPcsS5Rh/
X-Google-Smtp-Source: AGHT+IG1e3GptgIXE0HC8FCQIABJ2seFG5lStgvWMjTuXllbX3tE9EnwHIyGGiVRWBCUk0c7vSQFcQ==
X-Received: by 2002:a17:902:f690:b0:298:46a9:df01 with SMTP id d9443c01a7336-29f23dd5307mr21047835ad.3.1765546612203;
        Fri, 12 Dec 2025 05:36:52 -0800 (PST)
Received: from LilGuy ([2409:40c2:1054:9e35:78d1:b643:53:d5d4])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29efb3657f0sm42544775ad.72.2025.12.12.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 05:36:51 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix xattr array out-of-bounds in ocfs2_xa_remove_entry()
Date: Fri, 12 Dec 2025 19:06:31 +0000
Message-ID: <20251212190631.210139-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkaller reported an out-of-bounds access in ocfs2_xa_remove_entry(),
triggered when removing an xattr entry.

The root cause is that the original code decrements xh_count in-place using
le16_add_cpu() before reading the updated count value into a local variable.
However, due to the way the entry removal logic interacts with the array bounds
checking (enforced by __counted_by(xh_count)), the stale count during subsequent
operations leads to the out-of-bounds access during the removal process.
This patch fixes the issue by reading the current count first, computing the
decremented value locally, and then explicitly writing the updated count back to
xh_count at the end of the function. This ensures the array bounds are correctly
reflected throughout the entry removal without relying on in-place modification
timing.

The fix has been tested by reproducing the syzkaller crash report, which no longer
triggers after applying the patch.

Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com./bug?extid=cf96bc82a588a27346a8
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
 fs/ocfs2/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dc1761e84814..de99276d12f0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1941,8 +1941,7 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 	ocfs2_xa_wipe_namevalue(loc);
 	loc->xl_entry = NULL;

-	le16_add_cpu(&xh->xh_count, -1);
-	count = le16_to_cpu(xh->xh_count);
+	count = le16_to_cpu(xh->xh_count) - 1;

 	/*
 	 * Only zero out the entry if there are more remaining.  This is
@@ -1957,6 +1956,8 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 		memset(&xh->xh_entries[count], 0,
 		       sizeof(struct ocfs2_xattr_entry));
 	}
+
+	xh->xh_count = cpu_to_le16(count);
 }

 /*

base-commit: c2f2b01b74be8b40a2173372bcd770723f87e7b2
--
2.52.0

