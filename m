Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A51D3B42E0
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 09:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781600890; cv=pass; b=cgXzSyl4y8WnoWcWK+UrHv0HsPvpDMYVympsUVAFvqQ9RMNqQeILSFucOk39hFGufTDklqxSXZqu5ksLJRAlsZmU8/I04EjIKYdw08CuXcnRvfqVrhOdQLRjNtoMLJdPrz08yGMuzD3aIQPf8Q8AthxfCOihzIPIN+tKitznigQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781600890; c=relaxed/simple;
	bh=jhrP6vNerdOVFYCsIjUzb4lcTYjfeZ7WyDwNosbxDUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UiTCuHPZ3yn1pelLzqV9uR7EhxE87IfgeOuvaVn0Raj19CxR4igwLQKzI8J6i2je20MlAwar3aN5UNqkEZov5v/XZLoyXYGuMp1xBtHc6DQ2wCCeBg2dpRYky9HBy9esces2iu3nX6uI5AxJU0KC/hqJTLKRbNDNt7c2A2bJg60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g53atmfr; arc=pass smtp.client-ip=209.85.167.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g53atmfr"
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-5aa624ff3cbso4186905e87.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 02:08:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781600887; cv=none;
        d=google.com; s=arc-20240605;
        b=go/i0Ri3EYIDGKDb/NVN3+lI9dPSlX275u/0HbiNTgN7HdKGsRGV4VVP7KyC/DZKU9
         lWrNebWCSGWTB/ZPrubk+L1RQ1xR5AlGc2jZgShHg8plzNyCws13Guem99K0GMyFWp2E
         CXuAtvWdrtcZbwOUKDl3+n0M/S3zLNqh3PaMRFeWcgtX1BqA3eI4i/usQxiq/rjML167
         NUl+alSKoUmK49I3MwDE9yfuxNmCV5tRmUrKYih6X790CgrI7PtvyoPKRfWzhLLPI3eM
         CecKwdwsEQHgWU4FQx+iuBSERZ8Vfbo4f5M2KPDxhLL3BaTbLi0iqQ9jAXHMX7CG+Cg+
         tx9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jhrP6vNerdOVFYCsIjUzb4lcTYjfeZ7WyDwNosbxDUI=;
        fh=p1XjEeacqnM+QhRfTa10bv+ffm4UsixDPt9tjbpXF2o=;
        b=kbWpplZ/b/zTvAsE7mJKJ592ueZMaMvK882Yf6BgHBygVSKi2fPF3akiycDEsc/ad0
         Fsme5rE9QHMJDzeuW5jDfI8ARCKeZHRYBhpAXzr4ZnnCTt2tngRU8mYrE4Ay+mdf/emT
         UjQNhr9Q53YqNNYPQzIXvWFaLMtEYpEw3EifwMhYC9b+JZQOgIB0gZEBqEaOdVpf2Su5
         idPKbOVl9j/zNMMiuEM4ocXabN1Wi08aXs+hXfB79LqITMoDT5yx60qMpm4mstPSqQVh
         XwB06oDE6ogHMZTWPawvXd4csKXgYbWZaSeRu63LxauzmySoK8VIMDpei3LE4bPegFhp
         t+wA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781600887; x=1782205687; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jhrP6vNerdOVFYCsIjUzb4lcTYjfeZ7WyDwNosbxDUI=;
        b=g53atmfr5oTa65tK2YHweiPMaepvISkQYfBEt80xxwVQyHj4CQNWXA5ZyPuYmyKky7
         MxuQqEBsPUfJP2SKqJKs+gPoMRvuHzmFSS7/qrc5sU96Tn/rgVNwKiLcy7vy4+Vk0NtW
         mRcQ5PHr6WDTYsfSiIiX+VUHtBXDjmQrFd/ogd9o2WaPy+AHQFwaQc+tT4JzsxjPqj+Z
         eBEgwt5ktPz314iWsF86fCi6Nn9x58jhRkztiIqRhLZBUcfnsEzJww9agK4hkP6w8yWp
         ycdwzs4ZJlXcS95ecxDVEUfyl7BAHdEZKYdTzebym81FJb1geE+fXXf0RCKH5K8NdCPp
         fh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781600887; x=1782205687;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhrP6vNerdOVFYCsIjUzb4lcTYjfeZ7WyDwNosbxDUI=;
        b=VwOELZdGI1/CAdMsU2nhvUvh1Bnalcdy1McZx8wXbxKXB5qAwGXmUapeqpVdayKPo2
         770+hWQsMPUMvdUB3hueFF740TPh23Xli3UiE2wI/ZyZRW+2QN33luoFDiektTcaNsG2
         /F6mmYf3qa5bBgKq8um1zerva7XRC5FRSHsIFLf8JESPQQPa1382PQcft0J4k9Xj402i
         2808wWKYiGK3j7QUIebfcrMMPZSdem3/ZIJgzWPrzACvoYQOQBvejpA6XDr6UL6Fg61i
         uM7XgD1pQ3CutE2ur+26ArctxnrPn1vWjPkMe49mPWalW4bzEOTLeq5UozxPRHlT/q7G
         O7YQ==
X-Gm-Message-State: AOJu0Yw0MECl453zCYzkq44m+EFBmBaHg6eKWI8iyPYHXV/WCwJzOYNf
	x8oAPxN939WLU41eZmZq0xFV3bX8NJ7s8iNprHhVgdOeKYD6Q6TjQhb76mkuozQmyurw3JgMnrL
	jAZm/UX0DQwleHkRnUQa8p842ieMbOVA=
X-Gm-Gg: Acq92OEQCv9t0YwJRQUgdjIDo2FzNjEjBIGBVm9a0IHj01J6bu67XqhtzF8Gg8iMBmR
	SnzX5sa0b56uf9v6M6mlF0GN9M2ozlaRWxy92cveiwTgZQX/nkmd0SkUyDNA3QIWgof4w3f1Uur
	ERj1Dxb+yOJCjJGDpyvXv/jnsmFrtJNFDYrLgFERsN8kD/Tm+1t0PalX+/3qomCvjXL2o+nD8Cm
	PDtxD/fVYaAkf1KBJC3kKAzFloQ2J0Bfotm+P0c4vpGpQ0zmELqRO+o7xxF+9qLxH3rrbgP2D++
	5S1+S8Sulw0EmB8NTjKJRsnnDnYul4sSNx2WnTl0u7sBIzNAWFQXcjSghkxfDshplIY=
X-Received: by 2002:a05:6512:8001:20b0:5aa:75c9:d317 with SMTP id
 2adb3069b0e04-5ad2db8679dmr3611792e87.45.1781600886857; Tue, 16 Jun 2026
 02:08:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260526034040.3602377-1-rollkingzzc@gmail.com> <92497bd5-028b-4966-8224-f2878120da00@linux.alibaba.com>
In-Reply-To: <92497bd5-028b-4966-8224-f2878120da00@linux.alibaba.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Tue, 16 Jun 2026 17:07:54 +0800
X-Gm-Features: AVVi8CeLWT0xD-9ScjqUhJ7aczNLTECLsT_ZMoXQ9CCURM_cUSipUtk4usE61jU
Message-ID: <CAB7XQsFM-W_Fg+rkXDB_zBaWqnzx2daxoL6wbjQYVsYwie2_Bg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ocfs2: validate xattr metadata bounds
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

> Wny not consider move the validation into ocfs2_validate_inode_block() and
> ocfs2_validate_xattr_block()?
>
> Thanks,
> Joseph

Thanks for your review and suggestion.

That makes sense. I will update the series and send out v3.

Best regard,
Zhang Cen
