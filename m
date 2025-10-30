Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930DD37A3B8
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761790667; cv=none; b=lmoTtoVDFhkahuqzFaUUSRDc6G+mf7nQ5tlaAGGeIBWZRVWaUNyWpmuOLj0q9F7qj/gn2S/hqGkGos8rXmFgnfisefaGw11XaqtaLmNmxNJ8JtmRERsb9Ftn7C3aRe6PnVpoKsBtc2uxanOvnDosui/gAxe1zFpyICBjvuExC9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761790667; c=relaxed/simple;
	bh=/ZQI8cxndWHYkM9VE8vSwBp7sh6XtjHfYLq8wF5cx00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KqcVUPRWxc68TRn9fhE5pSKisW0fBvYBV4xyHMdm4f6tHbTMAKIaOYUOIL3Xi2J+2YHTmN/6R+r39vP1ItH04w2PSNpCrn/VpbUqZZ10iJQC7uk91qtmB3iTr0azELxIMO7ldI/tBbLI+m+QUXp0pGJKlfCT7RDW6OSJQgPW+ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V1swzovn; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V1swzovn"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4285645fdfbso74099f8f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 19:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761790663; x=1762395463; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1zK8Rcgb3a7hcn6HmStHz5UjhG+bh4ZoweIT1zrMMnE=;
        b=V1swzovnYPi+OKpA/lZeu79LFQSVsvtTzSZwTPXSdIrFNEKYSj3qXQeRbo+8qIqYXS
         ORcXuecRRlmzIti8pCmlXbCQq6wJ7Y51ZGD/Q1gs1cHp/8bI+N4tJiy8ffjm80fZpyGH
         S1Pw1bdCNhwUoIDd5IVul2S6e2hmtnNhlVSPKpf5g+X8tqndDHOpm8vTcqTUJdzlk/Ab
         ARrPXh9f+KBvwgpJwJLYq5gYjFYDvT/uJzYOK6XMZeteLtmXF32naFUDmvzg4vpkMdjF
         V5yUKb0EatmTwew5R90GcEN1b9TsXbnRj80tmXVXjR5wGdOg+XcMX9dxXfbI65K3Wy0J
         XgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761790663; x=1762395463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zK8Rcgb3a7hcn6HmStHz5UjhG+bh4ZoweIT1zrMMnE=;
        b=I74bj17D8W3Q7jWyokCjsYJS8nhxffynXSVwlzJRXcF52kBzfGhKDU0PXf/YIjDZHi
         IKFa/LB0P99pbtcNceAw/e+gP14sq3TGocxLmrOAYdplq0SJD8tyu5/Adnj1csvwXd/H
         0XuhnjQMZxS+VDKn93h97bkDpr1BF8dUQ8FhEn6yRjNnDjR49GGAg17qv0bk3K4YZNKm
         hOvH9sLlcMJ+UJvg+5bgu+O6IYBH6TGk5QPgvapKre9gcIHRGOCN4DRJ1ZZLfSmVdzdn
         ENnCgKhNovMthsZCpgW5YSb4lJRy4uKHvJzhQMJbYUEBw4tMQia7VR3KaVPul1We4Ojw
         ujHg==
X-Forwarded-Encrypted: i=1; AJvYcCXRqUgII0s+sP858Kv7t22eBKpcdpTKNqZKzTauM7wGb7VD9rynSywpYlR+ctbAV4qh2N7beY49wYPh3w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzduEZgqMMVEguP0cBomBkvjG78Ln7BLXYlA7geD3asZYEJHBjF
	tfyd5EKy7cbzdexyh6ZBAKRnTMUiybPPqWNp5b1tpb3lr3fNgR3EPQj6hL6431FIML8=
X-Gm-Gg: ASbGncvJvrVFU0ntGYHkPxXVoyv8nnwcDn7Ebhb1jk9/22yyAenoQKaosNkN16X4YKD
	4i5iVHGAFUo/MLt29OAh9331DI8lFidBMqfN6mb4XLaGmqfPm0dUb6ur5YvX2VxuBx5atkEeinA
	AOw1w+7elSRsHGKiCvXmArB275vX0jMnHhs2E0RSRXIhrn4kFz0/Xj/iYNGtqEqfXo2hMkxGEs6
	MXyS0s4BpLn+M6ru7Q4xKp+LJeo7hOIl1vjWEYUMS89HAw+MKhSLh7wBp306x8JGnzn8bFC63C8
	0zMnG1DdorQcUR1bv+mR5oFd/XLL3ZNXclghXTHn07oq9Kb8SnAU2w6W8gkZBbCrYlBe/VrH58Y
	sPxk5lMsfY2qqcFcTM8d9MoCbn8NWxJlR/T3JwEqXKPf9Jkrh0vaOZOiWaSHZAkYubGaRHtBCng
	s=
X-Google-Smtp-Source: AGHT+IEF94/keRxJdpWjZ9QDAPS7sZjWxgNSNC6IhPS1HuRh675t8qlOg16oGD5ThyvE62tPyq0OVA==
X-Received: by 2002:a05:600c:4f81:b0:46e:5cb5:8ca2 with SMTP id 5b1f17b1804b1-4771e1744e7mr29043805e9.2.1761790662775;
        Wed, 29 Oct 2025 19:17:42 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d09a33sm165284075ad.32.2025.10.29.19.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 19:17:42 -0700 (PDT)
Date: Thu, 30 Oct 2025 10:17:39 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to
 prevent divide-by-zero
Message-ID: <k2mxbtw2n4mjwkzsfqyddrahx736z5atfi246cydid4mnwqle3@zdx25hanjqhv>
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>

On Thu, Oct 30, 2025 at 07:41:13AM +0530, Deepanshu Kartikey wrote:
> Hi Heming,
> 
> Thank you for the detailed explanation! I understand the issue now.
> 
> cl_bpc stores "bits per cluster" (the log2 of cluster size in bytes),
> not "blocks per cluster".
> 
> The bug in the validation code is: u16 bpc = 1 <<
> (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
> 
> This calculates "blocks per cluster" (e.g., 4 for 4KB clusters with
> 1KB blocks), but cl_bpc on disk stores "bits" (e.g., 12 for 4KB
> clusters).
> 
> The correct validation should be: if (le16_to_cpu(cl->cl_bpc) !=
> OCFS2_SB(sb)->s_clustersize_bits)
> 
> Since cl_bpc should directly equal s_clustersize_bits.
> 
> I'll send a v4 patch with this fix. Should I:
> 
> 1. Send it as a standalone patch, or
> 2. Work with Dmitry to update the combined series? (Dmitry : Please advice)

I prefer 2.

- Heming
> 
> Thanks,
> 
> Deepanshu
