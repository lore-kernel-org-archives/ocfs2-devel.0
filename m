Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F469D27E
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022431; cv=none; b=EGroqkbrrq1nba8jh6pDLrwczDOlOJGAIK2mmwrr5uk68D51gSermzwu+tBJ1R71pDvn2IsvL1a5oeUKcMSahnTEUsAjKMEsFRcLNi0hjEh26TYHifUQSKFWv9HWthzaLX8IC5K3Ta4ULjbg6TwST6Sn91COuQQolZboa9ZqOtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022431; c=relaxed/simple;
	bh=Ye5yGQJWj5Ut8e04EEVSHpSBX3yybb0Fj97NUTS8q+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kSrwvC9XPXvlWFCyvflcV6LDz4CyAotB7so9/c9kkTXrLHAM8ITc6Pq1x01fYkSCrepXG3//26dOaPpTwbGiw2n6nhUtBz/IPlB1DlMG27OuXtiu9r0sCi8kB4J6qHkBPQKBa8w/dsTgzJ2nSyrlWwYGH8WMatS9drRhj9e+2Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YxqeRIbG; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YxqeRIbG"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d80baf621eso26544861fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712022426; x=1712627226; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cuuh4bCRD3OoMIs2nZ+BULo2xldVDct+7lZgRhzCxXU=;
        b=YxqeRIbGRZttBlBJMmqKtyvBoCuRWoXwfjg+/o4J5Wz1EMG6cbSf+L+OwJ1XmcPNt5
         H23y9nDp5lgLJi/peARzHOsxSX2JoMjiWqnxyZGkoDCLumY5X2l34/8v8q0guBD4nkEe
         ALQKld6tsWdVcbdGZWAfYCKxN/9geC1jcrQ7VPQzet3KoewrglISs8fd3xCJ9wVZy5xj
         E+su1wp0YvO8rJE0Uzr8jEdusqM/RXWFJz7VvKwVrRrR5uqkMwMO3BH2cWTGAnptCnog
         9Ik4TrCbo/RRsrmZSxD6kjL+eKP3MQK32oiygFi1c7CCH6aQd2nsVJRH65AgwR6DlUWD
         TDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712022426; x=1712627226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cuuh4bCRD3OoMIs2nZ+BULo2xldVDct+7lZgRhzCxXU=;
        b=eUZ653Ko9WwHyMoltYB9nLxgCBuDd9TqiZOOLgUf1AUzjeYl9QbKJ3W9JcihI/7TOJ
         VjOtktwsZjHg4w1rovarfTWarb8HftAGP1dsGJeLWYY5vXPJquhu7kyOgEDtAiY2ECoJ
         UXs2ADpb/DZvXbEI0nZxW1Jnn8AiQtfHNrYvQgCndtU8L2Na0OcFhN8B1rFe1W+LNGTL
         JuMTc5F9ToKHV37hzuyk3dhEPYGUaNEmY+wNBcg82OVYgJ/HRsBW3bujxodOZaM8KyHm
         cRH8ScydmeoSz3pLtwSuo0kwTeSltOxwik+VNudnOmh6SekTPcmi5e+rSG9rGJGO6hC1
         oJJA==
X-Gm-Message-State: AOJu0YwVIoscf7M8iYyYS06o440rJ/jnNMddNlernPrZUfXme3tG+kQw
	Fyww9j3pp+0vjeO6R6jDwE0eM0DNw8ibeSUv6qCU+uPT2rbN09EUC5VCd5NLqkUOyK6VrP4QZ+3
	UFpQ=
X-Google-Smtp-Source: AGHT+IHeViJyfsRJ7XJEm7pC22gxikhepbkpYEcSWvHS3qFjPdhtJjWbZWdF9WVfEmiv1znJ32vXlA==
X-Received: by 2002:a05:651c:1a21:b0:2d8:2480:de8e with SMTP id by33-20020a05651c1a2100b002d82480de8emr1794751ljb.8.1712022425947;
        Mon, 01 Apr 2024 18:47:05 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id le15-20020a056a004fcf00b006eade394613sm8049125pfb.198.2024.04.01.18.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:47:05 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 0/4] ocfs2 bugs fixes exposed by fstests
Date: Tue,  2 Apr 2024 09:46:47 +0800
Message-ID: <20240402014651.13723-1-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patchset is to fix some wrong behavior of ocfs2 exposed
by fstests.

Patch 1,2 are about AIO+DIO vs hole punching. generic/300

Patch 3 fixes inode link count mismatch after power failure.
tests/generic/040,041,104,107,336

patch 4 fixes wrong atime with mount option realtime. tests/generic/192

Changelog:
v2:
  - Fix typos and amend commit message about the functions called
  by ocfs2_dio_wr_get_block in patch 1.
  - Add rvb to patch 2,3,4.
  
Su Yue (4):
  ocfs2: return real error code in ocfs2_dio_wr_get_block
  ocfs2: fix races between hole punching and AIO+DIO
  ocfs2: update inode fsync transaction id in ocfs2_unlink and
    ocfs2_link
  ocfs2: use coarse time for new created files

 fs/ocfs2/aops.c  | 2 --
 fs/ocfs2/file.c  | 2 ++
 fs/ocfs2/namei.c | 4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.44.0

