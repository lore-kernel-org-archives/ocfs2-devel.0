Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC31A21D3CC
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764657590; cv=none; b=EECtOMu99OnlNKQ4uFa79Z4Yk2U8vbI4HY1heJsHrhhT+rBZCB8SOuDAR24jDBsPF7duFEwm3Bcbv+OilIVmuWUr2o89KJxZ+1/PTqhH8h7iX98JJsjf2sTbSXVou1hDTPois69bqvKrIM3Vu53rjrRRPnAUXxZun2dMTADSmnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764657590; c=relaxed/simple;
	bh=cybMQlqzqWSeUEcRLV0YY5xWTvsLY6kfQPdhNnOCMds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jsVAefvv1Lx6Zwf4zQnieNCDFsFHi/wpaiAled1RuDLXKdkn7LEczL+IK0+BiNfBk9lWcuEnzx/iChr5e93CAi0DeyzISA6yhBmu7JgU11BQfr4n7WmpMtQpofqoiZEf6kamKEALdg/gXtnvhm7iR4eTaecCKCeJOyxsWMrL0p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eqpo0+j+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eqpo0+j+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779fd615a3so4969055e9.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 22:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764657585; x=1765262385; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jJWPPCiXNdZgK6BhwvrD7XUosARU9VubGRwbzKKTJJU=;
        b=eqpo0+j+CyEedQ+9XvFtJt8HHWFH6v6CO8EYotQMi/YTG7oPfL6kVMTld1hkdSLgqF
         qxeg4Z+wemOixhunlc/kCJ5tNc21PgnVLZoZpabVxCEId/dfPr+APjQ9D688cTglGOkk
         RGSmUnkiYf7keSmDqSKq4okScMc3Zwrfg6xJ6C6vpFPSyPlmLDr3MyGr1TsGdXvrMZug
         7mJUoZVsoSjt5YZI0YXNShXC5QKBMkBgC3NJebHvdkTSdXa9/itvbN1BMqssLLC7c2bV
         CVk3mvT94tr43DBMhayuJG5UKl55Xtq+8hUXUiN4Qu9eKZvScXnhApoBv/TvxeyPHpTJ
         vA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764657585; x=1765262385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJWPPCiXNdZgK6BhwvrD7XUosARU9VubGRwbzKKTJJU=;
        b=tgkjHxJGFigRd7x7a3IlDTnFJxZj3LLmifdlDvKsMFn19Em47dH7gBYPowpWIM9rR4
         egQV5SN+EJyZ3kdDei3ZszFxI2dTeCwtIppdBBmywqYzcz8M5T2PlDz5aLE1HVWQD6wS
         4hhatN9zMZftg7C5VoN854TzW53HNaeTesgrph/+WBr08954cyd53dz+TYdHuWIJ1AqU
         BpwDf5B1aN3jedBQFUqU+vItRNQ2F2iL9gjrabdNcxPWQB4bFdcBVFd8u/YO/dmlHBuR
         ZF5rDtcpo4xUukdkYJQPR7n4EIy/4kjj0aebEzWyL8hwNVgoIVBIcHKOftD+qhprHGPk
         pgYA==
X-Forwarded-Encrypted: i=1; AJvYcCWXzH0gN1u7MYuwBzW7HzQwm1qSzQw9ZzBl90Dsito4oNIY/nRv0xqKQJImai74AyNcVXYgsNmtcoWYVg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfbD+b1VAgxETieXSYk0Jrmae7X65NYSywXCAqRfPjjxwrCvw4
	MZoHVY+NZchx5qDdTvWVyr4K2MMf39S0MMid7eT473rC+CKC8/NoXPCZwJAuaOf5knQ=
X-Gm-Gg: ASbGncsyu8VyTOeB6utVKyi38Los4DjBjTqVlXy2EzAmbazRT4hykJajQXL0ac5HtNV
	cB0r6cHRZ/6Be4FDRan9Jae6jznmgZpbQMjfedyrSKujnm4TMAIrQd7iMRBWs328evaMoAkFhsU
	WwMgLmflJ+p+OZ1B1jHSmsYjhc+ZHS53Uj8uHvjLdR5P4Qyfpo3LXaJfqEVffB8JUtwYUyHaWY9
	vmbzVFin8bcFfMF5QCWkdm42i7qts1GzdObAe9EhpA8lmFweJtb6XdRAGfV4BqbO9DgGpti1FOS
	Yb39P14YTrYvLr8T8sdz0ZuA534zsI56gObxUR3c5uiqkN3CyX46QhWt8dq0Dd+tGQDuVY2R2cA
	1prIul2ZW6c8Sf+KFFSJClz6nPQDC6lQCF+wiv73brZ2dW0i1b8yDLDEpL7ECwhU4xnfcGK4GQh
	aQ+cnlMFO6JiiT8c3FwNkVl8yP
X-Google-Smtp-Source: AGHT+IGozbeGaga8/a1PoH9/elj2sfZVaATZBc29uYPZeq6Dw1myReOM8PrF79Dt2XurrEfBBQKI8A==
X-Received: by 2002:a05:600c:1c23:b0:477:5c70:e14e with SMTP id 5b1f17b1804b1-477c01d92cdmr266007405e9.5.1764657584938;
        Mon, 01 Dec 2025 22:39:44 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15fb1430csm15702796b3a.59.2025.12.01.22.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 22:39:44 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH RESEND v4 0/2] ocfs2: give ocfs2 the ability to reclaim suballocator free bg
Date: Tue,  2 Dec 2025 14:39:33 +0800
Message-ID: <20251202063938.9046-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

why resend?
- the v4 summary description in the cover letter is incorrect.

v4:

Most of the changes involve revising comments. For the code itself, there are
function renames and parameter usage adjustments, but no changes to the code
logic.

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

