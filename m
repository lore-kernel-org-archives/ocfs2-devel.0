Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E472EAE5
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jan 2025 02:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736304222; cv=none; b=gF4lgdNIcOO99GJmBH7kJmzIz/0e2Xy2UOd9tEfmWZO5V3yZJps7clGl3P8MWKMFn1pN22MXjBN1dqhEnK5jMVVqklGDCPWH6xpXcdBDFb3tumia2TsNrzZbRHOxIfa5HS86RrL/vjsnvJB1m9OVyAikKptSaajDCPPEiZDxhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736304222; c=relaxed/simple;
	bh=jbndbT1TVrQWV/QcCMGQqbFW9abFjV6Z0vSLVkbGZ10=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=f9vPO3yR0q80tqIF+kP+kXPQuSs/ijkBo0VhDyKH1cUgjAJ9oNzwksGA7f3+B1ZDJR/fwEg3oUVq32OaLT6ePXew7LhPBrRCNJNjh0hk+cvthXIQ7HuOKi4sFHvvt3EJmuzVk8elnWLKZiZGiSXrqix+wDXtquiaOd2UHJODGGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A/zJoeE4; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A/zJoeE4"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaeecbb7309so412305466b.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Jan 2025 18:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736304218; x=1736909018; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9Gobt4MmSxBxooGGU0OSNlpyqCLtpUyo1c7DCwlI+c=;
        b=A/zJoeE4irqRn6UIhoTmOoCu8XGM7E90kDnWPBXvbK9WzsI8eQ/nlIYUlY2M09lEeg
         La1ktKuJa16xHsdsA6vRGeOcMSAw3486/u+EHx+W3xgyrQtXsyNqCybARKkUb2UBigon
         RfOFCJEdlrYc0i2K+yvVWt0pnA79NwSZjfE4TxzyiyccYk4weAxBzJKJZ/J3O+7sPKNK
         /HRjzBfgalFUG6VWMBr84IHi//k3koUEzNepvpTog7hmEvUD7aZkqmDoCrWSt/O4jeT8
         peX9zFeDO+tc+nFMxUnQ6IeZK788PPME77URzCVpvSbvFn+YRc36GqWJI7egCGbdt6c3
         8G5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736304218; x=1736909018;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i9Gobt4MmSxBxooGGU0OSNlpyqCLtpUyo1c7DCwlI+c=;
        b=VWz4l576H9E8hAbDcCULVfkGU3ZVdBmpKXuA5zufQfHm8suWU+YzPMfZzKVMkUtUhn
         /MaYr2sTWIcouFcLRpTk4MTeOuviufatpI0nmBKKcjgLTg+DeWPeqs4n6SaUiKYmjp68
         xA5maoURh2e/0ZhI6PaKvqTgHFUeQw9WtlPIG7s6YuMDsIZbqhW1+J+vSkHPZm9qaWvJ
         GldqI/Odju2uR32BfAWbtSFv8mrrZftiG2vGA6J8yEcrqLBpwPGjPWPNRCypnZ5L2EQ7
         euntNgzY/ZGnE3k+c0SMZ1AyzA62Yb/B9Q6BXrC2puCoGnCoOltyUMbD7eS9YH2uJN10
         SDfg==
X-Gm-Message-State: AOJu0YxakdpTvCI2klHuyRULniXUHeGOOJUidIJYnYTDKiXE05nTf41X
	voHKWw9/RPIHQfKPtqSOacm0BM2dC7ooZJvYMtpsTl19pWvzEvta9/Qn9rJHX+ZF7kfMjW1SpUr
	wBBM=
X-Gm-Gg: ASbGnctXX2++O6prkp3Jmj7+aEsO6ApCG/6UUPOhCR5EwPnN6p3Rkwp3D+H3JeY0Yxl
	eOid1AAIYcvExt5FRru9mmN8hEK3T2neQ9OQtOj9xgGJ1TaRDJfmgDbmiEE75jvDtzKyWIzVokf
	oKEwuBWUgk9kTGS2mjA8V38gRtabrwI4d2XlR+YvzxCp/CQ8FOh2Gi22wfpfob+uTNVDc7abGpZ
	pKPhEFw8npI3/TofyhkKy0dTtgHJsfEYfYpysZJAfDeqwvPPTV6FyyWJU0A
X-Google-Smtp-Source: AGHT+IE1EdnC/RP7bDqY0P4nlAIkRZk+FSbrN3jhbs+K+jedomHFzLeSasdudzuJUr5lTdYCuvFn+A==
X-Received: by 2002:a17:907:971e:b0:aa6:18b6:310e with SMTP id a640c23a62f3a-ab2abc93dfbmr74129966b.38.1736304216429;
        Tue, 07 Jan 2025 18:43:36 -0800 (PST)
Received: from smtpclient.apple ([195.245.241.170])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842dc7eda63sm31627168a12.68.2025.01.07.18.43.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jan 2025 18:43:36 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] ocfs2: check tl->count of truncate log inode in
 ocfs2_get_truncate_log_info
From: Glass Su <glass.su@suse.com>
In-Reply-To: <dfe45022-dec6-4d12-85c0-b0922af1b0d7@linux.alibaba.com>
Date: Wed, 8 Jan 2025 10:43:20 +0800
Cc: ocfs2-devel@lists.linux.dev,
 Liebes Wang <wanghaichi0403@gmail.com>,
 syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5E5AAE94-56F6-43B6-8F6B-D4AE2CCDCAA0@suse.com>
References: <20250106140647.92276-1-glass.su@suse.com>
 <dfe45022-dec6-4d12-85c0-b0922af1b0d7@linux.alibaba.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On Jan 7, 2025, at 17:37, Joseph Qi <joseph.qi@linux.alibaba.com> =
wrote:
>=20
>=20
>=20
> On 2025/1/6 22:06, Su Yue wrote:
>> syz reported:
>>=20
>> (syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: bug
>> expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
>> tl_count =3D=3D 0
>> (syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: =
Truncate
>> record count on #77 invalid wanted 39, actual 2087
>> ------------[ cut here  ]------------
>> kernel BUG at fs/ocfs2/alloc.c:5874!
>> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
>> CPU: 0 UID: 0 PID: 5313 Comm: syz-executor404 Not tainted
>> 6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
>> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
>> RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
>> RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
>> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
>> RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
>> R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
>> R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
>> FS:  00005555722df380(0000) GS:ffff88801fc00000(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>> <TASK>
>> ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
>> ocfs2_remove_inode_range+0xff3/0x29f0 fs/ocfs2/file.c:1907
>> ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
>> ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
>> ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2736
>> vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1615
>> __do_sys_copy_file_range fs/read_write.c:1705 [inline]
>> __se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1668
>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fd327167af9
>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 =
89
>> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01
>> f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffe6b8e22e8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000146
>> RAX: ffffffffffffffda RBX: 00007fd3271b005e RCX: 00007fd327167af9
>> RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
>> RBP: 00007fd3271de610 R08: 000000000000d8c2 R09: 0000000000000000
>> R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000001
>> R13: 00007ffe6b8e24b8 R14: 0000000000000001 R15: 0000000000000001
>> </TASK>
>>=20
>> The fuzz image has a truncate log inode whose tl_count is bigger
>> than ocfs2_truncate_recs_per_inode() so it triggers the BUG in
>> ocfs2_truncate_log_append().
>>=20
>> As what the check in ocfs2_truncate_log_append() does, just do same
>> check into  ocfs2_get_truncate_log_info when truncate log inode is
>> reading in so we can bail out earlier.
>>=20
>> Reported-by: Liebes Wang <wanghaichi0403@gmail.com>
>> Link: =
https://lore.kernel.org/ocfs2-devel/CADCV8souQhdP0RdQF1U7KTWtuHDfpn+3LnTt-=
EEuMmB-pMRrgQ@mail.gmail.com/T/#u
>> Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
>> Tested-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>> fs/ocfs2/alloc.c | 14 ++++++++++++++
>> 1 file changed, 14 insertions(+)
>>=20
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 395e23920632..3d1d029d272f 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -6154,6 +6154,9 @@ static int ocfs2_get_truncate_log_info(struct =
ocfs2_super *osb,
>> int status;
>> struct inode *inode =3D NULL;
>> struct buffer_head *bh =3D NULL;
>> + struct ocfs2_dinode *di;
>> + struct ocfs2_truncate_log *tl;
>> + unsigned int tl_count;
>>=20
>> inode =3D ocfs2_get_system_file_inode(osb,
>>    TRUNCATE_LOG_SYSTEM_INODE,
>> @@ -6171,6 +6174,17 @@ static int ocfs2_get_truncate_log_info(struct =
ocfs2_super *osb,
>> goto bail;
>> }
>>=20
>> + di =3D (struct ocfs2_dinode *)bh->b_data;
>> + tl =3D &di->id2.i_dealloc;
>> + tl_count =3D le16_to_cpu(tl->tl_count);
>> + if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
>> +      tl_count =3D=3D 0)) {
>> + status =3D -EFSCORRUPTED;
>> + iput(inode);
>> + mlog_errno(status);
>> + goto bail;
>=20
> Seems you've missed brelse(bh).

I prefer the original style. v2 sent.

> Or we can refactor the code like:
>=20
> status =3D ocfs2_read_inode_block(inode, &bh);
> if (status < 0) {
> mlog_errno(status);
> goto bail;
> }
>=20
> ...
> if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
>      tl_count =3D=3D 0)) {
> status =3D -EFSCORRUPTED;
> mlog_errno(status);
> goto bail;
> }
>=20
> ...
>=20
> bail:
> if (status < 0)
> iput(inode);
> brelse(bh);
> }
>=20
> return status;
>=20
Yes. It also works.

=E2=80=94=20
Su
> Thanks,
> Joseph
>=20
>> + }
>> +
>> *tl_inode =3D inode;
>> *tl_bh    =3D bh;
>> bail:


