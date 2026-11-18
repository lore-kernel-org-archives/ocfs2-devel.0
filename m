Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961260;
	b=cVT4Vzwrvg0nJGUOi/Hp0ltDAkYsJmYJ66u5zN4zwNE/7choUgHGLt8CAow9q32LUgxc
	 fEvCQFX/h2uhfp7Ud2F98G8c1hsuGwi59RcS1rxH2uCP85e3mgZq4rTRvsLULIUKqoh65
	 8ddMG0sgIIJoW+5+JAELueyOwvDoAT5t0O6+6mYqhNUm2WoshQHn2SCsxwUPEB6WVRARc
	 ryoKhpLeYRuEcYPwsnZ35Cx2Zdfnv4zjg4ff3RBV9xD+tLGCZ+mjn5Gg2+ivFoUNrMgsR
	 3VaUQZXdjtagNzLg16KUNe6MJ2n3XZ/d1wEr9dheFTp4swKX+87RQwpCvjoCnsEbGgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961260;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p48I65HeS0LE6+JEAKuMNs7lMy0Bmt0jolYFmJ5Afoc=;
	b=D6Ottuq0jNE67elChdsgQPxTbZ+6KmV5l33fBpud9A6KZxYdYXaVgrLvNTSp+d+72Yit
	 gqIi5CB9+mPzF2/U9sTP5x7VLnK6cV7p8jJd0B/YrethvIMm+AN06ZwgZ4DoLM7odPnye
	 est3b2xqcnPHJuo+wBhvKEk+EeSC2jKfRq1JQUVV0ULgzqv49b7YPyIVs1M6S6T1E4I0W
	 mf3qcPdiVbNZyfbgbRYps7Ic8C7zZnVxwRVaGsRKJxwNiox5BYmtgl0nACZSAFTXCUb6e
	 o2da0CiRSNwdEvpBFUxK/B9ONrBCkZbsgnqJuPC4M855ipXRc0UmL5oubKMEHM7yZww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CGgZiMpV;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B9A606A31C
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Nov 2026 00:21:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31B9A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CGgZiMpV
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4a3dd785f65so45034f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 16:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794961258; x=1795566058; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p48I65HeS0LE6+JEAKuMNs7lMy0Bmt0jolYFmJ5Afoc=;
        b=CGgZiMpVEKnWgWcXgIrD4MmIPaoMopiDLIY4M85bLhPss4mijJVwZorHMeUgeGqCL6
         HBRtuxtlwetXLnDFS580uIC5IPMO/En6qwnXGi4SN8jg7ckf2tU6UzUXTgTkTIW+zqvo
         S6DaQ4XPHxCgvtBX4BIoXESZIpmIKvPgwnjxW1ZovxAfikPZmPbxkkVgnZ02jbZkf+i8
         IWOj3NTK1av6NMQPXSLOd+iJFTn7xPDlg3NSTNFPc23BPiGL+VBxzRDhrbT38HE7iBfD
         iJPRpvL3xYUe2YqP69Wex1ZDG6bODuKnOeZRz/uThTfMnopU1VkLigTR6CSq2N9aR6KH
         bEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961258; x=1795566058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p48I65HeS0LE6+JEAKuMNs7lMy0Bmt0jolYFmJ5Afoc=;
        b=u5r7+ex4yw1tvu/OPQg6YE3mnhrHzfUoon/K1VFyzjQunWoEYJpP/1wZ/miygMxyiE
         Jq0SNscBPbiKvD3qdkUSXW2B0TXbqK35sfzZ86tBNYXOqBWVFtysBgZlll6Bs2ckfSvM
         6/eyTb8gO5vst+7XX/GKzl1azt5UJPsZbx8Ro8btACgRhaP0sSrTYaNJN6CwZDixfSaD
         R7cHPZQdsaCMM86QxMO348uGwkAqKR1RwBKT0CIETipkjQN4QP6Nf+mGl8OouUBE/yOG
         c4d+hZfUUvBSznCYprT4IZPTE8HsEGfceLW9LVM0TA8xE0/hNXaboXCd3/iMizbDZc/d
         xnsA==
X-Forwarded-Encrypted: i=1; AL+hErE0oaVkEbd2lCnaEX64hj54ujGsyjOE7QVPTQv4cUUWL5JhtWTQHXHufwQqzHD2Pg2N6Qi/vDjUMrjEaA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/s49j/5tNTnpsoTSuDvt5Vj9MPBk6jduxyPMzlnmY7SjHykkFV
	Y781XyFQLn8l+FKuLZyGQb/2fHtAcAE6kjuWsWxvOcKjplcRDizQamm2D3+mRzPfg80=
X-Gm-Gg: AYBFou3dATc1glsSZ6Nww2sXFAJrbz9kqZGsnv3CTAZitoKXvckjJkd6sHzcJpyerDj
	uekRCWXQdZwfNH2jMo5Baopgh6bTRkCjjq4svV/2IMblY9A/ysUsrPIaTk2JCUe9C2v0tiQ2gfr
	mFwdXBlzvvj5L/0h3MIs0jye/VRlP5HhzghEKiGyomJMBGzlS4L8QILxfNAa2j874ZksTeKS7H+
	A0xUxonM3pLcAdHMZcK2TfI8YMwkNB5LoxMEUxzgCaIgpusdHDor98rHaIgLR8vkOTpePiykA7U
	95hM9+iYqZoNYaO4jZq0KN/OxGBNkcYFBbo5q3G2bSlOnsEt5VxYgdpKsVKHGpdcAGCj99pfzbw
	i9l2cKV4anmcdBhapTn+7W4djm9XQknjUm9Zz+y2YATIh8u3R1ucuVrK5wZws5W2/+DZbtwIwj5
	rAIxOebYzWLZy05R7g1qHqVJ+SLOLG9MkSD48FshoQe5AF/R2qBtZtHcC8+pwnfFRsRggs7fp0C
	BWaP9IVm+zOiefBh3NVByQB993SyHn7Pqol42IIP+R+22M5LWRirKCZ9DU6/SeanyPYfl+BMIfc
	d+shpzRAO3oXupZWGou2hDwk+cF+xSOQkVXdpCXrGVI=
X-Received: by 2002:a05:600c:2e0b:b0:4bb:6a02:d42e with SMTP id 5b1f17b1804b1-4bb7da033b8mr9285215e9.1.1794961258575;
        Tue, 17 Nov 2026 16:20:58 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447da7e0sm2373481c88.9.2026.11.17.16.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:20:57 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RESEND RFC PATCH v7 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Wed, 18 Nov 2026 08:20:46 +0800
Message-ID: <20261118002050.9019-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode. And the code base is commit aebb72744764 (v7.4-rc3),
and also merge Joseph's code and ideas from [1]:

V7 changelog:

Address sashiko's review comments. Main changes:

1. Adopt the latest iomap API and remove the iomap_ops structure.
2. Add a retry mechanism in ocfs2_dio_wr_map_blocks() to fix a data loss
   bug. Multiple concurrent writes are serialized by i_rwsem at submission
   time but completed asynchronously by ocfs2_dio_end_io(). When the
   unwritten extent conversion fails and finishes first, other threads'
   submissions would lose data but still return success.
3. Fix DIO alignment issues.
4. Fix several edge-case handling problems in the DIO write path.

Resend this patch set based on sashiko latest review comments:
- ref: https://sashiko.dev/#/patchset/20261117150053.18417-1-heming.zhao%40suse.com
- build issues with the latest iomap API
- comments contain some stale symbol names 
- patch [2/3]: change the check of "map->pblk < past_eof" to
  "map->lblk < past_eof" in ocfs2_map_blocks()
- patch [3/3]: remove the dead w_unwritten_count field in
  "struct ocfs2_write_ctxt"
- revise some commit log mistakes and a typo.

[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29

[2]:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com

v1 patch set:
https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
v2 patch set:
https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
v3 patch set:
https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/
v3 sashiko review:
https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com
v4 patch set:
https://lore.kernel.org/ocfs2-devel/20261103135605.22943-1-heming.zhao@suse.com/
v4 sashiko review:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com
v5 patch set:
https://lore.kernel.org/ocfs2-devel/20261105071930.16399-1-heming.zhao@suse.com/
v5 sashiko review:
https://sashiko.dev/#/patchset/20261105071930.16399-1-heming.zhao%40suse.com
v6 patch set:
https://lore.kernel.org/ocfs2-devel/20261115154013.9379-1-heming.zhao@suse.com/
v6 sashiko review:
https://sashiko.dev/#/patchset/20261115154013.9379-1-heming.zhao%40suse.com

--------------
# test report

This patch set has been tested on 7.4-rc3 kernel with the following test cases.

The current code still needs some polishing. I hope sashiko can continue to
find issues in v7, so I've only done a few basic tests so far.


## ltp

runltp -f dio -d /mnt/ocfs2/

results: passed

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/075 generic/091 generic/094 generic/112
generic/177 generic/211 generic/225 generic/263 generic/319 generic/321 generic/322
generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/498 generic/510 generic/512 generic/513 generic/534
generic/537 generic/552 generic/557 generic/563 generic/564 generic/578 generic/588
generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/771
generic/777 generic/779 generic/784 ocfs2/001
Failed 45 of 632 tests


-----------------------
Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig |    2 +-
 fs/ocfs2/aops.c  | 1626 ++++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/aops.h  |   42 +-
 fs/ocfs2/file.c  |  248 ++++++-
 fs/ocfs2/inode.h |    6 +
 fs/ocfs2/mmap.c  |    2 +-
 fs/ocfs2/ocfs2.h |   25 +-
 fs/ocfs2/super.c |    1 +
 8 files changed, 1533 insertions(+), 419 deletions(-)

-- 
2.55.0

