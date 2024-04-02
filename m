Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8DC8C7
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022439; cv=none; b=tArbOtULfj5Iuhs0Hc7oqJmvxa6j5RFqNVwTkhAr2Ui38Hl/6BPhULQCkVt1Yix2FY0IbTS75o6Cp1AFbp6i8hgUysA5ZFpIRpQ/EhFjXD+JyIlFiCj9K81JwfAPc7bGQTu1ZosfWFJIDM48Hw9+I2eDSyu7zfBTO8HSJIo7Jq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022439; c=relaxed/simple;
	bh=EUQBBRVfjrFbyH0pLAVZSh+v87osHX0+H6stj1GndSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCtBmUn1bIEVtq/tPHJknchZJzYpMdg9TZt8bvDM9nYQNM4CZGIvUQ7e7eJk/YkiZ1YYEx475oFVlS68WYtJeCF23JM6XN84vbpxD7p39JhOt8JofMUbevPsOuKJmTdilyFq/DAxkTDRwP1wHnvp6dCo4lq+X+GllqW7ibHmOLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YoPzGFZ6; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YoPzGFZ6"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d6a1ad08b8so47701711fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712022434; x=1712627234; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnLmAkNpv6ysKAmUctPEM54zxlE07PEt5MQOFcZLsVE=;
        b=YoPzGFZ6DAMKAeVy9f9lIOq5fvAOv5AtptjdkZQi5WRB3oN7ThH+tZm0F1SDlBzbW2
         gFAs1Ng8REjH7pt4fFQK7/B9Q+MRvmTNZuUxv5Qcfhkyw0l3uorcljZL831UOCooe6Qz
         ljAiP/VdaRuVMBGYR8LHmwG7QgI47MEE+q5uUaSnuEF2qEUVsbIbnaisG5qtBIfjnoX6
         CGBHLGCBCVlh1ardmzSHh0ho0QQr9b+5ZoPcSOc/HCIm0KPHNgn5bR8zLmPsbLFPG2+J
         cKzWayhvkKp2+7574u5KUPrQ1HfdtGDfdbRA0A0ZGctBiTe+lUoPlP5/8/G2d4m/M/0A
         /5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712022434; x=1712627234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnLmAkNpv6ysKAmUctPEM54zxlE07PEt5MQOFcZLsVE=;
        b=iH0SM9Ep4zORX0BDoTDi6tCozAp+mgagrwev7QRB4l9wzq+baguoWBdfio6ySLJEnX
         XjJdJDMEBKlXCEsHD2GOTygMSURaN4b/PIXOuJ7gqfG9qKe8S8i8pT8ggNb9jD3bZo4U
         b1Sr/2H3vQ6TVIncte5QfUUpiLov56ywbVP8z5eyD01or9G9NwtkJg5jrK0B5w4puHSB
         CViFsOXo6iv1mTgXm0dS1/WOK3J2ewQkrt5uYhVCBlbjCgs+0PfY3fbVnVULj5FFEeJg
         qxjVDrcJM8BckEQtdOP2nKILsydrb+YmJgxyLRojnJLbuRRVWFUJvHKaF2pRu+Btm1ei
         BqcQ==
X-Gm-Message-State: AOJu0YyuySzytkrv/eTIpr70pHn6eUjG4g/YEV8N3ZEe5FEG1L1BtRv7
	kS5wrOpxAisOoCfhXUuzCDJeBIIjkCZZtAh6HjbBKkLz0I5xc/F6XdWgKMHWzNhADV/1MUe9fIw
	Nyec=
X-Google-Smtp-Source: AGHT+IH2KSoSX8xjGeVgy7OcCZH+N/5AtCgEfTYycrXY5pYNx/U4gpl/JDLroQrghmdXcNZxx8ALZg==
X-Received: by 2002:a2e:aa27:0:b0:2d7:1805:1079 with SMTP id bf39-20020a2eaa27000000b002d718051079mr6178566ljb.7.1712022434309;
        Mon, 01 Apr 2024 18:47:14 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id le15-20020a056a004fcf00b006eade394613sm8049125pfb.198.2024.04.01.18.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:47:13 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 3/4] ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
Date: Tue,  2 Apr 2024 09:46:50 +0800
Message-ID: <20240402014651.13723-4-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402014651.13723-1-glass.su@suse.com>
References: <20240402014651.13723-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

transaction id should be updated in ocfs2_unlink and ocfs2_link.
Otherwise, inode link will be wrong after journal replay even fsync was
called before power failure:
=======================================================================
$ touch testdir/bar
$ ln testdir/bar testdir/bar_link
$ fsync testdir/bar
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
=======================================================================

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9221a33f917b..55c9d90caaaf 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -797,6 +797,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
 	fe->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	err = ocfs2_add_entry(handle, dentry, inode,
@@ -993,6 +994,7 @@ static int ocfs2_unlink(struct inode *dir,
 		drop_nlink(inode);
 	drop_nlink(inode);
 	ocfs2_set_links_count(fe, inode->i_nlink);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-- 
2.44.0

