Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE992D543A
	for <ocfs2-devel@lists.linux.dev>; Fri, 21 Nov 2025 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763710843; cv=none; b=jWoTvDuBxxkt+zoroQVE+IJ9WWuswXZSwKXpoVQHWCl4O683cHq6I09CrooOXQstCSg5UEf7YqjBxslu1ubzMsKEgUa0AnQyBAQIEXVFOFhVwCGlvBsRMNoAGGii3X71UrEqHz2PK7eX/NHV6IWSGP7oP96Jns03voi2X4LSXzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763710843; c=relaxed/simple;
	bh=c9Nz2UaUThfK0wiQ6EO5TmFRdJn6/FoBXbp/8eo/Wf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hp+7I/hFWHxB/YUFqLE6KSPqXayyjiP8cZu6Qao5gGq8J0zLDTxewKt5IJ+75CvGLFvn4GHDlKtHfUdmnpj8KYC6EqWMOgbrRm5Gb5/K506Dm+XrQzPiMs4rYa3mkf38Zy0nUX94bs1OSJGrvh7SC8SN/qEifT/udpylmanftKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=evvi01+0; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="evvi01+0"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b4c7b2c8bso142761f8f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 23:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763710839; x=1764315639; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/3OzWeCcHm6SP5u4UWtyGKWgezzJaPTk+c1gYxlf0xs=;
        b=evvi01+0t5zQGexUYDxwANNvwHmZeczSxNR6P/44dfRwI1KrmKTWY5bgL6izXyVVnd
         sMOjyEou0H8zD4W6NjNAEBN+xs1/N5WzS/5XO+HsdYIG7soqagD9/PxRYpCARZyfBVg8
         I7nLEXeIW18xJcxwzX9z/iEWgXYGGh9tAZJBLrCu9H3bxKKUSKlwUr2+pSQHPs+R73Ae
         aUtYHbY8EHdwltSXJ1lpuXWMrIfAQYxpmNmoXwy5GS1Os+U96Q8AcpbaL0hverdLN3Nx
         xoQAonTNcQ1l2Z9VI8Zb4g1exSXC4HD9vbwgVgbUiy5+95GTrEsOHCSPSSB6bCv9DtTd
         5anQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763710839; x=1764315639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3OzWeCcHm6SP5u4UWtyGKWgezzJaPTk+c1gYxlf0xs=;
        b=oE5AsvUdkp5Mkj8w83Q1M782Rgr3wBgU7qTvvw1vPrfvquuDrZ9ODvb3Ds6cLyMCvV
         2G7HT5zMNG44DGCFwQld1TztOaHBnYAWwwSi/MUOFvTyWI6h2EYXa2sr7WmHTr0UMd5v
         74fbeqe3rVNg1a91sxMxkI0BroBZAuOA9Cy1BXYPioZaPuCftv1gEmn7eetKZFZtMmj7
         f4dhb+qXl3SqYC7OaWUqHFVAb46KxbTeQ/fs8HS6ADmOAbZ+E8AAo5kaokLdebHKZrqL
         pChFTB9oGufWux3OWdrau9a7PlinEiDpjvQfGkqk2raaWRP3o+va/jy97K9UZ1QVBsNO
         p/tw==
X-Forwarded-Encrypted: i=1; AJvYcCWmfcZWGejkeNmQHBBOU8/4qZmT6igyvgpV09ln3N4KCVe0eb6eqMjR7mIPohFq2+fE1mT5ifRQ27m3bg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyWg/TnIhSmutYYEZEV2hV1onknUtA+QKW81xVLXJEYarp+lunv
	D5M/6FGBI8kBOKUTKN70B5E7SMu0yAJZtcnaKib3JHuTCt+1kSLzq3VBvojMdSuOo58=
X-Gm-Gg: ASbGncvX9xXCp31guWQVG6sIcnv6wbR+nQbVJLO2Z+CtSpEeSwQT1PyVe1E4eqmzak3
	YWij+oEFtLtAAyQ6fmJ+EBFF5kYHwYH8Gqqwjjn+1QrIbV4diHHvuBu4YuA0rlcWgUxf49l8n70
	cnN+hqWgQswRMPL1tUwLdoRrJCnNo7djduzvQ+YgwMa8GjRMDCJZWft/r/Y5DLnxi8EtL6EVwL9
	sbxroThOOxeXryPfl0jYNbEgE5kt9XkUVCsjocqH9q5593xA0uteL6+A8ocBm0CgO86+ZvKiRV4
	v1DXye3jAdJqwZj3VzM4k+b9s4+MtejVReUmPAszT2cYZC8bFisG9MoLIT2d2FwjxEV704p+D7p
	kLGIDRA4TbfdPoOaRX4SNMSigtXZC+r6Sk91/gVNLP6jRCHDUxzU7qqRh2I79F/9604vK0zqPCO
	rfguPicrcCZJR9Rfa/I3Vr4qET
X-Google-Smtp-Source: AGHT+IFQGzJembqiPsHmanOKzrRgr/zMYZ1JaT37ImbUe6LUK2An3tixuhnERMEGsxk3/RNERSjUgg==
X-Received: by 2002:a05:600c:1552:b0:477:9c9e:ec6c with SMTP id 5b1f17b1804b1-477c01f4ed3mr6595575e9.8.1763710839483;
        Thu, 20 Nov 2025 23:40:39 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023fba8sm5081295b3a.41.2025.11.20.23.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:40:38 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v4 0/2] ocfs2: give ocfs2 the ability to reclaim suballocator free bg
Date: Fri, 21 Nov 2025 15:40:23 +0800
Message-ID: <20251121074030.12014-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4:

First of all, there is no code change in v4.

For patch [1/2]:
- Based on Joseph's v3 review comments:
  1. Modify the caller to initialize the ocfs2_read_hint_group_descriptor()
     input parameter '*released'.
  2. Rename the _reclaim_to_main_bm() to _ocfs2_reclaim_suballoc_to_main()
  3. Change the text "not empty rec" to "non empty rec"

- Revise the comments preceding the function _ocfs2_reclaim_suballoc_to_main().

- For the question: "How to distinguish the release case or a bug?"
  I write a comment before ocfs2_read_hint_group_descriptor().

- Revise the commit log to make it clearer.

For patch [2/2]:
- Revise the commit log to make it clearer.

Remove the v3 patch: "ocfs2: adjust spinlock_t ip_lock protection scope"
- Reason: This patch belongs to a different topic/job and should be
          handled separately.

v3:

For patch [1/3]:
- Factor out the reclaim code into a new function '_reclaim_to_main_bm'.
- The function ocfs2_read_hint_group_descriptor doesn't return -EIDRM
  when the group descriptor is invalid. The new code logic returns 0,
  and the input parameter '*released' is set to 1.

For patch [2/3]:
- Modify the code to follow the new logic of ocfs2_read_hint_group_descriptor
  as introduced in patch [1/3].

For patch [3/3]:
- No new changes.

v3 patch has passed the xfstests:
./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
-e generic/081 -e generic/266 -e generic/272 -e generic/281 \
-e generic/331 -e generic/338 -e generic/347 -e generic/361 \
-e generic/479 -e generic/480 -e generic/628 -e generic/629 \
-e generic/648 -e generic/650

v2:

Create 2 new patches:
- ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
- ocfs2: adjust spinlock_t ip_lock protection scope

In ocfs2_read_hint_group_descriptor()
- bypass the validation of GD when the BH is already managed by jbd2.

In _ocfs2_free_suballoc_bits()
- Move up the position of the vars 'idx' & 'rec'.
- Move up the position of the ocfs2_journal_dirty.
- Use le[16|32]_to_cpu() to access cl/fe/rec vars.
- Add error handling for calling ocfs2_extend_trans().
- adjust spin_lock ->ip_lock protection scope.
- Follow Glass's review comments, add 'comment' & 'else-break' for the
  'for-loop'.

v1:

Only create patch:
- ocfs2: give ocfs2 the ability to reclaim suballoc free bg

Heming Zhao (2):
  ocfs2: give ocfs2 the ability to reclaim suballoc free bg
  ocfs2: detect released suballocator BG for fh_to_[dentry|parent]

 fs/ocfs2/suballoc.c | 336 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 317 insertions(+), 19 deletions(-)

-- 
2.43.0

