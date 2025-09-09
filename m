Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B178299947
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409262; cv=none; b=M6cKkN1amPwlgyRV6hsbx8HRV+SHlWF0Jwhgw91c3UK2sIG1VO0lffqnT+BHE2a9q6SjaD/0Zu30SvK3hUEkLqX5fkFwm2oDvaC0qiOj0H1hGSpbMxSmfikACOrjJOBpfP90ZizCEoB/QrCWIUs9rQCJ7mG7gnLREANtvGjp53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409262; c=relaxed/simple;
	bh=50R3pwXs1e/VX71Ayzy/05cPJ1lbpi+2qfPdQ6LJu4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFxO5W/MxG/j3K+eL1tV9t7Q/mBcIPBUkca55pWchKXwUm/HmnpfIxdFYB1p+zNKeVyLCuLyAZUk8ICwPrTI4SoPvSBMTOMs4nNbauyFtffA8SnEHaE3gj7SygGJWbqPACAklT1+lX4jrJN+vmnLQ17RhX6E2fjE1wdRcjyLgYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RgduYbYJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RgduYbYJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3d44d734cabso3691932f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409259; x=1758014059; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5aEOGf5lzke7NfjFn8+kgwyzmdKicgx8i+x5xoYQng=;
        b=RgduYbYJ+6vOdDb2uEDnWQixH/9vOAYAhbdiQnoHWCUsS0z/iKRSrnGC8znGfRJhKG
         D5xPGyXJgw4yUblrj29bXQDZdnZsadyUPuzVXoZZP+OvqoEIiI/L8yQCZhjGftN5gJVq
         6mxhG31MmoegL7crjUsG1VDQffYvP31nAkqEUSG+hZF44Whb6qtHdtCaH5LuwKTE3wc/
         1KpdBxgdhxWvFwAJSeWJ8dH5jrE1M8Pf1cSSacwxDniZ1VuyiOte/ojsw2NQimzU2IvA
         0OhQ6m/QA5M8Wale9jPRk+1Iz+BHwcT422tp/7sp+Nnt4l05sojFpa1CnkzzZ/i9GxIE
         wDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409259; x=1758014059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5aEOGf5lzke7NfjFn8+kgwyzmdKicgx8i+x5xoYQng=;
        b=oi9nWf4IsXcS3MzcVyGQ1G+7u0/u5A28ky5o4kXrWU/N7xXI+nmB+9xynbL0/jhsoF
         j3e6BWq+RHpB0Aq/iyRsEP1SFGEkF1F1P25Y6Nbn4fZrfH5zY7zLJ6LMxNYGPlTdTggQ
         9tJ3MbFKXmj8gmWwB+LQ+jQ8hwsCLtUxOWfYUH6sZfqO40fbupIuP6dbacDFM8LULyAf
         9wClwSEDJfp4HKhWmuGSwteHRwwlUKMiioPspV9TanNGUPFYUE1BtBgTVDu0aWz0UgDM
         +KqQRDZLJIpPjoc3U1nyCG4iuWINoc0FvIxWai4nTlOxYhXqVv/hPTJyMPTm8sL5zLFG
         1+SQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0lARCRdpwoUP6oyuWGTG0tFN63JddYN53PXW4azKyQPPyP91KsGN2Xr2qezrqz5pOaaIJLQ7i0SqrmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+x+O0Y4jwZ3qSpMqbMwPxqwT0Swa7KGpYAVU1y47wYXxeFzOu
	yOlCbcUCsH/f+wCq2TmaI2iA/rqN+TiGYhpAZ49NloL+sTQlYaSp2JNl
X-Gm-Gg: ASbGnctAXUt4mOkRFHO/KiQ/z5+lwNyx4BQTSzUIN3yN+eIO8Tc3CD7qZyefRILwlt3
	fwzzLPQXDehtxUvmOJ3Se8Ex+HTaQCHyjo/HwgM5S8F8g1JRu/RRUrp9ydSuOVEWvDCQI2skA3S
	tb6HG1Fd7Npjj7VI+irrs0GQg2SFuOEuVtbmcD3cs6I0rfWAKGnrWJEhgEYx5Ko7n9Wijx1Fe6e
	S30eb+4oMvvGvpHJT9q8hQ5Azgvt5iAPmstwYf2YNWazeusnT5lZzg+X4tBWuNnJPUfr484Ys5U
	7ep6n3zwr+rWtOANg4QxdwNsshr6iGO3OyEZskv0/3FP+VU+5K30yNOgoxw4GbPYgOsofGKzVuV
	aKoNbDM7JsC1E86dR6B6dkzm/Ghwxpx5zvsXRSKQIIezaOs3u500=
X-Google-Smtp-Source: AGHT+IHqMwLiYolQ5me436vqKuF39mMXx3pO93Vub5Pv0KjfPnkmrMoeMa+RFTf/DfJaqpH93CaTXw==
X-Received: by 2002:a05:6000:18a4:b0:3e5:955d:a824 with SMTP id ffacd0b85a97d-3e64d22b2c2mr9348224f8f.63.1757409259384;
        Tue, 09 Sep 2025 02:14:19 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:18 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 07/10] ocfs2: use the new ->i_state accessors
Date: Tue,  9 Sep 2025 11:13:41 +0200
Message-ID: <20250909091344.1299099-8-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909091344.1299099-1-mjguzik@gmail.com>
References: <20250909091344.1299099-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/ocfs2/dlmglue.c |  2 +-
 fs/ocfs2/inode.c   | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 92a6149da9c1..b3b7954926d6 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2487,7 +2487,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	 * which hasn't been populated yet, so clear the refresh flag
 	 * and let the caller handle it.
 	 */
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_unlocked(inode) & I_NEW) {
 		status = 0;
 		if (lockres)
 			ocfs2_complete_lock_res_refresh(lockres, 0);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..02312d4fbd7b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -152,8 +152,8 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 		mlog_errno(PTR_ERR(inode));
 		goto bail;
 	}
-	trace_ocfs2_iget5_locked(inode->i_state);
-	if (inode->i_state & I_NEW) {
+	trace_ocfs2_iget5_locked(inode_state_read_unlocked(inode));
+	if (inode_state_read_unlocked(inode) & I_NEW) {
 		rc = ocfs2_read_locked_inode(inode, &args);
 		unlock_new_inode(inode);
 	}
@@ -1307,12 +1307,12 @@ int ocfs2_drop_inode(struct inode *inode)
 				inode->i_nlink, oi->ip_flags);
 
 	assert_spin_locked(&inode->i_lock);
-	inode->i_state |= I_WILL_FREE;
+	inode_state_add(inode, I_WILL_FREE);
 	spin_unlock(&inode->i_lock);
 	write_inode_now(inode, 1);
 	spin_lock(&inode->i_lock);
-	WARN_ON(inode->i_state & I_NEW);
-	inode->i_state &= ~I_WILL_FREE;
+	WARN_ON(inode_state_read(inode) & I_NEW);
+	inode_state_del(inode, I_WILL_FREE);
 
 	return 1;
 }
-- 
2.43.0

