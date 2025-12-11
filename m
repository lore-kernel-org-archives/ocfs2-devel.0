Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CDD33E7
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 11:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453964; cv=none; b=cIUOLVaLfuB0/KjLbyMcTWfDFZ6YaZPw5zByYQrXCgxgZ7BB7X1ji4VUU/OPGhj1Gg5I0paqeA1A0ceND88jqx85F8chX7okjlXKmrhYHJL13Y4vZ/miDJAIiYYbKZrZDv+bgUSQSpoe07mwozb3cd+xTgBq60yhy105ujTik9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453964; c=relaxed/simple;
	bh=IHcdPwDYaOP9mnRlaK2tBNRlVnQPrGDe6fxMGkmdV8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uTpJ6HQmdHWMahElLOwPV73ektwaF82dXaB76ZpXZ4z/AH3D3+VeFHruhefaln1mEWkZLaFj9JZq7C35uy1SJ72k5csUmHo9QNAKF+5uM//c6Lp6y2CuCyFOYfBvF19DO0xf7Pcplq6LZp3oXWO+9181i/ud65aPxo6/v7z3I48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCGMooPV; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCGMooPV"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-343dfb673a8so906556a91.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 03:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765453961; x=1766058761; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=psXlLAerr36Cu3nb3TCz/ORHSimLjF4H60tNxXRDbEY=;
        b=WCGMooPVzPmZAKZZz2Gdasppiu9/hAiBU+VA43NRGOkGqQV7cKyage197pqQRqDGe+
         UfYLpIYkvAZrSJBQSOK5q4/j5eA/mV+l6PWJ5yVBnwqps7Uw6sjeY5jsaBYZJlr2+Uk+
         5nY36jV90lsU4kC1AV09cTiy0RoDURwZBZ/8yDzD5wCWtcAg4qnriy1cKGDQt+2IiLHt
         MtVYf7c34UMGq0ue6vS4LILcwJzJZjHVfDl1lKFfouR2LslfZoS0xCirQn0d39uelXdO
         t9f79IB8mUR8ttiY/GHpJljdeC1kggTFXf+K+K0YdDjyRKA0ofd/SYXTMguKlhKJzvbT
         jdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453961; x=1766058761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psXlLAerr36Cu3nb3TCz/ORHSimLjF4H60tNxXRDbEY=;
        b=ULG1nFsVpeZPvJHrVzhnPMT6ZF0226w4JcBhztupy3X3y0r6VQuKTiCOI+lztgj5Ba
         vN+ajd1AQhJTxSPiSqjyN0OY3iJZTNAwIU82mv/h11YguSoV5tCe5sWSBPSp0r1njby9
         O3u9PedSUinwBMuruIuiYPxtt3IMC9xf1lUxTxWeeWCVfAMCN2jWe1nKk3Cm03SzfZZb
         M/NygoA7emJ9vpvkatlS8HD8V/MwvG9yfafoicZkC9RRITLsYLTjJpxog/9pioCNvi0O
         9ttV5CsmP/btbZj4XEFJG/MmaqEbyznFUw906y1qguZolW8+3UhumC1GQu/qF6cbrF9k
         gyxA==
X-Gm-Message-State: AOJu0YywH+h2Gc8OlI+6jyLA0yKL1S9I6E5rtQyH8/awf/+froSJbQ4R
	yZ1St2hjlQQ1sH5f+UybyZhoJLUk/SlxPk/e0k6jyTc8YLzp7xHuuYIp
X-Gm-Gg: AY/fxX48GkjN0pBonZbN/Ey/2nmE5i0J6XDNC0Qc+BL16Vw+plcWFUMyDgNj7Q1nEqF
	f2Dh2N1j4jnkTgvrzwF8b+9WE3bp593auWTqx/ZtlmGwKqHzSqUudNmOd401JB8Dlb7fb0SABp4
	qMhjjJqB5CUXX9lnkVlka/HXoUCCDHWhOKd80KTlSXgAXjgkrL42hXb45SmRb83KVD84J35DLzv
	XGvRx20n5JGxYEJit5+raeRiCMGtUVT2yf7SZ+9+4YCl+TbUtOfyTU0Rvj8JawCZF2/JiiTkTWx
	g84cCS+uHOXxc6iAPbCPiS6iXJSBCvOBRYGPw02Qr9YKGaIT+w4HOAlmVkoj9vabNM8UQn6iJYB
	Vg1jVkajE2Iz1iLJbwFPOA80sDjsx/Ro6bgE+xgxubmMv/+NEtoGOiqpe67mXL7XV7LMcNduKAy
	duwN24DXLCEsAD++OGqIZjTSRCWzUoqGB971d684cZu3DQTTYsMVIGSRA5RIceC6dQkLsgRzSRi
	NFQ
X-Google-Smtp-Source: AGHT+IG6APBLZxbb/LYrdmx22uddAVJjZ+LzQjdEPj+olmhhgmQHKYUVdd5RPNYmpXE4g4gd6sXHwg==
X-Received: by 2002:a17:90b:4b85:b0:343:688e:3252 with SMTP id 98e67ed59e1d1-34a7281c71emr6270191a91.12.1765453961476;
        Thu, 11 Dec 2025 03:52:41 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:7fd7:d1cd:305:6207])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a92754ab8sm681880a91.4.2025.12.11.03.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 03:52:40 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate inline directory i_size during inode read
Date: Thu, 11 Dec 2025 17:22:31 +0530
Message-ID: <20251211115231.3560028-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reading an inode from disk, ocfs2_validate_inode_block() performs
various sanity checks but does not validate the size of inline
directories. If the filesystem is corrupted, an inline directory's
i_size can exceed the actual inline data capacity (id_count).

This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline
data buffer, triggering a use-after-free when accessing directory
entries from freed memory.

In the syzbot report:
  - i_size was 1099511627576 bytes (~1TB)
  - Actual inline data capacity (id_count) is typically <256 bytes
  - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
  - This triggered a UAF in ocfs2_check_dir_entry()

Fix by adding a validation check in ocfs2_validate_inode_block() to
ensure inline directories have i_size <= id_count. This catches the
corruption early during inode read and prevents all downstream code
from operating on invalid data.

Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/inode.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8340525e5589..9eb364bef5c3 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1521,6 +1520,20 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (S_ISDIR(le16_to_cpu(di->i_mode)) &&
+	    (di->i_dyn_features & cpu_to_le16(OCFS2_INLINE_DATA_FL))) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline directory i_size %llu exceeds id_count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size),
+					 le16_to_cpu(data->id_count));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.43.0

