Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3712CD502
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022433; cv=none; b=hiyfDzew7H1JLexD+ZF3LCxPEbl9uBvllZRFmDyma7lCXuerb8XaQ+1JX/4CnXJYSktXERslUYpCSleg2POf9x+UlCuJEDrTqzFuhmejIBxQF+NARm7z45BxHxHjK54qwms99JWie332Z4tEEyOQtD5jDFbvuhUcNpAnFXdwwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022433; c=relaxed/simple;
	bh=T6YcWO6odH19dheHFRMWYbNzbnGbdaXZP3QNSkwknI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfuje10+GbZVUfoSEt0zrtlDAQU+AbC1W8A+yV60gc8C19ibj7r5noN4vShoGfXP6w9i/YIdbrKAsm9gC86Ls94jaY7mUvLGnfKq9YVzXBI9UA0JiYNSLKGdzju4vDfHVGXTcdfobAVPRJTOuGS/5pGyvYrJy0ALPaNhqmyfImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ko8J50pt; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ko8J50pt"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d476d7972aso66862271fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712022428; x=1712627228; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joMMQ8AjA2B9z22TdhbD/nK3xkrl8x7U3+m4r0dQeuo=;
        b=Ko8J50ptoskfur5N+zJj9BsiOds3kKUy6G8LaXS2HLU8E1pA5MGQh3gNF8PMxScA0D
         7fNj7zScjCit3oNpvwhoMmuTpJ7d0NSbL5DJR0rQ+biceqFIFcc9f+rUpSm8NywdF3R7
         knAP2qM5rvKEBmTnE/v0LCRF9xteWP+qgw1AIlkaJxlSk6bjS8TTFMNfyYssqUdunc/H
         qC1Dn6sk89dLIWbWoSB8q45SDQcgUuvD89kqHenxZUH1M69LLDcH91pNCtIGjOspxJXV
         UsqVl85gNQ3a2BVWdxXwTc/aVaYjqTcYccdq3cOXwbrlap7/wJL2YiFvwr6Dkbywuy48
         TB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712022428; x=1712627228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joMMQ8AjA2B9z22TdhbD/nK3xkrl8x7U3+m4r0dQeuo=;
        b=EUH4zqMIRlbWdyoNDco8ayyrhWm+PO/goXKGRl80JgrWeHz5+hBSnRfO377ZNKqGnH
         QZZcz7RVR6IV+CvkV253HKtkC4JVQiK81XJhduhQkW+WxFlBcN3wj6hiy4QwWlvcePJw
         eHdcc7ezeXLbfO+vVF2XqR1TK/F+Ft9GLfDEkDMqr9BgOf5iWMzcHf3mPekAZMByEgzC
         TStraOp2msc9StuO8WJoe4qtfRBnTliTiRIXYw2xkgR96oQy3mCACaC3IAMElmoAuMzw
         1XEsrDiToi5lVKlgAFH7l2PJuSSQg3qXF86a9XWgIfve8lGmVGXEonXDCboWmGJVfvbR
         VZhg==
X-Gm-Message-State: AOJu0YwKXp+9bWuRhTsvuBzseVMzaEjoNqak3LzEOVUe1bIqti0V0sqL
	vrLfqbRRY6MkUb0yB0ICna5+63tVfAOExTOD+hK2LDSmg1LqXD8tZk5IAK+zTl1DdG/+c0llerI
	9Dvg=
X-Google-Smtp-Source: AGHT+IFsxnthheZS/7ytHL7jOEB6VxeyXymSkaikEFtdSqlkfjcdYjx+3d8klll9FyihvaKgBHGrKw==
X-Received: by 2002:a2e:9b07:0:b0:2d6:c2b9:9118 with SMTP id u7-20020a2e9b07000000b002d6c2b99118mr7238642lji.46.1712022428736;
        Mon, 01 Apr 2024 18:47:08 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id le15-20020a056a004fcf00b006eade394613sm8049125pfb.198.2024.04.01.18.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:47:08 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 1/4] ocfs2: return real error code in ocfs2_dio_wr_get_block
Date: Tue,  2 Apr 2024 09:46:48 +0800
Message-ID: <20240402014651.13723-2-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402014651.13723-1-glass.su@suse.com>
References: <20240402014651.13723-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_dio_wr_get_block always returns -EIO in case of errors.
However, some programs expect right exit codes while doing dio.
For example, tools like fio treat -ENOSPC as expected code while
doing stress jobs. And quota tools expect -EDQUOT when disk quota
exceeds.

-EIO is too strong return code in the dio path.
The caller of ocfs2_dio_wr_get_block is __blockdev_direct_IO which is
widely used and it handles error codes well. I have checked functions
called by ocfs2_dio_wr_get_block and their return codes look good and
clear. So I think it's safe to let ocfs2_dio_wr_get_block return real
error code.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/aops.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b82185075de7..f0467d3b3c88 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2283,8 +2283,6 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (ret < 0)
-		ret = -EIO;
 	return ret;
 }
 
-- 
2.44.0

