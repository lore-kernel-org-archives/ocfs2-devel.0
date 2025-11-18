Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3E2AD35
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 00:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425646; cv=none; b=t7jRYuAqyZrt8zPud6gS1Da/9yoigk4Vd+490X5s/CQw4T7tdaRUNoyyCjkpeRNE3llhiTz14c/38WuOV/4zpCV51mEY67FXStABxmBgitYwwdLdTHqFjYbvrdKZB5l0sgblyOcTJilHbOS5E0EO6DJLEVfCxczmU2KxdRpy3no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425646; c=relaxed/simple;
	bh=nlPHRzqL3P7AYSrGKbubBYTx+jzUX2FJFkFsKmVcKEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rkh/pHg7BHEQeE6ieFlbifCtBCHt96hmcMWPTu2it0weJYjg0xpKcN2xQSoYAxXgZXlaidWfZb3bBqsE8ZW1VFJiEdAqJfP2IRE9RWHdBxQvgNniIZqOkl3kxmDVsYt/SnVFTpw3eEG3tx54mXlQq5g05pwQtyahzxHhEZnXlrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RNGwUby1; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNGwUby1"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b72bf7e703fso815168066b.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 16:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763425643; x=1764030443; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=prCp0tfH2qTYxZSAKZHBGjZXVGST3CfQUhmEicSbPrs=;
        b=RNGwUby1VsJWAM/It5f2woCLT2sZX/Oqg18NRM/iTua2PKZN4vwY36cMJ0fifg+OVm
         X7hxtS+fUdWul61QqB41FZwVtDXIWrm9CpZPbZueJX/9UyoHEV/gCdHD05ucPpQOOVcV
         CNQdedGZxPrCYJJREoIws92MCLVloYVYO1Y9CeDKKCR00d5EyKM/lOZCUW6lPnwz1S1x
         39FcMP5UJ4Uh5i6Pq8Fju6NWA+gLX7xNDslLBj8yEVOQHDnpORf0ur71FPAxgZFKpzWV
         hm84Hncln/p7yY8VpBxEB7ApLLx/JrZTtY0G3ZlnjBAjaR7fMpeb6wcgT/aNvvPY1yaK
         sdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763425643; x=1764030443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prCp0tfH2qTYxZSAKZHBGjZXVGST3CfQUhmEicSbPrs=;
        b=ant56njiDrCUKxVMFcBX7WGMwrZhJHgyBTH8++9kWmVCIlrJ1HlaTqBsZ68tlHpZG/
         BMvNM101orjJduAZe5TLld+wMz2PT2Kt7yjh4DfgcZRDBpQSKK1oJP4xtlMrGUD/MGFr
         gcXKvdet4DcFIMt+hrLTMzkJsCIf2/2WtTabZxaovLp3+jtrWnF/682bTccnrfS8jVWr
         cGIq50s4SQf0vYOvS/Z3C3x9i6KJ1UBTkbZdbEYhjw5iiaSrOBOPLExN8DB/xDAqmIu/
         u4QdTeyFusQ+WkE7gAuKF9zNucleu3IW5MHWQPwHQTTP1P1rXF06Vb91DIKoBL6q77iZ
         AgMA==
X-Gm-Message-State: AOJu0Yz2VJeHhdlHdxbg1VvGD/g73BKEsnDH8gZYHMQs2S1a8ujHtBqy
	QZTt2FbBtmCMd3Q+u8Iwgv2o8tDyxBGuyxotVn4eGnAnLWldMLg7I6oY
X-Gm-Gg: ASbGncspSAfFvRLNhhfbX3O98XLqlDxdof+tzyF+1ysjdwyfTdT/MKvW6H6ondJ5Mod
	+MC9GkFYDSnV8ZFjIsSVou9lOqY+dglfNzKk4yIS7DD0P6mtdnNsVPpyvg04eXPfNotJgLCcoXk
	42gXSyIgD3pzn2QirNeVtA9WHp4uqxjzRjUbKfunqlRbKRMJjk+lfzh0nLgCdsxW91tJvWTYZUB
	+TGvZf9qm9nOKd8W/mRD7SZco9DQAHxOpiY6dQWa7B1HiuE1DStpK3bWt0xZ0dCbiaQ4ZzBSyYJ
	qnrs/A/yTFD3/Hc8AKiPoVIP8kmF4Csy6VYAIN8bh+NKtfmewMuGpn1DOH6MOUQ02nQjRsZLRWl
	LaEIPR0mg/16Cghez/ZZahb/sSxPICZkiqCPev7Wz+A7rdIGPHpKp5AbCLUwI2MofvtA0RkI9aq
	JwlqUM2FFk8WLTvqIBjiIhRg==
X-Google-Smtp-Source: AGHT+IFu6cy9He+lLQZJ5Pa1M7Yv2fPYPsXHCqBqdYNgAfDgvPT859ppX8w6SN0ZkECS6zDf5Fb3/A==
X-Received: by 2002:a17:907:7fa9:b0:b73:21db:64aa with SMTP id a640c23a62f3a-b7367983f2cmr1527425266b.38.1763425642660;
        Mon, 17 Nov 2025 16:27:22 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d08:f72:eb64:1d0d:5855:afe7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fda8a86sm1172606466b.52.2025.11.17.16.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:27:22 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: [PATCH 0/2] ocfs2: Refactor read-only checks to use ocfs2_emergency_state
Date: Tue, 18 Nov 2025 03:26:42 +0300
Message-ID: <cover.1763337347.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Following the fix for the `make_bad_inode` validation failure (syzbot ID:
b93b65ee321c97861072), this separate series introduces a new helper
function, `ocfs2_emergency_state()`, to improve and centralize
read-only and error state checking.

This is modeled after the `ext4_emergency_state()` pattern, providing
a single, unified location for checking all filesystem-level emergency
conditions. This makes the code cleaner and ensures that any future
checks (e.g., for fatal error states) can be added in one place.

This series is structured as follows:

1.  The first patch introduces the `ocfs2_emergency_state()` helper
    (currently checking for -EROFS) and applies it to `ocfs2_setattr`
    to provide a "fail-fast" mechanism, as suggested by Albin
    Babu Varghese.
2.  The second patch completes the refactoring by converting all
    remaining read-only checks throughout OCFS2 to use this new helper.

Ahmet Eray Karadag (2):
  ocfs2: Add ocfs2_emergency_state helper and apply to setattr
  ocfs2: Convert remaining read-only checks to ocfs2_emergency_state

 fs/ocfs2/buffer_head_io.c |  4 ++--
 fs/ocfs2/file.c           | 23 ++++++++++++++++-------
 fs/ocfs2/inode.c          |  3 +--
 fs/ocfs2/move_extents.c   |  5 +++--
 fs/ocfs2/ocfs2.h          |  8 ++++++++
 fs/ocfs2/resize.c         |  8 +++++---
 fs/ocfs2/super.c          |  2 +-
 7 files changed, 36 insertions(+), 17 deletions(-)

-- 
2.43.0

