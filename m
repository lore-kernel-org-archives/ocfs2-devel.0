Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF31C69D
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 01:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331854; cv=none; b=p0xUW4ZSv/dcnCMybzziZpzh4t3iQBsed+TlUOF8joWbg/eQrQBwiMMftdzeZgHKDUUA6ZUT+V1nYdYObD+8xxSzlLjK1ssTa+/jM61Hzd5u7ZHzv8vpwK0mdpxAv+AJMpSfFNErdREbr6GS5mcE0YV7COY7ri2aMvA539/dhio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331854; c=relaxed/simple;
	bh=EXMGCVAIoyAy/xxruOm9uvQBoxoRGp+GnKT8R/4C6tk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=piV4tmwjfVXVFtglhIh0gSv36zeSe/GbGuUdJMOj4Ev1NvEcZnBhW/Vs/GBo2xmxheNYODLEvYrA9rO66puujSTiA8dF/3BLJBAuS1PyjWP4k900aRcO4pP8y03fzZ4uP3XTk7/y7LSbS58ioBjVLvg1PPuLVomP6Q4QFurpfwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XRgQFXf4; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XRgQFXf4"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47928022b93so13950265e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Dec 2025 17:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765331851; x=1765936651; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t8ovbNgKg/lgTT9dyc+7/3rfj3rR7+zCrXiqUlR8nTg=;
        b=XRgQFXf4hN1IQpx6xX/Dc0yF8ziupGaYWOEsL4AvhdE8Th7uplNQIUpsYNnOMvvOGB
         t7TAAOdaue3DHISt8Kp1UalnzpP3mHr+B9BFdRNkpTMZk98aHIxVsUlHjorS1dG2EWAK
         RWIcoLJb+uR6wX1EdZ3lcE5Y/pjjJ4aB9wP33ugGPVjYeJzIg5b+Bu+exHP/pA0tCQni
         Nkx4CsCAzXee8phGjR0vaKiEXG6s5oZ2LkYWoXOnUlQUrms1jg7RxnPoFiUAWZL9mrph
         qP/kpikPMdxFOvzXR/uKRsxxP9rNStdvKoko4STXMMZxvKkP59GEMxp5bGNAGNb32LEr
         i6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331851; x=1765936651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8ovbNgKg/lgTT9dyc+7/3rfj3rR7+zCrXiqUlR8nTg=;
        b=wl6Ampeh2IomCYfj6IPNrjkLxw45ulZBYRuyTPMYafLTEK+3/PBE8Ye1hKJR74wK0Y
         IEB38GcvsqqC8x40sPdQQzuZ2qRgjUyY0+fZyXzyHo0geLWTCQu4lX86kFzr8kAi1XdV
         bqiS85seYsPG9gOfbKmZncktkX6rsvdyXi/pobdx93pe94r8Fuwu/1cgDG2xudcmlX4Z
         /6ZzTMEyByK2tUzJi04LOW4wQErU8EoT5ZgE9yx7tF+61wQF9kF6W0vpqPAfMTaFICAA
         cN1jkg3LjSExrE6LgC1WlPzuBDk7Jjc4AlOcu8Bq0+e2NSqjQYPzJA5zRonVqclpmAZf
         4frg==
X-Forwarded-Encrypted: i=1; AJvYcCUE9ILPpi40TIiaPS3JoWIeXf4J6+is4kmh5OnesDooqwULRuDv/xsQNUk1PC2NWRQ/2Mjhd2Q8YfzOTw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyO0k2dvIv30Qcmtg6MA4Otv6TVdRfc9KdAzUMfZngoepQTxjam
	FtgPXidJiMyXlgH62IUsIrSmCwmtk9IJxSlv8TT676eApnKUNjj6YOisgMn9U6WHrEb5SaPpW77
	zmxfT
X-Gm-Gg: ASbGncusJeWav2SPuCVTtnulSM9Fp+OquBKVbXYgCv0/DSrHQCR8TmO4IOjli7ly+QX
	Mt6yDWsylm3Xl72ssz+pJqa5ayz0kZ3G8/4pQj5/+y89jIa6rW+tj79s5xE6traF5ULf4IiWLk2
	pkWTlWTBM196KhXXBl2oiyyel/d2vyFRir+IcO3HzrMqB6OSNTAXpsjuV7k2E7xijyBX4m3xmYk
	jOKdJxgYHBbccLvANAlupZDjgPjReDAfoP5T5g5L0zvt0D3klHtq2iBjEMpjMdxr2QSIyRM3UbA
	4U0BTb+gL0kPfAcWveCgQVGLUQseShF/kL3GSTyOtRGFFWBicHAc6yT55cQTfZMnS9eUsYV5j7X
	ujmvmgaxNluJqnmryfAkBN3MFh915jiHs5cH4cWz8lW3WLQEOVqPzu7iaL/tTRx70G+xqoCz9W2
	t//GhILc1SuBDQsxyH8UEo89ji
X-Google-Smtp-Source: AGHT+IEF2RfiiTUMOopT5eCWNA5egYPzxrTQLXLc+5epK6vGnh+VtAMca4T8Bzpx55E1JMB1KJCY7Q==
X-Received: by 2002:a05:600c:46cf:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-47a837a8c9amr4047365e9.3.1765331851178;
        Tue, 09 Dec 2025 17:57:31 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae49ca1esm164755985ad.2.2025.12.09.17.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:57:30 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 0/1] ocfs2: fix reflink preserve cleanup issue
Date: Wed, 10 Dec 2025 09:57:23 +0800
Message-ID: <20251210015725.8409-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

why resend?
I pasted incorrect ocfs2-tools test cases.
(only modified the cover-letter; no code changes)
-----

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
single_run-WIP.sh -f 1 -k /usr/local/ocfs2-test/tmp/linux-2.6.39.tar.gz -l /usr/local/ocfs2-test/log -m /mnt/ocfs2 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster -t inline,xattr,reflink

discontig_runner.sh -f 1 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster /mnt/ocfs2
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

