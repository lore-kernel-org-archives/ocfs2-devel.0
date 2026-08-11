Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D29207A32
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 02:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786416232; cv=none; b=W7uR7d7CvJNi1RWG4QN0L68jyvP0JOF5V+JI/0xaEsYSMKikjEM21/O1dF/RNDlr1Eha6AMdIWNJ0S8QC6wmD1JK4VbYfvofMLe/GcG05xly7TwH6TwQlVFB7zKKDIJ613OBGivfvu1w1nYl0d2fl/ERdiw7uEhagY9V/AY//hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786416232; c=relaxed/simple;
	bh=I45dsT3xuoqipUSXlfx1FRXTh6Ib+OSWP+YuDS349FE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gyjQIhTH/3/FdI009oXsEv+i04NBOiWSZ3rb1b+4l53w4zRUe7sU2IYQFpep6kIYQNJQFWM6yweSmD8nDSsXEF5X8/Ht9B1Z3Rf22tdPWUrTOYLaXSd8S9PjFQYirVv83o95OjjyhhqCK9imsEMjLjGMmxFcpI6r/KpVgVamaao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mnkd67Kv; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnkd67Kv"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cace91f112so29336375ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Aug 2026 19:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786416227; x=1787021027; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ZvDsNGj0dOoEDAiBEEB1HZ1EThQVnZv7Q9QNTdwMqc=;
        b=mnkd67KvhjqiQhQPcCb8wwnIHglEYUV8n9sPZufuYZQ2PRwFhzHz0sQR8/+UExpmkI
         bcqKkpmueJwGrbYSqyYGlUS98dlDGodz8JmwDjgWD9tbO3ntatLENELEvvdAee+pTU9I
         Tx8zgQRhYS4qi1wDJ6gWN3XXGaDybIYgWY6pHy7U3EVo8+IxBgi4g+1J9kpYcpHg18tl
         FO39HQ909XFgECG6m5yTPYJ8OjERm/OZMV57n+wITpTMv4UlHHZifJcumF9p9xxApiIL
         DWim+9mdQxXbuf4ZAFUapjFGmqbegAkxIVSV9qrJ/WVP/67IvEMFe3SL0u3siswkFmBn
         UkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786416227; x=1787021027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ZvDsNGj0dOoEDAiBEEB1HZ1EThQVnZv7Q9QNTdwMqc=;
        b=StLkv3XoyzoByoPEGQZLCNEbLssf5DyI0U1e/Vsr3ja8EAsXjO5ztFMMXgAz9Fv4Oy
         u60WV31sk1eJ5KGmqlMLu5geixSz26cilRdXUEF7lI/Y1ZLPTcRKY53kbQCUtWSlRqOu
         ZOoAA0cOZPcHqOfw+v31RhHXDbSR0pB05SFUTN+xo+rsA6wucyk1NqY+tTkXuCLl7GlV
         yvLm8Y5kVcjVVGH11nD171uTMVQfdNXSfShT2tWeEXWjSg8IFWSTtMDqWcZVFMb7j0Qk
         LmUmf8QH3UVeJo6tu7wRlGBIN5hUjZdtNwUWqSTTPJDbJDrdTj+3ueqoXecBgaURCE4i
         S2jg==
X-Forwarded-Encrypted: i=1; AHgh+Rq4OCIEckc6MlVkHrWYj+JxnTLPBj3L/ZukORal1XX+9LH1MwnVWA2mH48G7wwhmRbCHgDdWsAmzfFGeQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/24Y5r5ay8QnaihdIWvn0pZhlOfyswwx3Efr0nhiLj2tDUIfY
	ZLDJIPUlVMPrb41a9kCtPJadzPlwclxMVNzGe+v7iTu70KiJUcraZCkc
X-Gm-Gg: AR+sD12Ijs01IyA8QHEWat7mvSzY0MmOwULQflvMqDLNr+yvB+0RTwoiOm5tiu9R7dX
	2Q9ZFh3ps+TPz5UlPD/O+cAov8IFomT1VAUjrmFYYQSZqrFqZ/2jXJA1tR/AAlYCLKC4BO0TVhq
	ihMl3nCoxdBotxhB+WgvNP+H6xTZuGmOpcCPVnHlMFeq2oWTkwNmUcCaFvd7YLnFzCwoJKHwgM6
	MhD/jMZ9Fd2xIxrEnwIf0aK+XfucpcMt/bhFqrhQluVW8eTtRecqf3SUaM4usWrjJGeSeNE9tqr
	9EYi8qkn9TaZjCGbuSFk4jsBXOYj7/IlLaFG2pfF+dLROt6ww1SI/HS8sYtRetlbgqdwqIxpWQL
	6AsT59iigNFm6XED1ig2JXaYxmKDKcUs7El2H3E0wMVdZQgn2qsIU39LhETL4bCF4yj4mCsTGfX
	F0kxezrrVMTELU/BWW92a9t9UjX8bEbt1jE/si7Np5Mq7SNPoT897rxNbTvAljMqcdCQz7fS96
X-Received: by 2002:a17:902:ea0b:b0:2c9:aae1:a611 with SMTP id d9443c01a7336-2d31798092bmr2076975ad.23.1786416226610;
        Mon, 10 Aug 2026 19:43:46 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3160f47easm464165ad.64.2026.08.10.19.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:43:46 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH v2 0/2] ocfs2: bound-check both readdir re-validation scans
Date: Tue, 11 Aug 2026 10:43:35 +0800
Message-ID: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Andrew, patch 1 replaces
  ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch
in mm-nonmm-unstable.  Patch 2 is new.

Both are against that tree rather than mainline, because the patch queued
ahead of them rewrote the ctx->pos line that is now in patch 1's trailing
context.

v1 only bounded the position before de is dereferenced.  Joseph pointed out
that the walk has to stay inside the block as well, which is the second
guard ocfs2_check_dir_entry() applies for the emit loop; patch 1 adds it.
Checking whether anything else re-scans the same way turned up
ocfs2_dir_foreach_blk_id(), which walks the inline data area and is missing
both guards -- that is patch 2, which Joseph has not seen yet.

Neither patch carries Fixes: or Cc: stable, matching the trailers kept for
v1; please add them if you would rather they were there.

Link to v1: https://lore.kernel.org/all/20260806122133.956847-1-zhanxusheng@xiaomi.com/

Zhan Xusheng (2):
  ocfs2: bound-check dir entries in the readdir re-validation scan
  ocfs2: bound-check dir entries in the inline-data re-validation scan

 fs/ocfs2/dir.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.43.0

