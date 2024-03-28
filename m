Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785997D081
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711630334; cv=none; b=aJwZmenUPNImzg9GAE0LzZ1DeTu8X8m6U+oQ2oyAEmcHpq+pcZVJVjc1iLmHWZJaCCE0oLUleGa6i9Pu+QsbGz8moFVOH4QlPqjRSp3q4eGL01mLw7+UtGigIXA6mFkG9Jn7zHMuuxwDopimS3EPZ8KWyXmAOJu3luDjlctrllk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711630334; c=relaxed/simple;
	bh=WMFwClR+bZRnpSewtfPvdVbQfcJtprto3G2sD/zyRqM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kQ/AbTXympBzTsR1ErUcyrmiCz+IdWpx1r+pCIseAv99Sf11vxswFTYZJHkR8dhboD/wlOrFUbZcmdhdR6sW/w+Wxtkwr2terREJoEXbTH6Tmy/sYHkH6yFZB6qCkCb/UoI/TbsK04qcQbjmoU7Ak+L1FP5PL+8hG+GXJsXpG+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BsIS+iRm; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BsIS+iRm"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d475b6609eso9671571fa.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711630329; x=1712235129; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nZBceF3qsOwEtkrarmEgJy6fSqTGiwqP65aIGUn2zbg=;
        b=BsIS+iRmbDoiFbE0a5YcFDqXCT+Ixs6RKljiyiidZLTxg6DWaLhfw3VAIOtEOX9GLk
         f63JZ1lQD0PAqHZsquTS6Cw+aq/9jD3FmgFy/91irTMEAcWtJ2Ji4dXzmb0x6ppJG0p6
         nnqHyECeYMoVYXcnPLUzeevg/aRe23YlE7jOVVoAocVN0+RZNF2CtE41gqo9QhoOrw0I
         tuTlKRFIm/0zev95nhpkQdAfqp1JcEKfjo7B9vI0HNPH/4nT1j/0hVAVYJuEkfR6qrRi
         vErkAFgOcZwzGaomfx57yrcBGdZPAk1U/3XLf0fZga4bhz07jlYJBJVJSOsp8RcbYFWK
         05kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711630329; x=1712235129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nZBceF3qsOwEtkrarmEgJy6fSqTGiwqP65aIGUn2zbg=;
        b=ojjvuj6Jz0/BkEBWcfwNQ2uDvF9RKEBrqvHInk8IvgVi+6PLGhcjZSS5IG/BR7m1uq
         IMVHy17xq6RAxm9eKuPBe/Qtvr3d/kqxnVlWU8MfQPI7zNbaLYv9prTJ7MdszKuMr1Ru
         QeLK40I8XmjrJQocF8JPygwROfTFaldnp3DRMh1uaDFiLV69Byjlj297oY7pJgQBHOLB
         GI+RSnhqnXZ/aaoILiyHP1zHyKfOgKtJNqALNNVNI25Pz6pQ1sOXspl29zJefcXau7nr
         Kit4KIJBMSMdQCaeEApgTzxWKRzcdTLubCDCq+Y9nLCnJz0Y8aK8r9Z4TqTZ/kyUlKJN
         SBVA==
X-Forwarded-Encrypted: i=1; AJvYcCVErxwrq+s/Ro0cbG64w9KzzntuD9cisPRBb0oA+apVqnUurqiBclxGRUNBxnEYjEQGP5f4i06sfPcc919pU1g2bDH5CMOdDWbxPyw=
X-Gm-Message-State: AOJu0YxvmWj4VrfL4HS2EQyvwkV4A5gEWec8G+Qk5pGVpn7UkzLD0Pns
	tFYkL9bcS0rbE9dFeNU3X1RUXfTJLHlxU0Jrni85BqHefPg0ghepiyajTT6FZng=
X-Google-Smtp-Source: AGHT+IG7EEjaXd6eSMFPYL9okeK1pwS9/2fs3P/+GIrGqRMPY+224y4WaJ6o68zU8gO829E/UV5uJA==
X-Received: by 2002:a2e:3309:0:b0:2d6:d7ff:5d40 with SMTP id d9-20020a2e3309000000b002d6d7ff5d40mr2037286ljc.38.1711630329481;
        Thu, 28 Mar 2024 05:52:09 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id mo4-20020a1709030a8400b001dd8d298693sm1485010plb.23.2024.03.28.05.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 05:52:08 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v6 0/4] improve write IO performance when fragmentation is high
Date: Thu, 28 Mar 2024 20:51:59 +0800
Message-Id: <20240328125203.20892-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The revision log is written in each patch, below 'Signed-off-by'.

## v6

only patch [4/4] contains code change. For details, see
patch [4/4] revision log.

patch 1-3 are unchanged, only add 'Reviewed-by: Joseph Qi <...>'

## v5

following Joseph's suggestion to use a new patch [4/4] for fixing
sparse warnings.

After this patch, there are 3 warnings left:

  ```
  1.
  fs/ocfs2/suballoc.c:2490:17: warning: context imbalance in  \
  'ocfs2_block_group_clear_bits' - different lock contexts for basic block
  
  2.
  fs/ocfs2/dlm/dlmthread.c:241:17: warning: context imbalance in \
  'dlm_purge_lockres' - unexpected unlock
  fs/ocfs2/dlm/dlmthread.c:286:9: warning: context imbalance in \
  'dlm_run_purge_list' - different lock contexts for basic block
  
  3.
  fs/ocfs2/dlm/dlmmaster.c: note: in included file:
  fs/ocfs2/dlm/dlmcommon.h:1119:9: warning: context imbalance in \
  'dlm_reset_mleres_owner' - unexpected unlock
  fs/ocfs2/dlm/dlmmaster.c:3337:9: warning: context imbalance in \
  'dlm_clean_master_list' - different lock contexts for basic block
  ```

## v4

split 3 patch files for easy reviewing:
- (1/3, existing) improve write IO performance when fragmentation is high
- (2/3, new) adjust enabling place for la-window
- (3/3, new) speed up chain-list searching

## v1 v2 v3

see patch 1 revision log.

--------------------------
Heming Zhao (4):
  ocfs2: improve write IO performance when fragmentation is high
  ocfs2: adjust enabling place for la window
  ocfs2: speed up chain-list searching
  ocfs2: fix sparse warnings

 fs/ocfs2/dlm/dlmdomain.c |  11 ++--
 fs/ocfs2/export.c        |  12 ++---
 fs/ocfs2/inode.c         |   2 +
 fs/ocfs2/localalloc.c    |  15 +++---
 fs/ocfs2/move_extents.c  |   2 +-
 fs/ocfs2/ocfs2_fs.h      |   3 +-
 fs/ocfs2/refcounttree.c  |   2 +-
 fs/ocfs2/resize.c        |   8 +++
 fs/ocfs2/suballoc.c      | 111 +++++++++++++++++++++++++++++++++------
 fs/ocfs2/suballoc.h      |   6 ++-
 10 files changed, 133 insertions(+), 39 deletions(-)

-- 
2.35.3

