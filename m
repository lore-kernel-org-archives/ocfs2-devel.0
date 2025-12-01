Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26462D8DD9
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764594458; cv=none; b=bWx10jO5YglM+wrw7RGgjPyhywlBoIFHjDbQ145EOAWXDpOvN+lurbDveKVB3D1xVSge7HSLtqliBh6n8NBGqOYSeUxW5+ZU2gKcKkfg3m677fyApyqHyAdNmjrbqZhMkNtmBrnrQotfNcdZo0xoe+pA1JAtD2y+mVJYRog7clo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764594458; c=relaxed/simple;
	bh=plntT5yPstXzUw0Dpn9IFxN4qgEosGtIgjWLHWO4W/M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ilr/P2dsqmpIusUN2vEdoIlL6Fv1BuV0bauA+qDNowF2eCULavajkA1JOj8eyj1Jf3Xp+TR2xgUfq3nb6uJ/qWNSZXgI76jRN23WouObbzxtF1oFkMmqC3JAB6bp8AtWkLoimRUrfqy6+CycwtyDfSbKvwn53shjYXG74cQaVLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XHpVt9PL; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XHpVt9PL"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso4804676b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 05:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764594456; x=1765199256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GNXu/1jH2RyJZPkWpjl7hMV9jv2CQqUwV3vZHk8AaQc=;
        b=XHpVt9PLIuOppM6Ck1D7/R3i0UmiESdlRHOoozNGgG7R7o/A7TGsbFWAbaBMbx/O9f
         0PncbPccqO6KGSyzjxaMHo9yf6Dq8dzjbYIu7fGr0EsQcP3fg7vmbDlzzZvUBBXYPFb8
         ayGfzKmjk+qNLhYK9Lu8Mye8Y3T/r+Ds9aiM1Lav8UzhyjSTT/6IqhoAwYNqdqWA9Cg4
         BgapFT0TjdpUL3sBV5HKYZL7A8HHQQIMHg1arWr4PB/WYlEQT2uTtLGmDlmK/rL6+QnA
         nCxg3Z4dgn8BsxZieCCZQa2S5kZpSkrdRKWZsP/gH9tk8txVkMqxfQD5C7AWlaJ1XsUr
         v7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764594456; x=1765199256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNXu/1jH2RyJZPkWpjl7hMV9jv2CQqUwV3vZHk8AaQc=;
        b=Z5+sRf9Xj1ux/UXuWRcNpWDVIT9O8GizW+Mwx1Mt6u1qOmW/MrHhX7Mn0q4juWAw1T
         a69AilT1nEGalkyWiO0E+MqPoKkAmUYn511mYp1KZ7sJBoAaBMtYV6sexZvPHT8GmcNO
         MtkcUtKIcQ3SS5n/t16j9LykWMqj6ONvuVLiXepmH+vn59VPBQun7Q3AxdLXPBechGd0
         cDFZsFDQPa8hNX+oYejiOgb06VfNUSM5gWAXcO58FbH7iQ7d4mbzUt2JJde2tCvy8N2A
         EqBThVjBolkpKQMBC6xsEpCdvpOHZW/IF10LlnYJd2wO+pX+0b0sJ7Olxrn65TwO4SAx
         i7tQ==
X-Gm-Message-State: AOJu0Yz5dStiPCI5P9k2TFqup3zlRJU0hzJj6d9b2tO3z9Jcpah7nXUw
	amgQ3Y8pDWRlnKmMmRgX4gOdT6WBAmPOBOdeQwFwK0uSfjF2s6JtFDYQ
X-Gm-Gg: ASbGncuVK9lLUU/Uh+iOt+0vf4mVMOdePrTS3Rp/Sl/AQ4Wi/644Lcv9qNpU3FXV7a6
	KoikDuiYgpPza4S1uqJEtUvkZvygUdThUWMnEeHAiHhOoM9V9l41+M5/SQbTYledutpusD/hu88
	NzTHxT0Zh0UbpGrxJlvNOUx02SR24N5xLL2r0N87KEXJ/uBDMgnmvhJBEejhs66HmNoO3woXbTQ
	Lz6Id3keJTAx4JEKIEmlKO+cw1LqI2YYw1lGni5UdGMp3F1QPZWrBZsvg4MpRetVYL7598277xq
	J6Nk4TFfuoBsMNIF3YA7BDBVt57q17YJMZ2byxj736zpXmqmWlOmrKHC47+41GyxUrFM1tZM3KQ
	sEShPKD4jTEf+d+3yeT8M9mvuqsvMLGQqoBgXMeQr388U93xNrT7IGkgc028SopEZ8X688Oj0Dr
	HtETyR7AyME4r4RME2VZPoJQV486Y=
X-Google-Smtp-Source: AGHT+IHPOrXcm13bffCEXfP6/yWgQTkgDN8RI4zKLTdSkUdTCCIaY6ua/6tI8O1gMmObE4vDOKYpRQ==
X-Received: by 2002:a05:6a00:2789:b0:7a2:73a9:97e with SMTP id d2e1a72fcca58-7c58e6016fdmr38241883b3a.26.1764594455804;
        Mon, 01 Dec 2025 05:07:35 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db6ddsm13365913b3a.34.2025.12.01.05.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 05:07:35 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3] ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon,  1 Dec 2025 18:37:11 +0530
Message-Id: <20251201130711.143900-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
`cl_next_free_rec` field of the allocation chain list (next free slot in 
the chain list) is 0, triggring the BUG_ON(!cl->cl_next_free_rec) 
condition in ocfs2_find_victim_chain() and panicking the kernel.

To fix this, an if condition is introduced in ocfs2_claim_suballoc_bits(),
just before calling ocfs2_find_victim_chain(), the code block in it being 
executed when either of the following conditions is true:

1. `cl_next_free_rec` is equal to 0, indicating that there are no free 
chains in the allocation chain list
2. `cl_next_free_rec` is greater than `cl_count` (the total number of 
chains in the allocation chain list)

Either of them being true is indicative of the fact that there are no 
chains left for usage. 

This is addressed using ocfs2_error(), which prints
the error log for debugging purposes, rather than panicking the kernel.

Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com 
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
v2->v3
 - Revise log message for reflecting changes from v1->v2
 - Format code style as suggested in v2

v1->v2:
 - Remove extra line before the if statement in patch
 - Add upper limit check for cl->cl_next_free_rec in the if condition

 fs/ocfs2/suballoc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..e93fc842bb20 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
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
+		goto bail;
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1

