Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62C324A05D
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765522830; cv=none; b=ZP1rKikHdyF1rCqaFv7bA7FErFzpiWJN/5/TQpATqun4Gz6+zEmIcrQSs9wSWNOnE9VMcOW4ljs+vRm/6HjDWIqbcL5N/lMZ0xBfS3cMSfd8P903qPJogRbvMTAI1vxwB3v/MwDT/IRnR+52Uzuu9T1CYbIQlqE3JVt7O3YpyAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765522830; c=relaxed/simple;
	bh=FPoRP5+Kqajxr7UkHu/cAUiYgElz/qB4wGgPpEUJDwk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ClQLjvYnwA/g2dUOwItSbYyLUi4nUlThfOnKagZUDPZbubwf4Pv70/HooCZqEKEyVaHC7JSwBpQZL0aGvQN1v+aHormo50P3x9b//WajVejV5LPGMFeDGYAneZ0fcKAIEYBaZ5VC1lpEx/h+HoQOKzandXlVsFIcVqUJi5wefjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W8PWfhOp; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W8PWfhOp"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-429c844066fso95154f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765522825; x=1766127625; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=THbScTGkSGIU2XjOzF/TQwQpqqOWclLks3BaUo4NhFM=;
        b=W8PWfhOpo4Hv0xcx3lGm2QilnU7Ag6Cq6rTlQqYvARtWU1pvQYFrDUKhF2X3WmSlOQ
         S9puELgwIDf+fXJV9ifWLj6U94fJIN6Qhd7K6ENUaTBMhNxPaPz0BiS1ipQOd5+muqxn
         XtxJCNgr/7bWI78UzSHt6r1AsC0BczZX0t6fWPqVaf8VLFZanBorD5OXON1bZPJdqFVp
         l5+Dr53pxaglyF10iUpblWSPaRe+0tZllK5OP/cnVd5eN2ehubtPIbIhwsCdPEQ7XlYS
         4HrGo5K11WNXKSSaAHdQ2bjahRZrRqLASpd4QkdLn0cvOiqzAUUUVB31sMOgHfGFE664
         r9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765522825; x=1766127625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THbScTGkSGIU2XjOzF/TQwQpqqOWclLks3BaUo4NhFM=;
        b=foYtvw/baBVdUNjhHPEzcl0IdEYUrvJ5KyVvX6ZOS0LMKyFi5O5vT1GDMQm4tHMMTb
         NDVWaBg/PqxA/HwVswJcYwJGUCpVkpdF004JjPph3/XmRXUzx0pzv1ujOBCRVMieYocU
         Ky+fUqpPN++iBNlEHQ3JFF3IMbLGtGeTiq0eaHerE3KUZ1ZoRwLwqHyXHNQWuC7/Hg3v
         OtXYVDgEsCTAPpcZSRlBC/kfpBd06fM7XQMPP3tA/yl55D/OQVOxDbz8+dFPHL2MIA9e
         R/MxtrxuDtV4lsqojeY8pUvRjAAkiOWZnosg72uugO4FbwusN18S8ehfGr8WlzajQWUo
         WK0g==
X-Forwarded-Encrypted: i=1; AJvYcCU1ffPxzPB6VKb17EoeKU1d+I5zqFlAX2oH6MaXd9zUyC8c9qI4EPdR0FTIU02sXa7QC5q4W1H6fYzC3Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YytyIUyo7gOI3+QBDu/VzmgY1ZZWP7sgSFocDcn8FHKd4/toQWM
	SM1Rb4Li9rMiIdpk63ExPxOK5/YSm4TErRKm16OrFqUiaKcRBzS/EtY0HUCcYArwDss=
X-Gm-Gg: AY/fxX5OoZImjsEO+cOx7qd18hbG9yWa+h7K/sitrVRvnPt7OetdTGxzXEc5/HI8cqx
	yBETvVFKrUBdQpM/LUVwMh9cf+HraGmJ6ScFGeYsV1hmJRzK8EoU5w2430GhOrI+aRrqwCO9KLk
	reGWjnuyRlwYVvT4kQNZU38Qp18zQM8D61ofJOKHkb9n/99pzv2OlA2kmb3ecL55ncazKS40uym
	VLS3Gl5ADes3VRX+2BLOVqUF3PSPy3W78HQfriWhWGbPUU9xJ2qj+YXljQiCC2L+nZZL5Ii1GGc
	nqk6LtUc0NbMgtPPtvYbxDhMmXyASHbVOLVmJwk/jpNf54sK2xlZaY8sej0XYlZQ6igNBtGMdVb
	HSJ+zTm/MPUFFeHFKqeeluOHO4xyplBSTeYHBH4hTh/qbRCt3eXBNPJE5fJjz1LaV4a0l80ljpR
	pr7Whal0F4nlY=
X-Google-Smtp-Source: AGHT+IEjlf3RnWS6dhTn9grSi3FP+gvwhfqqGr8XQrgWLn6+PtT3lk/HHHRUIfW0VLOZ1K+XtLmQ3A==
X-Received: by 2002:a05:600c:5303:b0:46f:ab96:58e9 with SMTP id 5b1f17b1804b1-47a8f708658mr5198185e9.0.1765522825087;
        Thu, 11 Dec 2025 23:00:25 -0800 (PST)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38c74sm44479145ad.31.2025.12.11.23.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 23:00:24 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v5 0/2] ocfs2: give ocfs2 the ability to reclaim suballocator free bg
Date: Fri, 12 Dec 2025 15:00:12 +0800
Message-ID: <20251212070016.24235-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5:

patch [2/2]: change -EINVAL to -ESTALE and adjust the callers error handling.

pass xfstest case: ./check -T -b -s ocfs2 generic/426

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

Run test caese:

xfstest: ./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
-e generic/081 -e generic/266 -e generic/272 -e generic/281 \
-e generic/331 -e generic/338 -e generic/347 -e generic/361 \
-e generic/479 -e generic/480 -e generic/628 -e generic/629 \
-e generic/648 -e generic/650

with/without the patch set, *Failures* are same:
generic/003 generic/007 generic/228 generic/322 generic/329 generic/376
generic/383 generic/384 generic/385 generic/386 generic/420 generic/424
generic/448 generic/449 generic/510 generic/513 generic/537 generic/552
generic/563 generic/578 generic/594 generic/607 generic/620 generic/630
generic/741 generic/755

For the ocfs2-test, it seems that open-mpi4 does not work correctly in my test
environment (OpenSUSE TumbleWeed). Therefore, I only ran the tests in single-node
mode. The results were the same between the patched code and the unpatched code.

ocfs2-test cases:
```
$ single_run-WIP.sh -f 1 -k /usr/local/ocfs2-test/tmp/linux-2.6.39.tar.gz -l \
/usr/local/ocfs2-test/log -m /mnt/ocfs2 -d /dev/vde -b 4096 -c 32768 -s pcmk \
-n hacluster -t create_and_open,directaio,fillverifyholes,renamewriterace,\
aiostress,filesizelimits,mmaptruncate,buildkernel,splice,sendfile,reserve_space,\
mmap,inline,xattr,reflink,mkfs,tunefs,backup_super

$ discontig_runner.sh -f 1 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster /mnt/ocfs2
```

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
  ocfs2: give ocfs2 the ability to reclaim suballocator free bg
  ocfs2: detect released suballocator BG for fh_to_[dentry|parent]

 fs/ocfs2/export.c   |   6 +-
 fs/ocfs2/suballoc.c | 336 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 321 insertions(+), 21 deletions(-)

-- 
2.43.0

