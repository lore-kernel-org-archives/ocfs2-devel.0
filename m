Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792856347;
	b=s2rkm25GKXslkFGdMYsefK2peEQf0a5/bCQ6VhrgsmvqZszFHhu3fzc6kp5oegkxnvTF
	 iiL0pr6KhESzKVkMce5N0FZcNniRxHg0xaL3KGpQ2U2IHcg+cQZAixN4vGKrbug0yEswP
	 sFeH5L+2JnuRV60H75KcnEv1uBLeEpTAFfLKfXTva0kH3KErCuKXqv4yTO4oI1Zy20aws
	 y7+4H6VpnybaUVCGb2DyqW1FnyslT00XUngcxYXIK7RAGhllGkUHl/QmGU2KIBfJIuHkq
	 9OhTkVQXAA9Z5xcPJVAek5vgkcGILWHGOiCDdOGuYg+v0g7PYgQAcH6LZLb4K9n5MEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vK5pr9uyYz2jsZwQQgWCPkEz3CYe2XwtN4i5/OMooOs=;
	b=fwPgKpRAnL4CypHl8srrxSV/+1Te0QkIrNSr6Whc4aAMvG48DHv0oV++L8hVOZomx/WD
	 CVqhX03rd1PsTnGzh5uH2wbJklr/6q4+E65zQ+wOfiBKIxAq+IT8iLXPIDG5dfS9BVPlT
	 Cb4qJu92WAIRFiTHqpRdpA73UIlrsYScqjL+iWyRifhdsRjTonzP0MCB4yF9WPjLSVGsA
	 AtMAOa0l8jxyBC6yVdqjjqQ8YnSP8y5F/pkIGVpH29djY4HpVJzWNDVjPYfczNse5Kd9+
	 dcCG9kD9mrCGEzsdhhvyRMmFIyzhSvbDNTrFQpGhj5fBT6ikKMFg/DiM4vq95H4u31Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fbWcRt3b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4487606A31A
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4487606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fbWcRt3b
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6798eb0d13fso1974329d50.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 08:39:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792856346; cv=none;
        d=google.com; s=arc-20260327;
        b=EOG6q56W7f4x19LyVFWL8X7MSom50YZDZCkR5uV7zAQazx3h95MPN2/K7ExQ2Rs0k8
         94qx8jSK/mrhdJR69V0OtF7iHoNEKMAJEFVg+SrUe/AqpAXKJvR4XA4HZ8qlKHoHEPPd
         11TKv6ee7VnzlzQGrTPul3SLZvbCA4xkWp2vda1NaqotE1nMnPBv81nxhkG7OmFr6q3c
         4YmiyKUoglUEGww3d67duRt8v5LMW6F7ZnPUGycZbu7TBAD7DNV1AlEYc54nZF+YHPSi
         7y5BVltNw7BO9NsCqE+YDl/qpld4T87DhktH88qdjucFnL9GVyOmxdljIPfYdPgFTyK1
         h7PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vK5pr9uyYz2jsZwQQgWCPkEz3CYe2XwtN4i5/OMooOs=;
        fh=NtZHyS7K7Bz3caM+ODRquSAzgV8dIXh60rUSMtIg3O8=;
        b=Yo/P9B7Q7tQvWu4dlsm0g/9HpLGHH61G7/Im4D2tPVFoOgaVOYDJCLEU45APBlJmiO
         b4f0+rKqurS8ZBOIrnOlC9lljnnzU+dpujBSCyaUp2ugakA7j2LaEGUgYnY0adD3sl2Z
         CW8OJE4EAw6yNkJdJ0Eg0yK43jlQXsKNE9xn7gor+ezs/vgQHrO/IG+zkTF/rL/gASXS
         +Sa9minzkC9PwySpK/1ykFnxrKTCwGQrAcdbc7pt7g2UKiLf0IvQYLiGKsuSJoamBdcO
         iaY1dxRtTlseHS8VnjtYYB6VpAe6JPuVfh/4qiQUQdNFwI7PG1fAKTCb0XsFM8cxIwlI
         rBhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792856346; x=1793461146; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vK5pr9uyYz2jsZwQQgWCPkEz3CYe2XwtN4i5/OMooOs=;
        b=fbWcRt3bHtwMuK5WmB29wpNMX9V6gS1LGneeNCddHGXhgAv2c13O1QmwCrqlbP9DW3
         nWxlLKGaPhDjSJa2cEn6VagQjevGXc4Fg6JQZz8prawb7HUlSCmyTtvE/vuhUDYIY0YJ
         z/vvjVRUDrDvODCa2AJa5iGzzunDI80s42mO/9dLRNiElqAksB0kQQ/JfeHgoqkt3Dns
         4Rmgy/Z3ZqdQOuSkpt9smQKhF542kJWy4O7xiGyrJsIGYchfHgXBNR3Eagef2fp8241x
         YB1C/22NbsEeHmFJxCRX6G7K0G1sknEnVO6M5oUU11YOtpcu9m1viN9pGrC/ujygk0L1
         4ugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792856346; x=1793461146;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vK5pr9uyYz2jsZwQQgWCPkEz3CYe2XwtN4i5/OMooOs=;
        b=gZz1ZKeYagYI2p/v9gULwbu83DEDVLMFXRBSZEYnW9xwPAjUNP1PaahnIgTeNK+7hP
         kkR1t2BCdXNj+3m54mD9hzmGJKZzyuYOHPoAZTYN/Clmwk6+WYu4LDOJBKrl8HNfgG05
         tmlXiM6awz7mlZYFw+YjbzjYcPkEe5vGLxzI9n0mXnl1Yxyb6gJuzoVgEmS4L+Omfzyd
         qEifyx+AQdmmkZYoGPxlzSZfavDxaOuusv9OlrhR1JWb5AfywQ0HOgomp6XLmSjG1Jh1
         q74ERhIn2p5/GHfi+w0ja4bAEddskI6FlnpPRcIyuBG4llAR0fiLIsdTTllpYjc68v9q
         /EKA==
X-Forwarded-Encrypted: i=1; AKwUvByCSdQ0Kn4W64ipVn/rLLde/FF4JVlTU04PlsPg5OuQOpmQj/DUz69r/jU4tiz5IgOpgQdl+n/LRu3oQA==@lists.linux.dev
X-Gm-Message-State: AFq9FYLqDqUsapFq6NjYYuiPR4qgETtPKahS1g1Cx1+3BCbj8yLQ/vz3
	VgI6K4rBYejmQ8GJYcZuiY6O9Pr+AgB9oKQIvoki5F3zx1EPa2va10NtDJ3SIgXIF1yRxUX9WJv
	wr5nDptHVWxFHa6wp7qeyztmRWEypRYE=
X-Gm-Gg: AYBFou3NNvdjscKXZP+hmTSrD4eF2bwzHl3eNkRTOkcspT/6DZpWpJxnW9ECIXFOf5Y
	mD3INAibUpJl5v72u+knX3/A2jR4C7WNrPanglDBXxMizG+XbDuDfg8X01Klnt5nPtBEPO939tv
	b4sDDzVNJKKtj9z8RDJYs0Dg31oljlKFfEDYgnawS78zhoOn1RVcO6iUJXiCAH9vPu/BQGvjKIB
	WItKnljaoKMIWb6odb51OOk2cTw38IADDzu5cfSRCGNWnyfiEhYDJMdl1HZ7zxek2q8HLH7WNch
	jm0g73FHBNcST1G+QRluJ8rTiMU5nf/pDmhOg1DFEio7r+Ekj4TGwTkUVGDDDaL+Utb4hWwb7mj
	N503BZtKtGlaLdSziRkqev2uXgJB5BrEl1XsRWOU=
X-Received: by 2002:a05:690e:4193:b0:67a:3417:1747 with SMTP id
 956f58d0204a3-67a454179demr1093499d50.106.1792856345704; Sat, 24 Oct 2026
 08:39:05 -0700 (PDT)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0012-v9-eeb9084fb29577971229@gmail.com>
 <31b48648-c157-49f1-94d5-d1b927bae1c9@linux.alibaba.com>
In-Reply-To: <31b48648-c157-49f1-94d5-d1b927bae1c9@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Sat, 24 Oct 2026 23:38:54 +0800
X-Gm-Features: AclHuK-pel6d6vEds-ViiTQ9UC2ScVH00hRCkn1-aVXEOr3Df3HDB0eQcYBlZ5E
Message-ID: <CAFRLqsWiioFrCmXjzmrFaRBNH8b_JryTgwdPrLie4AF1GbKsKw@mail.gmail.com>
Subject: Re: [PATCH v4] ocfs2: cache the mount context for dentry lock callbacks
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8823=
=E6=97=A5=E5=91=A8=E4=BA=94 15:09=E5=86=99=E9=81=93=EF=BC=9A
>
> Don't see any difference between your v2 sent before.
> BTW, it seems v3 is also missing.
>
> Thanks,
> Joseph
>

Sorry for the confusion. I rechecked the early inode accesses you
pointed out in your v2 review:
https://lore.kernel.org/ocfs2-devel/018d8feb-2e63-4a73-ba36-10a5f94f3341@li=
nux.alibaba.com/

My understanding is that these accesses have the following lifetime
protection:

- ocfs2_dentry_iput() keeps the VFS inode reference until after
  ocfs2_dentry_lock_put() returns. Lock teardown waits for QUEUED to
  clear if the worker is already running. The rename path likewise
  keeps the source dentry/inode alive while dropping the old dentry
  lock.
- A final put from ocfs2_dentry_post_unlock() runs synchronously on
  the same downconvert thread as the worker. Recursive processing
  from ocfs2_mark_lockres_freeing() sets FREEING before entering
  ocfs2_process_blocked_lock(), so the worker is skipped.

Thus the early access does not rely on the later extra-reference
check. A zero dl_count can still coexist with a live VFS inode
reference, and MAYBE_ORPHANED still needs to be set on that path for
local orphan cleanup.

The asynchronous DLM callbacks can overlap the final post-unlock
iput(), which is the separate lifetime window addressed by caching
osb.

I incorrectly moved the orphan marking past the extra-reference
check in v3. I reverted that change in v4, whose code is identical
to v2.

Does this analysis miss any path that could drop the last inode
reference while the worker can still access it?

Best regards,
Cen Zhang
