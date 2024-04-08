Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CE7171A5
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Apr 2024 08:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712564467; cv=none; b=jIYdEYK52bwb35AGhpCywwO5fSMLfTHVi4wuiYXa5nLTGrSW/DS/97z/f+/oNyIvYk0mktBpBL0ytj0l5Cm7yRa3UF+jpvDafr1lttttqCUTV7/hZTm3Tstyn7kSfJhB+p1cpDQ2Z9cJ2Vuixcr8B2DyQTa5IyoG+QSVRa4BNio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712564467; c=relaxed/simple;
	bh=/AeG3DYk/eW8cLN2CW8Rk7adOidcJzjowoR1eCXFPbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfuxyQOTm6GemAfKiIcrUl3ggCxy3qG5mSpcoUiDtt+A7AS4YSdrlYITfTe768ekC1cK4i47JYp5uNtLxRVo6ZJF0w2mVxfzeBX3R0uv7rxBBZQqEdBfttOvlExZCad7CgOxcdhLTqBFqT9+USIFWt47bK+Sq31O7JG28Xl/sp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q5CI7OIo; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q5CI7OIo"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d715638540so50448571fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Apr 2024 01:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712564463; x=1713169263; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BbkJ+XSY9Df+z1Sk0IjqHeYerqOmLYxKLPipkVMz3A=;
        b=Q5CI7OIojCDy35jXzi+BFizVbCqtWnipj8v+hbt36i96zlfmVlgEytJX9B9CAadU8v
         j8C41rH5/FUh52dKraNFz2QAVvoH+PXZAHJ39L1JsENmcJ12JwfyyyvzSJnwkUnJ5j+m
         gqpV1aD1KEqgFj7z6775f3RA/K8macw0jZTYodiLUn0YyPWjBffRpAKoJBJpX5CGVBO+
         ZVhA080Nvj2+P/G4QvAf5Fg8JYsvKxNbnbM7GuQiXQ7DC0Jd/lJok/wDzZ8Gu9gWqW/g
         W8ccmiQJWWT9BVxLSn+jnKxul7dP4SZgrrRb07LEngauCL7v77nDum/aAP5Grk9j7cDz
         MECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712564463; x=1713169263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6BbkJ+XSY9Df+z1Sk0IjqHeYerqOmLYxKLPipkVMz3A=;
        b=jNtmz7amdnd1MwaHGTG0J3XUK7+60N1jbRWy48jx7D9G8GJlLBiO8IdXFsTj+CHVUm
         AX+ufPrYhqFxJ/llDsiu6+BUDciqc9stT1nin1sUnNr52U/j+AD5TRIBavvEiN4hdXOC
         tNvzF8tN987KeQV7DOc2eT2OcIAiMcIAbDzPpQOBdX8dztbTB4EFcwZ9DANmsWjDd7YS
         u+cqjthSJPF/maQzPSO6NaZl5YLy91U/PFSKPPlf1MKt7qbQl8qEjrH7GBbO2GDIEBJ7
         RbGEFaZWX2pc2QHK3xETANiBXpUkR9GweCVkr0haqLJazu9Mmv8U58Q0o0Gl5Y+vqyTS
         dB4g==
X-Gm-Message-State: AOJu0Yw2gd2VBwGXiL+yD9+EJ5HpnN47yULFQ3Lo+RNJurc3C1FwNHAd
	9n1z0zXHfBIAhhOggI5vi4QYbqjM73XNzBJow+2fHHYpd+Psj19oamvvV/REw23/Txw34B4Hudz
	I
X-Google-Smtp-Source: AGHT+IEe4n5Goe2Qrz8BVTkFpurqZ5DQIv6sG3hd7tS/0HzuvhZZk+wMuzTRZvj8N4a0q6lntdBcjQ==
X-Received: by 2002:a2e:914d:0:b0:2d8:8368:e22d with SMTP id q13-20020a2e914d000000b002d88368e22dmr1870881ljg.42.1712564463223;
        Mon, 08 Apr 2024 01:21:03 -0700 (PDT)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id ft4-20020a17090b0f8400b002a54c4dd0f2sm213894pjb.43.2024.04.08.01.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 01:21:02 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 3/4] ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
Date: Mon,  8 Apr 2024 16:20:40 +0800
Message-ID: <20240408082041.20925-4-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408082041.20925-1-glass.su@suse.com>
References: <20240408082041.20925-1-glass.su@suse.com>
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

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
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

