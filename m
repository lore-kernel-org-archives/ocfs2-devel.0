Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A38B26AD8
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614593; cv=none; b=H5Jqg8hgWvkdpCLXUCM6expmGkeos7P4KkbO5UxfGcFL4cxmyoZGWNaRSjRyk3zPH74XoSwGK6RZifkJ7lD2mwXjqqpBB+rsHyqzB6LwBs0RQnOYjZVg7X+ENy/E4s+mED4M9XiR4lAzHw+j69MY8/CsDrRooKFQsZ8XvavoFV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614593; c=relaxed/simple;
	bh=fUbrQ3otw3yrYc759IRrbvC0N+b5wXnAl0x6rPpIhvk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZtZywFtHkrmIOru4vLAa0RYrOOvVCpv57eNuP17FPDQT0OCFD2U7LqmeIHOdw0+YsSW+AZeQDv1Q1bHn6pA0RMWbmhGY9Qv0MYW6ag+PNkteKzWZbxPcmIgwT8f/JTCgcMkyQ+w7PQ7Xr862AAl7Gqw+povn7Izj8NhFb8JcfxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gRdDipd4; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gRdDipd4"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d68c6a4630so6527141fa.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711614590; x=1712219390; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TOn1coniwitboQaY+MH5jwPuFkGOxLYnRMtM0ldnLXs=;
        b=gRdDipd4rf25SxVH7awsf/xBG5BnSNRYXTargPxE18VN6Q/1sBn4FtJr9s7sGvnH/a
         YAMslSo+ImluKWxP0UHDv6wx1Ezq0Vgc5AykrC6HuPNoV0CE9p6MB82peQrbXjxec2+1
         FnypvTP9yGZgYZ4bV0UV/Wb4IQlnAABrjAhQKPe/hS3fMEh6YwRruRrkoAId2JWEoc66
         Oia5mAzbsDbTlwLKJwgBbAu/TRjVsK11KvTXbG/0h1jBzSgaqXar88M4V0u9sxhMYb96
         p4w198+AVZaDRqoc01tbpwfMCHIX6oyGkprF+L91uEgIfUZBfPb2fwcBQNWMe5B+II7Y
         dntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711614590; x=1712219390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOn1coniwitboQaY+MH5jwPuFkGOxLYnRMtM0ldnLXs=;
        b=NrZWrJRQIGr9MhDSH7EAw2XqhPHr7E7uLW4OlziZPMoqHwgj9Z8KV0oMyQ3Z4ISw3w
         SiudYtJegyBKJaZVl0C1qE5mKlfp9LjxaiCUF9vNnMuzZ2BCgw6jw04sckxp0WviPiqX
         hIk2wIjhwLqDP79CZvuZeSHltMu5qwbOUsAEI90c3pdeaxkKvm/vjyikjrJH5cxTtYBW
         4LUhQE75TBfK+1FA0lGY8aPUxVdRQrMZEiecKEY/ODtfBEPBP9CxXZBrf1mkb6oyho9F
         1Dd7Pa1jAaVkS108UldmcRI+Tw52GvlO0ycQmVB04vm5SDQbx2wiiK46J9RjCJ44sTbr
         T0EA==
X-Forwarded-Encrypted: i=1; AJvYcCXPRSdq6JzsCMDG8k/nyRtyZ8jyfZKqBgpibfKCNZz5oL8p5dYbOqOKgpK3LebpoTvXO4aa2Wyy7Lc5Vcv5TQpWzWDy7mt8piHrmPI=
X-Gm-Message-State: AOJu0Yy9GV4M6riuRZNeUVfsMEYHKbhSvqmLnBDa440S7/Q5mIwxKqwE
	n4FK7XVi2e0pjrdTKXdmFPmNcfhjVWmarz1ChgR64dd4KlP02WOiq2GdNMJAGCo=
X-Google-Smtp-Source: AGHT+IHQPmUDRv13TslSgk3AFwBHvoksVCpy5iHn9yYY6GRzsAj0YubCpylhiMbPEIKIguaNlqrUaQ==
X-Received: by 2002:a2e:9241:0:b0:2d6:c5c6:f5b1 with SMTP id v1-20020a2e9241000000b002d6c5c6f5b1mr1924144ljg.23.1711614589579;
        Thu, 28 Mar 2024 01:29:49 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b001e014627baasm955120plk.79.2024.03.28.01.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 01:29:48 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v5 0/4] improve write IO performance when fragmentation is high
Date: Thu, 28 Mar 2024 16:29:39 +0800
Message-Id: <20240328082943.20251-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The revision log is written in each patch, below 'Signed-off-by'.

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

 fs/ocfs2/dlm/dlmdomain.c   |  11 ++--
 fs/ocfs2/dlm/dlmrecovery.c |   4 ++
 fs/ocfs2/export.c          |  12 ++--
 fs/ocfs2/inode.c           |   2 +
 fs/ocfs2/localalloc.c      |  15 ++---
 fs/ocfs2/move_extents.c    |   2 +-
 fs/ocfs2/ocfs2_fs.h        |   3 +-
 fs/ocfs2/refcounttree.c    |   2 +-
 fs/ocfs2/resize.c          |   8 +++
 fs/ocfs2/suballoc.c        | 111 +++++++++++++++++++++++++++++++------
 fs/ocfs2/suballoc.h        |   6 +-
 11 files changed, 137 insertions(+), 39 deletions(-)

-- 
2.35.3

