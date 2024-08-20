Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4844B33FD
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116949; cv=none; b=BIEtWxVR4xnDN5XNbQr+eJ18Hc/yqfs28jMQJ2EZnVMiR4Qah9YOMNL9KD8EXCJVqQkBNgTA1FAc9kfSb9894c38XjoEQ783DeVYQ5c+vcOhJ+ojML0rktSsuvd3ufhATL/zWWYVs0MhCqjhKvmIsqHVSLQ2J9suxyp/ddttbTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116949; c=relaxed/simple;
	bh=nnbDVBr+zqffuUc5l4B6rJDkZdmLgcVx+nBpY84gAhA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CTsyP9BBtjoHI/GL6LJzVkBcwzwRL6DYxDn74PggSNDzHVAiEDltK8MUF4l8dD3Lkza1wFT039Y97TgucD5qe7exHKf3xnpF1/xLN8l9Hm3OQc/HLsqWBISo6SQT+iYmifvuq5cCViFAjnXKpThomQtAdijX58z+cBnZXf+4P4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GeP0/xg/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GeP0/xg/"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5bec4fc82b0so7442086a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 18:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724116946; x=1724721746; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2mUATixxdq33VSvfaBNqqUsP8DZlp66vJtGsDHyEY9Y=;
        b=GeP0/xg/MtxQoKmwFIoJJQce9zdxjfw51eVSR3REDPMvjpREdfGvNSaaSzNhMiB4hI
         nACComygID01MsjrAzfzPwwd4vrLY/F2VKWCAUv2cR1j7I061vcejeYa43KyZ4PUkOJg
         GXa/RoIvI+Ftu7byhpKAjOn6AX3yGQyU2NQanLpwFNuLE0ySnGQisSBwnl0Q4Cf3nUkh
         qIiNLnTsdlXnMA2Q5t9mrEKbwNszEv00OJAuFL1k0haYkulLr9ZflRq/2RUt7w0NbNZv
         ZI39Umsq/ZsfRLNoRQTfMYz3HxIctb0c3vw1WjbCdFCYI4end9800TDm8QE14jVS0gWf
         L0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724116946; x=1724721746;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mUATixxdq33VSvfaBNqqUsP8DZlp66vJtGsDHyEY9Y=;
        b=KT2cRW5CG1ukVvtt0DwBrK6wEedaSZwlWGj2MhfE8HBPX5Hxpn0RY3rK6stfaykTag
         jDc+0CdxbxHguQhZ/7bFS6mKH9kLoyy7L1SLlPiI4RG/TOA7gEMU4sU+ulKJL5PZcY0i
         wRmLhYJdXoAmDwpbLj+rywWok6bzexMyQdz+HDMAFLYs7TE2S6RAXjeLcg+xoWE3tyYx
         bhMJRHq6k3k6vsJB0I39GVDlVp+HBGcuADZFVKuS/yrH7f3EX8uhivzlsWawWXxOpWXE
         mBrE6JJM8awyjqndIBlc3m44/uGcGyV1fDB9qNxh75ERraRO7SNorm49M8YUgzJbHiJx
         zLTg==
X-Gm-Message-State: AOJu0YxFhPqjZ1YpfbzQ/XKss9sEoPkTeE9RGv0Gtb9KOsihnvkIjsKa
	3RLiiZdC3iSYF/54JhHycaS4iUAsUTRREYn27jd8Syev0T8OBjCQ
X-Google-Smtp-Source: AGHT+IEBTOKoW9zicq24+Fr5+Y8S2974Ig1rcqM5vCHBuaLcrRnuEqm8ucueWKsvneiaAk4RYuPixA==
X-Received: by 2002:a05:6402:3805:b0:5be:db8a:7f58 with SMTP id 4fb4d7f45d1cf-5bf0ac5d461mr1116106a12.19.1724116946154;
        Mon, 19 Aug 2024 18:22:26 -0700 (PDT)
Received: from hostname ([2a02:c7c:6696:8300:44d8:63fa:6beb:ff38])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe5a74sm6164618a12.16.2024.08.19.18.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 18:22:25 -0700 (PDT)
Date: Tue, 20 Aug 2024 02:22:09 +0100
From: qasdev <qasdev00@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ocfs2: Fix shift-out-of-bounds UBSAN bug in
 ocfs2_verify_volume()
Message-ID: <ZsPvwQAXd5R/jNY+@hostname>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch addresses a shift-out-of-bounds error in the
ocfs2_verify_volume() function, identified by UBSAN. The bug was triggered
by an invalid s_clustersize_bits value (e.g., 1548), which caused the
expression "1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits)"
to exceed the limits of a 32-bit integer,
leading to an out-of-bounds shift.

Reported-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=f3fff775402751ebb471
Tested-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
---
 fs/ocfs2/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index afee70125ae3..b704983b2112 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2357,8 +2357,8 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			     (unsigned long long)bh->b_blocknr);
 		} else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
 			    le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
-			mlog(ML_ERROR, "bad cluster size found: %u\n",
-			     1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
+			mlog(ML_ERROR, "bad cluster size bit found: %u\n",
+			     le32_to_cpu(di->id2.i_super.s_clustersize_bits));
 		} else if (!le64_to_cpu(di->id2.i_super.s_root_blkno)) {
 			mlog(ML_ERROR, "bad root_blkno: 0\n");
 		} else if (!le64_to_cpu(di->id2.i_super.s_system_dir_blkno)) {
-- 
2.30.2
