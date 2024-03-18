Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C20738382
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 11:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710762980; cv=none; b=XsFAfsvHO59cYaW9uQYkKLmHjBW1x9q/B6T2utbXRThY8EZ3h2dwukgjfCXGYUt9f+hhbEPxwPIU1o2VBZsg+bNn0FHjXFF6Ti/rBXmnqIn+JZHcsB9pSKWL1yhPS83TGTG9PD7+JmQG1vMTnz/EWBpo9lCArIPkGMD1+hrXeTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710762980; c=relaxed/simple;
	bh=bwQ1buzorakp/810NF9qIcq+KAxJA3uOyu9SQhpX76s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=btYOYJFHhUNVIW5KvfDpNxHhnsKqUPUsKC4LTGugsIv/49jdsofHmXkihTuJGCOpqZokQMV5HuyFhtXeToYhQL17ZkACYbuL8BScJ59wgDU7TDw7WkEPyfuEia8n4ajy5QUXl4zbz1KseicNq7G1nNZ7HEAMO+gdZu/7MPU9XBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dOa6o13M; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dOa6o13M"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d475b6609eso54942061fa.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 04:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710762975; x=1711367775; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/A79OrAz60tvb2XbsgGNi36JaxZebi67TrqXl/IhhnA=;
        b=dOa6o13Mez+Msh5jGTyEqfEza2sM5ReTd978v7IBmsViMkrNgKiuy7gR/2O43FHESo
         N0M09k9i0/tKMHtObRk4qzzIN1573DfdW4UlY4CuhnV4KQfqMN0OMsH+LyuCBQf2sjuS
         vCkNF3w+Q6R+38w6bSPr78NfBwNZNkiiASLb40D9plbzXcd9qsJMjY9QSp4NmNcd9q5t
         N2ummhMZx2qiTw6VVDxEm6Rt/JQDZRUsrcKYOKF1nvIgxByqTVxImFMd3Tka5YOEvyms
         h7t3T/yw8ttw+OFBB9WHiQpUW8/UUaddSc16t+XKtgk/av+PB3RuEAL7S0kC1xPV1t2u
         hpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710762975; x=1711367775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/A79OrAz60tvb2XbsgGNi36JaxZebi67TrqXl/IhhnA=;
        b=VIiF42hyzSRm7P63DgVXFwIBbNIKZqSPAb3o7ZuQkjJY8IZjO4wTjzNHzL5Kp1bwSr
         rkbSr7vh6vl74NyQFgReCbzn6pX+VAY9t6A/Yxto0gWZ6ssZsXh4lwvdh8+NKc76IikN
         dQY5wQFQoOZQH82fc9rkaAGz4YfJvae7KSFsCmA8uVT/UbhUFD+VJEhPRVW0+u1jJpRg
         lTHnIIFLEWmiRK77Kbl0seFp7rQcvHajIdR6WHsyaBJOPeOs96GiHZNaztOZydsShh+H
         +RoYC/+2AsVcxSEvy6AeePFoAX65/1/VDEsm/LVB+dnirXJtiL5IHJWTCV4n+rM6C7uQ
         HUOQ==
X-Gm-Message-State: AOJu0YwJxX5zpnEov4FE4I8eTIhceOCzlSsU2zLZty2+sfzh2EnfnAk8
	MR+MkQ43dsajq4hx5UtZaed6ZYU4mTNeSQJ0tSjWY1kFt9C8Z966lxqEixOXF6ukfo5dLrOz+SE
	E
X-Google-Smtp-Source: AGHT+IFbrlDbNwRvRdyFBzROwJ06VjQ5x9BTUBIQjcQNTFSWkBikRY8OuoAdn46vpNrRQkBXPFtN6A==
X-Received: by 2002:a05:651c:2112:b0:2d4:a7ca:4158 with SMTP id a18-20020a05651c211200b002d4a7ca4158mr2641579ljq.19.1710762974906;
        Mon, 18 Mar 2024 04:56:14 -0700 (PDT)
Received: from cat.prg2.suse.org ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id g24-20020a633758000000b005bdbe9a597fsm6968240pgn.57.2024.03.18.04.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 04:56:14 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] ocfs2: update inode ctime in ocfs2_fileattr_set
Date: Mon, 18 Mar 2024 19:56:09 +0800
Message-ID: <20240318115609.3194-1-l@damenly.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

inode ctime should be updated if ocfs2_fileattr_set is called.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b1550ba73f96..71beef7f8a60 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -125,6 +125,7 @@ int ocfs2_fileattr_set(struct mnt_idmap *idmap,
 
 	ocfs2_inode->ip_attr = flags;
 	ocfs2_set_inode_flags(inode);
+	inode_set_ctime_current(inode);
 
 	status = ocfs2_mark_inode_dirty(handle, inode, bh);
 	if (status < 0)
-- 
2.44.0

