Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B3A345CA1
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Jun 2026 23:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781998000; cv=pass; b=mgLNxlmZDc1VzepmZRT+S6IT2ez15tplmHvKdDeTkv6NKywxN2yIWiAZwrw6ijSsAxttKnVd3j63gKqL0qGAztmH872nNA9RzSKI4crdCnXLykfUNzSiQPQpw1hlr4WzU35GGyC0BTH7uZgq8Yhe/p0iRFx2oDi0GpQUR+RTnZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781998000; c=relaxed/simple;
	bh=p7A47r01QLLxvPJa8GPartZIvuyI0yW3DvDkorSmJIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HOTMr0YWChrRzXiXv5loA7R7Qmacs9doVPzw2GfQTkNjLIz4hN787xCY0wNAVC1Tf8og4Y5F89Tox9/euTuaZHMop38jUw454JdQzJ0Vvz4AWjQk8IzztjpW6uJRzff3Vkgx0MHWnig0xo4wcf8gVgWd3ayd8ayvKsZOuRvQYbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oGcWa//b; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oGcWa//b"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-660323f7b27so3542385d50.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Jun 2026 16:26:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781997998; cv=none;
        d=google.com; s=arc-20240605;
        b=X2aK5910q21QUrXFSuodK+GQlCVVwHv3ujhXju18JXPWQB0B7FYsVPQgl3y+LdAro7
         ncKMJrxCrtWZ4lGLQkyHkZFfyN9/oMcLaXlRyCJaojrVRRjj5EvywCFClTDvy0hvz2tu
         vwQiZ+YLaP2swMPEiYAOF/i6KA8gMrGcNqJ0tupP3f2hdhm/lEUsXDRFEf3ICJnNVtgc
         HG8Ij+EMQB9IsklaDgti85ZB1ZTMAF7EDanJpdAkDPUsDZjuKIYTZRC4sb9EeCF3QOKV
         Vpjcqy8GM05MUrXVIwA0nGdvHIXG5r3bfBLqvqmGr5CxCU/FdPMtlqvoE4TiAvKtm9aG
         KBug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y/VTsGzs0OyEB3v9Q0VmgQrEz1yxfxa7BO8lFW7ZSrU=;
        fh=qBbwC1fErC1tRxtUFcoawfFJBM6YhgRxEJiD9MmPN7c=;
        b=ZMvLRGgS0pZzGBWbB41iQW6fQkjW1HEpDXbSGEA4qZZnM6oa10m5PeztraIpyjuupp
         DBHTxV7Oa6mtJHaYW7eg+tRYZuU8Jz77TIjj+c6/a7o79w6aeXe73CjUiZbf4R5LAIQ1
         Jdq+XpS2DqgIxvmlOH9XuRyUViW7WlSNOc0xAp4dNKJmGc3G15W7fUt6wPu6pO9cwEd6
         E25mZufGdvnlo9Vnf0uI9/xW5GrzQb9Q91jRanXFjO7qVs0QMZAXth7FH6PLOTvfswFj
         ZCGrYohCuV7NAxFIubM4Wr8Ov92V6PvSZZSlhlRfA2AvHKKSMuTefka2cWouNDph1OdH
         CT2g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781997998; x=1782602798; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/VTsGzs0OyEB3v9Q0VmgQrEz1yxfxa7BO8lFW7ZSrU=;
        b=oGcWa//bGe9FW8+7z2/BxlAIgTBkhMA2IAeJPsZ0++vvj4p0TtFhkGbJ4fUywEbm5S
         S1+moCyzs4dJ7Kw5i4zmqh7uF7j+LiJxW38KE9WblWZD/iYo0lyKucOhuJ7sEWmQMle5
         0SKyCBNuLj8JMD5oBbBY1oaHSsEnHggEvxLjvKsK2k0pKtIN6kDeZn0zvh959jusGGF8
         yOXI/H9ZOtS1lPThJjDTJOO3Cc69Ou0L4nBoBwJbS+Bvq+grg7rw7uEZpVEZO6NfTF0y
         mcA5uTkJfqMy1rpdQsJtdY7p6g+dr9aFUUg5TUHdWCvHyunei7oRLvpE8HQ0sVwzhqmk
         GT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781997998; x=1782602798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y/VTsGzs0OyEB3v9Q0VmgQrEz1yxfxa7BO8lFW7ZSrU=;
        b=Jg2ZaR9g9kqP5Ec5YXcfUW4ZnnWkuiV8k8d/vNoCEnaPNKGjma6QpIksFuojxeHUM7
         XOnL3ktGsMb19D/n5CNdnKjfI7Zcym2mAoEpMpn6UbRY5rw5/decjZ1E0x0GyG0hU0Ak
         rOO/YYZ7IU0AQ08wDfeGfs9LJjkSI9ZJXr2SHkQy1ZBjP6K359XytIuJof3VL9VkRTw8
         5ANuIdsIGO3zQU7XyRRXxC7NIpWacnjSXfbML313bOxAhxu4Rqw+Ut+L/p6AKynru8Cn
         JOning/Yx986PcigoK7n0ApfCHD6A0IHe+Ik80a3R0JX+hssTTqCdu3nFQMuUs6BEIVs
         /PIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq05/5SBpt37Sjrk+ije2RtB1W1JngQhxgSFq9EJqxvsL7WOQafa/4H6/DnDU4yNZZn9On6Fcuhn+HbjA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxeIwO+/YsghfUx5kGLwLGXtDpqG1c6Z5qLisDg0krWc0hbfjl2
	5YamTbm3MfFh6PJUMkvEgRFNNu9ha/jkDd4NKVpiyjIJUcAhBP9/+aCtdundYhwBedeCsMGWLCK
	QjL8HFghG5TtIJJy7sIhyP3vy3T4AgLHyzHnF
X-Gm-Gg: AfdE7ckODWXexVd0mrA2MpkoIaFYHp+jidU2Jj+sLcejArzYUFIY3yP3DCNSpJulXGO
	lnJFIMgIJM3R1pPoXOCxIPD0xVtLak+XYY6ZkiiuCSF5kNDCJrHL8RWx6BtaqZ72mMQFHRW25Qs
	tm1nXwhsQEg3CshFyvLUEReBj2/EB2eT6VvaBoVl8AEa+8JslfhH8PC5G0Bg/Bg9qcHtLcPNLIN
	jPAmtNsfYB0ZXPeW4cY7CvBcwwVHtgXPZQZX8AFyWCmbyKLRhT1ieOB1/zmBpjTtZkX3Py6HEzn
	0bInDZkAyUfomXf0fvpTpzWW9l5Oy/WjKDKHm+Jf/uVIfGlQAyCfggNwglrgkhoGHD0qbUq9
X-Received: by 2002:a05:690e:2251:b0:660:60a9:2b20 with SMTP id
 956f58d0204a3-662fc678571mr7897226d50.16.1781997998246; Sat, 20 Jun 2026
 16:26:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260620080802.35165-1-kartikey406@gmail.com> <ajbVDMX0mSnLKe2X@casper.infradead.org>
In-Reply-To: <ajbVDMX0mSnLKe2X@casper.infradead.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 21 Jun 2026 04:56:26 +0530
X-Gm-Features: AVVi8Cdt0nLqXewdAJjUwqYgz5xg7xyNbEB-FkrRzdLGTwWLchWlfatOaCcEbA8
Message-ID: <CADhLXY51V2kQqKefy-VgUayYBCHcyk8vPTCq8DWCDgVS_cG3oA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix deadlock in dio write orphan cleanup path
To: Matthew Wilcox <willy@infradead.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, 
	syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 20, 2026 at 11:29=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> This seems like a false positive.  You can't call write_iter() on
> a directory, and orphan_dir is always a directory.
>
> I would suggest that the easiest way to make this warning go away is to
> replace inode_lock(orphan_dir) with inode_lock_nested(orphan_dir,
> I_MUTEX_NONDIR2).  It's a bit quirky because, well, orphan2 is a
> directory.  We could add a seventh lock class to
> inode_i_mutex_lock_class, but that feels a bit excessive.
>

Thanks for the review. I have sent the patch v2 with
 inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2)
