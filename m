Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFE23D7CA
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 04:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761798162; cv=none; b=BMacPcvvrpmcdG/tiV/Hpv0K4F52XUHUM7D8luLHrAiuqbzy6eyGz3L8RLWcyN4udMuw2gZ1IF8pxJbm510sVgC6iQHOMK7KrOuY4WYrbTjqR/3bPUTq3ZJWuRuqdOPinKdHCxKf+EJn9zabz9sM5YFPFX17x8HhivHOQY3Q/Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761798162; c=relaxed/simple;
	bh=214fcSrSHyVXNOEVqraGy8obso2RsicGxDlSlyHUr8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApM9S+B8VoRMdVWmPMZ+N+Bo0viYR8ese2PrGT7z90t5HGu2VkyZRp9uhN4rd0v3g9s7Ke/SYuaBXGz6mmNz1kM5ULH/Htxn0Y1tCkrI8riyYVhnr7T2QKn3rKQeaFrlFJa2BfBKKPJ/0lA65wsQ8QIgV56hVaZVcjAOZcwxlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X0T5QKPh; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X0T5QKPh"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3fffd2bbcbdso58176f8f.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 21:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761798158; x=1762402958; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=80l8HB3/f7pKuoPDVp+UbiGYPPoQR1U2LqmaLtJnTi0=;
        b=X0T5QKPhWWX+W3iDTynYTXgwDb9sBlHgoVNT1wF9anbg/Y9TIhdNpmejUYHXgnI4R5
         m+V06T/7aMkDpTvyrshq4E2pKn+mo1FJsxlmNkUqD+PRyJCl+SDsPZku2yBdwC94/wmj
         C6ACHB2J220atcSfdDni8QkcjpAsfAr65ovLW6BEURp/1EWTCFxmuBBlxH4Klwo05b2R
         KiMjoccH3QZpJlmIDx4/WT64JoKuakbj6acowRo+sW/M66jOTrLvzTZMYz4D9059jRdH
         kj6v5jzwrgNHUf3vsLvoGrnX7wJDbMIvqzJ+LHHtNX1WLNcbsKMGuy6mWDHwK8WGSXEG
         wpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761798158; x=1762402958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80l8HB3/f7pKuoPDVp+UbiGYPPoQR1U2LqmaLtJnTi0=;
        b=DiUDbT2X4dA0jRFhKrPiu8UCfP+j2Q/6eaP8bN1AbWco32EZtbOmo9d4qbeAhTJHNG
         FAaCDCNge+cs0zYx7vlMiH+G3hYQczO+uBTfT7lhv1KI/G38vXzNJRgYe70xGK0t0C1D
         G4R77wAye787i1I6FskLiz09/Wskb8WmOwQcvowWyM4b5diBL3iNYMs8fEYfkObijo/u
         HMuTjf0t51NRBeHrUXUV76akvRR6+yEo6UIDTw6sTad5lj64qsSyUwDlRCnEEKDBHPmi
         R/kUwbgMDVsSuG+7LGJ5YoobtsICef+L91hW6cCs9GoSF1OzjxrCTabgy5qq7OwHfn8j
         TUrw==
X-Forwarded-Encrypted: i=1; AJvYcCVNn5MztnMi2lHtVAVyrkY6bOK7KR1GoH3TIICq6oEGUVamsAYwqOvhyWrbKxVILR2qvZg2mqfDy1p//Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxzyK5lb/jHc7tWelgyuwflAb/d2r9kXcOf6S+gNWOQo5PWWZHJ
	ZA0lNnAuYmII7xOKiZVxhVmO6Zz/Dk+AEAt9u/1xXKdTaZABv7cwtAMYC9Jy2Ns4PCU=
X-Gm-Gg: ASbGncv7geZOKUKh6k2zt6I4ut3hfyW0fNixEzrjvSUFSpB1J1keCPmSwmEqWlE7ige
	yEqsS65A05n0KA8HsraqkbwsskTdYzIS5zNLScUGaJCY312AOTC7AFHXNS9L0C4q51nT8lyvRsb
	i4AC/vhzYsVi0Dw5Xp+u/s1sPSfCMdkL8ChG7eFHtRauSQ1mrY8J6GjdSNLjIF5pOG9ueMNrrGD
	G+QVTCx8HLSLyQ3A+s/8IQw0uHSqeqa5r/pALEGYBj1Cl5+3iCmxz4adPPuXHUuEJamSkoi4D/u
	I63HCkcMe0lqH5xDQ4hvfbGvx+XZ4rENHpzE7mUux8h6CAEYHMegLDcLh6pmVWvbaOR8e9rUUrc
	AviBXaxvG8UpiGRQ8+9bzfFR9aK4rqBsoLSRhuPa6+8BAPEytV2h0QHlQms5Rw+bj7SFM4oqhSY
	I=
X-Google-Smtp-Source: AGHT+IGdnTOP53/uGYgDxUyDqiHC3YFbNP4iOn7qeQ83h9kR71WxhMAwdNpBmKwbHYy7EoDw9reBYg==
X-Received: by 2002:a05:6000:2512:b0:426:fe0a:1bb3 with SMTP id ffacd0b85a97d-429aefc0392mr2108479f8f.7.1761798157831;
        Wed, 29 Oct 2025 21:22:37 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d4254asm173630815ad.82.2025.10.29.21.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 21:22:37 -0700 (PDT)
Date: Thu, 30 Oct 2025 12:22:34 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to
 prevent divide-by-zero
Message-ID: <x4g7symjachxmkyhjqx5x2dfdn4ybvfkbzjvqiso7qbtxdgov7@2xds57btyzt2>
References: <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
 <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
 <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
 <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com>
 <CADhLXY5QK3vDcXhuW-xq5Bd72uPCVA1MeTnxn_991irOmvhRCg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY5QK3vDcXhuW-xq5Bd72uPCVA1MeTnxn_991irOmvhRCg@mail.gmail.com>

On Thu, Oct 30, 2025 at 09:25:12AM +0530, Deepanshu Kartikey wrote:
> Hi Joseph,
> 
> Thank you for identifying this! You're absolutely right.
> 
> I see now that cluster bitmap allocators (like global_bitmap at inode 23)
> are intentionally set to cl_bpc=1 by mkfs.ocfs2, as they track clusters
> rather than blocks.
> 
> I need to update my validation to skip cluster bitmap allocators.
> 
> Looking at the code, I'm considering something like:
> 
>   if (le32_to_cpu(di->i_flags) & OCFS2_CLUSTER_FL) {
>       // This is a cluster bitmap, cl_bpc=1 is correct by design
>       goto skip_bpc_check;
>   }
> 
> However, I want to confirm: is OCFS2_CLUSTER_FL the correct flag to check,
> or should I use a different method to identify cluster bitmap allocators
> versus inode allocators?
> 
> Thanks,
> Deepanshu

ocfs2 doesn't define OCFS2_CLUSTER_FL.

I used hexdump to check an ocfs2 volume. the di->i_flags is the same
for //global_bitmap and //global_inode_alloc.
the value is 0x491:
 - OCFS2_CHAIN_FL | OCFS2_BITMAP_FL | OCFS2_SYSTEM_FL | OCFS2_VALID_FL

One way I considered uses the inode block number to bypass global_bitmap.
the code seems ugly (demo):

```
osb = OCFS2_SB(sb);
inode = ocfs2_get_system_file_inode(osb, GLOBAL_BITMAP_SYSTEM_INODE, OCFS2_INVALID_SLOT)

if (OCFS2_I(inode)->ip_blkno != le64_to_cpu(fe->i_blkno))
  goto by_pass_the_check;
```

- Heming
