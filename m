Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323278;
	b=Uhm9JMNRVJQkNWgk7vE4HlbWyo85uQcQnOXuhDDdjphmajF1dHo3Ku8C3dwLdNmaScJv
	 RfQYco22eXPXj5aoWySor414zbuor0pDDqDH9gXaHUzvj59EtY7wjPg6PwUCx0noF590A
	 M+RgxNIDhEdup30mwLY50SIWN0Oyvrxpqm1kMvkFvXHK97MG08m8Vppjwsg18wbQmDZMf
	 1s3hQZVf7bMvV2nMF/p+iayaWtxunWglANls/VtXx41sDKo71yFSTZvdAjxErz/+F1zra
	 uUA8bxFD/oV7RfeTISjWk0E8WRt0PV76PdqUgfcQquzHIoby83TM9l84f2fXfCV4lOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
	b=H/p60+n7ozgMSDqYAtWUrbr71oapKfG9hk1tEHtrPjRzrSD1Vg8iOs/BmYh7XKTz522r
	 aJpGBt5ICEELEFABTvsXTdaXh0eL3aDnAuFb1vIsqg0Ka7QmgYhTwrtZRJ7NUwbvsyOBH
	 QqbeAUKurkbLSpah+0Sh+P4VBowy12vtSwvFe0m8Z2PCfLCraHlEqvJYWvs/a/L/0Up/8
	 55biYr1cV3GQH34Dl3DnHBSF9ruXqDtbL42jiaxhi+SBoYw01aFTdDdeCx8mMOwjiZhTF
	 tordr5gqnSzeFBOo+D2cQ4eBbQagc81/StoH9WliJ4xMYOxVRtPOainGcAu/+Ksx6Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WY9WLqSe;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF160A2627
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 15:07:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28CF160A2627
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WY9WLqSe
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e977109392so12284625ad.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 07:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323277; x=1794928077; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=WY9WLqSex8zTA98AgsCgsvySnBnti3hsAcNXSCUIpk1n/rzXAG6GAfga+1NK/udSyr
         SRI7l1rlipLhb5CeOOXpc51O5sUCOLc6scggxIDDDQxlMMulFmAggTt2iI5bmCpV5tLc
         tBicqpnm6fO3bxU7QH56qQDFvqaJ+kouxYSkKpCUx+CS1dXZUsURXQqWDuISEKKB4QIv
         myUAdiXOI9r5D6c+i7gIpsMSXWUpVEemJbNAfDlg7+hbhlTOIIj+bDq2oN7DGeDaQwWb
         ryp22JkxxkpUNiwZ92Sp5yT/DqN93ABcFetLPDaVyN3X/LwmXxu60AId4gSK3V82dtU3
         XDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323277; x=1794928077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=nXsPkhxyuaGB+WN0kCFYdFF+fd1iPi/4sQzLWtMP72b4L63qxV5RwxhNfh5LkALDDW
         SiRW161dLfXowm/iYCLY46zHMGbebfHx0TTkFo8O/HNs6aKWdQNtvyI/lmxCvEmJqQ6/
         kmtdG3/ubQY2UgoTDLShaNR0QgDj0IAadPZ0H6Gd9JsqqkZlX7BZdSJbJia9BZpDvQup
         LY2WoTZ0S6rZQGanNSo9IgpU7GPvKhBnX4UyAyrp7uZS7XFaaAN3tZqR1Hsua5xx+sY3
         X9d6YIadJRsGuml8C2dUmPrQFizWcu4nd131JjeeQqwGz2otqVin5h8sgevS5ZXXKV4Z
         VqGg==
X-Forwarded-Encrypted: i=1; AL+hErEEN4udoK4eDABh55qGOpA5ix4hri1Yw4uWpATP9NB9KIxtbAXENxYHcxcIsg7XJje1Hhy38qY49fK1kw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9VMqcR0H3hBW96fB7Ha7dcoeBgLChc2nf2Eclw5iX1cKPRPI1M
	+VTs8KA2bopbBco4KZJq7rXgfknR/5jVjv6JSPs2H80wkufJtezS78fg
X-Gm-Gg: AYBFou0Ll3We7FDw6xBSHahfw6mxbrL4RpqbnEivvfIWVcYq+VcnRRE3v71vj6Gj2Dl
	0rLlisjSu4p+uOQdz+FYfKk2YHv+hXmLUrETiXoqpUJCbvdvdRmJNDqktkvbfTCTnFlZTrYYiab
	sif6STy1WAwlzt3nDGQt5d3VR4PlfhJoKkYS8BXqOE9hG6J86ect9/p6j0MX+0MrMIyf8+5rom7
	L77xFdcJSPrisKfL8UDpz1kLAO40xjnZN7AoJq0eZnNJTbn6to+6XCkocNQqfqV1+B0mOJLMFTI
	RNk2uBQpH+48WrPx0sluZq/nk6Ss3VBLqodLY3QIYmIMLnNT6s8j/P5OYm79tsM7KCObsnww1aX
	4lt5vjPXedY94mIrBsqidZnnBXFAg1lFRCiYgljjd6X3m0LY9SpTPXgn2wdzUgfFOeTKTluzXKF
	pH0cGoIc+ZJCxVpnHytcxgbBQG7iCHvaZkpPKxnw7+JdwgLR5iur5Fuq2nruEEfs/05KjxXIkfp
	Um72/MDSGGQfaIiLRIjMyigfYcG8gheEyJNkxKdH9ztIqgsN5s08tmZHjv4GksE+e7q+uYr1t44
	SCUudbEcM6S1a9krQpE1TIthcs788Efm5ZVK0NVsPmsbs2qZfF/hfm9Slnn+zyWu99yDutKTNnh
	lJ1S3Ke9HBlg=
X-Received: by 2002:a17:902:d481:b0:2ed:1ef3:9ec with SMTP id d9443c01a7336-2edb9172a2dmr26826345ad.14.1794323276968;
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Received: from [192.168.2.6] ([27.75.101.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d78dbcsm10397575ad.27.2026.11.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Message-ID: <71f76e5e-ce24-4a71-863a-169ad262c510@gmail.com>
Date: Tue, 10 Nov 2026 22:07:46 +0700
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Language: en-US
From: Bui Nguyen Nhu Quynh <kaylovefoss@gmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/2026 4:14 PM, Christian Brauner wrote:
> The file backend takes any path that isn't a block device. With
> buffered_io=1 that includes files on procfs or sysfs which then get read
> and written by a kernel worker on behalf of the host. Refuse files on
> pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index dfa8aa46188c..71c69bac5394 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		goto err;
>  	}
>  
> +	if (file_is_pseudo(ns->file)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 

I noticed patch 41/41 doesn't include a test for nvmet. Would it make
sense to add one with buffered_io=1? The test would need a pseudo file
that can be opened with O_RDWR and supports both read_iter and
write_iter. Otherwise, it could pass without ever reaching the new
file_is_pseudo() check.

Thanks.
