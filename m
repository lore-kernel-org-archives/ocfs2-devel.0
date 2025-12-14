Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B371B243951
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765720568; cv=none; b=jc8C2t2idHCD02CCoFlDx2nSsJSXCFF3LX/GDCVa41prGaFq1yQfHAta7K3Df2zG4yjkg7vexikGQu7FHKBrFVoDD/I707h/JKGlkewZutsaCfOKg8t9XimBHrmMLtuVaxH3XYFSiuPOAsmSJSA7YWv5s+DQvKakO0dn38Djs7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765720568; c=relaxed/simple;
	bh=wedzmxq9vRGeFWym+k/7YqocDl1APLkqXKwn22ekS7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ybnaa4uTQNJmzz/wQsgpg28BV1mo5WnSPxA0gEownN3hdi1RcVoe8fFQlM/b68GpEt3WlQpToX3aKJGQ0W6dR+uAGX5VBsfclrwZCT+tDicK0uYrAJBQWURYyTN01HAfD2QuWFel08s+GP0vTqrgES5hv6wwdGnpDXF6b79upEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AQ1+b9zC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AQ1+b9zC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477985aea2bso2431455e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 05:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765720564; x=1766325364; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w/kWZtfqmu/7DDkSydk2IW7goxHu5lFJdCvOdUo1JPQ=;
        b=AQ1+b9zC1M5Sp+jIhZBWVH4a125Z8Ai1Q+bqhYA+bij3ggxl39YYqSPnpl0dZz415K
         E/Dh5+Hy0wm2qNewNUB3eZaJp3TzVOlQ8Pv1VpnB9aj7RhIEN+Bq0Lf7W1yOMpwya69/
         CQmINOfIDHl7Hc2xbZXBifzeobhOlBA1IZkwIOdomOem7IfFUthUprNYDNKFBfgBpaTs
         uZzr7qh/Shv+BVqGuqBMGo8TcOcQiiAL0mhWu6gOB3yXj0Gbny7N+3OPAwOci/ku+GU4
         jcyn8VswqdR4H3V64XcQXMxYLKYp8WnvQ1u2/ruL+jW+hn/4Ec2UtHATcFhn2lcJKrPK
         +w5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765720564; x=1766325364;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w/kWZtfqmu/7DDkSydk2IW7goxHu5lFJdCvOdUo1JPQ=;
        b=USsckC+hxzLF9AzEfb/IHkZ9dyepEZjvlxsFGz2/8/Yu+qYZjPlGJ75aP3TK4AdxAV
         VC3R/w6itmvmvthiiQvZ6Jd02cETIzSrAnlYVdS3GF0Q+DLjBp/9xOeRyxoah/rnZmF9
         IhlS4jeG9Irg+aEOP0k/8HY3S4ikfF3OuBu6qsjiAbZ/EgSTSaSf3HWF0rbBHt/Wkcsx
         UL2XC1d2HvScUavNKdelELyMeVcANOu46SHKfYJu15Pyh9+qNdNpfimPFY3NNkgrZrAL
         u+kf5glpXRSqvyWYxoDFP/z8/paHzM5yvF1Wlwwmmhx0gPbZNqaLC/shDoSWDMc7Kvh/
         uP/g==
X-Forwarded-Encrypted: i=1; AJvYcCVhvjRJ7+fYWZXWH5Hmraau9GBGmBPPWr9UiSVOczzHqLYLpkqOlBi6E1d/LyfI+cDw4owY7lWj5kQg4g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxVFTIokKqope1O/k0RppqP0qDWAnkzUy1LQ7wjhFGSxNe0ZJON
	Y8nSkgUopddrl/eal1RB5dli5EiYgeW8ttnTthghegMBsxfy9ykBcNWukvLHjOaFmBU=
X-Gm-Gg: AY/fxX7uKwAdhXQKho53MJbq1jLjpZrdZllZ+iCV/+fbYyHc0wdB8+NvhgCzbwTFAa+
	TXJ4E8nyXrW3wLlhUGppv0cQAisNzN5C1VM9oC3nsQlO09ZeSOx23NSF+GwBf+hMS4Rc0juzfky
	m3ZuokGiOPDWJVqgD097p2h9nJIUj+dDsijEH8PrHBVxpU3SxillWIauPzbXPHk9zOf2H6Xl6h8
	aB3vfPTo2W5O3O3T3jjAvgXLdUPUJSxkWFc4OdAXEQcwnHTJIQcWm8hNc80iztKAeEs/B8505of
	XG4YKJsckHms/x67a8+FDIgjCEvuceFq5yZ/ofF/K0uUg5UlhT+G3/XW2hn3/eB7Au/pzM5WWUO
	zA+DCBQVq21Vg6uDVTUr7kL0L+zWBWR1ApfwuNoCxSNa93MPY+MC16ktVbFz2VS2DSWkyuTMIe9
	G7b2veNQYizw==
X-Google-Smtp-Source: AGHT+IHb0o55kPmmOQd3U8MiGG9aDz6cvWX0+o6U7s8P6ghMHurFFp1rm9FJu/Ywa84TrLMV6XYv0Q==
X-Received: by 2002:a05:600c:1992:b0:477:c5a9:33ce with SMTP id 5b1f17b1804b1-47a8f904696mr49928085e9.4.1765720563988;
        Sun, 14 Dec 2025 05:56:03 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea0169dfsm106820745ad.51.2025.12.14.05.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 05:56:03 -0800 (PST)
Date: Sun, 14 Dec 2025 21:56:00 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Mark Fasheh <mark@fasheh.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, joseph.qi@linux.alibaba.com, dmantipov@yandex.ru
Cc: Joel Becker <jlbec@evilplan.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix xattr array out-of-bounds in
 ocfs2_xa_remove_entry()
Message-ID: <v5k5n2txkjo2hngffk44aa3noqdwt2mnpy6fueoc24jhng55y3@ms44337i4j3q>
References: <20251212190631.210139-1-swarajgaikwad1925@gmail.com>
 <CAGe7X7nY5iFFNmV5VT5Mji-vknFgi-cGeJYn6U7z5HcnCr=mBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGe7X7nY5iFFNmV5VT5Mji-vknFgi-cGeJYn6U7z5HcnCr=mBA@mail.gmail.com>

On Fri, Dec 12, 2025 at 03:18:06PM -0800, Mark Fasheh wrote:
> On Fri, Dec 12, 2025 at 5:36 AM Swaraj Gaikwad
> <swarajgaikwad1925@gmail.com> wrote:
> >
> > Syzkaller reported an out-of-bounds access in ocfs2_xa_remove_entry(),
> > triggered when removing an xattr entry.
> >
> > The root cause is that the original code decrements xh_count in-place using
> > le16_add_cpu() before reading the updated count value into a local variable.
> > However, due to the way the entry removal logic interacts with the array bounds
> > checking (enforced by __counted_by(xh_count)), the stale count during subsequent
> > operations leads to the out-of-bounds access during the removal process.
> > This patch fixes the issue by reading the current count first, computing the
> > decremented value locally, and then explicitly writing the updated count back to
> > xh_count at the end of the function. This ensures the array bounds are correctly
> > reflected throughout the entry removal without relying on in-place modification
> > timing.
> >
> > The fix has been tested by reproducing the syzkaller crash report, which no longer
> > triggers after applying the patch.
> >
> > Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com./bug?extid=cf96bc82a588a27346a8
> > Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> 
> Reviewed-by: Mark Fasheh <mark@fasheh.com>
> 

Hi Swaraj and Mark

Dmitry Antipov has sent a patch to fix this issue, and the patch status has
been reviewed.

ref: https://lore.kernel.org/ocfs2-devel/5561c14a-9aaa-43b7-95f9-8428a2364f09@linux.alibaba.com/T/#u

Thanks,
Heming
