Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC1030E0D5
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765525516; cv=none; b=IMM5ReI0wDNy+513BWrNfeAH/Ipv7V4eP74UtedYM2rhFlXRp1VUxtwbmPEFW2Lzc0Au/MXRD+IEt52iwLZabyBTSKs6LO8YI3HibPIUt+pTCo+phvxK/JYQ/olF62mrEZd2fXCQAskiNGEpQM2SugjkkcBiC5I/MACp9RIbmos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765525516; c=relaxed/simple;
	bh=relwAsxvKqMzMae+rLS2iayJDoROXdGHKJuaNx6neJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IDxsLUeacGEU/h7xNgLxw0xOgphq7YcX9xBJpV96i+DQ3cBBJ1ppsoXfFzhNGTad24sWf2HWFxaaxuJ8ym2vxQyBUXHyvXGTe/PDZX6yh01IQUXw02y8zBPFxix2+YTsXyXOrbMQ2j6Z8ponORMHYMLsxlv6VqMjL++uK7Sxa4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DmaxknK7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DmaxknK7"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47798089d30so930645e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765525512; x=1766130312; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MAvfPr/gcfnx0HGhdEEHCkXUO1xEmlg/1itZRpTpSfo=;
        b=DmaxknK7PmjDBKp+QrBYfgGDpnzlY6rotjlyQbSpHq/2oBksoXml1fpkrMh1WjPj/3
         brD3DRDkQh8XMcyXGEelYk4oYUePmD32bbyENex0jT8vKO0+5KiQZ5Ees5YOdcb18ste
         TkqGiMPrN+wc2HkkzkSdpL7Q4FjtwXV/B8OCL/36P4Eiah7aBH4rgD0zSyad+k4C4fPu
         sEczDbCQUtHiICcgEtBc+tqv3Jlau0vfXf1tKG8asOiUoZHWNV8at8oTAZzNQ0GODCGf
         bsVPn0TR8e9su92gC8aNDvI/eUeWm7ZdHpDN9m0dLFyF30BS9JNmVoRea+w+6CIUPtiR
         5YvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765525512; x=1766130312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAvfPr/gcfnx0HGhdEEHCkXUO1xEmlg/1itZRpTpSfo=;
        b=VvWK0PRBMh1v+4F/zgBb8Jd2NKknpnlzZpO1A0OfYZnTjbByFgoTU15FLalmOGZjC9
         JsSHN1kYub400dvfSYaV1JRr0Is8vJcsFfH6XJr5abT0+FOqJcUgSotJI1wBhtK4IQqY
         veo60YVEVXuvbp/9i7HudEPWM1QH4QmtlvL1JJz19poI6JlKk9vcrt1XI2Gmysk0E9JI
         TFSD6ySPXPEl0Ea6xB2/1Gs9EC8UjSbtryJ4J4wRZ8VQZWbjiUzQbXd9Apn6yy5JEdiI
         /dmVGZpFeVWFAWfBcSNjwhsLkqb1iJ31kvxlYHq4ZaguaFcE/+llZ0fg6EcXDlTDapLU
         9D5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRFmMTntG7v1L8CNFDbOMZgeJ3WIwRmhurVckHtXJ4Qa3UaxSe1/Ye5zyF+k5USzTuI10eaPgaqZIPTQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzvFaDsogZfb82Xjaufh74U+qjoGcAJg2Uy2bo9b43q3DmglC4R
	3kxUlXciwTHvUD8xc0Z3m8ENqjl6xLo3WUMHJAAAqBk5Y7Daq8+aGT1A1mCFd4MR0A0=
X-Gm-Gg: AY/fxX73nx/FO4Rf7cM1Wp8aIJhCzpUrN2p+/2EmXGKFs6OfAlQ9Rn5jZEgLy95lP2i
	L9TCRL1HAq2xz3WHAnzEtn6juGdwTyvZ8CtTdF9fceZXp7GV+WpZNKb2e0AGMLVDb8QiTur1/rR
	NboAxcVx4aSA81ht5WOQWUZum53zt3jc/dnaU9t3uS5G1MSoM72B1LkP8TLldEwIIhmWsx4IMiI
	Nn9Ez4e/B23F4Ha2N/j5LJpjW6vr7E1+/Lij5sbmiHUjIZxsb/epdoPMdWr8OH4EOw955C1xvWy
	Ew8yEA85VWm8hbmwsbECqspkg5vYzm4hI1A4m8vQl+iXrjsCVhJsGyCQGDTn6ZAX959BE7YC1QV
	Qn4W6YjT7GfZJJaX6Jv2TG9CebFb348AcSoqCcn//W3i5Ql7OrqIoFLpcp/dBxBCrBKUS8cnDoo
	+pZVFCqiHWjwU=
X-Google-Smtp-Source: AGHT+IHuUkJQVa4prqOR27KUXfJMRmRAdmduVEN310DwGwZtVb4gsr4UtwlTcRoZt3I4F6+r7INw2A==
X-Received: by 2002:a05:600c:1c8f:b0:477:7b16:5f97 with SMTP id 5b1f17b1804b1-47a8f708f26mr7275135e9.0.1765525511588;
        Thu, 11 Dec 2025 23:45:11 -0800 (PST)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38adcsm45916975ad.30.2025.12.11.23.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 23:45:10 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v6 0/2] ocfs2: give ocfs2 the ability to reclaim suballocator free bg
Date: Fri, 12 Dec 2025 15:45:02 +0800
Message-ID: <20251212074505.25962-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v6:

patch [2/2]:
- based on Joseph's review comments, restored code indent & removed useless parentheses.

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
 fs/ocfs2/suballoc.c | 334 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 320 insertions(+), 20 deletions(-)

-- 
2.43.0

