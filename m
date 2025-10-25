Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFD7288C26
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761390876; cv=none; b=HPCUF3WZeUoks2SdYt+bbHzG9B1pShrL3aM/w2DFZwzCDDZTT1fdb1gPZ3esCI4lg7CIkimraPomE1i/QHZRsHJE9elOeFGxFp6Wbrf+qq74hPwCOQVQXlYUFX3Wr+N2QAgkWG+1tLEl6wwfx+d6bjcMOAEZCsB1dD5RNXfgHHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761390876; c=relaxed/simple;
	bh=s2JsTGJJhPRBobBrxl1HoHTSaGGJq5e20ABAYu7phpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9MaadiQ0bRlxw2ONTVhku532qa3ZAvbl1hXwaEf2auoJtToR9H/EzbfqmoHYPA71BOPCytIwsBecEO3wBOdYu9ptNiJtXEvKb9karWpMggZM+U0fS91EDskWv0eBngxsWHviPgmydEeFxjApmf4VG2868p8TBSAdF0dqKRqggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQ94TBl1; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQ94TBl1"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3e9d633b78so640000666b.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 04:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761390873; x=1761995673; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R80v4yxlifPVzrQknKQdgGJrNUlwmjhmtAoakF1isME=;
        b=GQ94TBl1etO5LQsgO4CjY1Rrhh+vlpQHxpMo5Fb2owMf9UIJJ0dQ5u9uTpu9tQUvxx
         rTuoZNetpAZAqqsvauzs3uGhBK9Iw65KesBpMEtpfowG/RydsxrwpfWYUv9G2kczLx4/
         Oc/zJmBSUMZVezdN3S+0J3/BbY3uXJL9zV5d+3B12UBRXqgDUUWLcbly+NaAY7g4Iy0e
         MZfPNxhdLHoNricQaKla1BiJL+p3d/rc5XRibxbuzsvqXNrR+ofMew7szBkn6mPnMMJr
         VtjXf8TbGk588PAx1dLrBgVaahcjIZgseuVdElE1lL/l1e2xVArBVEk5oTgnd2JAByHF
         1qCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761390873; x=1761995673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R80v4yxlifPVzrQknKQdgGJrNUlwmjhmtAoakF1isME=;
        b=nAQuhcH13XlldnFxuDsN6GWgD+9xDEhmgxNou21x/PNnb3E0wEktc93DqACdos/oqG
         iBOJKjRjbWPbMeUK9NybiZ93+T1QH3sMi/wWdWn6NARiZU1cB32AGQLAfrrmegbQp4+x
         p/XlwPoHhEkdugQlYAB3PaMSYLaik0IBuIfdCgmzb/PVXLYtF3JRhPi/xLLhwRVRGadL
         YOaEHC3k0cK0TH6ebxCWIqq+dhqAQeWY2KWtnBUXpELvb+Qr3hw9lkinL9T2MS3R4etw
         Ifz4Qr3dsPejP6TTlJS5LKtmjLQTs6wtlOV35tRB69a6r6b0D2Guo2E9eNAtlIVzTBKT
         HZ9w==
X-Gm-Message-State: AOJu0Yw0vLcsSzFlhTO39I01Uj7wdrlLeGjQp72LRqqw2S19G8Bx1ciL
	G25InHPiX+Fk261iqJXHk4Zpi3YV49KEymPfGE5ZpX2KXiGpSZZSLzaM
X-Gm-Gg: ASbGnctN6QB4AAd/nsHAp6KW3vGL6rhGUtVMwJXzwtV8k1N6D8SaeitQRawTeNg3CyQ
	TZuHVuc1Pk5rQFr4zoNJCDsWDVn/Qay2VVfPUvPbsScqVwc5tPO+BpxjVTxdXFgz32QpdfxBA+c
	urChZ8nVyB58T6doCdOzyqIs1vkLX8bxMtt1+E7/8r5wiWOncgcBNUw5VsZv0rGTy5YC4ecpLC8
	RrIEGaAbebFRRfVXJeYcwpRM+gqDBLpOwV1D0yJfVSCotRxfLy5DK23W//XYoHgARyhEvuQIkyo
	kZq7Cb1hnT7YLOzhdsNkQKv1ekmKJOZX9WPRuHr7h387itTPhHTcC1aw4MCfSOfwEuR6ptymmPI
	XQK2gu37XtvpNTmN1v9FjKNbedjmKrI+mJVhWGayr3R4eFnSEM0l0DeLD+wvrIH7q7nOUVmIEf0
	WreA==
X-Google-Smtp-Source: AGHT+IGgKo+LgBDmphrQJh61ZlnfUrDa1Hl8aG+8kt1bR7ElILIfxo2UJgTRCkZE2FX4aOJP+gtAcA==
X-Received: by 2002:a17:907:968c:b0:b4d:71e9:1662 with SMTP id a640c23a62f3a-b6d6be49e16mr645586566b.30.1761390872508;
        Sat, 25 Oct 2025 04:14:32 -0700 (PDT)
Received: from eray-kasa.. ([2a02:4e0:2daa:1585:4413:c60e:7f80:c15f])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d85398444sm175638166b.35.2025.10.25.04.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 04:14:32 -0700 (PDT)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Sat, 25 Oct 2025 14:13:56 +0300
Message-ID: <20251025111355.32045-2-eraykrdg1@gmail.com>
In-Reply-To: <20251022222752.46758-2-eraykrdg1@gmail.com>
References: <20251022222752.46758-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.

This "zombie" inode is created because ocfs2_read_locked_inode proceeds
even after ocfs2_validate_inode_block successfully validates a block
that structurally looks okay (passes checksum, signature etc.) but
contains semantically invalid data (specifically i_mode=0). The current
validation function doesn't check for i_mode being zero.

This results in an in-memory inode with i_mode=0 being added to the VFS
cache, which later triggers the panic during unlink.

Prevent this by adding an explicit check for i_mode == 0 within
ocfs2_validate_inode_block. If i_mode is zero, return -EFSCORRUPTED to signal
corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
make_bad_inode(), correctly preventing the zombie inode from entering
the cache.

---
[RFC]:
The current fix handles i_mode=0 corruption detected during inode read
by returning -EFSCORRUPTED from ocfs2_validate_inode_block, which leads to
make_bad_inode() being called, preventing the corrupted inode from
entering the cache. This approach avoids immediately forcing the entire
filesystem read-only, assuming the corruption might be localized to
this inode.

Is this less aggressive error handling strategy appropriate for i_mode=0
corruption? Or is this condition considered severe enough that we *should*
explicitly call ocfs2_error() within the validation function to guarantee
the filesystem is marked read-only immediately upon detection?
Feedback and testing on the correct severity assessment and error
handling for this type of corruption would be appreciated.

Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
---
v2:
 - Reviewed how ext4 handling same situation and we come up with this
   solution
---
v3:
 - Implement combined check for nlink=0, mode=0 and non-orphan
   as requested.
---
 fs/ocfs2/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..3feeaa475b62 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1455,7 +1455,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr);
 		goto bail;
 	}
-
+	if (!le16_to_cpu(di->i_links_count) && !le16_to_cpu(di->i_mode) &&
+		!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)) {
+			mlog(ML_ERROR, "Invalid dinode #%llu: "
+				"Corrupt state (nlink=0, mode=0, !orphan) detected!\n",
+			        (unsigned long long)bh->b_blocknr);
+			rc = -EFSCORRUPTED;
+			goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0

