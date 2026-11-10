Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794305680;
	b=Rvg4dh9EaMwSTvU8Qgs9OkKLrnajPm9M1mo8+wZjQcJyGgJ0zNqMAlq5QCALTA54k+gG
	 9W+ElwBdr97IhPa1g2/BCIZQExtkfaH+l2xBsbXKJvZ44O0JbzmGGji5Pmg8bKIqUjo+Y
	 gW6h63VRKh4SNPQljl/ozq73F2YTOzsM+wgygtiw8XmOBUbf5xw2tGvE81JiL1iwCjznr
	 dlOvarqTSj9EnmNZPdactuBNbRxmU6saUnqq75JkZroLUd6esRx0TvpXCKHDdjpJrrAMj
	 EtcaraF9YfG9+B+LQmpDt52wTIJvvJhoYXBLRja+4S4Afk5VZ2bfSSs3/wTR5hMw6GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
	b=P1d2rREJ8rTozR2RL9kQ6k0GHEWoMTLWMmFdEErGVN8zuPjGDtgq9ehW/LHJC9XCxrj6
	 JHuwTGZSLof4WORxuLeuGaaIaOPdKWVu4BJnbC0BdTa9GK9ddQ/LpciUhRMqFA/cmLg5g
	 8bc5gK6kA1l2xC1FlcA35oqm1Fc6b40ULbumN83awxamu/TZrAkFMS5N55X+cGdNIQxQu
	 RAu3rZwGQ/PHJceUCirjQRB0IF4zMXQiFaxVAoc9jOhuDjfcO6jQHVu/ulZiB5TkzW54X
	 EiYfky7sGx0I4fxLMtXtFo/btGawZK2feyFyDVTCQnZiexkFKFsTHoZw+kmR9Tcp82Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fDdNrRSV;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802A3606A33C
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 10:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 802A3606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fDdNrRSV
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c504bfd7393so80979466b.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794305678; x=1794910478; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=fDdNrRSVNR9TpZFUkHd2W1DuQHlvVUFibD6nEgoFL9wl5DSEDU143CIePeWmKV1eNo
         p2IeaviV4vP3RE1b0IAwmilqzagyYiEqwzgjXQIZxK/IRPy+x1ioxTws3516Ab/ZvS9D
         sAWqIxu2pfvu3ECnuFJ9J0QHkyT+t9gw05wbYDp7ttMZ6IzrNLgFSLMmxvohKdw2HI49
         PET6BrCja6mmQXbqqc3OHaaNKz9cPz28KJEow3UjQ8JYrlPXmEOjwVp7EDGjm7QVPcaO
         AqzXADEZQO9jfCT01HjEy0+su4njKuWs6asogL8j5zkyMWKdZi4vnWrQqpQ8hwcBKO51
         2pIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794305678; x=1794910478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=xQptLB4roeXospjHU6ClL7TTCMVaSm4E+d6fGhb28OdSJ2Tau7vch92RSB4JzPS4Fv
         /HgC3BG1js9172oXIoTPOEz0tacGd9BZYpC2y8lathcpMLyvbWLEYdkqtykwwzKabvVz
         7N/dSljLo41L+FF8V0AHLBTXHDuSV8ft4K87MUX9992Qoe1K5sFXQ6HC4dP/oPiqWpEf
         MgAbGR1D1jcWOz7yTSVbYpy3aVkUxq37tTazwvgtrEONlm4yrRYYUE5EvMwY3QYHExNi
         1BY9KUDImHd3WDPSqSZAb1jgX6sL7ckQ+RSKrEqBoBC9olDkqarjB1StxsO4T0xVLUlt
         g6Rg==
X-Forwarded-Encrypted: i=1; AL+hErHbktvioeso0kmakA4nLoGgZQkB/a3/4MQMzAVeATs14xABzbJcgfFmPoIa4EuXVzAQA1gXnM3t0/8ObQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8JgEhUu+MlfiswQ0HNumwT3MlebgFKv0mQ7vA6MQUrmfimRcU9
	GubVECBzuDWquatQcFoRHVQoY7CNkTpJ/FRPaq6T+J960sJWxMDyy5Co
X-Gm-Gg: AYBFou2RylIMwRNv3xtA7J+sDuT50ks+I8Rj9kBAJIIlW6IC8GAwSFhr6jdUwzs8H6b
	+q9vXLcH4REK0x+H1kBt/16eZzac5TqoWubfA6hqEuvQKlVZk2FGl62sgPvzsHsnRtoWSBAOKml
	2C+Fz19CvNPdyvzj/l87KXLvQD2o2Rdmz2sGmrgZhQjxIohnCCyQgTIyygkF6GYQT+k9Cmi4nrT
	gmBXX84pqB9ZXZNnn8niRjRrYPk/l6NuGEO+xnQxfyRo24MlfJ2ZJPVL0fAnXiT5wELQBkSc8yf
	MGBtuvpuE0dXL/n9gh8tlJmvTgG41uvy7U2sFoREZF+wzYDf/ROyeVDzY50keuPxhvzVAO6u4h/
	1lUXTjlEWp2YVrfPzEdui0lfGGJBjiCVddbLR65VOWS2639bNmopOSuzwkFoCacIoSEUbainNTz
	SIm81tjqqt9foTW4nCA+CarB9QyBy2vd+MTy0wbJvxSMyLprH4GeC4kQQxV2ZmXyrq3psSObGQ7
	Ab2TGejjtmbx53lcy4ufCY/qIbDDHcTLhJHTUtfLo1LMx0L4ZxVWsEEPAGgBXMx6yj8V3fiHaMn
	mJcVzgST7QPfqpJUmRAU4EMBH+/f7posFJc8QYD3miSbnebIOfmJ2tTIono/xdNP7AZWnNF8e6d
	Tf0h37bjBSjwo
X-Received: by 2002:a17:907:944d:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c504963ce05mr189793966b.44.1794305677695;
        Tue, 10 Nov 2026 02:14:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593eacsm90433466b.36.2026.11.10.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:14:36 -0800 (PST)
Date: Tue, 10 Nov 2026 11:14:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avLui6Mpf8GbKbtc@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>

On Tue, Nov 10, 2026 at 10:14:54AM +0100, Christian Brauner wrote:
> The fuse server can register any regular file as a backing file. procfs
> and binfmt_misc files are already refused by the stacking depth check as
> both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
> other pseudo filesystems aren't. Reads and writes of the fuse file would
> then be done on the pseudo file with the fuse server's credentials.
> Refuse files on pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fuse/backing.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb..4e4fb810ddaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>  			return -ELOOP;
>  
> +		if (file_is_pseudo(file))
> +			return -EINVAL;
> +
>  		fb->type = FUSE_BACKING_PATH;
>  		fb->path = file->f_path;
>  		path_get(&fb->path);
> 
> -- 
> 2.53.0
> 

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

