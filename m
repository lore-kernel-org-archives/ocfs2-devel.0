Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE15649BD83
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053874; cv=pass; b=qix0uTes0cqgHWZBpz5jMj+Iniwx65VNXEPqjxHnhRy6ZfNeFCJYTr0CWA5ZtPACEmNzYrWpLnu7KVKaC9HflwrJZvtP5q9E3ZjEmjGk/EQceh/Ci/x6+rRLBiafJuF8KDnTIph6qlgdyGLM9L/L8Q92VIrPUOwiOH1dJi0kQ2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053874; c=relaxed/simple;
	bh=9VQjJt6a+185GkYjPMQmDeyCxl5xt0e29jz5LgzWiBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kZlSTDyufB7wXnlGsAc8VonuRTQfQhxodBvhlN+pIHA96ipa//1+zydLNZrSn4iaANQ5w45LNm47Yh/bl7ShZEf2CcQM4uSIgJKHiNrxDNTW5wS5GQoBgEtaf4nWGPAo1AZ7EcM+wh/Ldt3OyqlmEWyHmVpOWeYWg1doioJA7QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iyZfODGG; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iyZfODGG"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a67fa7a64eso2511265a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:24:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789053871; cv=none;
        d=google.com; s=arc-20260327;
        b=nHEdeJFs0MK4Zuqz9e867ePRil9OzXqSy3WuqDCZa4+uqDDxkU9CebLjFEwvt+8WAk
         G8ne9urvZb2mIImR7UhCppKoBGPGfn3izlB7D+b958qWh0KRkRvjF3Fd15ntBzRmeMFb
         /e1RUA+UzLDI/ivYxRe8/SuDCSKsuoQ9VblOvAYPd1n06wlFmj7trfRfz4KTayhN6cQ+
         db+dTryBSBjXNlVWpIktXnNZSyXhj03bk7KkOEvPM+rV/5KHbGgj3CkiEIbxinzX8II0
         i9EM+Cd1nuJ4Yzyw2lsm2l+8srOya2JG75waBmkXM5tILTS6OJI0CYNeOjfn3hqiwkO1
         yc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W02XYVTB0Nl5fojAG5hBMBTOksfDYePfH5xC6TePd8A=;
        fh=J1cZGKfjoYahbAjA79mwu2WN73m/UcRlPYi0hUVwEaM=;
        b=Wgda2VgcXWtVNVvGVCbs3YKl0VgJSgmOY/TxJCNez9Qu6c46EeZcRxUG/3LioEFvJL
         J6G09Irry22NauJ+jTEOr1TQhgSijNVcMegmrXZk2Z6IjfVKRE0yFgOMBRneyL0iM3q4
         bHLglLM5irMXH0PABkISTvH0Wg3dQe0QjQloczwDFxPOBmmZp+G2lY74yMLVeFOxZaV0
         kLjQZnYukyZ5Dz7c4kjiF5Oi1wx46VDN0ZRprAaQionhk6d+bI9pDUnneaR7EE9IvSL3
         LBuDm9O6dvxk/mXHJvWI4mKoqgtXDhDpk3KIwxwIlEYJZ/ktPj0HPiKruHHmSn1Z9Wc3
         Fygw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789053871; x=1789658671; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W02XYVTB0Nl5fojAG5hBMBTOksfDYePfH5xC6TePd8A=;
        b=iyZfODGGSBtq9XwGJ0s5ukmToA/aqZIHZRnaQVGlsjmpDZHuoyRPAxLxq4qcKGJOCK
         e71w06LBwgJ8cuzuMiHeXbU4WdzdUen73I0fnNr3pJIs0DdrsnUEHuQ6BH3N1vhr9u+c
         OKEvM5cqMhTtnr9IYLIl38jGZ28EboMqDq6H/AMyLUrQbBL0Nsq6oKTrIOnviIGV8Q7C
         Rd64SPbsGCskVY3CcsT5+juoPeHTB8qoT6/ZvkedqjSb2vwESNNxBx9PQv6A482ez8oq
         KtbyIP9PwSmbYfGLKBmzpWKxW+cWYYBCW9dhdRDfUxpf6h4Nm6tn631QscG18Sl39hEE
         6F1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789053871; x=1789658671;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W02XYVTB0Nl5fojAG5hBMBTOksfDYePfH5xC6TePd8A=;
        b=rpFoVi/6c2cWfthX1f5rya5Jmzm9eXQrjUKJJUBOZeuEUCEehsC6EPUbYK94s/+X9T
         GZRwPvm/iTYvsWQN8wBLG6Xb6V9NUXiJT76QxkxF6vCXZbEKWgZWbM5fV1+iQr+OOSUF
         Dqt1L8vatB0UfiXzw5ZlDjzT1W/Yt2e1tft/IeIoXXhbgPsWmtDANElY4aWwWEVCSq5V
         UEIZH13J4g9Gdv8KKEogbunvfUtEdWZa32mAlQ5ZMV6abWQLsXQydzV0z1S+UHsH++/B
         bhbtK7Gj2FU3R42YknSBFdcTmJof+tYKjoXdFaNwNMHIdu6ZPfVLSugtSRnxa/+PqWOM
         /kEg==
X-Forwarded-Encrypted: i=1; AKwUvBwUbr4GNEgIsgeaqVtuzR2bnB9Xiy9VzGbonhXFhJDlULVPHbNmCs3S9tfprDIdmIFKyGnJEk4iCCcAhw==@lists.linux.dev
X-Gm-Message-State: AFuF++msfzrc78TkNz5BIoIziaTbp1jX1BngvRQWjei7Fpb/SgQBWEMp
	dJhS/YtZUm8CNU9weIXg6U+7YEDOqlyunwrCw1WVMKm7NXtATRidIDuUtgCDquy+neCrq8/6oTb
	m3gc0lWr1EvzUKzpJSAL4O+V7AvOVt+Q=
X-Gm-Gg: AYBFou08Xvt1/ar96ojOIXKwukORvyJmZiSCA2+BiUmWEqe44o8LeoNIkvPP5AO/i/4
	0dC1ISPbzvAiqP7S4DoUsU68nCx0hOu+9h+f8RNk8HdUn9m3wBVHxkNv97cT3S1iQJIbA0vKOpP
	NATSf0QCQ6OF01VqTsHqf5ALNAirnYhCHmyUINe9VWFDP2UdkOj8e9Q3f8d1rwHRH9UOAT3Zwsl
	CBFqgXrGHbPjSDXS9Vcqdi+PhbIifuSRJmfBNGZa48uGFd6kpq7mCSKVa+FqzBI/pA+L/LNByF0
	2pzWr9A3EsLb3/3ArXugi9M5FdYoGEEkQnNvF7Oq7byFpOrL2pfMOKg=
X-Received: by 2002:a05:6402:3512:b0:6a8:451:32b4 with SMTP id
 4fb4d7f45d1cf-6a99ccf0837mr3371397a12.23.1789053870395; Thu, 10 Sep 2026
 08:24:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9CC2EE8A-9F67-408A-87A1-62AF671B4BFB@linux.ibm.com> <20260910141524.12362-1-spasswolf@web.de>
In-Reply-To: <20260910141524.12362-1-spasswolf@web.de>
From: Chris S <coshi036@gmail.com>
Date: Thu, 10 Sep 2026 11:24:19 -0400
X-Gm-Features: AcwNN1XO9GRsWlKpqFSX7PpQbLAxVz7EBaLMtD1MZCmQjL9KwHLULMUzhoKDyzc
Message-ID: <CACd_6n2cPqmqs=Ao6yKGSzW8WxUPPsHaLJBOHGeMtKPkk6aR_Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data directly
To: Bert Karwatzki <spasswolf@web.de>
Cc: Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>, Venkat <venkat88@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, 
	Weidong Zhu <weizhu@fiu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You are right - I checked rather than taking my own word for it,
next-20260909 still has the unguarded dereference.

The fix is in, just not where linux-next takes its vfs branch from yet.
Christian folded the b_folio check into the commit that introduces the
folio-less buffer rather than carrying a separate patch, so on vfs.git's
vfs-7.4.bh branch 781bf9c7e307 ("buffer: allow a buffer_head to point at
memory outside the page cache") now reads

if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
   op_is_write(opf))

That finished this morning.  linux-next merges vfs.all with tip is still
2026-09-02, so it carries the series without the fix - which is exactly
what you are hitting.  Should go away once vfs.all is regenerated.

Thanks,
Chao

On Thu, Sep 10, 2026 at 10:16=E2=80=AFAM Bert Karwatzki <spasswolf@web.de> =
wrote:
>
> Just a quick reminder, in linux next-20260909 this has not been
> fixed, yet.
>
> Bert Karwatzki
