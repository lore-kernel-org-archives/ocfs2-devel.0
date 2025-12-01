Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E543019C4
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 10:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764584396; cv=none; b=CYgTGQ/7wHmZX9zL1h4EFqQL2tuMprS8tpao86Ps0lOKVnmkdrQ6dVKkGiX+h2lg0shCQts84mjxf8nwvRy3t4DyFYbLz7YDJ/RLI0ERv//vM5SZG0ugnOVhPEQS4pmfrLs1Fet0RhdWPJAq0IY/otJy1TpRfTWjHTZ2Wzsv1cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764584396; c=relaxed/simple;
	bh=tZwnj4aboeCs3AaWsY72VeZ86o2jO2KaAXGBraKws64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p5xSpmzySE+0hMne843xoJbh2QG5pKuBp75NaZW5C6RsiZl/lJ+/zpXasLnDc9kr54307S/EV1oLOqQWWkCLQ7ySLVYwpw6N0ESeL2GA/5CVWz1MCavx2/EA+R+NwWVcf959ypMamjkPIhybHhStSY+cUQH0q0WW0eGbzaSmyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMt9S4jm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMt9S4jm"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-298144fb9bcso39048685ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 02:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764584394; x=1765189194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePKejyYRNJTNB6/J06igMKwXPLlc3e8UKCfIra5krD0=;
        b=QMt9S4jmrHuoTAnSuY67/hYJxVaM2un43dZdKSUHW97VRM3l45/jYo9tZluLj+9FvE
         xdtXxKzAEdyVB0zZi+MI8Q/3nCTNJoPZPBW/UBIAtsQzxPUvF3ttkRTzFfSlF2PShmjz
         tSauTXRIERKGnvDiJwmZnC/4m4wbxDLgYLdPPp22zcykARcRPqgeKcSltCjf37dZsMay
         ZgC8ND4WHHiDB1PcmS0xfJACuVUQ7SCSIfP980R58Tta9pSACFXbUDglCE4i9oCNr+RQ
         vhosPZN3yWUzyI/X1XBA/kG8oiluvfGZT3cxDsUyg40HnXgng8BLCdam0uG63Qe1a31Q
         ZEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764584394; x=1765189194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ePKejyYRNJTNB6/J06igMKwXPLlc3e8UKCfIra5krD0=;
        b=BTiePTJNwgUkFCSOzf15zbOjLcWWfgQi18UGZe6fSY3Tnnqayra+9RotSAmYIFnLEL
         PgM3g//5BX6omMhBpp2nbMryO8ULiWzfJcsUeIxmBMYQf/m527xpiChRo6Fh5HAkJR2y
         pjWii6KY59jB15nrQiSqbgM0OhlMYMmT5OF2YOkLBVqi1xORjehql4eNl4VMtAh9R7vk
         a7B5ryEY6pAzze/Kxj4wZhFdIIRPD8ixiGFKSeJGpa1Q7GqrQNUjm2pBBj4zgesF3Mi6
         Z0pyQBTBtwGbd4Nxaw4fI6Mcfu81+HsSEsF5RxtZwhGBUO2K/E45U6/huMR889+Talu6
         0+sQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhGF6nYSORIOxMfjB+XG8GIdX/bdUmZiUyysnr+kobKqbwHB494MD6N3m3Y7x9JR6ffMDqkky2XHOicg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8ZsJLFffjgi4mfdPUiE8eb1jhzaEKgdmwY4dpK2T1HAzVieTz
	u0jCokme6r2JhT6xWqgxHn/Aisi+pDQ6L8lpcfxhJtyqaUHR30zhfcpu
X-Gm-Gg: ASbGncsYLatWN69azMjfsQ8iKG0ulTQ0AsjglccIHuI0WhMppw9VKGY6ejCsTKh6f6G
	Bh+Z7S5DK71/LgYtkfoRaqaLrxvDFAIqDPNOTKIJVkD/+kIqhdr78Xvih10QjG1n8JfBXTWqg4c
	99dd9krKeaaJIu3PqcC7DVJYjf1IGtl2kY9CPauC4E1v8uhUyWyqQmzKIO7QRSaATTdUnArkWvk
	VnoUl+MMGTnEfmq0gZuLsxi/Uer9+qRaVldUF/dDC+OCKa1l4WChqvQFuzmV+RNe4A3t8gG1u+b
	TfAl765LfSY60oh1eFF0um+cRU2OYn+tFkSsMivCn+5jzb1TBcXOxzSleB5opx3JXNu6zSZLkuP
	LkHov1umnLo8yxz8fa37LJWAaDoSBQ4xpc8hgNYdznxLcEdVlCkjNcdsRfVBmYtrhYnYNObATH5
	uKQHmmtrEBBs9/GGCRL3aLkzLrERE=
X-Google-Smtp-Source: AGHT+IFtJSXbhxz3LwwENHstglFun3OJt/L5abx0uvvdaZijKf7b+yUfB/qeNLslofnZsIozExynbg==
X-Received: by 2002:a17:903:3d06:b0:246:7a43:3f66 with SMTP id d9443c01a7336-29baae45392mr273250105ad.7.1764584394399;
        Mon, 01 Dec 2025 02:19:54 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb5442csm117546945ad.85.2025.12.01.02.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 02:19:54 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon,  1 Dec 2025 15:49:38 +0530
Message-Id: <20251201101938.103998-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000560ff106204134d2@google.com>
References: <000000000000560ff106204134d2@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..c310345b7135 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,14 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has invalid next "
+				     "free chain record %u, but only %u total\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno),
+				     le16_to_cpu(cl->cl_next_free_rec),
+				     le16_to_cpu(cl->cl_count));
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1

