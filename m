Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C278E1B86F9
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Aug 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723815761; cv=none; b=Lz/X4YR7PrVWrNLoRtrEEFAkhrq6fvIcuAQ70WgUe+xs3FAmCfHLBYFpT0dqPjRnSYSKBvvcLSHcNn9yvNtShU5tbiSaRuwzMaDSKbeWaaGg4CGKuBKyuKqZ+r5+5HsyUDmKFj5nr7XEiIWxKVLQ8pIHLYY0Sf0vU8BqVruYID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723815761; c=relaxed/simple;
	bh=GDRN/U17nLltMwM8K86CB2KETOu93s5A4TrFjyjHQjw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fa3lL0qfpxGoHSrkh2FnUNUsBrfGnb7OhX85W0GrHvJsHa2wTdSjWIMr84qU38iL5jqTpVL/bgIyqlXvEW+FDd6pXD4JQIviJGQwUBT3n+Yo1hv/dZlt3zVCtA6PhhxzrbXb48gA2CXGDCdre1GOJMLoz/Bzghhs9YuXgImxA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfRMY0/G; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfRMY0/G"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso14778195e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 16 Aug 2024 06:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723815758; x=1724420558; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IuyVvuAkRjJSIAKvYtsQnHCMkhH/3BO0FwvyRHQBab0=;
        b=LfRMY0/GaXTZIHACaq8r7VHjUrrqk4bB3kmB1fVGrNpv93JIMOGlWhyDgemcRCHK55
         ZeXI92IUxrK/DMp3IGdSmAbQTb4FJ8tr+lIeV3qfejq3ivAxCX2nnTNV4Dm1ziOa625K
         qTqmZyJu3j4IyREwNiq4blS+U3JrB46v0Cb6a8sf9Sa2xYJMm4h9JP8QV9i66r8NwKL3
         iEo68O7RFypsD78R+X/avHoYgHro4FYApf065v50PRi40EkOZBIrR+u7vgE1zPOhUeXf
         gAdKeCOF4Yd3PJ3r+c+cYxGVnkNqfWV11btqJkGdaDC7eCvwG95ItzsIX3TM+ToW0tKC
         QMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723815758; x=1724420558;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IuyVvuAkRjJSIAKvYtsQnHCMkhH/3BO0FwvyRHQBab0=;
        b=daqFssRFkmzyR1ODZ4x35UP1WlNBG3XQcnb19c2NfTP+xm2OlOxLN3TNCSj4Drz49F
         +69hUs66OAvqiLGrOk+J6nhrYqR0M9zIQFRqMFYhaq2tv659cftlG7C/aiiIsPsLZE5J
         N+Mh7nCXVOU62sRYyvWsvoE7JVsDSKHf0Kpfkfb/PKsLJ/c8IhrR0+z1ZZTKINvdP0WY
         G7wezYFvr0zbJEfkBTXJmxOrHsaqnRPYF1yjP86H6lfhl7hvvY7yBj6R6UGaawFwrcbK
         fkVDfGTnuxnbYsjlc9HUaANzrTorQ4g+y98Wrxr3akiuLIwLV6KVSYJm+Ql2jpt0+2nn
         CB6A==
X-Gm-Message-State: AOJu0Ywcof1qbeXi4Xxn4Hmfd3tgS1FDgxjkkCM/NV/G+BW3sZUkLOEK
	bxvGwf/CorqX1PNYBOVjOqATIXr+TZsvEeAlQq9S/7qtMatOXQqx
X-Google-Smtp-Source: AGHT+IH5kC7MTYBBM7V3Itm0SZ+IDwrTPeMZxvzzWO1NKbR+0e0bPv9WVVYmTDRNL4HQoOoR5xE4fA==
X-Received: by 2002:a05:600c:450b:b0:428:640:c1b1 with SMTP id 5b1f17b1804b1-429ed7c0944mr18400495e9.17.1723815757628;
        Fri, 16 Aug 2024 06:42:37 -0700 (PDT)
Received: from hostname ([2a02:c7c:6696:8300:44d8:63fa:6beb:ff38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed6593casm23148145e9.28.2024.08.16.06.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 06:42:37 -0700 (PDT)
Date: Fri, 16 Aug 2024 14:41:56 +0100
From: qasdev <qasdev00@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Fix shift-out-of-bounds UBSAN bug in
 ocfs2_verify_volume()
Message-ID: <Zr9XJJlZ+RzkLK/M@hostname>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From ad1ca2fd2ecf4eb7ec2c76fcbbf34639f0ad87ca Mon Sep 17 00:00:00 2001
From: Qasim Ijaz <qasdev00@gmail.com>
Date: Fri, 16 Aug 2024 02:30:25 +0100
Subject: [PATCH] ocfs2: Fix shift-out-of-bounds UBSAN bug in
 ocfs2_verify_volume()

This patch addresses a shift-out-of-bounds error in the 
ocfs2_verify_volume() function, identified by UBSAN. The bug was triggered 
by an invalid s_clustersize_bits value (e.g., 1548), which caused the 
expression "1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits)" 
to exceed the limits of a 32-bit integer, 
leading to an out-of-bounds shift.

Reported-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=f3fff775402751ebb471
Tested-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
---
 fs/ocfs2/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index afee70125ae3..1e43cdca7f40 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2357,8 +2357,12 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			     (unsigned long long)bh->b_blocknr);
 		} else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
 			    le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
-			mlog(ML_ERROR, "bad cluster size found: %u\n",
-			     1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
+			if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 32)
+				mlog(ML_ERROR, "bad cluster size found: %u\n",
+				     1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
+			else
+				mlog(ML_ERROR, "invalid cluster size bit value: %u\n",
+				     le32_to_cpu(di->id2.i_super.s_clustersize_bits));
 		} else if (!le64_to_cpu(di->id2.i_super.s_root_blkno)) {
 			mlog(ML_ERROR, "bad root_blkno: 0\n");
 		} else if (!le64_to_cpu(di->id2.i_super.s_system_dir_blkno)) {
-- 
2.30.2
