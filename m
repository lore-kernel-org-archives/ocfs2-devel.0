Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6B267B89
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 03:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761796527; cv=none; b=GrEa9u9Xfz3ijAkfnO4Sz83xnIP176Pwa+OHlgb3HAOznea+qmqkDLDpCmf67H/YHLu7cGURNSEdPnon9H+FTUNoLUXCqDDH4XKG6afw+Tj2+UvwHux+CMCS3TBosTPaMfZ/mZ4dGH22WyR7OEb8ruOMgS6rBDaTB+sAxgjIrks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761796527; c=relaxed/simple;
	bh=3/fJostkEM3ienM7znBfhianSYP66YPj0PM/WyOHzZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ee0uiuE3Q7pLk9JD5Y5ICJ9GxUwfOnEw8/TbVqS5LwiSP6pSkcfqovm4HsAKWDa0E4v+/R0CffzU8kFgs4ZSAP5T9TNxK/lJWEXtzDo1262uP4mPoQnrVR+jVLVG3vnLnZzQNvkt68r8WNZtgmDf9+IjPtJTl3t/kwO4lZqTbuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NM1voxdP; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NM1voxdP"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-781421f5be6so7875487b3.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 20:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761796525; x=1762401325; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gIAaEIyUPwTrth3PKVnCysi9esjFWAl5GkhCiWEBrLU=;
        b=NM1voxdPYXsm0EMWiep9m7ojhAxDPfHfolopFGhlAUFdUhNP6N7OcigDuIyRBEQqN6
         kta7/dwh8CATj/FmNXprrRe9YhXFptJqltPyzBVAggSiJhU4TSmjOUm3mBsc7LzAnSSa
         0Zikh/JbkhH1r5/IUyWWaQsZsvFm3YEmOGUmy2O1CHllEtyFEFhDc88BKkycZ2nC4U3N
         gDO9C1sEO0it6Z44KyZkbmlAXt5G6cSz6K/7O2z/kMgRcl+ZkgJ0pSxMr2ZmXJvQPL6i
         TpPNYA5lTfyNPRc7MCtJtRxOnZW5mPYR4eLjIi4pmKgahlIcUF2frimhhA1Tj4Ea/kGV
         wTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761796525; x=1762401325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gIAaEIyUPwTrth3PKVnCysi9esjFWAl5GkhCiWEBrLU=;
        b=W0U50ln6o5MI/POxEQjAop7BBJAhRBPHhXT9+8OXhUBJGUnjbfr4P9tbfB0KFJVTGm
         pxRlElHRyPEkcbK+bd5Z3GvwdpPxiUtKzOFWmSEhf+qcbB+7O2cDRQVqv5DAm6rJXtcg
         v0B+0rknlQC2dv3ENzxJyaHbf+A5kbdOxTQsQnyga/0hMvhG8yKVSB456r4f17jGUSej
         +pnaCbMUxUFIFNUcF9yK9XXTbHTnFcOUpY10i5DvEiD1ByvDW9TbDS99ByQ95NpQJdVk
         hQWiPU+X3Yfnn3jHTe512Ketkp7poPa7nqm0d/pudX0gtny2Wg2YSO0ZbIBSS8SNFS/Z
         l30A==
X-Forwarded-Encrypted: i=1; AJvYcCWjShKC2eI+ejqfAYavSWiAPByXtC9xgLYUOWmrtJuxO4n1vbydDgOpD9xT42LMDqiafnlQWHhbu1qCUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyF+U2WDupEhPZoNQMpygOVwzn3K+na+5IrJSA0SkkhUTX2SN28
	gNa5F27NhXe8NFxECcMz44GNugNujc+xA/C4BcPgGlUxml7CopAo3BjQYyLfMtjSZn2pRmJknoh
	NeVjEV/2xNP2gk5OathCpIiDCeUuV8jA=
X-Gm-Gg: ASbGnctZBEthR5J99Xbfc/UohomLCqbR+PO+1+B8b4rn7YyyIaMB7DwMeDNHA6XKEzD
	F6x6153WHfzkVpL7XZqLLRzhxEyXWDnVaElp/liQ2t8p03+uy7MBt68MzzcO/YR2awynB7QCnm4
	LPtgI8M1EGEk0okiIwkGJVdH+cG00Td7HRB8e/nOPDrZlDLdIY5ubNnxVHDtzBtBIYrJwERsGnu
	+wCs6NQ/fZLW8d3BqApgABlLhsJrB0aCCFsD3czTG683oYsetfNgGnPO3Z+6AB9ET/mBLe+m/Zx
	GLuU5PfW1uG68JkwTg==
X-Google-Smtp-Source: AGHT+IG9Yotu8gQYJVOufggzKa7RzP0CjKOiRdMt27j4pUtqu7JwDFwsb7hKbDD4SGZp2r3fIl2kLmbFvwOniufr5Bs=
X-Received: by 2002:a05:690c:6c8b:b0:780:f8b7:c177 with SMTP id
 00721157ae682-78628e42c72mr53776417b3.16.1761796524693; Wed, 29 Oct 2025
 20:55:24 -0700 (PDT)
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
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com> <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
 <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com> <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com>
In-Reply-To: <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 30 Oct 2025 09:25:12 +0530
X-Gm-Features: AWmQ_blRXpZQEGpiB0-XW1zZg19nXmP3LNQAZgINzyEeeYGvpa9r6PHFKMEKa0Q
Message-ID: <CADhLXY5QK3vDcXhuW-xq5Bd72uPCVA1MeTnxn_991irOmvhRCg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>, 
	akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

Thank you for identifying this! You're absolutely right.

I see now that cluster bitmap allocators (like global_bitmap at inode 23)
are intentionally set to cl_bpc=1 by mkfs.ocfs2, as they track clusters
rather than blocks.

I need to update my validation to skip cluster bitmap allocators.

Looking at the code, I'm considering something like:

  if (le32_to_cpu(di->i_flags) & OCFS2_CLUSTER_FL) {
      // This is a cluster bitmap, cl_bpc=1 is correct by design
      goto skip_bpc_check;
  }

However, I want to confirm: is OCFS2_CLUSTER_FL the correct flag to check,
or should I use a different method to identify cluster bitmap allocators
versus inode allocators?

Thanks,
Deepanshu
