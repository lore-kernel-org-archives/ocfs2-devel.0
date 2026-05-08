Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36E1358D00
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 08:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230778; cv=none; b=XLnqWXpNmdf5emUAOsz35xOX9O7OhMevjdTNhsKBPZpjvf76Mr21Oj7rX7Ht/4NV0A17ZoTaUKDyha+/yq8+TwI7HKCNQmVEC6Zy/euVRG+Vb95+xdI2LX8Sss5mQo26TAx9h16+pGJKD4bUlyNICh3SRSWmshXJlqIL1z3TFqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230778; c=relaxed/simple;
	bh=oJAvOQwQbiAbBbPxK+tynQ3nmHdW3M18HMEd5mQxQvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+lBL95fgkVR3MuKEoAu/QIgjKj6+Lmc9HmXC93NMk2s1y2wQMEzHEl1AZqLnLe8LQtLDdV1rGozoDwHHQzUrOwBZFHfx7RaXdHspKP0PX/tgzi/bVbpLGG+zQOZAqPRJGqTD1qNpgifrtWhZJV3Wd6BxjMyhy4aeNjBsnQSdNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBEgLu33; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBEgLu33"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba4a1a0325so12183235ad.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 May 2026 01:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778230776; x=1778835576; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=03vFn+TVSNF7XIyaC4L1Hb3ARxQRDo0HyqIjZK6JIfg=;
        b=JBEgLu33uvxZa4IYmsYnXkpyNB+peK+eI9XNDSFwUg+xwWDDwwRsMC/UC8gyp+zo9R
         gbrfHfuvP30csLYjRiKo2KuShN+ytTrg20KmO3SNs+cLqIJC2W60AJNWvY2+elhGaNJB
         jPM8d250yqzwTnCuoPbkm72fbC+BapyW42gp4tthkk6DG5lkXFr1GMwbI1ByneKlvfXI
         mPgQdykSfFYX0I3jYgzYmEOFQcZ4248vdOtsjTX7nNooHFeeE5Z7b9w7deo8LXc4ZWQE
         Z9wTE5iS+LtEEycwLvkgO2huc+KBq9rFPdrT0O8Uzo59IAschcb1E1COStK4ewb74AiK
         ASmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230776; x=1778835576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03vFn+TVSNF7XIyaC4L1Hb3ARxQRDo0HyqIjZK6JIfg=;
        b=fomggWujX8M4fO/9d9aDZlXmlrxQI2+zqoCk1D3akQdiGFuFt3RSMmv9r0O5x0D7S+
         JDRMAf2c09+vxgxfDzYnm8C+D8LiIjMvcM1UH/UMor6nwAaYPMKzyi2WiJEqM3ERqk+r
         9HFVunPptAPXzPZotU+39aXa7wHOu4S2N/rDQlJoyH3+rPi68RO8WIFH4m7tHKSPCzwi
         NXrRNvm3443ccEttAZ3MIxGoXDQDXOWlzEgXys4pGwlzHYEiNhFsz52Usmr28yIFrqty
         Vu4hWNgKJL/1CSrxRNakJsvU7RbwLBwnZOUp1bNa3PQx+KacnV8cgYmuWjSMtCqCBN0c
         NZiQ==
X-Gm-Message-State: AOJu0YyLoxDGuDSSOOTzWea+DqSIis7xkSxG0WOY3WaRosBSsP8/bD5A
	+vZuScjQ58DQxuZ3A48wpDsozhYfwiaNyWj4Y2ZT1XzaG7v/4kGt5G4F
X-Gm-Gg: Acq92OGKXXCXsLXPpa3C60yMeQNhU7MLzUOAdtawlNymjcT3Ao3jYwuf+uQcf4fUPdV
	ZopyybDmamCOwTIMlVNutIXHR8YmXnrJAH4bIh5/+drKfbBqe8n+f8Qtf+SRoiYGX62kLOcNGz+
	5PMfUTR2K2FFmm/ypM+R0UAcsNKtDhzBXc+rL3in25V3qIv6i2ZwBQcKoVtR1bxbYDXwQTcPyPs
	DXORsvO2emzLckmYI2VC2Hfb74omlz+uCfsA0K90MNyi9q/MPJbpymghCrGLwsqMLbIz0V6gaRW
	09jDQvpk6jXSvr+/yop2WpNLoX7eR/7FH8kUhzUQoPvY4bjauLiuPrWMXT/emVwAki8vwGPwKxy
	LsP7us2xcRkilS5JEO+c4kg0mUNBTDkFH0ZPaPjF0pbAOt1Z1R4NjaxX9p4UdwZxKcyYIsD16zd
	QOjrIuQjmqmV8YSf3JR6gtTgS6JLdZd3kUkjnxr2f2cuOqPk4zq528bEnk2Mp4IMr1p/9LGh0+/
	G9Wijl1ONd6Hya3FgbdSGOM1hd3cijW9d5K
X-Received: by 2002:a17:903:3850:b0:2ba:b738:bc2 with SMTP id d9443c01a7336-2bab7381ebdmr79463375ad.27.1778230776076;
        Fri, 08 May 2026 01:59:36 -0700 (PDT)
Received: from localhost.localdomain ([111.202.175.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm15526795ad.5.2026.05.08.01.59.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 01:59:35 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 0/5] ocfs2: validate inline xattr header consumers
Date: Fri,  8 May 2026 16:59:09 +0800
Message-ID: <20260508085914.61647-1-gality369@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Corrupt i_xattr_inline_size can move the computed inode-body xattr header
outside the dinode block. Several OCFS2 paths then trust xh_count or
xattr entry geometry from that unchecked header.

The reported KASAN splat hits the ibody lookup path:

  BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x37b/0x3a0
  ocfs2_xattr_ibody_get()
  ocfs2_xattr_get_nolock()
  ocfs2_calc_xattr_init()

The same unchecked header derivation also exists in the outside-value
probe, ibody remove, inline refcount attach, and inline reflink paths.

This series factors the existing ibody list validation into a shared
helper and then converts the remaining inline-header consumers one at a
time.

Patch layout:

1. validate ibody get/find and reuse the helper in ibody list
2. validate the outside-value probe
3. validate ibody remove
4. validate inline refcount attach
5. validate inline reflink

ZhengYuan Huang (5):
  ocfs2: validate inline xattr header before ibody lookups
  ocfs2: validate inline xattr header before checking outside values
  ocfs2: validate inline xattr header before ibody remove
  ocfs2: validate inline xattr header before inline refcount attach
  ocfs2: validate inline xattr header before reflinking inline xattrs

 fs/ocfs2/xattr.c | 123 ++++++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 50 deletions(-)

-- 
2.43.0

