Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFFE37E2FE
	for <ocfs2-devel@lists.linux.dev>; Wed, 12 Aug 2026 02:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502280; cv=none; b=k/k7K9BSJwEKhlw9Q8Ofsajbao9ChmoAlqYf2R6WENaGBiIpKXoOLGrCLuPVFrIqqezobH9kjwauI8scXaAAcjs+0GXF7Tm6TFnT1XWGfWO0WiGIGc29N9/baVlKQ3fuLSiqntLuzg/KEKWBdwnxPJrxXYb2yMCA4EJRTQ3xPLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502280; c=relaxed/simple;
	bh=MNYH78QWkyw9Pq1e/bkf59S4FkbUDGDGvrNXHpVxyG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAu7+I3DiWJ0KwjNIp3esvUmHQ8R/qoRdKhVSy4yWQ634g8kGDHw+dV5mZSxJzI1NwklT3TalaqmDmcQBd4KQEZdrFBT1gX2y/fPgelw5ZNngKFYe+v/qTsmg+Z1psQUhdNRb9JaRYkvE++zFe2kudNDjjfYvk/kx2UjskzHFMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M098odyW; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M098odyW"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso541733a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 19:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786502279; x=1787107079; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RpELQhFRTDK4N8pa5SbNu/In0uBvhQZECESgkcsnquc=;
        b=M098odyW45gxXCobjVVmjU78yhITrqCIjRmxtK/TxeLL3YPcLpKES7hmBxU8VVv3TI
         odFI5rAn9D9MR22BOSHsBIFzX7ni5+hJjulwGm9wgfOkXWjyYTSLOHesO7JzZCpBS7Zs
         mdkUJ4JqPW5k35vxtQcBJmKmJvbgifBEbLDv0hBuAHTKYKk0B3xDfRdqHtYQHeudgQDO
         n3WyX7ukdE9BoRfsNDjkrjV9+B5KLV9D44cfGogNSL0TW6OQ4rfoCxJH3Kee6MQ/MpsA
         6dP/15CBAHT1wTtn6N4illTQ38AdlcQ0/+hdalyjmBVgpFHTcg1TtLhDPiHCFBaJIxIO
         +sSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786502279; x=1787107079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RpELQhFRTDK4N8pa5SbNu/In0uBvhQZECESgkcsnquc=;
        b=bcqwaWwUwXWKod5/tmLnJrc3mqQwA/oh4vqTGXkTrTljHBT5E9l+NA4mBlioc5t0u1
         lnUeM4LjBQd/uGoBNOOUn0XQmyF41XJL+SPXvnavCB8DTbTT1saosfqjxQvmShbHB8RW
         tliGEeqp7CZBhjnnDWdGHtQk4F78+MRmoVgsh/0O8XELKyEZbOednjHEizRjJ09ESX4Q
         7aEv2ief0tWq29jT/OfQKNir3iFSTWBgT2N+/ki90XhETK39VB7im74J7P6BvOMZ04Gb
         2CTp5NGPaRDUosXjbIzOtbDdx+rzRsd7soU8bfom0gSMPA8T3kstonegz03i2Nxg9ffi
         NYLQ==
X-Forwarded-Encrypted: i=1; AHgh+Roo/Aqrlxh4Hl2N/8AHMiNyX3RpqeVMO8sKveJJ6Qx/G1u/XAmk4Rs+2NXtYNY0m51GVkk0e6ctZTFo8g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyC1ZB3g42Ivd8IsNOmz25YZDjFFPD5blW/xbh1TvYD7z/w2tnD
	kuo58iplhEwjnIhMcjVVpKMlsKt5/hxDkgOV/ufuDi4KUdGM11OXNc+0
X-Gm-Gg: AR+sD12sATTfhD2b0XbrmzvvSydynTBYSPAFRh2yl35J5BS1NDH0hDxa57UIuN+faKU
	EN+HPi/FHCof7OuF1J4CTJ7+Nkz+sqC0IePKbw8G7sO2KwGuwkqFYh4wTmsIOScceQaXq1NuWtL
	OdGDfWGw2R9bou8UhN5XRFD/VVXBBCb4IxvEZtEd3w+03Lml0tDmcpjAPYId59KbxVzSRBCV4dM
	QtZvhXFVxzB4D1CsGjGvNSvm2VtKopfS3txX24WsYlY1hBGToIFExgXPVVu/ItZUKmki5Glv/5q
	3/12EF739f1DpgpJv7yXM7F/eSGDwiXL5xSKzD8Rf1ZEDEV/FHJCDyFEeZT0MY34vhNVW2NgYdC
	eapOzbJEf+bVMv55KV/bc3vuh829V6ToOkPXHOBcyTbxs5BXhRY1S4fYcoz3LRD52MszcyrucxL
	7iouvEGxTVVPTNDERHMimSNcpIBR03tkkLgwH/F2/zktAj9VvpPsXuUcoGd2PX/drq8ItUwyJ7
X-Received: by 2002:a17:90b:440e:b0:38d:c74d:29c5 with SMTP id 98e67ed59e1d1-393014b609fmr1444326a91.19.1786502278616;
        Tue, 11 Aug 2026 19:37:58 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f94d30f4sm1719155a91.14.2026.08.11.19.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 19:37:58 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ocfs2: bound-check dir entries in the readdir re-validation scan
Date: Wed, 12 Aug 2026 10:37:48 +0800
Message-ID: <20260812023750.224082-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811192231.b0998aaf15f4fe9c8681cfe6@linux-foundation.org>
References: <20260811024337.3972976-2-zhanxusheng@xiaomi.com> <20260811192231.b0998aaf15f4fe9c8681cfe6@linux-foundation.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 11 Aug 2026 19:22:31 -0700, Andrew Morton wrote:
> This can be prevented by using an explicit From: line at
> start-of-changelog.  Please let me know which address should be used
> and I'll make the edit, thanks.

zhanxusheng@xiaomi.com please, for both patches in the series.

The header was rewritten by the smarthost I send through, which is why it
disagreed with the Signed-off-by.  I have set format.from so the explicit
From: line is there from now on.

Thanks,
Zhan Xusheng
