Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A55E38F9C
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 01:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331469; cv=none; b=ly5mz0ZN2+aUmRGqZViHWqSgxV+4QbLRH4uhqpqIZJE82LXKadsGzlgJg8NDzKRCHETcT9llj92yfYCfoyc6lZfJ4M2vzsy86ThF7LrWNOFPkGfZ06RMAdH87MbjpUAwLNnJgCchcvc78vneGtIpBh05Lv8M/JGaLDK0GT7+fjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331469; c=relaxed/simple;
	bh=6uOO2c6HJrwvoCnbPOaIYnYESzn2oI4AxxCCGofjFAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pH5JGkhPV/JDSnOh6xfyWOQeDmOgSj/38toQ0BFu6W0lamPneGId2QDF6MQOqTP1ZV6YF9QO6bwN76yZ6Ul3awWOIC4TzAYHg2hhtsNtJmACgLDaDJ4rPpbsA0SYZ0n6c4gpTc/CIiyl7P0zykI+v1SNuyW/UQMu3dM6hnMoGWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZKc4RPZP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZKc4RPZP"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779e28ebefso5412595e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Dec 2025 17:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765331465; x=1765936265; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p9JWvH5K0pV03Rn5hCmHs5OiyWYm6zlJzjBCuutciN0=;
        b=ZKc4RPZPYVvR8Ad+Xs7KjwqM3EpQWBmrVQIWzvAmigFBmngb5Ixcf1GfNGSk9Ou6Cr
         +hFQp97HyXBr1L6t2HhwAZzQuaKF6epOk2dixaWf0bDrzYMacf/0jMO04Ua8CafalDjM
         7/EDEdPNNjMyYYtjRso1VFYlR8AywVUG0U44X4W0SaoYgHHDzIlm8PO68wmJNjJgB2PJ
         tl8/XZVLZQbzqjjQYAbzQg2fEjelnK2AlgT2TK8lkm24efaTpWRk6VR7VZ6H1Gg9xIev
         ffL8kXp4DQQZte+OJlx/K4B1N7DoLA8mWcl2N/oyJn6qxNZTpomkJpHebMGl32oE4gT9
         ZKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331465; x=1765936265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9JWvH5K0pV03Rn5hCmHs5OiyWYm6zlJzjBCuutciN0=;
        b=HRt+mEGEiOhxhx9QKPekF5NZei1SgfUyfGne9alhO8ngU+UUih0BJsBHZl+Qr0H7Sc
         bOwszYxfCx+/Tz5bde0fHCADUj2oLU5fVztXcCcDaPkhbhB4031bxah3YIH1pqMmCLFh
         H0IKVdvR00F5jLtUh5jwSRgyco6fmBECzufHnu7kuxQvAueOrUPCw+nOnXnsN4Cic7pK
         yjUZadp83se01b01ZNvnPQjsu7nay/bDrlrC4E1cHCPlIlLxqEeG2/7PC3bFIG1nGt4n
         MEGnRQTKNmH024Q/Dkz4i44tUSvwBSSNuhP8FmFYpHoInuwotZy8yncvQ45j5OxCwMSK
         xOvg==
X-Forwarded-Encrypted: i=1; AJvYcCUYivdYcXVR1/9Hw2sT/40pTcwztNQZjf0/ldxvY01ywAHvZhm1+T2sEDE0BGQo6uypTeJNZ93T+NRT2w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yze04b7hJ531yWBjVspPDqib18tEoPxHU6Kv4w1UCvaBx8axov2
	PXpuLxoat81XPtVFR6ilik0UqCwx4VIIpjSldp7AG14qS1dhMkvqScqaYwWRRlWaU4g=
X-Gm-Gg: ASbGnctD4RbTNp6HgGAgPCrPuHiN/aUWGaiGgSh5ACXdMO1T1akZccM4wY026LgLAQo
	81kmds7iQY52Ugpavhyawoi5TvnWyXX6wEtrJmj+IRQcbolvXH1W328/LVFoMk5PC9otfgu2K40
	tlhsnMJfdNF5MErrxFkToIi3crrVT2pg/3uf60d9QuCRjMkjXEoc7B1pgkBgYLCJCyptspVHr61
	iGpVJSSjoD5KKU6AaS86YWqS8gZK/O2Zwcy1e0Zb+B56s8rhvOh8NNW+ulmNCxNcWZoqEka9rkO
	+b4IsPMHj6W2bOtoc70dCbtotBkuGx2ihFWSGzjlKiKS7O52I0CUS7T9FoVrLdztqDWnek2teHs
	/cBwkm3HFWPmmbb9BX0IHsq/K6GPzajaZqkUBNL+EHcq20WaaQ4i/+MqFWRzh8g/zu9OZn4Flqv
	moQ+lCv27VtNQ2kcaJg3tgV4NYuiRDL51lqck=
X-Google-Smtp-Source: AGHT+IHR2utxLGAAdWRVngXH7j/+O9Uc46BiluisKeqZOUmbtdE0a6ESz7D+8AtSNGsK8pf+cSlN+g==
X-Received: by 2002:a05:600c:310c:b0:477:9c9e:ec7e with SMTP id 5b1f17b1804b1-47a8380c6a8mr4334015e9.6.1765331465446;
        Tue, 09 Dec 2025 17:51:05 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf748c6bcacsm15706689a12.0.2025.12.09.17.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:51:04 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ocfs2: fix reflink preserve cleanup issue
Date: Wed, 10 Dec 2025 09:50:47 +0800
Message-ID: <20251210015058.8327-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus and Andrew are busy, so I don't include them in the patch review phase.
This patch continues Linus's job to fix the remaining issue in the reflink
preserve path.

The patch passed the following tests.

from xfstests:

```
./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
-e generic/081 -e generic/266 -e generic/272 -e generic/281 \
-e generic/331 -e generic/338 -e generic/347 -e generic/361 \
-e generic/479 -e generic/480 -e generic/628 -e generic/629 \
-e generic/648 -e generic/650
```


from ocfs2-test:

```
single_run-WIP.sh -f 1 -k /usr/local/ocfs2-test/tmp/linux-2.6.39.tar.gz -l /usr/local/ocfs2-test/log -m /mnt/ocfs2 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster -t reflink

xattr-single-run.sh -o /home/ocfs2test/results/ -d /dev/vdb -b 1K -s pcmk -n hacluster -C 4K /mnt/ocfs2
```

special test:
(reflink command is from ocfs2-tools)

```
## this case will leave one entry after cleanup job
## create file
cp /usr/bin/basename /mnt/ocfs2/a0
## set OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS
setfacl -m u:ocfs2test:rwx /mnt/ocfs2/a0
## check, will output: "user:ocfs2test:rwx"
getfacl /mnt/ocfs2/a0
## set OCFS2_XATTR_INDEX_USER, don't trigger cleanup
setfattr -n user.comment -v "tst-xattr" /mnt/ocfs2/a0
## check, will output: "tst-xattr"
getfattr -n user.comment /mnt/ocfs2/a0
## set OCFS2_XATTR_INDEX_SECURITY
setfattr -n security.selinux -v "unconfined_u:object_r:user_home_t:s0" /mnt/ocfs2/a0
## reflink non-preserve
reflink /mnt/ocfs2/a0 /mnt/ocfs2/ra0
## reflink preserve
reflink -p /mnt/ocfs2/a0 /mnt/ocfs2/ra0-p
## check
getfacl /mnt/ocfs2/ra0  # "user:ocfs2test:rwx" non-exist
getfacl /mnt/ocfs2/ra0-p
getfattr -n user.comment /mnt/ocfs2/ra0 # "tst-xattr" exist
getfattr -n user.comment /mnt/ocfs2/ra0-p
getfattr -n security.selinux /mnt/ocfs2/ra0 # no security attr item
getfattr -n security.selinux /mnt/ocfs2/ra0-p


## this case will trigger cleaning up all array entries.
## create file. then set file with OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS and 
## OCFS2_XATTR_INDEX_SECURITY
cp /usr/bin/basename /mnt/ocfs2/b0
setfacl -m u:ocfs2test:rwx /mnt/ocfs2/b0
setfattr -n security.selinux -v "unconfined_u:object_r:user_home_t:s0" /mnt/ocfs2/b0
## reflink non-preserve
reflink /mnt/ocfs2/b0 /mnt/ocfs2/rb0
## reflink preserve
reflink -p /mnt/ocfs2/b0 /mnt/ocfs2/rb0-p
## check
getfacl /mnt/ocfs2/rb0 # "user:ocfs2test:rwx" non-exist
getfacl /mnt/ocfs2/rb0-p
getfattr -n security.selinux /mnt/ocfs2/rb0 # no security attr item
getfattr -n security.selinux /mnt/ocfs2/rb0-p
```


Heming Zhao (1):
  ocfs2: fix reflink preserve cleanup issue

 fs/ocfs2/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.43.0

