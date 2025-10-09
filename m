Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D9D2EA736
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760020165; cv=none; b=and+z5G9Fp31jUgYy1gvJlriBKqS8SeIP0IC2otjxXFqMT4TdMpzzED+v2GR1AkgBVhv3Q4lDTKSkYc7G2HVqRCJX/mQRXaaBV9XiSJuOpOGPvcVecP+llXw3ZXref+STXBWYNTRYSqf1i+gtsorx2Bl7ckQkhxKnb+H2NzPtf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760020165; c=relaxed/simple;
	bh=zeDf6KdhYAzkJxWgKM7teSxvMdUp3SBOEpzJkkS8EKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gx8A4EjQO+U8G+9gYT7kk51k2Feofh2FKxQxIxGOlFo+dbRk0rdCAFlFpzYGGBPfLYkFNCBC7gPUmVjKseDHCOSMpyq31Qz/rzGbtHJwS0uU8/+a4cxrQnGwh8VeW1SMjDjrFhDnste1+2CaYB/lkfHznh/ypoEw+H0yD2KuOrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jumjmuwJ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jumjmuwJ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-271d1305ad7so16801995ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 07:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760020163; x=1760624963; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U/74xq4XJsElEDgJYijZf54I5DhXyuQKsFilC0hgNrc=;
        b=jumjmuwJi6Iktfw34mi8n7yVcnMI7OEv/8CDDFoEegNGiL5bHHcESOy+6dVJlSahsD
         DEQAzPD5YHs/JzMNw+A2sbPff5nf6R52BQ/lWQuBEEHfH1bcAp2A5SOij7tKbOmoZm1h
         S9Ix+kXSLUVZrLRELSRAfR3ojZ9erZ3RjvYMfWAOEQjwACAGlvpk+WEAAxkRp55h18D/
         ZF4SCy9xZQXqyemp9vUMpeKasZznoWvmMODNZc5cE+sinQPsu9E/g/BF4/26sckU0R0y
         URMuOOG89xzj9MIhEC8YoJa+kwXMgwzuswgx7xnkkhpSmTSX8XKI6E2L3W9IkwzgsJFn
         Yusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760020163; x=1760624963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/74xq4XJsElEDgJYijZf54I5DhXyuQKsFilC0hgNrc=;
        b=A5GpOrP54PAVu9oa+TvAg/3HaKtp6fM9YBxfCiYa9dEqwJ+D+zr2m3ee/3Af9PHHeR
         eNZVfPG58ydMQ5bpFzJsvSfX9y4jpRKGQZAXXpd1s1Fxw/i6sbIRghacQrx3x5egOc9u
         Puod3uZL6PmkL2QqrmxoY05DEVN5NAqoh8Q2RhewlFUk1yIyetg0ZkdWGF42L4R5J85r
         BHTz/MxeNKAK4ofbyzfw2kQDG3KjBM4Owplnwlmj74yAEPhMmL26ScdHWkeBkBEAyhv3
         X8YJx0JfSeiKOHLMh/nRAZBl90QUr28QxeUQPraDUYEROs3yIMiUkAJVUpik7yTpfvq9
         vLdg==
X-Gm-Message-State: AOJu0YyEhZvrMY6NWai3aN23uSfXmcGmb96IWGORIM07/ncgYlVarVka
	Kj3T9Dfd9pF4OsA9QLZrU3diHl67Qw/vIObEPk8PMN1yj+4/TzP/8N1b
X-Gm-Gg: ASbGncvJ7qwsNJSqYfaN9ZCYBhxi8eWVvbIH1cQaTysJM9T2TReoJfg+YWYpN22wnv8
	DgLj7bqenyAJCtbAqF2jaSLyGIAW+x6nPhiaqFEo2B93xPRvq7WPqkuRUasVWlqAqP2Iht+qm1l
	sMeHbgTWsDYb/HLbAnTRVS29XXD4g/W7SYuviTubMDwDYdFFxf+iTe6ZZZtdeMTfMROWCmAcwfe
	rr/pNqR3Z0+oX9TQk4ybnLrIxtHooPm2YPLce8rg+XgompxMmfWBiT1zDEdlL+g3sJvby7NBoUH
	u6W6Z2TvBzdDb7RDrotKfieeohRolU06XqtO+zTIpbPflPRnXN28coLtAOCTYeIVZ3OP9lnCVT4
	30LCPNAIxy3oNH0ecz5jMoM8E5feH8ror0CDoC3PaGdVJucnPNiyADa8rzLuWZKoRUhNc2UGBYJ
	LKtK1cHBGA5j0K7etNzdCBlDPtKvY=
X-Google-Smtp-Source: AGHT+IFB4dSwBRuZ4Sz99mGQnC+OkqQeSCmKq0qSpJyArZKnozhvJoOda9lEv+5VZ+rvS9S7fjQ3xQ==
X-Received: by 2002:a17:903:1ac8:b0:264:8a8d:92e8 with SMTP id d9443c01a7336-2902741cdfbmr105368775ad.59.1760020163233;
        Thu, 09 Oct 2025 07:29:23 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:60a2:fbdd:54e6:8eb3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f961c5sm30527265ad.129.2025.10.09.07.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 07:29:22 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix stale extent map cache during COW operations
Date: Thu,  9 Oct 2025 19:59:16 +0530
Message-ID: <20251009142917.517229-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


Hi Joseph,

Thank you for the review. You are absolutely right - the cache clearing at the end of ocfs2_refcount_cow_hunk() should handle the COW path correctly.

After further investigation with the syzbot reproducer and extensive debugging, I found the real issue is in the FITRIM/move_extents code path. The bug occurs when:

1. copy_file_range() creates a reflinked extent with flags=0x2 (OCFS2_EXT_REFCOUNTED)
2. ioctl(FITRIM) is called, which triggers ocfs2_move_extents()
3. In __ocfs2_move_extents_range(), the while loop:
   - Calls ocfs2_get_clusters() which reads extent with flags=0x2 and caches it
   - Then calls ocfs2_move_extent() or ocfs2_defrag_extent()
   - Both eventually call __ocfs2_move_extent() which contains:
       replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
   - This clears the refcount flag and writes to disk with flags=0x0
4. However, the extent map cache is NOT cleared after the move operation
5. Cache still contains stale flags=0x2 while disk has flags=0x0
6. Later, when write() triggers COW, ocfs2_refcount_cal_cow_clusters() reads:
   - From cache: flags=0x2 (stale)
   - From disk extent tree: flags=0x0 (correct)
7. The mismatch triggers: BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED))

The proper fix should be in __ocfs2_move_extents_range() to clear the extent cache after each move/defrag operation completes. I will send a v2 patch with this fix.

Thanks,
Deepanshu
