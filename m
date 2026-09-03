Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338035AC3E
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 02:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788402727; cv=none; b=CumiO9sipc3ceS1fojAxACDB2qtX5VJSPa5zwXPd2OCDHHFn/kjubX59I32mN9ABzsZQ3+BTot4ZUdcqiiXyxC2owrcUAqH0VsYgGPNO3Ksqq51S8kr27AoauK7q8IplOe622r34XrGplA+cdax5hh7Hj3l2uRQ0z2y5LDMXJDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788402727; c=relaxed/simple;
	bh=mhnQUgpB08Teq6ugPKEvbkk1XBrN1Jr1TmAjxKH8h+4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fOX9Gd2CzBrIh7sMB/v9cBHdVVYKd6yI7rFsQGZ0pmc/QycLF89N1/cK71WAKKGTAoHaVDv7SH6ZcnU5HSvKCHgiWiEYHG39OSTbTrha5CT+JE2uTGNdRaZBq4CPP9/klAZQh8kRbPihHRIN7D4hWMCRUMS0HU+VeSJHQjjlZMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IZCZ5R1I; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IZCZ5R1I"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-66e611e7c05so1794622d50.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Sep 2026 19:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402721; x=1789007521; darn=lists.linux.dev;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SZ9VwK4M9RrXiYAkL+dI7dyHkhFNxu+nw3mnW/q/dvk=;
        b=IZCZ5R1IUK1PQDTbUofOu9Cn18KGvq6118QXnyJhCepVuHyeYgFsW1+mobXP5AMIkJ
         rGLirn1uptEjw4DEFQNTIdTkh9B23GThpSDCI2hExGoPy+8+c4fDwLtKqunu0lec2EH+
         dhFS1IjvZeBAN2vulDQG6CsHGvZQ2npgRamDqp9wNklXhzXw94xwbR6aSs02Ji95psM4
         tSizfz4TuDNYdMVI98yu5R0WIvLzsPVNWK9TWuA99du9Ercp6m2N9H6kVtu5Kps5cP3L
         NtoUgRy1N0pV2+fPA2vu6Jj2wMBfK51joGDxAXZor9T9q3kV2WJkBMDFJ0OKLor74Oa8
         rHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402721; x=1789007521;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SZ9VwK4M9RrXiYAkL+dI7dyHkhFNxu+nw3mnW/q/dvk=;
        b=iVuaQ9GA8qzdIVo7RmTrNRuasb7jQAxL1H56mpH8DSwIQyBJ2zWBQaQ8+OJspbjlG5
         L7BgkY7i8PfzlKZFaOlthhZtl8eIKI9OZLeQ01KLq/KeKL5EWp1V74McPwlYMUvtcfAe
         5vx6tEqxFxltiuPBadpJ6cvFT4Pp+m6UnPLnx//f84EaK7ZLgHGbcFV+zDjK8pnTpgCN
         Z6qwB4QBnfn7izKcUqQ8UPRc8WpxCT1Q5unCmUThE5pt569tkyDE0KOKzM7qXA5qv+7i
         w4Wfu4Uf8PTtcgRmRIZbEqn1w6sZJzsutfnsmsNXUbvvBb2t26jfIfmjU1fgZnnBz/PB
         jl3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzcmYzOFfgB0iA89Ewj93I6tk6XvN4SAv6EnurWTP8iKRBrBzYPVw2WHywIBkzIQtWn6b6wwcaWPFQG/Q==@lists.linux.dev
X-Gm-Message-State: AFuF++l+GoMS8NlY9OfdyvKLs3NFn6RHTtuCktCyjJEPUvtFXWYGXfY/
	w5iVK6XPhrGgeABYQ8PN6UlcvZRInkWqgU0lpIRGpib83YSZrZlj1hk+qz4Ga+XnSw==
X-Gm-Gg: AYBFou3zSqCa7olaZX5gxBdu5WIc6w+tcS++6WeurZ2glyBfYVX7MtbdfXmbirL5uY3
	BmpMwvCrl33gwFwAY7Unb71Ut8xzo/kreREaQsm/+5JiNt01JMzO27WuL0opVTcwr9MYgYZOpc2
	NwabS4HWMFZsVuuMBHp2C4J4s1T3Rwjci8FHKCFkXIqBpoTihD7lDLFangzG/hRn5dW3bgeYbwU
	MDV1wp9rIpQ57ggTOQ/FsEXtYX6BxS3zrmQCG1Ekg47/V5q5zMZJ2XSScJtFtRF4Fv1wmUIQUqm
	Q0y0iWjhzxknj/kZKHnPXI/uieqyho2fp185toqN9pH/6Y+xEjjTJcL0ZcLMBJD/wnzdwwq2eoL
	Unm5Y0rq6XBwI6RK6owDE/mk5G2Yb4OGEKxelj0yeo6hVRYwksNz9FJ4XD07Lj7FrrZhlxMVuaq
	puFFJVSij9SvqqW6v6PRUYLjCZgwXk7Tc5MmoTx7aRglGXWLfNZBsUS3LY4CyxWVmTpHoYfNXNY
	iXPdV2uHhXAVWxyon9zL0BipSEOsMPF7lHdmqc6/3U60lfg
X-Received: by 2002:a05:690e:1689:b0:66e:65b1:6977 with SMTP id 956f58d0204a3-66f9b8f010cmr3430168d50.5.1788402718645;
        Wed, 02 Sep 2026 19:31:58 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66faa62c132sm753177d50.7.2026.09.02.19.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 19:31:57 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:31:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Jan Kara <jack@suse.cz>
cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
    Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
In-Reply-To: <20260902133702.1313635-4-jack@suse.cz>
Message-ID: <5f7e2e81-6a79-3b5a-1dc2-83ce775017ac@google.com>
References: <20260902132458.23590-1-jack@suse.cz> <20260902133702.1313635-4-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 2 Sep 2026, Jan Kara wrote:

> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using tmpfs quota format. With suitable
> passed arguments this can actually succeed in enabling tmpfs quota
> format on top of ext4 filesystem which leads to crashes later in
> dquot_acquire().  As tmpfs quota format is intended for tmpfs
> filesystems only, verify we are indeed enabling quotas there.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/shmem_quota.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> index d0b92d6da50f..6e0b43cbded3 100644
> --- a/mm/shmem_quota.c
> +++ b/mm/shmem_quota.c
> @@ -54,6 +54,10 @@ struct quota_id {
>  
>  static int shmem_check_quota_file(struct super_block *sb, int type)
>  {
> +	/* Verify enabling happens on tmpfs superblock */
> +	if (strcmp(sb->s_type->name, "tmpfs"))
> +		return 0;
> +

I don't object to this, but was rather expecting you'd check s_magic
for TMPFS_MAGIC: isn't this the kind of hi-tech thing s_magic is for?

Thanks anyway,
Hugh

>  	/* There is no real quota file, nothing to do */
>  	return 1;
>  }
> -- 
> 2.51.0
