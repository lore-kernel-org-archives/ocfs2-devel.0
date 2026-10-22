Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.128.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792659825;
	b=iPS5Zu7AgmCn7dwiZJjKKxchx/yItR3+6CIamH1FAY3fkpNnOHDXcRYeayFYzYQt/Jh+
	 SEU0m9jcaGUmpTjpRq2NzQHuP+JywtrO2qHheY78DBymiPw/4XLz/e27cqQNjUjj8zcsc
	 FTbFH0R7oiVm2DZRY7FJpF3qrBUyuXIfm7qtUfZqYDpOT10dWDtqt6dls9oU6xSVSQr+W
	 uaZglpvN4IhSf3N8BVsK7ydPbxsM2l7Lg2i42kKcbjB34/cvww7bPVTVmc0ERX+aYnSLi
	 IHwT4yHvNrJO0qgGFgTDK3NTLElCoiAtyTjpRV/bUUbH661TA6AdN7wQIOWU3TGndwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LWhw+HLJxYgscIYvU2wsKpAHdSFa/l1EBTg1QHDwjyM=;
	b=UwxlsbX+02TkGA/EtR15XXrexzvwesyctNOTJAPhDbAxoPlu+xmbU4bb9K7xYFxEKstf
	 awwwYBXq9kcBUmupaS6lR31OLBWUPGQwRwsGl96vz3ky6wMOB3pQWmCP4NZiWFs7rnETk
	 aVaxvRVlZ9y41skzT3RDV+C35xCAoYd3ncPjf49ssJtVWlwGytaOtAru7PqP/Lhi6Rmg4
	 YE/d4TeHtAQgSrnrlgVRgJJ3t+wq7DYriTv2/Cbs8yXpwzyD1JurLX+GOZW57EXfnOrGu
	 zDAwcrDqdMSnRzJip7ikkjq8lg7u7yaaZ/erNGMGmYJW6+2YNzmtsF7IiLM+Bjy35YA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Jv/AhRtJ";
	arc=fail smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0765606A321
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0765606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Jv/AhRtJ
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ac4806e210so15145737b3.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:03:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792659824; cv=none;
        d=google.com; s=arc-20260327;
        b=qPUHa+lAZGfdtYQq6peTCAXIsrzEsgHRhCR8bwwxAgwXY9grmle47a3J1/FMt+ubEw
         FmrHsa65bl+Ugin1JKTrGMsMNmFLCO0EyBNz6Yn0pKwqt0yE+TIwZJP/9gJmWefFzz3x
         o2ullNxYasG9YV7Y1ZbKXls6qGMf66fIQn9sE3fn3GZVKCJX6hW1nSuyhRC1dkn1kzF8
         RuCrlvcq8+F4xVEb/5r8pPslgtPMywVijcMLbx1O6+BTsUZzX6JNWNoBfTUaJrn/FgTC
         M2F3lxb/g5oyyMgAAEWE8GLlhf7KhL+Zv8AQ5FKqSNa4pTuIZNexm8ZKnVYi5eHOmboz
         7Ofw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LWhw+HLJxYgscIYvU2wsKpAHdSFa/l1EBTg1QHDwjyM=;
        fh=h8+PetGvnXnKOz94w3oWAqIPdyFPH40h2/S/sjL99gs=;
        b=pl6czyuiLsaFPCyHnwAS3iQepMLeCjzUuccJSN9aOktX+BdxjFbZ3DZd9i1/JJrY9c
         St4ltE3GtF3/NLe625zOr2btZbe1g0kARujBfS/M8ieEc1c6IoKaBMAoC3dRofZrXT86
         zShzpmLiRk2D//sNzsgUQRcATj62Qbte6x+vw8+tGaFK/T9NMuObGuDvCHpozrcr8hq4
         AnnY86evyQg0DQxyQFVnGIF/MylZj4kAo6ekHe4G32KGoXHryZo3iwF4N+WxKwQZw1QG
         5d+dnQBV4LPYtgq+wNlS6+I3RJh1bIEBNvBRrTJ0e9rr6t/EDg909h/Lcypj2og7tTxu
         rlIw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792659824; x=1793264624; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWhw+HLJxYgscIYvU2wsKpAHdSFa/l1EBTg1QHDwjyM=;
        b=Jv/AhRtJ/Hb6dPNtNNXqAYjNj772s0aZrAPpKzfsRGhps6OcVutXvs4A5wp5tSLdDZ
         f64aTi17v1V3kSWRsvTZ1c+fXuLgzwHd+FtDGJZapJB0r5sgDJrV1kOIb1Sje1JdqXk9
         jpZgb7QGBgyJUxRD3CLhTa+aCsHGt8gTKUgcZFVBnhpc6VGIRbAyUPne/WaZGdspmhhW
         LuIgdwhw66Flk4G98696nYJQFTAV7fG6WRs72v0xWwtBr3gCImWK85fQcY165wANU8/T
         cWO4+inMocr+2oBXAORDMW9JQ7u2qIPF1VTraalclTFfSv6FkW2yYR689wJ/fhPmRLKe
         MKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659824; x=1793264624;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LWhw+HLJxYgscIYvU2wsKpAHdSFa/l1EBTg1QHDwjyM=;
        b=parj28oaaqnM2Gy7h4KJ3x4pm/ey5hhJgFJN5I50DyOjFiHwlEO7S1rmkOaj8sW5FY
         Z15kRWC5WBjxyQ+MKCmpM4nkKcAVJ7T2+LrUBMvgQDCOzvi6LXrN6EZjODAilZqXYIL7
         LIizYODA9rwxsHwQjBq/JZm+HWk/I+ooi8R6Sk3gNNdPeolXib1MR978wEvE3D4gN4vY
         toR0Raj66c8f7U4/wwQ1xnDRPOA1EZlJ9o1tagMdO5vjKtwPNZiOAK/C5B5Gpdcgu/cH
         m9vn1eV5CY/dkhJjh/umiZFwkdAPHfDpdeM6eE7T4eF8Gy/7wcuHCQL2RxQe8c0tk1gQ
         NNvg==
X-Forwarded-Encrypted: i=1; AKwUvBwt5HUjl21u0vuFx+hORk8SXqBf/iOdtXLqpbWu6f9A8nhuPMO8Ai/qviR6JVJQoJOZMg+qrTKMeOyo+w==@lists.linux.dev
X-Gm-Message-State: AFq9FYJxmmKPQ/wPBCY3eyU3x4nSruNHYo+K9BwWlodw15SQ9U97l+xZ
	ehk5L6Yng98WYuxJto6yK1aeTje74e62fIhCK8hqcYlElh51yRVUUWZVsPLfWwosuUumRIwV9Qc
	Q+NQEDqmIqzfFOW+kBqVBhDSdCdmy6/U=
X-Gm-Gg: AYBFou2OzR9Kp1oM1+DnVFV+TOwpvhAI4QkemgUFcoNqVn9aasNgKFem+iXX0WbACLR
	bJnGp5JoDt/fNWztfrTiBjEdL+yhp+foH5kafhoSNgjSYLecwJpHmrlQJSu0dg2GkYj8v0QC7+k
	T/Gxnhcsro7ldNLCbQCwcuRHhHJdShe9LMnxXhS5o6nO4uvNQdgC9ZywXPxG03JMx3xsc1p55DP
	NEz0L3NFEsuVU+PYZH6iiQtkbLQTPW1uYkq9BThlbnnLFZ3P4D3lUktymsB8kBCqqFTJ9tDU2+x
	5CWvOH01xrEtPyhtZpNmiweUf2+L6DGAeZwK18h+Ry3N9Zn+Q3XPoOX26ZlfFtZ9wXKcMh0/WL4
	pVdI/bqcWNsLYf9gJZ1PyR9ekRtDvNNj5blzzyQ4=
X-Received: by 2002:a05:690c:e3ed:b0:8b0:d9a6:dbcd with SMTP id
 00721157ae682-8b13406330dmr30687627b3.48.1792659823756; Thu, 22 Oct 2026
 02:03:43 -0700 (PDT)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
 <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-1@gmail.com> <9e071e7d-ae86-4b55-8609-1f00a0deb913@linux.alibaba.com>
In-Reply-To: <9e071e7d-ae86-4b55-8609-1f00a0deb913@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Thu, 22 Oct 2026 17:03:32 +0800
X-Gm-Features: AclHuK-h6BXGmIG1OsOHu9Jb9Mx2Z8xCnybGzVquX23jnd9uB-qla6UpJFXDbIM
Message-ID: <CAFRLqsXgk51QnjPDoZ+5JmLSrY_M0RWPtc0bMEAqt3Ee48J0UQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ocfs2: snapshot dentry names in file-operation traces
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

> Seems ocfs2_setattr() also risks the same race, and it is missed in last
> review comments.

Thanks for catching this. I've added a name snapshot around
trace_ocfs2_setattr(), passing both the name and length from it.

The inode lock does not exclude a same-directory rename of a source
directory, so this trace also needs the snapshot.

> This looks wried, the inode is dereferenced above in OCFS2_I(inode)->ip_blkno,
> but checked below.
> file_inode() returns filp->f_inode, so it seems inode is never NULL here.

Agreed. I've removed the redundant NULL-inode check from
ocfs2_file_read_iter().

Both changes are included in v4.

Best regards,
Cen Zhang
