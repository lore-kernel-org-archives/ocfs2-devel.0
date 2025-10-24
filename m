Received: from forward500d.mail.yandex.net (forward500d.mail.yandex.net [178.154.239.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97141A9FBC
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Oct 2025 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761299409; cv=none; b=NYAoBdwQ8Wf3JpFUuv95saIt8JEQnoCZzYaD/PndxlADpuSti4FwCnWcv7YAs71a3uB9YxCqN76DHQNH+NLuZTBU7A5vV4kDBhGOt/MMq4ZqDCufTV029/iZRVjErtrJc3tQT4h+vbLmMTIYNdvUHLxP5mhFsJKyQI2z3Y1QY/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761299409; c=relaxed/simple;
	bh=WLdYR56WUWyG9mKog+vhm4l31od8MNz4B+Ue8Otvqww=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=eqLJpmSGD836v9qcn+wp5JCjyo7cEwOhsc1t3q3M2uu5cri0bIX3ADal2cShsC281SEvllGmdwHI57N18dsPLGOkuxv1jYMAKiJ1Yf3E50S0uJgODlsXSWOrau6VHtwRu0UmSQfaidQ4cjkv/cDHflJIeiv+iYMpGFKzUY0NxA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=FFH8eFtB; arc=none smtp.client-ip=178.154.239.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="FFH8eFtB"
Received: from mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:3d48:0:640:52d7:0])
	by forward500d.mail.yandex.net (Yandex) with ESMTPS id 135D781341;
	Fri, 24 Oct 2025 12:49:58 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id unVBFRPL8Ko0-vZVaXdSb;
	Fri, 24 Oct 2025 12:49:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761299397; bh=WLdYR56WUWyG9mKog+vhm4l31od8MNz4B+Ue8Otvqww=;
	h=In-Reply-To:Subject:To:From:Cc:Date:References:Message-ID;
	b=FFH8eFtBtB7BKxPIn5xyaHGd1p/FpFg7mLAepiOIxmbhwayxjKkrXTtjyVKdxq3te
	 TZRUElTtr8oRlWn4UIDFQx2p8HCmiFyJ49AQyJ5IJcPElBPQ3bMSnMp44loCcWsAsF
	 RnD/Gyc4WiBXVaYdMtCiq/RgHrQSh5fuvk9Pm7GM=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <eee1406a-e2e5-4e97-82fa-bed6064b49bb@yandex.ru>
Date: Fri, 24 Oct 2025 12:49:56 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-MW
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
References: <20251023141650.417129-1-dmantipov@yandex.ru>
 <75608a44-e803-4265-9000-f93d048cc30e@linux.alibaba.com>
 <43f2a8e8-b7bf-450c-b00c-dafe31b538b1@yandex.ru>
 <6c276c88-24ef-4854-8008-a468bd3cee7f@linux.alibaba.com>
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 xsDNBGBYjL8BDAC1iFIjCNMSvYkyi04ln+5sTl5TCU9O5Ot/kaKKCstLq3TZ1zwsyeqF7S/q
 vBVSmkWHQaj80BlT/1m7BnFECMNV0M72+cTGfrX8edesMSzv/id+M+oe0adUeA07bBc2Rq2V
 YD88b1WgIkACQZVFCo+y7zXY64cZnf+NnI3jCPRfCKOFVwtj4OfkGZfcDAVAtxZCaksBpTHA
 tf24ay2PmV6q/QN+3IS9ZbHBs6maC1BQe6clFmpGMTvINJ032oN0Lm5ZkpNN+Xcp9393W34y
 v3aYT/OuT9eCbOxmjgMcXuERCMok72uqdhM8zkZlV85LRdW/Vy99u9gnu8Bm9UZrKTL94erm
 0A9LSI/6BLa1Qzvgwkyd2h1r6f2MVmy71/csplvaDTAqlF/4iA4TS0icC0iXDyD+Oh3EfvgP
 iEc0OAnNps/SrDWUdZbJpLtxDrSl/jXEvFW7KkW5nfYoXzjfrdb89/m7o1HozGr1ArnsMhQC
 Uo/HlX4pPHWqEAFKJ5HEa/0AEQEAAc0kRG1pdHJ5IEFudGlwb3YgPGRtYW50aXBvdkB5YW5k
 ZXgucnU+wsEJBBMBCAAzFiEEgi6CDXNWvLfa6d7RtgcLSrzur7cFAmYEXUsCGwMFCwkIBwIG
 FQgJCgsCBRYCAwEAAAoJELYHC0q87q+3ghQL/10U/CvLStTGIgjRmux9wiSmGtBa/dUHqsp1
 W+HhGrxkGvLheJ7KHiva3qBT++ROHZxpIlwIU4g1s6y3bqXqLFMMmfH1A+Ldqg1qCBj4zYPG
 lzgMp2Fjc+hD1oC7k7xqxemrMPstYQKPmA9VZo4w3+97vvnwDNO7iX3r0QFRc9u19MW36wq8
 6Yq/EPTWneEDaWFIVPDvrtIOwsLJ4Bu8v2l+ejPNsEslBQv8YFKnWZHaH3o+9ccAcgpkWFJg
 Ztj7u1NmXQF2HdTVvYd2SdzuJTh3Zwm/n6Sw1czxGepbuUbHdXTkMCpJzhYy18M9vvDtcx67
 10qEpJbe228ltWvaLYfHfiJQ5FlwqNU7uWYTKfaE+6Qs0fmHbX2Wlm6/Mp3YYL711v28b+lp
 9FzPDFqVPfVm78KyjW6PcdFsKu40GNFo8gFW9e8D9vwZPJsUniQhnsGF+zBKPeHi/Sb0DtBt
 enocJIyYt/eAY2hGOOvRLDZbGxtOKbARRwY4id6MO4EuSs7AzQRgWIzAAQwAyZj14kk+OmXz
 TpV9tkUqDGDseykicFMrEE9JTdSO7fiEE4Al86IPhITKRCrjsBdQ5QnmYXcnr3/9i2RFI0Q7
 Evp0gD242jAJYgnCMXQXvWdfC55HyppWazwybDiyufW/CV3gmiiiJtUj3d8r8q6laXMOGky3
 7sRlv1UvjGyjwOxY6hBpB2oXdbpssqFOAgEw66zL54pazMOQ6g1fWmvQhUh0TpKjJZRGF/si
 b/ifBFHA/RQfAlP/jCsgnX57EOP3ALNwQqdsd5Nm1vxPqDOtKgo7e0qx3sNyk05FFR+f9px6
 eDbjE3dYfsicZd+aUOpa35EuOPXS0MC4b8SnTB6OW+pmEu/wNzWJ0vvvxX8afgPglUQELheY
 +/bH25DnwBnWdlp45DZlz/LdancQdiRuCU77hC4fnntk2aClJh7L9Mh4J3QpBp3dh+vHyESF
 dWo5idUSNmWoPwLSYQ/evKynzeODU/afzOrDnUBEyyyPTknDxvBQZLv0q3vT0UiqcaL7ABEB
 AAHCwPYEGAEIACAWIQSCLoINc1a8t9rp3tG2BwtKvO6vtwUCZgRdSwIbDAAKCRC2BwtKvO6v
 t9sFC/9Ga7SI4CaIqfkye1EF7q3pe+DOr4NsdsDxnPiQuG39XmpmJdgNI139TqroU5VD7dyy
 24YjLTH6uo0+dcj0oeAk5HEY7LvzQ8re6q/omOi3V0NVhezdgJdiTgL0ednRxRRwNDpXc2Zg
 kg76mm52BoJXC7Kd/l5QrdV8Gq5WJbLA9Kf0pTr1QEf44bVR0bajW+0Lgyb7w4zmaIagrIdZ
 fwuYZWso3Ah/yl6v1//KP2ppnG0d9FGgO9iz576KQZjsMmQOM7KYAbkVPkZ3lyRJnukrW6jC
 bdrQgBsPubep/g9Ulhkn45krX5vMbP3wp1mJSuNrACQFbpJW3t0Da4DfAFyTttltVntr/ljX
 5TXWnMCmaYHDS/lP20obHMHW1MCItEYSIn0c5DaAIfD+IWAg8gn7n5NwrMj0iBrIVHBa5mRp
 KkzhwiUObL7NO2cnjzTQgAVUGt0MSN2YfJwmSWjKH6uppQ7bo4Z+ZEOToeBsl6waJnjCL38v
 A/UwwXBRuvydGV0=
Subject: Re: [PATCH] ocfs2: add inline inode consistency check to
 ocfs2_validate_inode_block()
In-Reply-To: <6c276c88-24ef-4854-8008-a468bd3cee7f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/25 12:10 PM, Joseph Qi wrote:

> Yes, if dinode with flag OCFS2_INLINE_DATA_FL set and also has clusters,
> something goes wrong, right?

Yes. Such an inode passes 'if (fe->i_clusters)' check in 'ocfs2_truncate_for_delete()'
and then goes to 'ocfs2_commit_truncate()'. And this function (mis)uses di->id2.i_list
member, which is actually di->id2.i_data if dinode data is inlined.

Dmitry
