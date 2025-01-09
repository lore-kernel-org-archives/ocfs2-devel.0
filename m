Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34B121E08A
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jan 2025 15:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736437539; cv=none; b=QDfeaPs8otRyCCs+wj9b2AyYLDpiXXR3WLbfoZOE4CYVsn2he8hPx4Gf2r7CYMIWrFSh+YmdzgnY2/6vt/q1aXnp23dxLJVJuhPAtIbM+T6mN23ZMdBynJp/Qs0n7MXqL5Gl5Rn41JBDw1U0D2yubaMalXD4UNMW5FPRBRbDFVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736437539; c=relaxed/simple;
	bh=2brKe+BKxputZorOKd+f+yIxImiCIbAyHwtB6oU0kzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGeKFkeTKGaLiYWhsx/QBQvtK9ZdXV8mXo5tskWkkDi53gvMlFacyzGh8UYVLhohYXg7vvDBi5cLa+h+qg8XoCnbg/FqFOqR/AUBLCwnLdhVZFKl7OCtqyjKVYXUi8PtQoY4x3Z6k8VHiZ6EPmlY2FUKCSQZM604YvdKm8K/4hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=minyard.net; spf=none smtp.mailfrom=minyard.net; dkim=pass (2048-bit key) header.d=minyard-net.20230601.gappssmtp.com header.i=@minyard-net.20230601.gappssmtp.com header.b=rYLNYmIO; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=minyard.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=minyard.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=minyard-net.20230601.gappssmtp.com header.i=@minyard-net.20230601.gappssmtp.com header.b="rYLNYmIO"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-71e35be77b5so294444a34.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Jan 2025 07:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=minyard-net.20230601.gappssmtp.com; s=20230601; t=1736437536; x=1737042336; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgTp2x21PamB5G5tjbV3jPSQRWSgTUkiJmrzV93coW4=;
        b=rYLNYmIOYvmfXmb+zRNgk72s6dfB5y4ZIRNc14R669pb+t8WZYEzkglRpVpDxf74D9
         DIWZrBQBGjGAnbS93fhlEpO6IwPYwxUgw+To5Z94cH8ahbZ4mPguwfXF3cE7w4ivHhjt
         d2Js+SPDp+6hPKABNO+383lKTACGdIJR+LS1P0gePPIfj+nCOxCTeXslb4H5SZacBrhr
         c6o3j2EMFKO39AK8Cf63onrMoyFJ3HqamZjPUyGkShJzYBsKPPtpZcFnsLnZMLF/gWw2
         JHgKPNSVlRLxMsbODSJPtWzuNVweOTsXh/2xeCptvV/+VgkqPII5bJDSJqv8LK1bJsGK
         IYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736437536; x=1737042336;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgTp2x21PamB5G5tjbV3jPSQRWSgTUkiJmrzV93coW4=;
        b=ZnoVkeu3nttm76PHH4X+AOe4X6E8QLA+YFeiPVRyNLxqz2QSvjhEwhazsGIXbegLy4
         /khoHM3VWsg/81BGdQpRbPXXgGIQ3UrLXUG017C/q4CZ/s3wJdObcpqeusKxlg7S2T8G
         6O4jp8a2KV0FS5RbdDKpwMFEtYg7b4NpqQOCbCSWeLT0jQx8mkKmvXuOMse8Y0XPIFgT
         /qzcc2CnPK+6K3HVdLXBpk1WWW9k9vAYBjs14+X89fPyOvZuc6nqkuivWHChUVMGw7NK
         T+HIbawFmLHlNiw2fNleWPYuHdS1z2UzaI+jol25HKnNsVgdY19SDX+DdHQIuCVc2Iak
         IT1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1U/ogliF4MtEYtYfWsQxrsBFBblo3wtGZ9GGwABHDttKFMLPIGauGvSjHCvE++hs1Fawq1Q/L2uXDBw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzZ0Lxi3jeRfQXHeZVDABRCJZ+RGJPaFWD0EqGelxd9cyAnJl+P
	l+2J0wTy1pK6KETvfbOeajD/18KQTJysEjBSFlAjOneVQiDEtbx9TmddE9ezXbI=
X-Gm-Gg: ASbGnct5mOcqXQBMmmt8bOAEelEUd2JMSML+WcrFHYtR8j53P+BfwYwDmQIoqdorofg
	cnE4LDiJGkfedUTC35y1u8eeLrDXOVDCjZRVXhZbB5WZoYDiPSg8hoW/1BHjcs3zJG/PCAeAe5C
	KYSK/apch4i7LvK56GmCGPUm3BexpmVohCHrkp5dfB8soTpdwuD9xC1xMB6pdMcmy2DPlDymUNL
	cy7KPcJRoRHwqKIRd017AysP9TH3WTKm8xOIxjZI/O9QIYOX9qJXl+SXxAj
X-Google-Smtp-Source: AGHT+IHELUnxP9ZvL+e2Ztemz39I9ORoPYZLTVwEa+XG73J5uz7w7yM0cuXu9KZqTaUsGk+1/+jmGA==
X-Received: by 2002:a05:6830:6610:b0:716:a95d:9ef with SMTP id 46e09a7af769-721e2e000d6mr4949630a34.2.1736437534534;
        Thu, 09 Jan 2025 07:45:34 -0800 (PST)
Received: from mail.minyard.net ([2001:470:b8f6:1b:9076:47eb:1e0a:16fb])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f882625f0esm386258eaf.9.2025.01.09.07.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 07:45:34 -0800 (PST)
Date: Thu, 9 Jan 2025 09:45:27 -0600
From: Corey Minyard <corey@minyard.net>
To: Joel Granados <joel.granados@kernel.org>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org,
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	io-uring@vger.kernel.org, bpf@vger.kernel.org,
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
Message-ID: <Z3_vF3I453flXoZv@mail.minyard.net>
Reply-To: corey@minyard.net
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>

On Thu, Jan 09, 2025 at 02:16:39PM +0100, Joel Granados wrote:
> Add the const qualifier to all the ctl_tables in the tree except the
> ones in ./net dir. The "net" sysctl code is special as it modifies the
> arrays before passing it on to the registration function.
> 
...
> diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
> index 941d2dcc8c9d..de84f59468a9 100644
> --- a/drivers/char/ipmi/ipmi_poweroff.c
> +++ b/drivers/char/ipmi/ipmi_poweroff.c
> @@ -650,7 +650,7 @@ static struct ipmi_smi_watcher smi_watcher = {
>  #ifdef CONFIG_PROC_FS
>  #include <linux/sysctl.h>
>  
> -static struct ctl_table ipmi_table[] = {
> +static const struct ctl_table ipmi_table[] = {
>  	{ .procname	= "poweroff_powercycle",
>  	  .data		= &poweroff_powercycle,
>  	  .maxlen	= sizeof(poweroff_powercycle),

For the IPMI portion:

Acked-by: Corey Minyard <cminyard@mvista.com>

