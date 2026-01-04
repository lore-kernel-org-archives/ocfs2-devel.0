Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831F41E7C03
	for <ocfs2-devel@lists.linux.dev>; Sun,  4 Jan 2026 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767490840; cv=none; b=Jd74szzEYwmX9aWarue0ca8fQtkRck1/3B3GLI3ZxRXErNd+tLU6zlXMTvzCKRsfQOtFNWniUSiSlqeuGxZDK4GRhFjiwok17wjGqZn9hnbpp3sPunxaGvNk/HRCTZ2iehWq39lkegvTlt5mVQvdAX4VjetBOwsOErtf6MkuEV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767490840; c=relaxed/simple;
	bh=y7/MyBJ/9luYBjLqkeIXsQQJWFW1iw7+OxRG6AiXpEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lLvdAiwLUZfHID3zpfENYJBoqQ44kujrP0Gi4CUeCzRgLXcwBoR/W+1Wxp7MRLiV6apuLp4ffs9qzYMLHgX9YVHS/ELk7XzJebzaLCqtTHKqbou2WXwC4qnq06m5TFZTFyIcMyEqAKK7Fcwv9cXV8p9ZSfiUXT+VUOkTilPHhSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPsOIzkD; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPsOIzkD"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0d67f1877so171688835ad.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 03 Jan 2026 17:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767490838; x=1768095638; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u/tXdSO3fVx76Ok1kJAIyCPe7HRmB+07nRH72tLtOlU=;
        b=jPsOIzkDdJ868SvZg4vP4M4zZhkZG+CXw4B1VVrFZaDmKWoBp91svkOVuI8dEaHA04
         4YNSHCy6FAqYyC4OtWxVpU+sdQ9OFyQlzZErZzEvz9zwtNFed0P+rC0EMf+nUgJfV3VX
         XmgA8tgYKfr12O7kHX2DqAf2GHNIfpdC1yR6I3ZQLJplUj807s33zITtq/qZZr7Bigy6
         aOcyc5+Q0Y9kZisvPZTfQdgRVm56MSEv1jdO9gcFRP+B4l+JxmpGZh/Um2dGR1M8FFMp
         /bbqp603tMsNKyYdlhbX+rnd7dcxy1kU/zDulGqkNe9IbuDL7JE/n1SwYNvsG+jVdOd4
         91vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767490838; x=1768095638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/tXdSO3fVx76Ok1kJAIyCPe7HRmB+07nRH72tLtOlU=;
        b=dNN7DEWR2pNvU3y2l1iEU1HV9BsJMpvFYmjeaz5BmHukVVDYJo8GHgnwI4UXUzeFr2
         ItmgYZTRpQjmu7MqGCxuE6sl1j8QDiAohno4y+IRxwJMQa1hS2WM1qv93/tjK8sKgc5T
         8K7UInBrJbGFMRaDjplJQ0aN4xrZFoGlzXhRGpsQ8kUvKG8VyRYfGabZZ+1khJnlzRvh
         N2f0XdvfBesi7Ayx/cACXc6btz6xvx2rdv18wYZ1BgEd05O0wU8Z9kzmoQKl+O0sh4nM
         B8ZVDxMfB2qxd3E7V83c2ZoDLrZbOXJo0suuP6uVu5YsJ4vy+yMhBlXQYIagdvLei2La
         R37A==
X-Gm-Message-State: AOJu0YyQS9fiQ5fJQV39G8Ycq8RA95jkqPTUvNBjvO6K3Sag9gp5ptTt
	UsAdbWOVMLUOL+2xM/bAwv+9jNZM+VHIjRKABQnHTo/CAdZh0xGlqi4f
X-Gm-Gg: AY/fxX5gl6h7VCnn8K8hqOvRXjPKCFJ9Y5BxEb03aRPAGZyB8WeFxwTqLC/jSzas4Tw
	RphprzPItGnKqO2wLQTXiIvjclpyuNz4zDjsX0D3W/sE5z9eaeUwqkz69dK4Y57mN6LY0Tj2/DV
	hDIrTJD5PeZXhahkrrVXanxJUkj4Ncnd1USGmkx7CoGgHA1r9/cIK0t0WOkk4VLDqMZh5t2SKZf
	WJlhU3SALmKtQIXtfv/0k5GPY5gri+k8S48MSz9/9VbQCYwBzhpURetzZL6+XpxTyHuTNusNpXZ
	pKzVI6KG4icY9FDR5eMunE65Rh8YpF4QWZM5tJiOpVP+/p7TFg0zcOFzOM3dH04QPF+Ibl0JFbT
	rhkVrfbsQQG13LBA4iU/jclob71ilmQgevkPZgWZAiCc11GP1kRvar1ZSFJZKIumw1Xk7Oc/hNU
	WHb2Wg6pCCifDyHPEDG/7k4bNN3Gko22TTW/hJAbJWhaet8fjHn+7f3vpoaMQJo1SzJKE=
X-Google-Smtp-Source: AGHT+IHXVUVm6YVAUnC0nMuF0Hqoyzfgg7VE2iGfV1T56h0OA80JwuYzPsH3OTKdGoZ1FH7DMWcazw==
X-Received: by 2002:a17:903:38c7:b0:2a0:c1ca:20f7 with SMTP id d9443c01a7336-2a2f2214973mr418825005ad.15.1767490837646;
        Sat, 03 Jan 2026 17:40:37 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:273c:63ea:24a7:bc91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c83325sm416486585ad.34.2026.01.03.17.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 17:40:36 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate allocator type to prevent BUG_ON in ocfs2_block_group_search
Date: Sun,  4 Jan 2026 07:10:28 +0530
Message-ID: <20260104014028.305029-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A corrupted filesystem image can have an inode allocator with the
OCFS2_BITMAP_FL flag incorrectly set, making ocfs2_is_cluster_bitmap()
return true. When the code later calls ocfs2_block_group_search(),
it triggers BUG_ON(ocfs2_is_cluster_bitmap(inode)) causing a kernel panic.

Call trace:
  ocfs2_block_group_search+0x1c7/0x2c0 fs/ocfs2/suballoc.c:1611
  ocfs2_search_chain+0x38a/0x1010 fs/ocfs2/suballoc.c:1764
  ocfs2_claim_suballoc_bits+0x3a4/0x650 fs/ocfs2/suballoc.c:1978
  ocfs2_claim_new_inode+0x95/0x130 fs/ocfs2/suballoc.c:2137
  ocfs2_mknod_locked+0x129/0x510 fs/ocfs2/namei.c:568
  ocfs2_mknod+0x5c7/0x11d0 fs/ocfs2/namei.c:802
  ocfs2_create+0x136/0x170 fs/ocfs2/namei.c:852

Add validation in ocfs2_reserve_suballoc_bits() to check that the
allocator inode type matches the expected type:
- Global bitmap allocator must have OCFS2_BITMAP_FL flag set
- Other allocators (inode, extent) must NOT have OCFS2_BITMAP_FL set

This follows the existing pattern of validating OCFS2_CHAIN_FL in the
same function and uses ocfs2_error() for graceful error handling.

Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/suballoc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8e6e5235b30c..fb72c062a8d5 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -813,6 +813,26 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	/*
+	 * Validate allocator type matches expected bitmap type.
+	 * Global bitmap must have BITMAP flag, other allocators must not.
+	 * This prevents a corrupted filesystem from triggering BUG_ON
+	 * in ocfs2_block_group_search() or ocfs2_cluster_group_search().
+	 */
+	if (type == GLOBAL_BITMAP_SYSTEM_INODE) {
+		if (!ocfs2_is_cluster_bitmap(alloc_inode)) {
+			status = ocfs2_error(alloc_inode->i_sb,
+					     "Global bitmap %llu missing bitmap flag\n",
+					     (unsigned long long)le64_to_cpu(fe->i_blkno));
+			goto bail;
+		}
+	} else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "Allocator %llu has invalid bitmap flag\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
+		goto bail;
+	}
+
 	free_bits = le32_to_cpu(fe->id1.bitmap1.i_total) -
 		le32_to_cpu(fe->id1.bitmap1.i_used);
 
-- 
2.43.0

