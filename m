Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA21F16B
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764715617; cv=none; b=TLdmuZFUX2AqHNH5SC213Lib/Y7NBWXobQUWbA6j//trjspWwESW3ahDNaTjlGIT3OW0ir4YWwbZsou0imwCSBO8a8prm4h2xrlG4mNecV7dyBc71KyUdc3zvQxxr8DHH6yvtnC7H0DKjrIiySTNrxb0ji0Hs3WO3GWgbRK0TXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764715617; c=relaxed/simple;
	bh=9Bf9ujHcjcq8ovaOcju2Y/IU6fHMb1AsAo1VIBD2RUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TboWE2O39coaj9sB9iK0HUBSRyVx+y7T9ZhKcp2BuP1mcaqTDY3axko3DV3LVqgPRNA8bEd693HVhYdq/vPdDSQuqqGaJjPTcLfrhU9y/f9kJsb7fm+VxvX/Kysdkcl3I+B/XynvEdwAuC74LmN48H3IMp9ffGK/fzep61BSEmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+cKotLs; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+cKotLs"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b728a43e410so1023042366b.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 14:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764715614; x=1765320414; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9BP0JD/Gk+5eWk3Fw3SO8aUPDHyheQIxFJmlzr1Sdg=;
        b=f+cKotLsD0ayx/vYUQogu2wwXjqw3uZdyC889LEbmby0nWXJc6whqJT/3uWmFTQP56
         gXQn7j7wBPYywR8SkCK+eLzYgxzahVEVBqgWMXofHWd6mj2F/ruGXpLwmTjMYC5OtUyy
         I51vxaeReg7gS7bqb0jEZGnTFd5KlKFCPOFAhJbfgDIe4Bm4wQcYi0XwuatrOOlVSIMy
         XV5uAJbBMl5NjOgMEDWHOjy0/wmOjfmZzYXamvqtWNa1VYSjM/ZERUfhmh2oRL2h9x9q
         kkwkYZOwMISxdn6WYbB35T53mBnT6d4bGvxHXjJ7hRZY2Ty6exG/TbGvnfEpRFWu/ReZ
         Hh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764715614; x=1765320414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y9BP0JD/Gk+5eWk3Fw3SO8aUPDHyheQIxFJmlzr1Sdg=;
        b=A8saCNLmmQVH4L6aCmqCrBouULbwmd3if7opzsiH1BeCFlpOPzV9AYiCJE+HPswJsP
         ELLnzzBfTZfFgOogjlw6ttFxjlPhxpar/co3TeR+hKcc3pQ22bolJLYZTlLqHCvKu1i0
         UTm7SjUb4BwQv7nu5XfkXeyZl1htVURPzE0WhVI46b2B+HTwvjJ9O7BdhWkt4CxWrguD
         FLraSKKctXEJS7sf/6abbcAarW/JvQ3ZU8V3n9iZxIbJ4gTfd9EDBEIJVdQJ7Kow0xyY
         yWu9Shtvzyx8l4oDvI7/ta+yI3aJeN1rcM3KpKEtS0cUnIZter+OwNDENk6CwOWLUK4m
         ZPLg==
X-Gm-Message-State: AOJu0YyXXxvluDs2RM3B058dc+bBWWGvIlXs9MVjH8mX5VWuCmjMPoCC
	/F8+9r/RZgX+E/7tMVQz093oqd951J/D3dznC6013HkUjmaOh013Mek4
X-Gm-Gg: ASbGncvnKI2l67RHFdJCzxj6Lq0U7MmRgJQRCQkb9v0FzF/t64eotqMdimXJ5Ix1J9c
	cFRbQsVBityRm4zm/wpajOiJLmZj39m9L6dQgvzAxMa2YlEwOsYajMOPj5KF+kBv0npmMWpFYsS
	d6SEZlCHdtm2ZFDGDCCHmFJa1Hp5mXVx10k+ERBcmnsI0a8dKlVNXARF79IfM09wmIP0iIxNS+r
	76eaInjQBks10rdD2fXADIMyagX+D7I4iSshn23UEy26S8gMSNXrqPbfFnOfkCm0lWwSSxfR+a9
	13REi/7UWSxnf1vppcsDrnKUReXx+ss+O1OlnFb8FRmV1xCFAqDSfqBqSfe4ljxlIGfXfKPYNxl
	903nwfZ9EEPy4EduF9doFihSixa7L1WdRskLNSD+lf5GmAALbyHyRXwPbqWb7zOnbE6gkysWPo1
	9thuKwUkzVgEw=
X-Google-Smtp-Source: AGHT+IGtTAR9cbqkqFVQ4UMW/RQSbo4Ss5u4i8LZNHdHqSxLPQnqcGFpVV11DTB9AMVc7wURNK5Rvw==
X-Received: by 2002:a17:907:c1f:b0:b73:4fbb:37a8 with SMTP id a640c23a62f3a-b79dbe8e16fmr6649966b.12.1764715613366;
        Tue, 02 Dec 2025 14:46:53 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:acf7:8de5:59bc:44c3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79c7c49d35sm215051966b.49.2025.12.02.14.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 14:46:52 -0800 (PST)
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
Subject: [PATCH v6] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Wed,  3 Dec 2025 01:45:08 +0300
Message-ID: <20251202224507.53452-2-eraykrdg1@gmail.com>
In-Reply-To: <20251108120133.37443-3-eraykrdg1@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
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

Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
make_bad_inode(), correctly preventing the zombie inode from entering
the cache.

Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
---
v2:
 - Only checking either i_links_count == 0 or i_mode == 0
 - Not performing le16_to_cpu() anymore
 - Tested with ocfs2-test
---
v3:
 - Add checking both high and low bits of i_links_count
---
v4:
 - Reading i_links_count hi and low bits without helper function
  to save few cpu cycles
---
v5:
 - Clear i_links_count check
 - Log the actual i_nlink/i_mode
---
v6:
 - Use `ocfs2_read_links_count` to get nlink
 - Convert di->imode to cpu endian
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..f83b8e4f4d8b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1456,6 +1456,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink = %u or mode = %u) detected!\n",
+		        (unsigned long long)bh->b_blocknr,
+			ocfs2_read_links_count(di), le16_to_cpu(di->i_mode));
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0

