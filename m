Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9724A0C
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Jan 2026 05:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768023894; cv=none; b=nJxhTqeS4nhMVNlAaHTsrz6zWWcXRPX+iGexxfNg1DUsJugnOwFUUn6EHFNXBDSvQ8lJowjpM2la+wDSzzLe86FHv5jRVhuT0GoFqehBxIT9GnxHoduRw7k8jmPSkdVt55X091M7y2HT/YgH/DOoQs+RG4Pq0bH/wiUhPkk2jag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768023894; c=relaxed/simple;
	bh=qjXsV1fXF5mWIQD1Y6+NHCIHSXg93dSjO27lRy6uUHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LWSu0weOFTIHnviafGiyCcpmaUryZ+MLU6eHETpaH0KP3jPtUQWVYg5kMfVATTAupLWSmJxBO0neo2l26oUcm1RTvkjDPqIWZIPDzicq8oZD+v8cNf0uLO6FGUTZ/XRrCimB3AQdmGePXaUWwlg5DxmK8Yil8MO4POWGo6uJl74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqabXBDO; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqabXBDO"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34abc7da414so2833326a91.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Jan 2026 21:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768023892; x=1768628692; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z68BN0cZI5QOdu/wL2wyS5FUbf7T2hnqvJbeV5WVky4=;
        b=jqabXBDOgfTJbPLlulPrqmnaNO1DsslM0Q6Rl42HWk2mgswb114z2TnWyRessN5H8v
         +Og2GKqZOynMuweB5TOYS8Ix4SM63//UPkPKT1EckJqsLtq+QdoetMuGXFBAhUAqYRbG
         No7szPfIYFkxo4T01w+J78KhzqRwsVUnXbtXrNDLOS4ljfx2sn4uXuSMweEh/9BKg8ml
         u760cV9XzPhwYP0xB3SnvPfj/ksogNE2RphLcme9sjtU+uX0OttSj5loYTZ7tf7bQT3N
         1dSzQJlafvXt6OGG+4S+OiAdbw7agckjuQK6PYuGBDNPATAN2nLw6v+owjTWAmzBsjVM
         Bmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768023892; x=1768628692;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z68BN0cZI5QOdu/wL2wyS5FUbf7T2hnqvJbeV5WVky4=;
        b=Eu70L1eh9dqZOWCJue9cgv8yjwzMleFvNIGsKinDX01keeXqRsWx7HU+U1AOscmBNH
         +i1EZTBuew2VTr2Zjuky+K+uakJi2nqmHjyBm3MBkiIazDOzAJL7y1QHiqr10G0pAweK
         J9QBmRHeWQdqbkCxn9wApsysWUqBZMYkWDBidm2E3OXVZ85S3sqhJGeajqmNbbdXIcTj
         Mtg0fuhWKNRq2oUTQ/2QIur3yh73lo93k4rDtUEhPotPapxqrIePMvcjTPyz5ogmm4Ga
         Uy+vvD4Ju2m7gNMVTMNGc8pNfSDT2nr3ZVAv7s8IAGbAbKRNhsevtQftyAIkx+QTo5oj
         PWaQ==
X-Gm-Message-State: AOJu0YzAIVM999s9jJku4INAxY1tW9a8DZAFZXe7Ej8NL0RyK6wuekr7
	JIyE0346KnzZQ0G27arcBe7JwzPh8Vh2q0y72bWArTnZaz/NI393OLXJ0XP+YA==
X-Gm-Gg: AY/fxX58PXgze7oNimuR1S1CMTNz+FfnPKT9oPlx/RnzHcb7gI87DCBPb7qKZ1kZFLw
	7/blb6PlZag0u7it3dF9Roj+87Uq3A1+WHMqwRhDwp4unQrqwU5dW5u+H4R8yxl3nLWiL2/0HJL
	24jrPTfUFCVjGDwFX7yxMaDDoBzKEEIOR8nenczTHi1JYgZVVLsltWoPfmgDKj20Ze7mwkvuPMp
	wj67PNKGX/WIzABFeGFRJrY7B0F6/ULUP8VSNeU/pqzaHFxqaYwdvPwX67GYTJ5Cr4Ak368c1bA
	JQjltrtF9kg/5wJ/Yq+6uWunTC8nEgA6RU6MkLnWGbW3SCLrCnZc5zPb63J5dqUqtj+pkUpQu49
	MvcCIxjhGuEgn3K0FGIneZqsrd7XdjJxgF1F3IbA+ZOTrDPQQ1v4XdtXOSmz7P/6CzElk70z7Df
	gDEkLGalUjcZ4PiGsy3YP2mSGKqiB52TYL83aXaIeOlMOTAqUi7O3A1LBaYU76Yy5shVQ=
X-Google-Smtp-Source: AGHT+IHt4ahIAGUhI8Zd0S/hBWvFKtfcny7KZw1sYUfxMZ2BkCeyItEV4H34gSk1f1CpeVUJNiZdUg==
X-Received: by 2002:a17:90b:2587:b0:340:c179:365a with SMTP id 98e67ed59e1d1-34f68a29d18mr10132869a91.0.1768023891988;
        Fri, 09 Jan 2026 21:44:51 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:3fae:1049:5d45:ed6a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b29e117sm4221799a91.2.2026.01.09.21.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 21:44:51 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: validate allocator type to prevent BUG_ON in ocfs2_block_group_search
Date: Sat, 10 Jan 2026 11:14:43 +0530
Message-ID: <20260110054443.604944-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_is_cluster_bitmap() checks whether an inode is the global bitmap
by comparing ip_blkno with osb->bitmap_blkno. A corrupted filesystem
can have either the superblock's bitmap_blkno field corrupted to point
to the inode allocator block, or the inode allocator's i_blkno field
corrupted to match bitmap_blkno. In either case, ocfs2_is_cluster_bitmap()
returns true for the inode allocator.

When the code later calls ocfs2_block_group_search(), it triggers
BUG_ON(ocfs2_is_cluster_bitmap(inode)) causing a kernel panic.

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
- Global bitmap allocator must be the cluster bitmap
- Other allocators (inode, extent) must NOT be the cluster bitmap

This follows the existing pattern of validating OCFS2_CHAIN_FL in the
same function and uses ocfs2_error() for graceful error handling.

Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260104014028.305029-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2: Fix commit message - ocfs2_is_cluster_bitmap() checks ip_blkno
    against bitmap_blkno, not a flag (Joseph Qi)
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

