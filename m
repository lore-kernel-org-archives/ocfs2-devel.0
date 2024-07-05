Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B01716DC04
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Jul 2024 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720204964; cv=none; b=GlOuwd455CISZ2ioFS/rvnB9tDmLXwwAtO5EUGAGoSYRK6ylyD5vkGtzW0J0c4QRF1tkmiHCvhbvOhC4uluVbwsGXA3yG3fMnlAzhlQiiLLnfwJybw1bujtAQ7YuR6ZY5e6wbDCyuGU9+7y+oDHtYd27Ng3hWqsWpjz/+DX5A9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720204964; c=relaxed/simple;
	bh=RrJ7rndzVW8wWddDcbK0dznVVkd8oXluEUwtWou4VIo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=W9d+SyXuDUYh6drJteAI6W1IJeVaBNMO3yclrSTvNkJ7qD0GLJblTKnqrLb53CrwgbgPMR5/9xW/epJGuO31XXJs/ZhRxV5ZgM+AqLDnkEh0VSKenD5cshEYjP9G4WosEPTZrpypRPKNktWBq5xgI7S2FJpN0VJ8uWCTKFrHelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=oversightmd.com; spf=none smtp.mailfrom=oversightmd.com; dkim=pass (2048-bit key) header.d=oversightmd-com.20230601.gappssmtp.com header.i=@oversightmd-com.20230601.gappssmtp.com header.b=ZZvqs5o4; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=oversightmd.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=oversightmd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oversightmd-com.20230601.gappssmtp.com header.i=@oversightmd-com.20230601.gappssmtp.com header.b="ZZvqs5o4"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e03a8955ae3so1859594276.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 05 Jul 2024 11:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oversightmd-com.20230601.gappssmtp.com; s=20230601; t=1720204961; x=1720809761; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0U2FOJo9CXRfPq7hAlw+Cbsn/eDhQhZBMrMfpp50/2U=;
        b=ZZvqs5o47vjyTTNt8nYxT0pwaD1XT8ua4OACZEPxKi8bAyZ09lDskkPdypctB11fDf
         7UjyhXkFHB22uTpj/LMAHV8KdJcqlUonaLvfsYEqPgYdWDmUCqkTZAePjrAlevj/jOLG
         zMfRWI53gKo7b5voqzrkNMiG1TnQcDDUXEECqpGWfptAEnEddLaTMWKbaIGceChjmSGe
         AMaoHH2qeO+eJjQyZCg5eXnfr8SR/xZ4+DR0rmBSKzFoTAWgdi2w9uzlJomJsEj4DqW1
         huBuIkFTF6oizrdmnP8qWdgaHuMvZeVt3ViE68xTDHT9vZSzgMmgzpjvaTi5ekMrHBzz
         /V7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720204961; x=1720809761;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0U2FOJo9CXRfPq7hAlw+Cbsn/eDhQhZBMrMfpp50/2U=;
        b=Kscfwb0O6++TgfkvA0Th9izMBGSnlSne+JdZh5z1oth2dD8/7F23YhB0UpNWCUDqub
         WlUoe2KEbaw9aKFI78XF5RmIgJoslFArQ/WTs8+Ix1PQTphGOJ1birjboPdDz9MEuz1J
         RtIPMtMIuq4fRTDCOs8ycfD6KN+PXYDE48TqNnMi2FFUx/fphEuT2Khc1g7HP9vy3TRr
         khYYbJxQ12Uk4+6Ctn0H8nsbchrQbIIJXrb9Til9aVu1lJwZASyRYAZOdLQXZKVETLsj
         z7S9M9S9/kMw/LbSKGCqlC4NvRL+jHvFB/th3cox6DzOXEEAngE4bduwINhPJ9Ho9UGe
         W4uQ==
X-Gm-Message-State: AOJu0Yz53B+e12quOX9qwlPNyvvMq72qA2UM10OPfDpPbgTPigSAkRXy
	bC9cZIZoSdn/9OmgoRUyLNEq17t+cO9mVxQTEndBNl2hVe3xtX3ZK1lhS+bbnrP+02J0b+Im6Ww
	fEsIfgutSxWMCxo0BKsmHlG46lB4p+2VgvQPPJXqUCzh99na7s4A=
X-Google-Smtp-Source: AGHT+IH2sXyT58rB5BHU4QOsbUSC4gqtbap+XZGm3FCmdC8caf7w7qOW77mWxkhOba5rleINQly4yKpF1RtpwQ1m5fo=
X-Received: by 2002:a25:8386:0:b0:dfd:b613:cd5f with SMTP id
 3f1490d57ef6-e03c193fa18mr5774337276.5.1720204961076; Fri, 05 Jul 2024
 11:42:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Paul Sala <paul.sala@oversightmd.com>
Date: Fri, 5 Jul 2024 14:42:30 -0400
Message-ID: <CAMnFpKk7DUHEHxH1Bgdc5xkw0YwoiwORXSVzakGOBmx_ejdVkA@mail.gmail.com>
Subject: OCFS2 on Google Cloud Platform GCP/GCE -- FATAL: Module ocfs2_dlmfs
 not found linux-modules-extra
To: ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

I have posted this issue on a few forums with no luck and countless
google searches, you are my last resort. Hopefully someone can help or
point me to another help resource.

I installed OCFS2 on my google cloud server, when I try bringing o2cb
online, I get this error:

  Loading filesystem "ocfs2_dlmfs": Unable to load filesystem
"ocfs2_dlmfs" Failed

The ocfs2 package I installed on my google server is from:
   https://packages.debian.org/bookworm/ocfs2-tools
and I installed ocfs2-tools like this:   apt install -y ocfs2-tools

Here is the ocfs2 version I have installed:
  root@lampstack-vm:~# dpkg -l | grep ocfs
  ii ocfs2-tools 1.8.7-1+b1 amd64 tools for managing OCFS2 cluster filesystems

I can see the ocfs2 cluster status as shown here:
  root@lampstack-vm:~# service o2cb status
  o2cb.service - LSB: Load O2CB cluster services at system boot.
  Loaded: loaded (/etc/init.d/o2cb; generated)
  Active: active (exited) since Fri 2024-06-28 17:04:53 UTC; 2 days ago
  Docs: man:systemd-sysv-generator(8)
  CPU: 12ms
 lampstack-vm systemd:Starting o2cb.service - LSB: Load O2CB cluster
services at system boot
 lampstack-vm systemd:Started  o2cb.service - LSB: Load O2CB cluster
services at system boot

But when I try to bring the o2cb online I see this error:
  root@lampstack-vm:~# service o2cb online
  checking debugfs...
  Loading filesystem "ocfs2_dlmfs": Unable to load filesystem
"ocfs2_dlmfs" Failed

Looking in the syslogs I see:
 root@lampstack-vm:~# grep -i ocfs /var/log/syslog
 lampstack-vm systemd: Started ocfs2.service - LSB: Mount OCFS2
volumes at boot..
 lampstack-vm modprobe: FATAL: Module ocfs2_stackglue not found in
directory /lib/modules/6.1.0-21-cloud-amd64
 lampstack-vm modprobe: FATAL: Module ocfs2_dlmfs not found in
directory /lib/modules/6.1.0-21-cloud-amd64

My GCP VM kernel is version:
 root@lampstack-vm:~# hostnamectl
 Operating System: Debian GNU/Linux 12 (bookworm)
 Kernel: Linux 6.1.0-21-cloud-amd64

It's my understanding that an OCFS2 installation consists of two
parts, the kernel module and the tools module.
I guess installing ocsf2-tools does not install the kernel module?
From other documentation it appears I need to install the
linux-modules-extra package for my kernel.
I have installed the tools module, but I cannot locate the ocfs2
kernel module for Linux 6.1.0-21-cloud-amd64.

I tried to install linux-modules-extra like this:
  root@lampstack-vm:~# apt install linux-modules-extra-6.1.0-21-cloud-amd64
  E: Unable to locate package linux-modules-extra-6.1.0-21-cloud-amd64
  E: Couldn't find any package by glob linux-modules-extra-6.1.0-21-cloud-amd64

Where can I find the linux-modules-extra-6.1.0-21-cloud-amd64 package?
What are my options if the linux-modules-extra-6.1.0-21-cloud-amd64
package is not available?

thank you....paul
