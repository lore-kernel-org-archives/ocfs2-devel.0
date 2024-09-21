Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890F83D64
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726928533; cv=none; b=T2P8bApKIBSqp2Lxv9vtXIdK+awUaZZEhXlzunO2duxra8JeX46k9f1LmZ1z6PsLgmubvg2p/HCwe9tbtiJ/vBKhQUOkvrv8X1EpNqDD3oLSs3MBqQsbbGAlLAOO3lVrnkLie8YBnq3ncHAgqFak3xvQd0N8pRQWTUh0aQ5xIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726928533; c=relaxed/simple;
	bh=X/BH7wuMLP2jduWFdqalM+7/pujCECO1ESe3ptDETSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6h8djoJXQhyiMdlm/roz81DDD+rcsDuy3g9yAD6fKe9T+4/8wzzvBGfyPR0MS/27HrhPOUeCPXLZzoj5mz+U1Ju9FI6kClIu+jw4EXxBXUj3lDozh1/DPX54mLQDXjZp/wPoZRpGL1jRIIJ0lFFf6YBeRuCc3+T+jEJEMxXHFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YyYyn/dh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YyYyn/dh"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-718da0821cbso2329399b3a.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 07:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726928532; x=1727533332; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/BH7wuMLP2jduWFdqalM+7/pujCECO1ESe3ptDETSI=;
        b=YyYyn/dhIdUL2bx3tlGv6lR5n1EKPKuUDgqCGFqkpmJ3h+xs9gGwg3WIWNyC3pWBd+
         5iqCQbB0ZP/zSvdajak852YCfv20kmAvJeGu9ziJr9HlxumELKBYg9ylbLzPmvXEehW0
         MJJW0xae+Zx+SLouLerEHVlIuKiecbYYPY8ERGIirwTjNFFGy+SO8Gm4x0DPGMa5hkeH
         VNvJW5JSO8SZa27lDlF69UDdghr4k0W1t/NFy6B8/HThGd8VrDZL4bWY8rbR8XtRlqK4
         WhHEEx5up1iS5HMeGCTXvHKIk0OdyVNpO+AcVZNRpM/995gBEoV0CM//ibqk5U0DV/V5
         8lPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726928532; x=1727533332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/BH7wuMLP2jduWFdqalM+7/pujCECO1ESe3ptDETSI=;
        b=NR53Tj1h1fOm+e0F5E2xvtnQP9gFQ2l+1EGPOkvqDcQweyrTiY1Csq1181rcesei86
         hDsVpH3vFKyrbicKVtR+Zl3uUCBoXNdlfsK2DSLkdgDCDu35mxDNfuATmYGTAAHhZli9
         JHfJKnTjeuzHbW2EgASh5np+oIAJZcUJ/7KiKm3HE8MN6xWFBLYWDx+XxE2ybPB2+cPJ
         EnGRbHhHYd07lLXMSqdRFxPQcDZCsOZvgcUzNyFafJB2icgfhH56367Ml1RLxBWf1WQ5
         D6InwsGJIwGZFzxJSAZJ36AWLRdMbgr0Ujo/t26ohZ5JfaPm1RTfgwS/rtutB3VmM1lr
         ox8g==
X-Forwarded-Encrypted: i=1; AJvYcCW2rnvax4sTxFvSShtW8JA74mmIValOYBvXdZfE4KS3nNA04p2ulJPb60s+pw5m87HhOn3/9XVTkcyLoQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9U+dLGaIYJ/phKMeC5fF7iFfPW6CQLgkRvDe8uNsJBqk9IKuF
	22DNAdiDIG9c/0gpFTsqzIXBBWgtMqGwhKlhuDSDs2Sj4sNk5ZOX
X-Google-Smtp-Source: AGHT+IFuUj9YzxZhno/X2uzgCZZIYddvxL56GB2fYTWRZo3CVQzpmp2G1r9R83QfEAF+aD1AO5sE5Q==
X-Received: by 2002:a05:6a20:c996:b0:1c0:e9dd:1197 with SMTP id adf61e73a8af0-1d30a948939mr6872978637.22.1726928531615;
        Sat, 21 Sep 2024 07:22:11 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71944ab50cbsm11335154b3a.53.2024.09.21.07.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 07:22:10 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: heming.zhao@suse.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	pvmohammedanees2003@gmail.com,
	syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] ocfs2: Fix deadlock in ocfs2_read_virt_blocks
Date: Sat, 21 Sep 2024 14:22:02 +0000
Message-ID: <20240921142202.4793-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <2690bc1f-049f-4a27-823e-5da0ae1bdcda@suse.com>
References: <2690bc1f-049f-4a27-823e-5da0ae1bdcda@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
I tested the patch on the URL you have provided, it seems to
tackle the bug and it is appropriate, i will link this to that
URL and send the new patch.
Thanks!
