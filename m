Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226934;
	b=wXsZ0eatF1BhwWom+uSXnWaMIfNI21z0EmCsgCLRESDOZFwodiFRN+k3RX/J0kkTmDlh
	 cNbRvlazL01wnI6NHH4knwSkZIxzwpjRCzbBnD3XYq0eKgqlaoyC9HpBN6aG9uyYyrwOr
	 6YEjn7zhTkltFDVkEm6gTH3hxJqEAtf+t1UhkcOxEUEPDBk62Ou0iZ6e5hp1dIppB3bN1
	 kagAweD74DWGd3hIf4zf4tYqbta6tFq85jOCyx9swUS7SE5P8vJOVojdOVkgB0f9QDXrP
	 eP709KNpbd2Ks0rZrttecx6mVrtMpuw52mcXJ5MX96effF89Lb9WthjWGaKKqrolY6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226934;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YsBDLDdvhHgGE4hbSYAmMvLRsGcnCVXi8pM03OETaug=;
	b=2UG8C99UArNNLFFrijLtUp+PuD0n09hgYOcuI8dwOknbAOznM/ruyi/dUmxYGc2L26k8
	 /whIWERdGEwjtu5O41joAlci0oM9Oc7wpDH9+tRDa1cjpQr2x0QtJ9ylMtumrYkCsylb6
	 a26yF88jHdMSKabVDLGtTZ28FfFoZBNGCYGrHsjVDM3p52Ch0N0aRuc7Cl2AWXa3Y8FBt
	 T11wvGQUU+lRyIMZ1PhcsEB28v8TkirGg+jVG53NYrlQma8YxMS3tdLLBzOy/LMgEnA+p
	 6EvoC55CrBBRqXI2V16/6jf5BzPCPHsNPG1GnwbqaFgPgs3e/oXC/njYE2GVy/YmXdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WGNKcYiO;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E47F606EE83
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E47F606EE83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WGNKcYiO
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226930; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=YsBDLDdvhHgGE4hbSYAmMvLRsGcnCVXi8pM03OETaug=;
	b=WGNKcYiOgi27DQ2qKjuUVv4iozZHBvGBnbSIfw1T1Q9cv1r1+CHuiduVbfjWoc3EjUX3nGfj6uvflaZw1Py4FFbs9OilzoIas8g57RYHaRmZfBVaQHS4nQdf3ryUeSNmQVTnEraJlCZ/m6M0zKbMw40YwpwPilZ2gI7UPZF3Xa8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8avi_1794226929;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8avi_1794226929 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:10 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 24/31] ocfs2: check dinode suballoc slot in online filecheck
Date: Mon,  9 Nov 2026 20:21:14 +0800
Message-Id: <20261109122121.21473-25-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wire both suballoc slot predicates into the filecheck validator.  An
OCFS2_INVALID_SLOT on a non-system inode and an out-of-range slot keep
their separate messages, so the log still distinguishes the two.

The range predicate excludes OCFS2_INVALID_SLOT, so system inodes
created by mkfs.ocfs2 from the global allocator are still accepted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 6d2fb46e6c38..10eaa2c4445e 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2029,6 +2029,24 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_invalid_suballoc_slot(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u for non-system inode\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_out_of_range_suballoc_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3

