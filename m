Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E73D16C6AC
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 May 2024 11:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716895842; cv=none; b=j01JHz5xSPpZLI3FSfGwlVOKhQwce/sjhAKGTZyS7M+VAi2F1qiQ2YvPLBKaCIXbMETk2fe/U2JsfHhreRzfb8RDonqTl93CK6k2mmLJeoSefWtrMgd4YfWhtseQOyeyBKQEZ7r/G/G7AFV4Lo0GUcjG6jCKiNNxJYA5OlMkYsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716895842; c=relaxed/simple;
	bh=FQ6F4fqrwNmUU0r3k7M2vAGNVs/druX0mE/06+nXt4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rbMxAr8t7i3Ldb7EFtpdUJ4Jucs6GKwkrqWPTF876piwQi03g81gjjgxNSvXlVLCy4//Ke40wfstArm0nGkr6H+KV1PH5JcSNh4UpbRaDCdZdKGn4iuiyYfKsykjuiGugfp59MK+9sXbWqLSjdr4ytaq16/KsFm9coGx6bljPjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agyuToP4; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agyuToP4"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f44b594deeso5512755ad.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 May 2024 04:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716895840; x=1717500640; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQ6F4fqrwNmUU0r3k7M2vAGNVs/druX0mE/06+nXt4s=;
        b=agyuToP41NiPGqxyFvGqXziCGiHgFryApTTopbchnc99Tk8ez4OmckiXQ1yF8A7jWP
         eT43dIrg9ExDxVcL5GOJHwm0OlzENiMwy5bfJUC5DWF6yZeNunB4qh1Ku7XwlSl4YWDq
         G2+Co6n8kv9n1zz0CJKcxlr/jd8IsVO1SaVrRPq2hPE9YkSo36OggaY+tcG4xvzLexwE
         O4/UWR+ZlnprrF+jWMTLgTfawq6XbV1GGAy/i2uIvBRtib3Jlb/hdmVI/gncpbFCMywv
         0k02jHS8yevCALJx9U4TNHyg/Ar0TeY8tX2u8tw3gMEngoTJQpKtqx+bgaePe84AlSMt
         UuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716895840; x=1717500640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQ6F4fqrwNmUU0r3k7M2vAGNVs/druX0mE/06+nXt4s=;
        b=Ffb3RKsr7s2DK3SqnArDtS3USd4vmH/4hVTt1ImMjd5JzQsqK2vEnPR5QlSca0JUqx
         5Diqr1hZPOCGkopYEEN/DmExuJPI9so7MYAVsxCG7pg0AZWwbxz2Yo4z0WPcqa3UdAQV
         HXJL9b/IYuqKez1f4JxD1ouirUt7PUx1awwzk2kbszoufYLU26GMqKRJax4D2eKRCYdO
         g13N0JmzknXZ7/pkS/2NkinbJH5eWp4SKYz5lX2pU0iDQFQTdEiV5ui3HOJxKlTSZZIy
         IVJLu/aG5lKs5q6DsYl0BS9XKTDrimfeIJak5LBJ3h2zIzwd8tA4LALctNE/iNfS4zOY
         1Wug==
X-Forwarded-Encrypted: i=1; AJvYcCVEzq9RVwK7IcpKAbRYYg1anBQ65LFRa3cU2SxOpTu+p5F4hL47fgaoqyZvm7C+qCb4tpclaHG/q1fmsGYHnVxHUGD1rd3is5uS/TA=
X-Gm-Message-State: AOJu0Yy9ir8+eA0KPOR8vyT+OQKgJKnHyRW7PlYhinLOb69fyPUBsoqJ
	K7q7Ex6xeynlwq/gcqyEZSyLCCOMflXXg4u0xOPwGtQls5+m7AOu
X-Google-Smtp-Source: AGHT+IHXps3nZ90T8WGg063fYN8QVMVV3g6nA7o5SquGS/z6Qy9jDzJGBr2bfLxeOECbLQ9CIXVaAg==
X-Received: by 2002:a17:903:2b05:b0:1f4:6252:dbb3 with SMTP id d9443c01a7336-1f46252defdmr108101395ad.26.1716895840365;
        Tue, 28 May 2024 04:30:40 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c9711bdsm80298395ad.145.2024.05.28.04.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 04:30:40 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	llfamsec@gmail.com,
	mark@fasheh.com,
	mengferry@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v2 2/2] ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
Date: Tue, 28 May 2024 19:30:14 +0800
Message-Id: <20240528113014.15257-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <784b6bcc-067a-4a27-93e9-60e96da2befb@linux.alibaba.com>
References: <784b6bcc-067a-4a27-93e9-60e96da2befb@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Maybe we should add the same check for ocfs2_xattr_list_entries.
