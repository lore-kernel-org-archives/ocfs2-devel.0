Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F389619E816
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 03:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718680755; cv=none; b=NR1IP+zkxqEZ9yZM1acj5DFglq468abMyg+oz/sgCcqp9OApLN81YX4aXo9g2ZKg+LXB9mLpU90JnYswKjXte7RR+gqgsBWyWAjwNUtcsPq/ylvvhDVuAIKeNZn9biTU6b4hfO9yMmZELvYc8o88mgOIiZQPoJhTtsjYuXh5+EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718680755; c=relaxed/simple;
	bh=E8+GLqzfezu+pQJhpvxMYh3Ij8nJzY4Z10z0CP4WP38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u7AX91+WK6odOxtFCKOk9ETGZ9jLNWnd3kfzcaSLkRIBdaI0C7+5k8RSZhUUEmZuD571riHvLo0XRUMhlN2nYuRI8Oy09OgF6WSM9nCnoMiNQqLfRdTAlAbNr28OIRH6wBK3TYICmLA0+xrejis4tFoGxU540rooruRp+xdbhAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dZhmx1gA; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dZhmx1gA"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2eadaac1d28so52629241fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 20:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718680750; x=1719285550; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FXh8ZfXnjbuW3CxAd8KkZ3q3lYd/tqSqAM9GU1NIHvM=;
        b=dZhmx1gAeoiPCq03MuQ2WQ3Yp5u/Z7jrHN7fF6RJVKadF6EdGpemj76/OTtfnSNRjT
         5YSVGLUEGjC4nWhUOEISXxZPCWiw15+eUJtNgIvbYCLlcfosBDZWEj1VeIYsuGIRkKXX
         c/Dhwkt2hyefwbj72s9VmYH4bDLxlgBtoJ6Ox7vJPlrPfYLHSn6byhoLlT+KeWRevFa6
         vyYLZO0Lwfry/8nkdhOr6i3dxbwe1s/8ZmVSB6w5qYnv1NzXbVibW5Hl0cZAc8OWb+7/
         anAnJp8MNhs3OaZN9WsrIxEll/kvDTv/5WgFk/gxG2gRklTl68LjW+WLrUA4mzoGrzyk
         8QMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718680750; x=1719285550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXh8ZfXnjbuW3CxAd8KkZ3q3lYd/tqSqAM9GU1NIHvM=;
        b=MUIEXFV7xa2jcFYaKKpAqMMYP4lb2ipM60CvfQ0XIYLg5WyoILkXSAdLI/03eE+Ahq
         OFfzUm/IaM5NjXpB0WR385D7bH7cyttnkb8TfJWr3veym2K+GiqJ5lAgZ4mqZkTlROmH
         RQTUpXa1AAGJw/hjmqnhPpDN/D8X1/cwlmcMpT0PH09QxUypowybxn5LhzTyNRh7rl7U
         oDAB+ItgnuVPtxj7aezQDy1jiaDUGen3SfzTXj+EMgO6wLUuMS6c+oyAsqrdpwzmY2hD
         65PWhVLMyPaURvmltkQwVI2GkqX0OAv2eF9YxnTOYIGIQ9ZrYwqFWUI5E4gPz2IeWNyt
         lhiA==
X-Gm-Message-State: AOJu0YyEZWaoprPUGSKqArhFqYRWVceNyETCehGUYfZx0ZlChtAcyu0J
	OdI/+iFR/CuqKgslwbw+I7tCMVCuhj4zWMgQOApwGiB7dB9yjUn7TECCkSNwJbI=
X-Google-Smtp-Source: AGHT+IHOmhKaTTGII7KoaTpMiVDpW7qZryWZ5M4xUupnu4bWGmR9OM3nW4zxyaW0wv3/qXxHg4Gp8A==
X-Received: by 2002:a2e:950f:0:b0:2ea:8d54:4530 with SMTP id 38308e7fff4ca-2ec0e47b682mr75689451fa.28.1718680749917;
        Mon, 17 Jun 2024 20:19:09 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fede16af59sm7313852a12.30.2024.06.17.20.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 20:19:09 -0700 (PDT)
Message-ID: <34170f8b-7c72-4973-a047-dbe4efce10f8@suse.com>
Date: Tue, 18 Jun 2024 11:19:05 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: lei lu <llfamsec@gmail.com>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240606065455.94846-1-llfamsec@gmail.com>
 <046696eb-4e56-4190-8295-d77a8b5cb522@linux.alibaba.com>
 <CAEBF3_bXhKw+CBsTQBonM3ZTSZB7hyTJiV6wrw7=3pieYT0DYg@mail.gmail.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CAEBF3_bXhKw+CBsTQBonM3ZTSZB7hyTJiV6wrw7=3pieYT0DYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/8/24 12:23, lei lu wrote:
> On Sat, Jun 8, 2024 at 9:41 AM Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>>
>>
>> On 6/6/24 2:54 PM, lei lu wrote:
>>> This adds sanity checks for ocfs2_dir_entry to make sure all members of
>>> ocfs2_dir_entry don't stray beyond valid memory region.
>>>
>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>> ---
>>>   fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
>>>   1 file changed, 20 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index d620d4c53c6f..85966385d134 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -294,13 +294,14 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>>>    * bh passed here can be an inode block or a dir data block, depending
>>>    * on the inode inline data flag.
>>>    */
>>> -static int ocfs2_check_dir_entry(struct inode * dir,
>>> -                              struct ocfs2_dir_entry * de,
>>> -                              struct buffer_head * bh,
>>> +static int ocfs2_check_dir_entry(struct inode *dir,
>>> +                              struct ocfs2_dir_entry *de,
>>> +                              struct buffer_head *bh, char *buf, unsigned int size,
>>
>> Don't see why we have to pass 'buf' here.
>> Seems it can be obtained from bh directly.
> 
> We can not simply obtained de from bh->b_data. Because in
> ocfs2_search_dirblock, the beginning of bh->b_data is ocfs2_dinode
> (found in caller ocfs2_find_entry_id). But in ocfs2_find_dir_space_el,
> we can see "de = (struct ocfs2_dir_entry *) bh->b_data;", which means
> the beginning of bh->b_data is de directly. I'm not sure what's
> causing this difference.
> 
>>
>>>                                 unsigned long offset)
>>>   {
>>>        const char *error_msg = NULL;
>>>        const int rlen = le16_to_cpu(de->rec_len);
>>> +     const unsigned long next_offset = ((char *) de - buf) + rlen;
>>>
>>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>>>                error_msg = "rec_len is smaller than minimal";
>>> @@ -308,6 +309,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>>>                error_msg = "rec_len % 4 != 0";
>>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>>>                error_msg = "rec_len is too small for name_len";
>>> +     else if (unlikely(next_offset > size))
>>> +             error_msg = "directory entry overrun";
>>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
>>> +              next_offset != size)
>>
>> Seems we also have to consider meta ecc.
> 
> Sorry, I'm not very familiar with this.
> 
>>
>>> +             error_msg = "directory entry too close to end";
>>>        else if (unlikely(
>>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>>>                error_msg = "directory entry across blocks";
>>> @@ -352,16 +358,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>>>        de_buf = first_de;
>>>        dlimit = de_buf + bytes;
>>>
>>> -     while (de_buf < dlimit) {
>>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>                /* this code is executed quadratically often */
>>>                /* do minimal checking `by hand' */
>>>
>>>                de = (struct ocfs2_dir_entry *) de_buf;
>>>
>>> -             if (de_buf + namelen <= dlimit &&
>>> +             if (de->name + namelen <= dlimit &&
>>>                    ocfs2_match(namelen, name, de)) {
>>>                        /* found a match - just to be sure, do a full check */
>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes offset)) {
>>
>> It looks buggy, even cannot compile.
>> Have you compiled and then verified with your POC?
> 
> I have compiled and tested it. And I got an output as below:
> root@syzkaller:~# mount -o loop ocfs2-test.img /mnt/ocfs2-test
> [  116.777184] loop0: detected capacity change from 0 to 40960
> [  116.843546] (mount,232,0):ocfs2_init_global_system_inodes:461
> ERROR: status = -22
> [  116.843946] (mount,232,0):ocfs2_init_global_system_inodes:462
> ERROR: Unable to load system inode ?
> [  116.844001] (mount,232,0):ocfs2_init_global_system_inodes:472
> ERROR: status = -22
> [  116.844821] (mount,232,0):ocfs2_initialize_super:2251 ERROR: status = -22
> [  116.845590] (mount,232,0):ocfs2_fill_super:1176 ERROR: status = -22
> mount: /mnt/ocfs2-test: wrong fs type, bad option, bad superblock on
> /dev/loop0, missing codepage or.
> 
> The ocfs2_check_dir_entry was not called because "de->name + namelen
> <= dlimit && ocfs2_match(namelen, name, de)" was not meet. I think
> "while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN)" has taken effect, and
> we got an error elsewhere.
> 

Hi,

I am not agree with the above statement. Based on your test, (applied this
patch), there must be another issue preventing the mount from succeeding.
"mount -o loop" command shouldn't cause an error in this case.

-Heming
