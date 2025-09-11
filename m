Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C812E24DD13
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Sep 2025 05:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757570087; cv=none; b=qexG/1H4ot+5PU2nuWkh/jJbjVLbYgOibMV+dbdm8R6sRrSiUpsV0a/6dHquFa49dbBvOu3R6c+qvwWTq68YVgXUyAvm07gIqmUhHvfJ158XDWkYa+cKU1ISujQGk3ZNKCfrPsn/yclpJ/LtkqBG2+ChJUqpCt24XRA7Uzl9rXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757570087; c=relaxed/simple;
	bh=JLVGfMwisW3Y4JGot2IV80m6V+FOPM2PsbTbCgXGcNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJZzSwURgiD6Dqol1uUC61WtJv4bzr03vN4S3hT5aDzhBzT7B1+IEu1dTqqr1S46VAsBe+ALzJdVYfKpklEKBBjcxOgdWM0hRUncju0aZ+/kLy6bXQKxysQM4Yvb2X6uZPmnaCiqwQcMizMMD+I2PfNEaXL+4cMpzQ3GmbXBz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rVURqi0m; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rVURqi0m"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24b21006804so3212385ad.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Sep 2025 22:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757570085; x=1758174885; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7U/qSpu3brb3YBeOIJTTylaUCIcvX4SeZCWNyYbixqI=;
        b=rVURqi0mKYkUuSn4514lHXR8BxF0vGuE+8k+V9jbn44RtKV703vJSitkw3Ig3O5lZL
         BGYY7EU9cR+8eyCTqgHB9umfglHf3QEXwAWpV9FrEylV5vT9AhkiG7W5126V6wDRLvmv
         qAZh2NVn3SXXSKEDbdWwCdVCnm8gbfxuAvCyX8SwZykv/GJ1rtzYM+iKZhJP+GAhAran
         X2jQgXc8jaxZEF+rNcgZw/Re/dbi1UiUX4Gq1c4YEvHI7y5wAbgMLbKgFjhn17bkfV/7
         w6NY+td2HNV/gnNrJ1YEmXqIS8nS7MlseE5BVzXzbzjyeTXZ/YfyURSbu8F8qe0aRwBL
         Dggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757570085; x=1758174885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7U/qSpu3brb3YBeOIJTTylaUCIcvX4SeZCWNyYbixqI=;
        b=vqA6s19czumcrQHq1hmHXOcyLRryEzY0UUBa/qsYATA27wneBNUDOsF3+Z7jRWahc3
         gA79wKiDJTGeJBZC255mO6yhoRdsZrvIrUmH46WNo4tGKTftI8aIWgFHVEMMJFAgZXOJ
         ZQO5YjCNCeVNqxRSs8mBMK0nLcIlTdOsSSG+ddNI89LYUVBIFBnnwo6T+LEMduT050cc
         ZzMJM0j13xipVIiAM7YkFR2zOgRr1rWEvrFxSrKW4pGhjipc3af4x8wMrsOFZAk7nxlA
         qLqGLFJ4Y4Vbx7knh0RWbaKI7StcpfaSdcwEU1M0bKfrw6GoogBZwyTI9nDRETmDuUcc
         Uapw==
X-Forwarded-Encrypted: i=1; AJvYcCWAtcXxsQmWqLxmSZsfTDDStA6cW2yNfpkDsrQcT5lILfKSDwX7sVbCckjYHNfZcJxdDLs8/II5h8CAOA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwOFM2TPdiOL88RxKZHHzKTN9tim03/fzq6V8TijA7cx34gDk+t
	a8qXk3q9aTVP8zlHAMb5q4Q+ikZon6yhME68uFn1ABQUMZ9oYS+ho7lrwAA2+b7Quos=
X-Gm-Gg: ASbGncu7TNbfsTM223m0jymGseS1E3CF4JU1+bINFnJpd4cN8xXhj06z5bAl82MwYqn
	5KLPrAz5ggU8K8osbusiqRBAApvHIqgqC5x66jgcm4abQzmKjfjTwgXKwqn1w4+25nemktZy4fO
	M8Knaky4lp5W2wz7afCmbYq6zu+cBrRZGiTZe08GZXZd7nBdhkesI1YZdIr6SBUfBYbhkJZioW/
	ipwiP0abIsGDcBl1KMymRhzFKDw+nlfBwb22468IV8aYGzMREYY2zll1aZguyyea+G3Ic0zLhWw
	YNhnDk752Fzejf5OUlL+R3a5Mvgavv7DkqV7VkETpTbXfUjtWSvFw1DqEgrwedejTnG2R/Si063
	HdTCzQLZvL613D9Ga9l4/FcbXL8NQYFzd9tgEC4ztqsXJzQu2nDTYmJb701uUpvpyGX9s+lhkic
	UqWFaHzkYy
X-Google-Smtp-Source: AGHT+IEJ8EWH4EX2E0dT8s/g+9UDN2nb1wl7crNvle8QYhSW73RtvbWKXJWPfnOBHU1es1wXSTrLow==
X-Received: by 2002:a17:902:c946:b0:25c:5a14:5012 with SMTP id d9443c01a7336-25c5a1457bemr5452105ad.1.1757570084813;
        Wed, 10 Sep 2025 22:54:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc6c59sm6905715ad.12.2025.09.10.22.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 22:54:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uwaGX-00000000QEt-1mcY;
	Thu, 11 Sep 2025 15:54:41 +1000
Date: Thu, 11 Sep 2025 15:54:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v3 1/4] fs: expand dump_inode()
Message-ID: <aMJkIbDwuzJkH53b@dread.disaster.area>
References: <20250911045557.1552002-1-mjguzik@gmail.com>
 <20250911045557.1552002-2-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911045557.1552002-2-mjguzik@gmail.com>

On Thu, Sep 11, 2025 at 06:55:54AM +0200, Mateusz Guzik wrote:
> This adds fs name and few fields from struct inode: i_mode, i_opflags,
> i_flags and i_state.
> 
> All values printed raw, no attempt to pretty-print anything.

Please use '0x' prefixes for hexadecimal output.....

> 
> Compile tested on for i386 and runtime tested on amd64.
> 
> Sample output:
> [   31.450263] VFS_WARN_ON_INODE("crap") encountered for inode ffff9b10837a3240
>                fs sockfs mode 140777 opflags c flags 0 state 100

.... because reading this I have no idea if "state 100" means a
value of one hundred, 0x100 (i.e. 256 decimal), or something else
entirely. I have to go look at the code to work it out, then I have
to remember that every time I look at one of these lines of output.

When I'm looking through gigabytes of debug output, it's little
things like this make a big difference to how quickly I can read the
important information in the output...

Otherwise it's ok, though I would have added the reference count
for the inode as well...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
