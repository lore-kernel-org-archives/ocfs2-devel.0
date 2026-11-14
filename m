Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686762;
	b=3ZvYZdHRoL1P1THiIPnyuMJkM1ynSvF+8an8bzxiIkVmpmdSNXcHCPD1F0EerWC713yJ
	 BmtddkCf3ClydHEIkp34r0ueS7bpi1VBvadlVJ4Afuvc8CPmwQTexAtIRgEbeeFKHSaF8
	 COHPJIgGcu6zFtRIOcErsd9Y+nbJBoFNd4rypJmSM7DxJ+I8+mzhlOlIgDQ/Jc7ipkMQd
	 cZqUCOqclmdfz/jQrWrJpr0LVZIWGqw2jpXotXj+Z3BVN3/JnebnqhqvkvxMG0SZeC1/u
	 EPUfLMgR2Vp2AT0EgJk8LLVB36vAaJBNob90QVZOWdeakwc3cKul2O3Q5YfxVBMrH/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
	b=uRW4eDfcxQ8GxGrlFcDVxC1jCEVYfo0PhkHdWXv9gs/5G3SWI4rQsPIWVYSZEGd3C/Zu
	 N+heY7sgwmed4ZCdNGz6JIccHZxbAFL1bha5iun4tQxLxTgZwOi0PV2q2GAi3N0qBYeWq
	 FXiN601q4KIs+nrplWMze4YNFVEeNpx3WvDJ9mEMbjClosni8mMbBP2PHq9Dayrf7gsmF
	 d3pQ3AhkhOyo2mSgFm96o8ypKrsezIc0sS0r3pAHefmsdFi6BjVxY4a25cUh/vYYmxYPV
	 friBua/ztPvVMqnvBDn5TwyTAkMpoL0zBuZFJE4HCF99J+suDWVPViAH1woJFWGUABw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=v3HMjNq4;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0594F60A3812
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 20:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0594F60A3812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=v3HMjNq4
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cddc597d062so1621218a12.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 12:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686761; x=1795291561; darn=lists.linux.dev;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=v3HMjNq41lVlbWtdzT4CFv6Psnqz6lFlawzd7ghXSUumwPeClYtDKOCE3eFYGT711w
         EZj0Mi6AOVw9gsDLJdAA9rn13sFYTyS3MvMJv/SqZgPd005e5C58KKdUcd56yaBOwxkM
         /4qjObAe1Sg78iPdnUBsPKDNFGLU+MaOOo47M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686761; x=1795291561;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=QgESqVonydbWJiaf1qwIOhFBg5sQ0+3JJ/yldUXZRWehupDsW1miOKU4Yc010N+67E
         hf2dCudrhoT4L1zqVWMF0By2qZgi2Nm+vaqgTIVPX62RC7prE43Aa36AGlCq1uh90Bhr
         wNfpjGE1iobEzaVbDafieDcfKj1jtH9j7awYDX3PpV0nrrwCw3UrF4cqIoB/omZtGrLZ
         qD+ehrR5qCeu+OBHe2/7YtPd9gIINoc9NngtXY2creIqymRljppZwTYY1DsOCUExHm/r
         NDo8dThc89rACZw6iITeqJw73asrP91NTQE7VhulLfVw1Ef8KciwuHE1ELaDCEZDgdEw
         mqdw==
X-Forwarded-Encrypted: i=1; AL+hErFURq2SWAgxohhuDWteVRmiwSSryVURFtQcTrZydUvOHA8b3/r4WdflqN991OEjI5CMuRrJCV/sbvDM6Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z+bcYA8nNCd0jzvVBjrGUr/gtFoqgwhV9hmgqiXmXd3G9diqQpM
	eEU0ZtHcItcFO2alq9FHe1IsKzgSJQoY/0dfKQiSfvsxwbMRsbCeDYs87JNvk4n9gqY=
X-Gm-Gg: AYBFou2d25ZztFBTBsmp/r3VcHLWQw6byc7jmNAlrSGtULHdfWwmkXZGDtZyvRIW/1k
	ILABEaomWCgms10Yyn5fgs/iYtLIW4HmJaD6/swOABh5JrRcEnPUhkPdjtiu7B5BO2zzrhwXbQb
	MrdX8FHL6W+FRtch8THk30F7BEMxMFViAfOKI/0NrDZgZcszu+9z60HUHE+Ux6T6npY8y6ZHJTV
	auuqVg5DAhrBeZfs8DXf3PeeN7AQL5ELZYcHCzV48LlMebA00shJ6mJJkWeH9LXBypUWH1R+yq9
	4coGXkPP9eKfM9bgYQlAvkvClC+rRdPzK5cmrBV0FgRBiVXsK5PCfrBq7laUL5QR+nclhdyuwpx
	XG2pNotF7bBJ9IhpbFo/YiVuJ2+y+lfcyxDyJ78vinpmUWO+fAilR8eRugc9/sdQsTfDMG1Lzdk
	/ng0ENR5mZyobLs6bUXb6EfKnFtSwM8TKSSTAXwh6yHcjZmSGmx5Z9UMdBZMH9PsIe2ccVxdHGE
	jCMZKaSS6gu9lDn5GLQn0MIVIwm2oLM0j/yNaQQRmw4WdTYW2wuk84yU8tgAOcfEIa4nEwy5xCk
	AJxPwYbI5Io/Xg5JUQviuk/kiWpKef5s5UTZC4OUfIee/7jcAOU7M+yRI5MU9I8P/PglWz4lMZS
	y6QiCr8FsXJz10N0WacP7hhYgQs9+2yzlLgOKc80T36zKJ9chz719Mzj3+bxKNlewrz0v745PoV
	1qcH0iMGEx+gDOPTS/pz3aXxjqxEednYeHM0je9t+DnK9LmRl+TaJNtVF/
X-Received: by 2002:a17:90b:2584:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3b1b0ba61famr5629200a91.33.1794686761104;
        Sat, 14 Nov 2026 12:06:01 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm5258887a91.0.2026.11.14.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:06:00 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:57 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>+	/* Look through stacking filesystems at the inode with the data. */
>+	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
>+		return -EINVAL;

This looks good in general, but what the bots said about O_PATH files
here is real. With FMODE_PATH this is reached for a file that was never
opened, so on overlayfs nothing has been through ovl_open() to look up
the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
itself, and when that fails it hits the WARN(1) at its end and returns
the overlayfs dentry, so the check passes as well.

Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
it's easy to trigger with that. From a quick test with a metacopy file
whose redirect into a data-only layer points at nothing, registering an
O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives

     ovl_d_real(/f, 0): real dentry not found
     WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
     [...]
      file_check_backing+0x308/0x5e0
      fuse_backing_new+0x219/0x4a0
      fuse_backing_open+0xe8/0x390
      fuse_dev_ioctl+0x53a/0x7d0

and the ioctl still succeeds. A normal open of that file fails with
ENOENT, so nothing could have used it as a backing file anyway, but with
panic_on_warn this is now a panic.

Maybe ovl_d_real() should just stop warning when the lookup fails, now
that it has a caller that isn't trace_uprobe? The check would still pass
for an O_PATH file whose lowerdata couldn't be looked up at that point,
though.

Thanks!

Chris
