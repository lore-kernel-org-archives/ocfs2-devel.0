Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974289;
	b=Vn1XVbKZn4NtINo/iJsuL9uqv9TdNCYPsqVVrFUMMm59unBae9nOSb+LCtkj58EQTrsf
	 DTDfmAbqNuHKtpxl+U59kPVNBcdAIIUYQqYEFUWWvNu153fVJJlyxeF3vhcJU4MVSmTqq
	 t3goBve7lZCQ8oC1TwaB0jg0kJl76SHmNX9YyaIUV67T8Sa2KMnBlhfG7L5fMTAgn4vsB
	 JmIh+Brmp29rjnVW5ErNXOD5HXnT5jsKi1CfMIuEzivA3ndiCqejscAQ10mWan7cVpQKH
	 u7SUDceoZm/3D3yjE38VIle4WxhSmWV+0ZB0DfhrWin53vsyQ1Nm/ry0kCm8mxdLjEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974289;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=gFAtxYAEt7DoJRTbCotVhzld7oCE+yb42G19+8+4Oi0=;
	b=EBodsPk1FoRVSoT+YXojr6wsVUvJDPhegbPzHL5xvgcj0mRcnn3+1DeOFK/5kWaYkTrM
	 7uUmUNetu7D0sB0PNXcBs1mbdLEUdWKIe/x1ddAgu2eWNLRExRYSEvFu05+KxmiwbBz7E
	 9llV92Rvfh+OlLD0a6ZmXR4P7kxaZg/QK7UCSfAgz7KlhMpFLfBOrkkF57myv9p5VWguN
	 QSZCISRk3ZE98NsuO/AqU0tIL7aSBmYQL2lkBQFeD/DfdNIO7HWA3C+i/PMQMAMei1IFm
	 BBU+uv93u4rW2XChHCxfqBPuaEPl/1jg+S5Td1JY3yGJo+QhzdAnMydjdsnCITM2j6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=SwXcr9H8;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11C6606A331
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 14:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D11C6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=SwXcr9H8
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a59ffacb51so718935e9.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 06 Nov 2026 06:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793974287; x=1794579087; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gFAtxYAEt7DoJRTbCotVhzld7oCE+yb42G19+8+4Oi0=;
        b=SwXcr9H8ZhhG11D+u/th2Ttbsk9mUmkYhOEJMWC2+ZqsogrBbBNdPTnq8TZ03/mmCN
         KCCIuA1Hl8obwrJ5d1U6e5UDVwI2m4M630kB6MYHtrs7hY+IJ6zENFFxfxRF8yf5MM5O
         pqeAB4zFss/NSSbv5YYl8CpP7lhj7t32ZlYXUcP6PUvwXr45bROiUG/LYZFvuinEvWat
         cB/kXPZxvXIGvzMxVDKi9lwEx9RnrXCsDsRcvgBgmDJaOH9LLNaXL4lg8CHoIeAR9LyN
         hOWG6tYxhBXeSB+f0CCkQxGsasFeHjoQT54vQmcDNdU2w7MfrVrfpdhy6Ql+LN7i4zh2
         /aRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974287; x=1794579087;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFAtxYAEt7DoJRTbCotVhzld7oCE+yb42G19+8+4Oi0=;
        b=d0JpFvirL7qhDPPF+gXB6xWs2UTTbvNp5H9uhWgDNeZ30QyOmppF5anTVlXcjJzXnY
         dKTUSuQ/t5uQ2cLmVvsPIgCVwjjB4VviCSoUbujmqG0/UrOUjPuG2loEdg++9vdJNDcW
         MsW1OUr41aKDLmzK40meWMsOkK2dS/ZG3Fxmdu92+LrIdgfNc4XJxXLtz13Mb0GGo9v0
         CXVRkSe7bsDeHz5xMNDHWGdlI831XS6G5Xn/HzOmGQ/QD2BFY9HryobCOdEysI/zv2Nk
         ixWblTQsArVk6NKCN6OVeVVDcLEf5sLVmsmiXregJVurQHqkN7m6VLNuqvirnl6YSnnF
         evww==
X-Forwarded-Encrypted: i=1; AKwUvBzcjcAVFqhCZ837B39Uw5g3leNBHbt2ilADrudamGdz7no+0MDcf3g9iO3WhYbe/osO0QNxfH09FM8cpA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9BHVDbTQHGDhgL0Gaj2/dOI+BCxwq/wUqqFUzejdGSyHHCKGO0
	r9GmPSKEHp6/yQE8i8USLab0fg0u8zbKuwg7XCYxW7oFPPgRoqiCVcCGulGm4wAtj4s=
X-Gm-Gg: AYBFou0Rk7UibApjaxBcFQ+a5c47k4mE4R5Qo5aJeZcvT0QH8MqOcdFb8peT3IZiUAy
	tlWmmkacWy0IfJid4k02+6CEXgdAqZv7hJQxybv65DC+CWb1tlcFSX8KirzAPQU/4NB+89AtKCD
	hH5nFvLO0FQi/lH371wq0d6hjfdJvKSGZW9SIDH/dvG0+rt8CIL+hXR7Df95lxEkDuZRq90BshO
	OuBegeV1fg7lZx2e+9+zWDML9f/AZKpO3iy32o6Sac22/def+X/4rED+pTAY4x2Gea1vcWlVzQD
	uj16S+dH9JkxOeNdE2phAFwZkELmgKdaH+mNXt+k/XsJKisU9xUpMRIEl38ZVvW+Un1KyTBZ4sk
	fxKg2NQiYJW8UPwAeTjhT+A/j8UEeH4aIC61ZKL/DJhL1AY0HqGGicls2BzgiKcWAP4D4SQisw1
	DWyJIuCzL711yh8jCJ+JtR3TiJgRsjqhJhdVnlwTEFtn5URBC+bGFcG8fqPrvtoiwrnZ79BTKU+
	jHi4ybwVzO/5rHzKhaxqB83r2jFPDWeSVCGW21wQrrGW1uU35j8BkMhxowJRzPRVg0JwXPCA6CO
	kLfzpe5pQvFPt4hBPN07GYLm+6gDrmXzkg==
X-Received: by 2002:a05:600c:e547:10b0:4b6:2242:d0d5 with SMTP id 5b1f17b1804b1-4b6d82b2be4mr28521225e9.0.1793974287161;
        Fri, 06 Nov 2026 06:11:27 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa30138fesm7420962eec.0.2026.11.06.06.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 06:11:26 -0800 (PST)
Message-ID: <da47a96d-3238-4907-a243-9f775e64710b@suse.com>
Date: Fri, 6 Nov 2026 22:11:20 +0800
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
Subject: Re: [RFC PATCH v5 2/4] ocfs2: switch DIO read path from buffer_head
 to iomap
To: Christoph Hellwig <hch@lst.de>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261105071930.16399-1-heming.zhao@suse.com>
 <20261105071930.16399-3-heming.zhao@suse.com> <20261106104831.GB5746@lst.de>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20261106104831.GB5746@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/26 18:48, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 03:19:26PM +0800, Heming Zhao wrote:
>> Migrates the DIO read path from the legacy buffer_head infrastructure
>> to the modern and more efficient iomap framework.
>>
>> Under the current code, ocfs2 holds a cluster lock during DIO via
>> ocfs2_iocb_set_rw_locked(), and releases the cluster lock in
>> ocfs2_dio_end_io() via ocfs2_iocb_clear_rw_locked(). The lock level is
>> stashed in iocb->private.
>>
>> However, iomap DIO owns that field (it stores a bio there for polled I/O
>> and unconditionally clears it before calling ->end_io). Any side-channel
>> state packed into iocb->private is corrupted, which trips the end_io
>> lock-state check.
>>
>> Instead, encode the unlock level by passing distinct iomap_dio_ops methods
>> (ocfs2_iomap_dio_ops_pr for PRMODE or ocfs2_iomap_dio_ops_ex for EXMODE).
>> Additionally, the *_iter() functions use the split __iomap_dio_rw() +
>> iomap_dio_complete() API so they can determine unambiguously, from the
>> return value, whether the completion handler already dropped the lock
>> (real I/O, sync or -EIOCBQUEUED) or whether the caller must drop it
>> (no I/O issued, or buffered fallback).
>>
>> The new function ocfs2_iomap_begin() performs a similar role to
>> ocfs2_get_block(). While ocfs2_get_block() retrieves only one block per
>> call, ocfs2_iomap_begin() can handle multiple blocks at once. Limit the
>> map offset and length in ocfs2_iomap_begin() to OCFS2_MAX_LOGICAL_BLOCK
>> to avoid overflow issues.
>>
>> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/Kconfig    |   1 +
>>   fs/ocfs2/aops.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ocfs2/aops.h     |   4 ++
>>   fs/ocfs2/file.c     |  62 +++++++++++++++++++++----
>>   fs/ocfs2/ocfs2_fs.h |   3 ++
>>   5 files changed, 172 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
>> index 2514d36cbe01..bf1678a5eb01 100644
>> --- a/fs/ocfs2/Kconfig
>> +++ b/fs/ocfs2/Kconfig
>> @@ -7,6 +7,7 @@ config OCFS2_FS
>>   	select CRC32
>>   	select QUOTA
>>   	select QUOTA_TREE
>> +	select FS_IOMAP
>>   	select FS_POSIX_ACL
>>   	select LEGACY_DIRECT_IO
>>   	help
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 0f7502de9b8d..8e4d31cb85db 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -4,6 +4,7 @@
>>    */
>>   
>>   #include <linux/fs.h>
>> +#include <linux/iomap.h>
>>   #include <linux/slab.h>
>>   #include <linux/highmem.h>
>>   #include <linux/pagemap.h>
>> @@ -2534,6 +2535,116 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>   				    ocfs2_dio_end_io, 0);
>>   }
>>   
>> +static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>> +		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	int ret;
>> +	struct ocfs2_map_block map;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +	u8 blkbits = inode->i_blkbits;
>> +
>> +	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Calculate the first and last logical blocks respectively.
>> +	 */
>> +	map.lblk = offset >> blkbits;
>> +	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
>> +			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
>> +	map.flags = 0;
>> +
>> +	if (flags & IOMAP_WRITE) {
>> +		return -EOPNOTSUPP;
>> +	} else {
> 
> No need for an else after a return..

OK.

> 
>> +	/*
>> +	 * Before returning to iomap, let's ensure the allocated mapping
>> +	 * covers the entire requested length for atomic writes.
>> +	 */
>> +	if (flags & IOMAP_ATOMIC) {
> 
> IOMAP_ATOMIC is never set for reads.
> 

Thanks for your review, I will remove it on next version.

Thanks,
Heming

