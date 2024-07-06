Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C175D360
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Jul 2024 00:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720226324; cv=none; b=tfFHCx1E0xwHHfI0Eea8E3pX7bt9cuKKLjZmStIEwTurpTiARdLVHIsoaVT6krP8m0SxS4nVKCuXYUjTyO0k5+pSm9aUNa4GTyKobdyBPYg3NmTGlMbd1c3I7OCMXzQteBkGg+7t7tuAbAZEskhtLKBU4PuQfpFwxG5KgyegNvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720226324; c=relaxed/simple;
	bh=GfODg356NfrmksiGznwvwcvywbZWFr3O8jKUmVSJVa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LRn1vW2/ASYZkkMQjFvUzt5kDL1cqwG7+o+mAAnpS3i3GErQdgVVfLFmGsvJPW/cpUhgwXM5K35rLdYBnHVTsE5XsyFZ3+hKw7+dYoK+cIeyTgz2H7YLeZvEx8lxGUdo94uR+ZxGBduvmBdwI7gqm64EC6lSvleca84fJAcwi00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AJL6RMPM; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AJL6RMPM"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ee77db6f97so29948581fa.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 05 Jul 2024 17:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720226320; x=1720831120; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7YF3D0UxCA6uzgxiBLNtFimT7XwB9LIx00O86UGxVik=;
        b=AJL6RMPMGTQCpM4VrbJc/UHUqezYgD9wNhawyE4HkHAY8W7OJYKlEwINCQC6QNnRuB
         m5qIk2fOBpXqfbqwjf/qxGMkntlFD0UlfiirUtm6+ryjs4epaRptpcrb114yfITGgOAz
         IVJyOy6BmucrelQcOpKbr1PDrneLXSe1kZlE68YI+OXMcrtpBrpccMgzDpl4FyF3ifas
         gpIbx7OVR3KSz0b4l1Hgj9N9FBirTcxnG9XZZGK9kymixKi9EQe5+nOuikrxtSPt5uHA
         1UQt0/31dfLOXgKJKoFpmNpbBckUif7xJoIukWYbBX5OHLaNsWjKt1+ND5AOa+s6qiAQ
         5ccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720226320; x=1720831120;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YF3D0UxCA6uzgxiBLNtFimT7XwB9LIx00O86UGxVik=;
        b=EsvQc4zjtN7TDtddEvtGHTAjQgCS+QjcqEFKDUF4iFc7FI3DG5U11FkvG1lvY3e6Nd
         esF260HOsZR5wJs4gyu+0mtHerhhouf8ue7s7unz+t+xGdxwXxewcinukR65nDdtOEzD
         dJNtqXsUUT466fajXHz+Ec6I7RwZOTD/wznzXk0LlT3r7fpo16YsT0UD4vYQzty9i+Xm
         QEuC5BNI+z9Z2CunxfTFDMWRuCzLO22m5jq2vwrEG2r6DB/HwKmdMzSqq3q+/eqNCJZ1
         1XClnhO7t1CZlSV2wf7bkGrRU8tlO4xv9v0wIdYIL3zbiox1cTOfMfY8ydI8/t2OThcI
         CghA==
X-Forwarded-Encrypted: i=1; AJvYcCWs7ZhRXbXStN5JR/Ch/bKfV30CAS2jfpn1KbUPkwoL/v+xxuyh9TtafHS6GVxTaT2R2zLZ8Ba/P9ON8/n6X4Wm7tox4aVDxz6J4OQ=
X-Gm-Message-State: AOJu0Yw7iYW87WpndQd9JbWLgND0JP71nDH6ErufNY35tXGadOOhqRNi
	UM2lyaYbO1GD0zWuM6IhW9W1J1BxXqquUbQp22H/vhBiXFY4jRMBoRjAL5EsmcM=
X-Google-Smtp-Source: AGHT+IFlObuJQbPdSAddAiJCcIq2Jvm3iegSffi+JfaN2nCW3EgKtQIVFbX2Nzcs0vQbHU0UWBu2FQ==
X-Received: by 2002:a2e:b172:0:b0:2ee:87e9:3194 with SMTP id 38308e7fff4ca-2ee8ee20caemr42479541fa.47.1720226319758;
        Fri, 05 Jul 2024 17:38:39 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b0c9b8573sm2145072b3a.191.2024.07.05.17.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jul 2024 17:38:39 -0700 (PDT)
Message-ID: <946ea908-9aee-4e59-88ac-8ed76c3dc19d@suse.com>
Date: Sat, 6 Jul 2024 08:38:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: OCFS2 on Google Cloud Platform GCP/GCE -- FATAL: Module
 ocfs2_dlmfs not found linux-modules-extra
Content-Language: en-US
To: Paul Sala <paul.sala@oversightmd.com>, ocfs2-devel@lists.linux.dev
References: <CAMnFpKk7DUHEHxH1Bgdc5xkw0YwoiwORXSVzakGOBmx_ejdVkA@mail.gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CAMnFpKk7DUHEHxH1Bgdc5xkw0YwoiwORXSVzakGOBmx_ejdVkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 7/6/24 02:42, Paul Sala wrote:
> Hi,
> 
> I have posted this issue on a few forums with no luck and countless
> google searches, you are my last resort. Hopefully someone can help or
> point me to another help resource.
> 
> I installed OCFS2 on my google cloud server, when I try bringing o2cb
> online, I get this error:
> 
>    Loading filesystem "ocfs2_dlmfs": Unable to load filesystem
> "ocfs2_dlmfs" Failed

"ocfs2_dlmfs" is an ocfs2 kernel module.
> 
> The ocfs2 package I installed on my google server is from:
>     https://packages.debian.org/bookworm/ocfs2-tools
> and I installed ocfs2-tools like this:   apt install -y ocfs2-tools
> 
> Here is the ocfs2 version I have installed:
>    root@lampstack-vm:~# dpkg -l | grep ocfs
>    ii ocfs2-tools 1.8.7-1+b1 amd64 tools for managing OCFS2 cluster filesystems
> 
> I can see the ocfs2 cluster status as shown here:
>    root@lampstack-vm:~# service o2cb status
>    o2cb.service - LSB: Load O2CB cluster services at system boot.
>    Loaded: loaded (/etc/init.d/o2cb; generated)
>    Active: active (exited) since Fri 2024-06-28 17:04:53 UTC; 2 days ago
>    Docs: man:systemd-sysv-generator(8)
>    CPU: 12ms
>   lampstack-vm systemd:Starting o2cb.service - LSB: Load O2CB cluster
> services at system boot
>   lampstack-vm systemd:Started  o2cb.service - LSB: Load O2CB cluster
> services at system boot
> 
> But when I try to bring the o2cb online I see this error:
>    root@lampstack-vm:~# service o2cb online
>    checking debugfs...
>    Loading filesystem "ocfs2_dlmfs": Unable to load filesystem
> "ocfs2_dlmfs" Failed
> 
> Looking in the syslogs I see:
>   root@lampstack-vm:~# grep -i ocfs /var/log/syslog
>   lampstack-vm systemd: Started ocfs2.service - LSB: Mount OCFS2
> volumes at boot..
>   lampstack-vm modprobe: FATAL: Module ocfs2_stackglue not found in
> directory /lib/modules/6.1.0-21-cloud-amd64
>   lampstack-vm modprobe: FATAL: Module ocfs2_dlmfs not found in
> directory /lib/modules/6.1.0-21-cloud-amd64

Above info shows that the kernel is missing two ocfs2 kernel modules:
- ocfs2_stackglue, ocfs2_dlmfs

> 
> My GCP VM kernel is version:
>   root@lampstack-vm:~# hostnamectl
>   Operating System: Debian GNU/Linux 12 (bookworm)
>   Kernel: Linux 6.1.0-21-cloud-amd64
> 
> It's my understanding that an OCFS2 installation consists of two
> parts, the kernel module and the tools module.
> I guess installing ocsf2-tools does not install the kernel module?
>  From other documentation it appears I need to install the
> linux-modules-extra package for my kernel.
> I have installed the tools module, but I cannot locate the ocfs2
> kernel module for Linux 6.1.0-21-cloud-amd64.
> 
> I tried to install linux-modules-extra like this:
>    root@lampstack-vm:~# apt install linux-modules-extra-6.1.0-21-cloud-amd64
>    E: Unable to locate package linux-modules-extra-6.1.0-21-cloud-amd64
>    E: Couldn't find any package by glob linux-modules-extra-6.1.0-21-cloud-amd64
> 
> Where can I find the linux-modules-extra-6.1.0-21-cloud-amd64 package?
> What are my options if the linux-modules-extra-6.1.0-21-cloud-amd64
> package is not available?

I am not familiar with Debian, you could build them from source code.
In my view, you should ask the above questions on the Debian mailing list.
The key issue is that the system is missing the ocfs2 kernel modules.

Thanks,
Heming
