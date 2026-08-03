Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC88811CBA
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 03:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785726045; cv=none; b=Jk2aeGB86FsgfHrdnlXXh5Aiu/CfuKuAyBYVs47D958tCkFdjPKmMxyhX0Yv4mSTbToRq9ggNX+VWhr6VqZ0XATbpNt7LTPhRsD5qv4KoUzWAvMstvR0DTd8tZg4NiF47SSYivfPsBHtcKXsfkmfSt3EQCPOuSz4MoEDwOnJ2EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785726045; c=relaxed/simple;
	bh=NY/jIrSLqx5rpVraOHHNXm+2uT1Fz8tHuTCfVWVK6no=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gjFF6AYhM7GFC6YMxOjMAsuDM+5LLzDh/HaduBOlIYsxRZYr9Yb3Hl5TE/Kw7vB0LKqgtNNxq4jef996J0BrA17Xs7zHzOWNr92PP00DTCe//TUbOR5kH9/QhVzRL0tGaRYX8y6DN5mo5rmm1DybMXltbAOzlEPAS2mRZWZ4hZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MaOxvY3z; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaOxvY3z"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-848479c9bd5so2304313b3a.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 20:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785726043; x=1786330843; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rxlCVqEv63EayolG+aZp4Zb3NXGW3vXo2tZglyFpBf0=;
        b=MaOxvY3zfZzarIBvegFGCP3gtkfNVzpjC6LHTrOtxTa3g1YH4hy1iS3SmT2goumvPO
         zFRXw5MLni6AC4wCKnTF2r03Uvduw9cuOP6FUe3GhrLxRmYN7ff7yEkJJW0IMRZYBwBc
         zLWc86gC9toW0Hg6UtpP9RKkb6HOJ+tI1I3Dnb3GodLkmgZN7gw4itAF3keqeqLBGVXH
         hRTTIvluwE4XvqDNNd+LPEUA6LMW3l05B3ck4wzsxJJjVPCmyQXE5813AWhnoZL+r+Rt
         BcLJvI787R/SEqZoodTB7HGB0ekdobaO445iyfozB9wuXnGxl6gQJbBsY1bXAXsxMt+B
         GOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785726043; x=1786330843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxlCVqEv63EayolG+aZp4Zb3NXGW3vXo2tZglyFpBf0=;
        b=f3BSzDMx6GU9doFoLPzW+3sWqECJGVqJWLq4TUs1djdYRXrw/0W0hopvlAcaTYxgum
         uAqsJIslD4vtweyjOcfIwptIw3PY14AqkakHVriaXlozSeAEpqBDS2buU5EhEhsgwU9T
         THjGr3wmZ/mcxZuHX5lJvJA42KrTy1LgpxxN/OiEwiJwvAFJn/7dv7D09J+oF4OlReXW
         1sTvBfUmGtYDsNA7TIFUHaPA1fvigEaYklj5+dyBzYaQsr3JyoZy87biafKFmvn6+lE/
         n9cfAoVr160siScQ4Fr1JLluqx3acPUQzUAvHpQXoEWveCsD+h67ND+Zp/NAB5dsY/g2
         4Z9A==
X-Gm-Message-State: AOJu0YzvaFG7GQ5JZVlTW10L8neA7n3I8dZlD6lSna7NVtQ/2YrUKkCa
	ghR9keWLwu7HiUpK8rRnEanz/Eu8UhQwNRtOxVgB3DLBS6mYGmKXTJC4
X-Gm-Gg: AR+sD10Cl8PqBLSxOGUGYoI1Y7912x7X7C+F+DNPhYV4tdIQlgmvwtfxGQdh/+xFdTR
	klOz7BpPuyhrNnvDm4HXwe5Go3Y8kPv7g/2Tl27nD6lEo78QxdsOPcCRLgmnr7oTV7zSI5k8r2l
	+ImijCMKvD1ssdWbG2stZoqvFOlFmGAM/N4FtBO/5Tqfl/Lj6z0JCpdA4s6pHHW5d92IqaweH3y
	nJ1e28/j0++O8gF2vc9jK/JMVckBES4tgW9hROGKiKLSCpqo3XgbouKWWo2A6tjEmpRusJMDZhw
	1TQ0qUQsu9TFcdikj5iRkmPQj0e97Z+GxEWQmavMiobR6hoZR8KsO7vECKzZqmjLfF9nObmTYrp
	j5NcnyQh80A52Xn5BjAaoYFrMqOiG2I4vFuF1rAKniBX55QXdbhmqOHhMIlBCO1Xg50VZ6R6Rk5
	EFWEriEUcGISeOaKN5hi/s/uG8FlkrGjaoiKR8W0PJKZVsWPoRiAdwfHvw+MnJfbnKTXG4Y7QtD
	OmcFf8uJ6RoRlifLjJbVjuhgWgpngfSDd8ABum8
X-Received: by 2002:a05:6a00:3d44:b0:848:7731:d95a with SMTP id d2e1a72fcca58-84ee48bc67emr7571089b3a.37.1785726043156;
        Sun, 02 Aug 2026 20:00:43 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc29f2b9sm2962878b3a.35.2026.08.02.20.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:00:42 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	tom442288@tuta.io,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 0/2] ocfs2: validate active orphan slots during inode read
Date: Mon,  3 Aug 2026 11:00:05 +0800
Message-ID: <20260803030007.3993199-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OCFS2 trusts active ordinary and append-DIO orphan slots read from dinodes.
A corrupted slot can therefore index osb_orphan_wipes or the slot-local
system-inode cache outside their allocations before the corruption is
reported.

Patch 1 validates the ordinary orphan slot used by inode wipe processing.
Patch 2 validates the append-DIO orphan slot used by DIO completion and
orphan recovery.  Both checks reject corrupt metadata at the existing inode
validation boundary.

ZhengYuan Huang (2):
  ocfs2: validate orphan slot during inode read
  ocfs2: validate DIO orphan slot during inode read

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

 fs/ocfs2/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

-- 
2.43.0
