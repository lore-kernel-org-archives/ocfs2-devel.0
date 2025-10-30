Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077572FCC0F
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 02:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761790287; cv=none; b=lbMrcGu01K4IctDs2aS5FOEgU38h24F8oYF+8KSP8AbZVn87GQb+rRnrgD95Xaz6h+vp8eiZtM1WKxr9lXdxyvW7VhAKD2BwA4+azGE4TfrTA7Rcc/ub6SlYsdkkH1+YKEXjjz1QLuxkKm0srKOBkSsT7lP+n+nZj2xoAMbC9rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761790287; c=relaxed/simple;
	bh=t8P9ckBCcA7XizQPsiqI/zv15NPa1yuUGZiPolrz0DE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MZNkFNscyKnWURMXHlE+IeboWwqF8ZklirLHDjnaC1y6FCYJyXyD7/9IFR8l6Xdhq+mdhkBGBdMna9m7EKBgqkJveLzAA6V0voF9tLnIs+cR8Z2aVP3s2tqpvzEQH2opi8qWPmCcKvXsSNL4v5uHb/n0jkNydUUi55m+klUZkJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/N2SXXp; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/N2SXXp"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78356c816fdso7765387b3.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 19:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761790285; x=1762395085; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t8P9ckBCcA7XizQPsiqI/zv15NPa1yuUGZiPolrz0DE=;
        b=F/N2SXXp33TWpqqvsl/5cUG4rcBpjWgb24+ZKGQHkug89OhftN6L60xpS1A/tZDkBS
         X/Wk7LfTcYOSn4/AKvbj6DHysXHHbsU+RDzYcrNXnE0kakAID+6TcbYKjCg3v9xoPTxb
         C8GU9NuRxadjq9LTD+CTQd35ZDmG1U68aO0e/u3G2PhCPuczBKzG3L52Z5IlKJXGO+hw
         eiS78cmWNgtoR7DWC4Qe7FlcqZCtNq+tHpHfN1KP8yDWOumsNe/OmN1LL3WfdvkY6zR5
         pCPba0mKimS/qXuvcCaK6YakJ6r0MU+VJemde1QvJYtzWNiPZL4CWj3RY8rzHwKz+CPX
         WbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761790285; x=1762395085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t8P9ckBCcA7XizQPsiqI/zv15NPa1yuUGZiPolrz0DE=;
        b=ZlLpioYOEzkIqdtgEBLGKjkXHc05AedScehfKDD6UWuG8nWnJ7EB6HhMa7wpXOw3t8
         UtH4hKqnHn6Hl3KQBgT3NCj5t7JEO9t1enhd4fMgT+HBfH5Y9yChJI6LSa5m8tpHgmJx
         vj/ZCg5yj5fwYwot17QUIL4h50bFjVNaXf8I9cdvNbTdvRItsVn8FCEyKzQzhfyfNVZF
         PJ0MrA8Od5KWwKtjhWHX+34yFCmWpAYps5d6D6YQz97xCKs8TulJ5+EIu3Wk5QoCuyGx
         izvVgYr0Ibqv2LoIK9tDf+CM3NqpMOBCTZIY0cZN6ZiAIHtW7pBhPL9UlEYIijyzATAW
         TbbA==
X-Forwarded-Encrypted: i=1; AJvYcCW42TEej9kUm3AQM/dTB0HrpZNsfpJwA8zWEsOZ+CO6V1GSXk+xX3rvprWhxp82SRS5ea7kXOxu06srWw==@lists.linux.dev
X-Gm-Message-State: AOJu0YydbPvMsPD9KIxyExlOrDwAnrIkOVdJJwSOlryyFT/rPVZHgCTz
	wZecmY7SESuE+o5tcAWd2B2AsINVFDJW/mkylnvDN33DO8HrAeE0JRWLE85qg4KZR5nyQvoh7fX
	uztBkJEVdFC1Q+3pwkzqJfpvkAIEWK40=
X-Gm-Gg: ASbGncuHUlS88lGCNkbPdQYpiY1lYwOjBsHRFOtb8kDoDNt7gmP8qLnLoo0wtquvTmE
	ZMQ5Kb7ACgCMOnKfN8FbNdsVm/rAD0sQCFJzBdxYZUzMouGOaNgcVMzRNr2s74UAilWZ602LmKG
	xbcJz6Mpn66NM8tmF1ropotkL9IihT4CWUpbpmLBFbt4/Dm1kic5AjxPFZxLzWLqEKnLzH71Op2
	vAfdD/V5DnCNmSxlF6r6HurusyZJu3G1zwzycBYtIwFMHETYslPsvZmWO2xS+rKG5yAPS1WjoXD
	+2UrRJjEcpFEAcSN
X-Google-Smtp-Source: AGHT+IEKmYQpW7Q/cKaqSZIQz4DCWP0qUKQmRROt9owCelyCnUyLsAxUVjQhBX++08lqjggZx1vK/WDEJ0vdPnHjxZ0=
X-Received: by 2002:a05:690c:6e12:b0:76a:c962:1f75 with SMTP id
 00721157ae682-786390d3ef0mr17059667b3.39.1761790284761; Wed, 29 Oct 2025
 19:11:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru> <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com> <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
In-Reply-To: <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 30 Oct 2025 07:41:13 +0530
X-Gm-Features: AWmQ_bl--do3EZf9VbYVhVfSMmJH4cL7t2kLqoag6K_Ys3IOH7ULPStk6MAKvME
Message-ID: <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Heming Zhao <heming.zhao@suse.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Heming,

Thank you for the detailed explanation! I understand the issue now.

cl_bpc stores "bits per cluster" (the log2 of cluster size in bytes),
not "blocks per cluster".

The bug in the validation code is: u16 bpc = 1 <<
(OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);

This calculates "blocks per cluster" (e.g., 4 for 4KB clusters with
1KB blocks), but cl_bpc on disk stores "bits" (e.g., 12 for 4KB
clusters).

The correct validation should be: if (le16_to_cpu(cl->cl_bpc) !=
OCFS2_SB(sb)->s_clustersize_bits)

Since cl_bpc should directly equal s_clustersize_bits.

I'll send a v4 patch with this fix. Should I:

1. Send it as a standalone patch, or
2. Work with Dmitry to update the combined series? (Dmitry : Please advice)

Thanks,

Deepanshu
