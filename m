Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C32D36493A;
	Wed, 16 Sep 2026 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.133.104.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542441; cv=none; b=MfJqjOSEgkFnkKF2p4gPDOrPkm8OSUeGU8+iik7R8fwFD6OImIE9sYVIM18cgju+F3CcQyZjEtx6UGkKluPKm/H/2uV7zfUAnJ4QbfZroKBRQt8vDGSj71p7ze6BfggwB+KnCV3T9q1O/ifKFAXuuauXwRJNm/EHbmF/PzsZ/1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542441; c=relaxed/simple;
	bh=xynsPymiv3WU3HsFIsBHIUBsQZdWEctP+XRoHYb2kao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/tEd8oaPieqaNXYyhr/eUBiHicg5Ei1GIs8cPDpCB0nN+ZuDs6eD4gK8yM6aEPd8ROZA55Q6W5kRFP7I7yeHm/3Mifkln08LFq9MDS0o2rZbAKgEdPEZJn4XvljX5NcbaN/HU1bHpw4qaSeP5Uidzx2l4ID5sQUAQEf0lkrcQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net; spf=pass smtp.mailfrom=iogearbox.net; dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b=SbpC8Ijc; arc=none smtp.client-ip=213.133.104.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b="SbpC8Ijc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=nHqWJxcWJL8kaea7bzuqdKjH1s9OouRzNKirRX9RM7E=; b=SbpC8IjcIunLNEglvGXoVo0RmW
	Bn4luGJAA/r5McFjqr9pXff/PgwpK4BJQtkE3D9OXrVwuJKRGkAfIMP/yyIHV1BGCWMPUeqJ+gzTR
	MusoWIRdftauZMD4IA6xxDutMEUNQ01dEP4SPzyIBdx1HFHA08zKRCW8CIr47MKpuR01O30z1vH5T
	fsjtIZ9z6IJFcSfyjOUS711ASv98SvHy66pd1NdO2sBhWSeHR2ORoFfBo4fYxFPryFRnYmKIR4R3U
	2DpK21UIJpCkboyuoIRQ7a21VBTrBsBm+CnWJ2WdFqwXp+QfBGjBLuzo0EelXcwhdAp5au87NJPlA
	6jtCVUNw==;
Received: from sslproxy08.your-server.de ([78.47.166.52])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1x6jjf-0007rR-0H;
	Wed, 16 Sep 2026 09:07:15 +0200
Received: from localhost ([127.0.0.1])
	by sslproxy08.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <daniel@iogearbox.net>)
	id 1x6jj7-000DiW-1W;
	Wed, 16 Sep 2026 09:06:41 +0200
Message-ID: <f05cc7fb-9766-4b2d-9422-45ea1822578a@iogearbox.net>
Date: Wed, 16 Sep 2026 09:07:13 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in
 ocfs2_initxattrs
To: Heming Zhao <heming.zhao@suse.com>
Cc: alexei.starovoitov@gmail.com, brauner@kernel.org, dwindsor@gmail.com,
 john.fastabend@gmail.com, memxor@gmail.com, kpsingh@kernel.org,
 matt@bobrowski.net, bpf@vger.kernel.org,
 Zhan Xusheng <zhanxusheng@xiaomi.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
References: <20260915150739.284189-1-daniel@iogearbox.net>
 <20260915150739.284189-2-daniel@iogearbox.net> <aqoCVQ78KOo2GZ8S@p15>
Content-Language: en-US
From: Daniel Borkmann <daniel@iogearbox.net>
Autocrypt: addr=daniel@iogearbox.net; keydata=
 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
In-Reply-To: <aqoCVQ78KOo2GZ8S@p15>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: Clear (ClamAV 1.4.3/28124/Tue Sep 15 08:27:28 2026)

On 9/16/26 4:47 AM, Heming Zhao wrote:
> On Tue, Sep 15, 2026 at 05:07:32PM +0200, Daniel Borkmann wrote:
>> ocfs2_mknod() and ocfs2_symlink() ask for the security xattr up front
>> through a struct ocfs2_security_xattr_info, so that they can size the
>> transaction before setting it. ocfs2_initxattrs() duplicates the value
>> since the array security_inode_init_security() hands is freed on return,
>> but keeps the name pointer as-is, given so far every LSM stored a string
>> constant there. bpf_inode_init_xattr() places the name in the same
> 
> Typo? I am not familiar with BPF, but I only found inode_init_security in
> include/linux/lsm_hook_defs.h.

Its part of the series here; should have added "upcoming" in front:

   https://lore.kernel.org/bpf/20260915150739.284189-1-daniel@iogearbox.net/

>> allocation as the value, which security_inode_init_security() frees on
>> its way out. Copy the name alongside the value and free both together.
>> This is the only special case wrt xattrs in the bpf_inode_init_xattr()
>> context.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>
>> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Cc: ocfs2-devel@lists.linux.dev
>> ---
>>   fs/ocfs2/namei.c | 2 ++
>>   fs/ocfs2/xattr.c | 5 +++--
>>   2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index e9c7774ccf91..e24f0e337a56 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -480,6 +480,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>>   
>>   	brelse(new_fe_bh);
>>   	brelse(parent_fe_bh);
>> +	kfree(si.name);
>>   	kfree(si.value);
>>   
>>   	ocfs2_acl_init_release(&acl_state);
>> @@ -2068,6 +2069,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
>>   
>>   	brelse(new_fe_bh);
>>   	brelse(parent_fe_bh);
>> +	kfree(si.name);
>>   	kfree(si.value);
>>   	ocfs2_free_dir_lookup_result(&lookup);
>>   	if (inode_ac)
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 35bcbb0ff607..d83840b6bed9 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -7524,8 +7524,9 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
>>   				    GFP_KERNEL);
>>   		if (!si->value)
>>   			return -ENOMEM;
>> -
>> -		si->name = xattr_array->name;
>> +		si->name = kstrdup(xattr_array->name, GFP_KERNEL);
>> +		if (!si->name)
>> +			return -ENOMEM;
> 
> The ->name is a constant string (i.e., XATTR_NAME_SELINUX). We can refer to
> ext4_initxattrs() => ext4_xattr_set_handle(), which also uses '=' to assign ->name.
ext4 is not affected since nothing is used outside security_inode_init_security
callback. ocfs2 is the only case in the tree affected, see this sashiko report
which this small patch is addressing:

   https://lore.kernel.org/bpf/CAEXv5_gTJcP5BkSysZujLxiUcjbbBNi_NNbAnOJsQQVLyO9HoQ@mail.gmail.com/

Thanks,
Daniel
