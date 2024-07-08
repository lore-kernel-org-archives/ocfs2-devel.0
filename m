Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F24812
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Jul 2024 03:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720410686; cv=none; b=L9V6bcUAUVBjdM+Fr/BPoFf3XKyfyanFSwUc10lzy+GLLu8KayUA+YsqwbxXp+K/RT4KdoNeS1NoAh6Z7Q+7zCWrxy416Up9rG2dRT5s7PC/hYmWs1yw2KR3hTGuj3KfbkEJE0gx0D3h9Wa2xpELryZIVTljKp5PMkv8qE+jhWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720410686; c=relaxed/simple;
	bh=veAz+BxO8wobXWTcYmo7BvUZy+GrbqAIYnVUZUHXYIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=koE/ckfdozQcYEkG0tnl0CnEHA0jpFIIKhGqgJNlvMqUhrSi9g9Wa2SsvhU1ySl3gRLkzYnKhsg31SZ0j14nPDxab0Qv0URiXg67GA302xSSWVN3cmdhGbZrMQDu/OdbPH9xk5JoYop0HWPo7BoCLLz7wNEjKmlw8SaWnH7BAFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JlLtrW88; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JlLtrW88"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1720410676; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eJlP5djid5Zi2rYyudDTPVAZC8Crho3FK+Jkb9yeDKU=;
	b=JlLtrW88IQKabrb8LwRj33HAnh305AKb64GrI5F3ysvLaS4yXA6RFYaa6AGmH6paKQ1NIRsGjtXnCQxcfL8LjoOPGAsvUL7ObQiQRMTzlGbxtx/aMOUXInaTOUwsL1Rg5s8gPSnbknYif5HVxURjxsg3O4/R0toipnm9ROI1pjs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067113;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0WA.94h6_1720410675;
Received: from 30.221.128.107(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WA.94h6_1720410675)
          by smtp.aliyun-inc.com;
          Mon, 08 Jul 2024 11:51:15 +0800
Message-ID: <144e79d4-9497-4390-9043-9fd5e09a736b@linux.alibaba.com>
Date: Mon, 8 Jul 2024 11:51:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: OCFS2 on Google Cloud Platform GCP/GCE -- FATAL: Module
 ocfs2_dlmfs not found linux-modules-extra
To: Paul Sala <paul.sala@oversightmd.com>, ocfs2-devel@lists.linux.dev
References: <CAMnFpKk7DUHEHxH1Bgdc5xkw0YwoiwORXSVzakGOBmx_ejdVkA@mail.gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAMnFpKk7DUHEHxH1Bgdc5xkw0YwoiwORXSVzakGOBmx_ejdVkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Please provide the following information:

grep OCFS2 /boot/config-`uname -r`

It seems that some ocfs2 modules are missing in your kernel.
Full ocfs2 modules include:
ocfs2
ocfs2_stackglue
ocfs2_stack_o2cb
ocfs2_stack_user
ocfs2_nodemanager
ocfs2_dlm
ocfs2_dlmfs


On 7/6/24 2:42 AM, Paul Sala wrote:
> Hi,
> 
> I have posted this issue on a few forums with no luck and countless
> google searches, you are my last resort. Hopefully someone can help or
> point me to another help resource.
> 
> I installed OCFS2 on my google cloud server, when I try bringing o2cb
> online, I get this error:
> 
>   Loading filesystem "ocfs2_dlmfs": Unable to load filesystem
> "ocfs2_dlmfs" Failed
> 
> The ocfs2 package I installed on my google server is from:
>    https://packages.debian.org/bookworm/ocfs2-tools
> and I installed ocfs2-tools like this:   apt install -y ocfs2-tools
> 
> Here is the ocfs2 version I have installed:
>   root@lampstack-vm:~# dpkg -l | grep ocfs
>   ii ocfs2-tools 1.8.7-1+b1 amd64 tools for managing OCFS2 cluster filesystems
> 
> I can see the ocfs2 cluster status as shown here:
>   root@lampstack-vm:~# service o2cb status
>   o2cb.service - LSB: Load O2CB cluster services at system boot.
>   Loaded: loaded (/etc/init.d/o2cb; generated)
>   Active: active (exited) since Fri 2024-06-28 17:04:53 UTC; 2 days ago
>   Docs: man:systemd-sysv-generator(8)
>   CPU: 12ms
>  lampstack-vm systemd:Starting o2cb.service - LSB: Load O2CB cluster
> services at system boot
>  lampstack-vm systemd:Started  o2cb.service - LSB: Load O2CB cluster
> services at system boot
> 
> But when I try to bring the o2cb online I see this error:
>   root@lampstack-vm:~# service o2cb online
>   checking debugfs...
>   Loading filesystem "ocfs2_dlmfs": Unable to load filesystem
> "ocfs2_dlmfs" Failed
> 
> Looking in the syslogs I see:
>  root@lampstack-vm:~# grep -i ocfs /var/log/syslog
>  lampstack-vm systemd: Started ocfs2.service - LSB: Mount OCFS2
> volumes at boot..
>  lampstack-vm modprobe: FATAL: Module ocfs2_stackglue not found in
> directory /lib/modules/6.1.0-21-cloud-amd64
>  lampstack-vm modprobe: FATAL: Module ocfs2_dlmfs not found in
> directory /lib/modules/6.1.0-21-cloud-amd64
> 
> My GCP VM kernel is version:
>  root@lampstack-vm:~# hostnamectl
>  Operating System: Debian GNU/Linux 12 (bookworm)
>  Kernel: Linux 6.1.0-21-cloud-amd64
> 
> It's my understanding that an OCFS2 installation consists of two
> parts, the kernel module and the tools module.
> I guess installing ocsf2-tools does not install the kernel module?
> From other documentation it appears I need to install the
> linux-modules-extra package for my kernel.
> I have installed the tools module, but I cannot locate the ocfs2
> kernel module for Linux 6.1.0-21-cloud-amd64.
> 
> I tried to install linux-modules-extra like this:
>   root@lampstack-vm:~# apt install linux-modules-extra-6.1.0-21-cloud-amd64
>   E: Unable to locate package linux-modules-extra-6.1.0-21-cloud-amd64
>   E: Couldn't find any package by glob linux-modules-extra-6.1.0-21-cloud-amd64
> 
> Where can I find the linux-modules-extra-6.1.0-21-cloud-amd64 package?
> What are my options if the linux-modules-extra-6.1.0-21-cloud-amd64
> package is not available?
> 
> thank you....paul
