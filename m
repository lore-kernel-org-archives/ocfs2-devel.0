Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040661494C2
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761403186; cv=none; b=iCe8aXbliG7UvHl0A0wBtMR5MdTcgtB/XrLh070fUgNoLojcv/HOzPAjkViRaSNxfABGR1aNzf2VBznHWkR+y1A54zZuR8ak7j0IeSaCJwIH3zGC9Ibn0YHaekg/BDDHm2qf9TtFIqSUk/hPeNMs/PJame1BRgrSpv2EZWxFoJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761403186; c=relaxed/simple;
	bh=d7oPjajSmdHJIOVEObk8SAa9pErxdZxHJm7CUegQEt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bREqrIq6FW8vq/hGy4/G1eFACcwgocOo8DjLTHeOU/qq0J3wVM5fdsF43dOguRKf1PxaaJQYn1hVsbOEFKKBzjKlBqlbQL42bgbDJPoTHvaU0E6BeWnuJHjbYTP8mnanUrtLXphdif79Cf/IlQvc0hf7mnbQax9R8fVvizGU64c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QbOwxAOC; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbOwxAOC"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b6d855ca585so141747066b.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 07:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761403183; x=1762007983; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dwV1zE7kHbhlnXNUv5Lwzmfyom/MI3+9ZkL549vVBI=;
        b=QbOwxAOCLg3nzzrN0DZD2aj1u3jbxIZHZOnBMfz8NGe2CYEhoBK3I6Pri0DMojbmYF
         WcM+J4y6MnQlDIlANFIcnt4KqXPxecNpTNi2H23pTO3tRt4A67W9W8LpjN8PK20zLzfS
         6oyclxGGVQQ0jPqMjWlv+T6Fj5YnreIPcKGH35JsFABuj6GjDprZWj2KG5SLzleM0+LW
         ezeLih1y7slnOfZIDSaQq2sqFRrC45BrBKiETR/wQm8wWJO3987v1A4UVouQzMq94hz8
         Tbku7+H2Hi5bk5mTwiNgFZZkatg/nAyosAP6LgmddCXEVXGyBobnwTCziIpqbAhl+IRm
         1Qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761403183; x=1762007983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dwV1zE7kHbhlnXNUv5Lwzmfyom/MI3+9ZkL549vVBI=;
        b=A3K7ZoUkWYpAHdmSzHhM2juuSBCI1XxgfypAsywQcf9AVrm7pX8y+Yp+kRSqMNetB0
         icR09QTzEGalz3ii5gllxdwPN4rVOv2lxkL4RXp3SYfj7H1Uc/UxDZuwTPIIbn/2MH6i
         Vf+FPKE1hJH6F9ZNmMaiC6ri5kWiaip6usjzkjAsfy21NJwhQ+QxW5QHFMKrHQaX/jA+
         ro73zbnvik3mr931CRyyrYT680tJIFzl7RI331r10AwhiRM+FNqNSY4kHvczsQuuwuVk
         j7Df7XL/mIJHwtVKBDh3gZ9LGU0tjcfSz2dn+y5j8JpBdHt/hpfhkuxyqisGOPFuvgXT
         GD4w==
X-Gm-Message-State: AOJu0YzvcB1Btt2QyAiguUhvg390nEGEFjby/DeBsxuzFzWkqDju1wvC
	uDqbQ/Nc9TutOgfJBt85Srhqx/gj70iZXiaSBJ3PcxB6TPr3k3AnrprD
X-Gm-Gg: ASbGnct6Wk00Oe4CALQSgKkG4GPT1pqUROG+WmPV/AnnzcHrbOV8YCsHW0yDRQCPBYf
	vwBprQLnRLpBbRwQV6lYsvEZnGR649x6ZqqgD42w5xfCgE9tXbYey5ogKj3VKtT+AUQ8JU/Ec2a
	NRlQejNlfAIijLB/rYKBv4B1gsAqwaB3RKn+p+YCei52VffL9jgNoJ0NfAse3TRpMNcKHQRvFJb
	c4ckHV4n7bz1kUbc3LdxGZcrCZpktPv97vSXcT4VVlo1COhJ9cGSJvT8kyc1k6gXUQa1x3l1vFw
	7B+LbEr6tStcq5g7UUeBgg6M4u6YhAt+gH86myd9YcMnakYNdl6ufbIA5xMMzOlzMCMxS3EdZlv
	WPPlHcnpCnVlwjr13UFq8/Dw6ejwKoZ2XRMgxL41dqV3Tut2H2zdTRHPIyY6bFzJ1iTD15a+vhm
	YJwQ==
X-Google-Smtp-Source: AGHT+IHtboGNa5ID1K3C/9/4U53O+54r9gF28NuabONifTJYD+CSQkmxBa1dSwsg8fM2EYeUS1k3Vg==
X-Received: by 2002:a17:907:6ea8:b0:b41:aa62:eedf with SMTP id a640c23a62f3a-b647453ecc4mr2568832166b.56.1761403183016;
        Sat, 25 Oct 2025 07:39:43 -0700 (PDT)
Received: from eray-kasa.. ([2a02:4e0:2d15:18db:d575:9d7b:cfb7:2841])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853386casm213340966b.15.2025.10.25.07.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 07:39:42 -0700 (PDT)
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
Subject: [PATCH v4] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Sat, 25 Oct 2025 17:39:19 +0300
Message-ID: <20251025143918.9106-2-eraykrdg1@gmail.com>
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
v4:
 - Fix code alignment issues
---
 fs/ocfs2/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..d966df3aa605 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1455,7 +1455,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr);
 		goto bail;
 	}
-
+	if (!le16_to_cpu(di->i_links_count) && !le16_to_cpu(di->i_mode) &&
+		!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink=0, mode=0, !orphan) detected!\n",
+		        (unsigned long long)bh->b_blocknr);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0

