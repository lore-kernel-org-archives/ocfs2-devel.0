Received: from forward500d.mail.yandex.net (forward500d.mail.yandex.net [178.154.239.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAFD3DCDBC
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Jul 2026 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783670096; cv=none; b=F65N2T6gO7wEX6k2xJ04FMUTnXDIsOk6jSp/Fr8SOjSkKRO37bPpyNruJZmgz2tViWV4l8DFSx1yhq3nsd8FzuVEx9tTJxlnKsN6VF7WXSSjH2lF+OWfdBQD1qxXyt4IUFdrb4pRzKZTVepKQoIZPTKt/hDO9kAz/YPeKkRe/CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783670096; c=relaxed/simple;
	bh=r+QpkomSdk65be7qVLiopXauLWVsz+LY39UI4SCSJI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W+A4dYYNfMXWSQmAHNFUgBmGHWhssP1IDLiKEpjAbMh9QN1+07zPwZUHHRQuqmi+En3bdKRPHmu0lI/jhvCfeoA1Hd70A7Yyct1aC6xetg+Z5+30G6oJh9YmIZKmrqulu/hC+AaHRFFBwVrQziJPhjgO345hVtCFmPtXyY6uJUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Pi9L5JJC; arc=none smtp.client-ip=178.154.239.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Pi9L5JJC"
Received: from mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:4f41:0:640:844:0])
	by forward500d.mail.yandex.net (postfix) with ESMTPS id 70FAE81AAE;
	Fri, 10 Jul 2026 10:54:45 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net (smtp) with ESMTPSA id hsFZ4l0dPOs0-3cj5QmTW;
	Fri, 10 Jul 2026 10:54:44 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1783670084; bh=Pqauam0jXruaNM3hTlzvMrtafeo56LS3MlRuytVCYrE=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=Pi9L5JJCepyi4G1mz2f7sz1OihbHBww9xqK9NEJ3KPf03mhJ/fcYdHOM1GQkvR/0A
	 G1pwf7F1RFGvVd9i5xRuMzuo2Ooo5OP5DLA+VxIYmhJj/io0VVvAimZbWuqYJxOd5f
	 3yGFgOZMhX7qRf6JF5nqcVm+SGUJZMkwGNhZFz80=
Authentication-Results: mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <f41eea26-44e3-40f9-90e7-6a0dbf14ba72@yandex.ru>
Date: Fri, 10 Jul 2026 10:52:27 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix boundary check in ocfs2_check_dir_entry() to
 use buffer offset
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260710040512.3310736-1-joseph.qi@linux.alibaba.com>
Content-Language: en-US
From: Dmitry Antipov <dmantipov@yandex.ru>
In-Reply-To: <20260710040512.3310736-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/26 7:05 AM, Joseph Qi wrote:

> Commit 390ac56cf0f6 ("ocfs2: add boundary check to ocfs2_check_dir_entry()")
> added an out-of-bounds guard using the caller-supplied 'offset' argument:
> 
> 	if (offset > size - OCFS2_DIR_REC_LEN(1))
> 		return 0;
> 
> However, 'offset' and 'size' are not measured against the same base for
> all callers. In the block-based lookup path, ocfs2_find_entry_el() passes
> 'offset' as an absolute offset into the whole directory:
> 
> 	i = ocfs2_search_dirblock(bh, dir, name, namelen,
> 				  block << sb->s_blocksize_bits,
> 				  bh->b_data, sb->s_blocksize, res_dir);
> 
> while 'size' is a single block size (sb->s_blocksize). For any directory
> entry located in the second or later block, 'offset' is >= sb->s_blocksize,
> so the guard rejects every such entry even though it is perfectly valid and
> lies entirely within its block buffer.
> 
> This makes mounting fail for filesystems whose system directory spans more
> than one block, e.g. a volume formatted with a small block size:
> 
>    mkfs.ocfs2 -b 512 -C 4096 -N 2 -T datafiles --fs-features=usrquota,grpquota
> 
>    ocfs2_check_dir_entry:314 ERROR: directory entry (#18: offset=512) too close to end or out-of-bounds
>    ocfs2_init_local_system_inodes:496 ERROR: status=-22, sysfile=12, slot=0
>    ocfs2_mount_volume:1757 ERROR: status = -22
> 
> The dirent's position within the buffer being validated is
> ((char *)de - buf), which is what the rest of the function already uses
> (via next_offset) and what must be bounds-checked against 'size'. Compute
> that buffer-relative offset and use it for the guard. The subtraction is
> reordered to size - buf_offset < OCFS2_DIR_REC_LEN(1) to avoid an unsigned
> underflow when size is smaller than the minimal record length.
> 
> Fixes: 390ac56cf0f6 ("ocfs2: add boundary check to ocfs2_check_dir_entry()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-and-tested-by: Dmitry Antipov <dmantipov@yandex.ru>

> ---
>   fs/ocfs2/dir.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8e6b032383278..d7fc3cccf2f4b 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -302,10 +302,11 @@ static int ocfs2_check_dir_entry(struct inode *dir,
>   				 unsigned long offset)
>   {
>   	const char *error_msg = NULL;
> +	unsigned long buf_offset = (char *)de - buf;
>   	unsigned long next_offset;
>   	int rlen;
>   
> -	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
> +	if (buf_offset > size || size - buf_offset < OCFS2_DIR_REC_LEN(1)) {
>   		/* Dirent is (maybe partially) beyond the buffer
>   		 * boundaries so touching 'de' members is unsafe.
>   		 */
> @@ -316,7 +317,7 @@ static int ocfs2_check_dir_entry(struct inode *dir,
>   	}
>   
>   	rlen = le16_to_cpu(de->rec_len);
> -	next_offset = ((char *) de - buf) + rlen;
> +	next_offset = buf_offset + rlen;
>   
>   	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>   		error_msg = "rec_len is smaller than minimal";
