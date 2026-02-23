Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2511A76BB
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Feb 2026 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771809076; cv=none; b=jt+uX0hR4eD22NMWP5PlePksP2seQWeju0tJZkuOX8X213K1YPhbmml12Pi9z7t7T859ywJkLCiG/CYJTJy3ooyKfHrkx26zAeDvYHk4TNtIGwtO44mpPbPmf/wNPlVKK21dyCNS/qZVIFDjxrc4Q1n/FQ/9nbNFojutXX9dApg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771809076; c=relaxed/simple;
	bh=L24fpwGeD7px2wf3dFOvRPZK8x7DN7NZLZ/Tn53Csu8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GpuVHHa7Q0Z6Qe/tXLMqQ44W0nIp9T1kDcDqPRSxV1kCF7hiRuGNA6OxHffE7piYXfX9dI80AwXE3yjanJAH1Y9p996N9WJ9pgK0MvZacJyVUEEw34CAZcpMhj4goyh0PFC4OJACyM3Dq+WS4xPOmgp+nPllwAH5ctt0DbShZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=3QCM/ury; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="3QCM/ury"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3585ec417f6so2316103a91.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Feb 2026 17:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1771809074; x=1772413874; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvESBW1qrUuw3Rqh3QinWReW7kdD3jhBUVJZUasGnN0=;
        b=3QCM/urysElt3bGdQAg8GGNdbyicWeY2GNANGcJ3hco6yTMHvMNKm3K/AEpKwHYsrt
         Bim/1rcnfvqcjVWB8UQMH0T6pjJUVXLeHEKlqWACS2FnhZkAUkpjZC3tASOoSQ5WDkrQ
         LiA9WZMaGc/IGQisbeJEQqdLHrz48tMq+2Ej2l+W3raYmU51VY1NRuc0x94ZTTgVgZ2S
         azSNg/PFTAT3gbhHYBEf4tCgNQYkktub6LzHaE2XNo1MnWvcN+BBIVVImsfbzXQhCk0c
         ShJJXEvylxuAy5Fi+mtnnEEermGProkDzBCmXAV+iMzdfhUvLnSGparK8Nkkru3fpkv4
         djSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771809074; x=1772413874;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RvESBW1qrUuw3Rqh3QinWReW7kdD3jhBUVJZUasGnN0=;
        b=OumphCA4Y+eYLUf1UIJnQ+YsD4Z0+PWARN1jp73NJFeBKSAgVu/SXmlQbm2+rtRWI2
         eWbkZJRoTrQwA47gIoXj5qcD/BJI00EkRUgR/L01ElR1RcmwoqjSmRwtt/g4Lz5MbCsX
         v3rC23wKBVl/Vdb8MC83tNkyy9wPlvMRFzG1+XBcX5YqEUmy0OsePNCUVApBVlgeDKwn
         /LfTeWrAHxHrAktmaxaBPz5Q1gpBrvPKeDRX35d6f1z8LAwWWTqZe1X25aobEVx7sL2/
         KjaUKhXQJRbC9sjywsVRSSUQ/xxuZefL9pFb/E43XX+QTQDn0It/EcHyPKgnCkk9KiUF
         jQog==
X-Forwarded-Encrypted: i=1; AJvYcCWHJc2vUSeAArna6dNL5Hj0rvneuxXjWVWdplqi5CKGXsBXtkm7sLriNgwOwMjVMwPuIGqIev91U6NWWw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxz6PZ1FdgutM7tJanOELrEbpNpAGmG36fVqo6mPw7rJKveDgW
	swGmLScBthEEZ+ltDkqnAlAoA+NOdsPgG9+i/x9P6VF2uEaSYNXXzraK0Ot1FJXnK6U=
X-Gm-Gg: AZuq6aLxgwRGOnrxSC0pnlPJ8VYW6XF2pMKsfAlq8IaL2NCn0RXAxFxLV9nQzGzoCHr
	mGHIr1eosret4OpIMUlhSJJ3yBkkV8s4aaHKd0SGVPFwE7341MWF6JtBN0X1uCMGE5Q+Y75yWkt
	tIVlUkGDWvX2waFp3KFKgsYYmJ3H3hMQcQiXL1H9qe6Uj/dUkM9nd5VC05+02utR/PCn/TW3st+
	t3yieqAXat5jiKBFrNq1Z9h5BXO0GrJI8nPZGOlkJFtKBO4ZjM1ueH3/bH9+5/tBKofk4h8xWQH
	xvRSOpaqPeElaS8QuCCGV39l3r2eK9USN/X3A3oWvv3uqbhYIDGPFrBPz3nnynhzK5/5EnLBB4z
	bIwnqiYYL0YvIPiP3Cc/V774ODeNPvcW3eSJ/JMqsY/mANCs5lqfx6TyDi4OQLWVyk+G7DQuuT0
	1/hWbtX09w15YLq5oQ7t2T2XAjvcni+jV54Auh9z33uOl/xln+KwS62E5NMwSKHOifOrjO93CXz
	0EVrVlqe5Xv5kfz
X-Received: by 2002:a17:90b:2cc7:b0:34c:ab9b:837c with SMTP id 98e67ed59e1d1-358983a8b41mr10989438a91.0.1771809074558;
        Sun, 22 Feb 2026 17:11:14 -0800 (PST)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-358a1a2cb62sm6227722a91.0.2026.02.22.17.11.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Feb 2026 17:11:13 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 1/3] jbd2: store jinode dirty range in PAGE_SIZE units
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <19c79ca43a6.6b379cc81360187.4397285579129640737@linux.beauty>
Date: Sun, 22 Feb 2026 18:11:02 -0700
Cc: Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.cz>,
 Mark Fasheh <mark@fasheh.com>,
 linux-ext4 <linux-ext4@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@lists.linux.dev>,
 Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.com>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <890EF4B9-1907-4122-8272-680845C2058E@dilger.ca>
References: <20260219114645.778338-1-me@linux.beauty>
 <20260219114645.778338-2-me@linux.beauty>
 <63C86D0D-9EF6-4D33-95B2-8D0F5B305B0B@dilger.ca>
 <19c79ca43a6.6b379cc81360187.4397285579129640737@linux.beauty>
To: Li Chen <me@linux.beauty>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Feb 19, 2026, at 23:43, Li Chen <me@linux.beauty> wrote:
>=20
> Hi Andreas,
>=20
> Thanks a lot for your review!
>=20
> ---- On Fri, 20 Feb 2026 05:00:13 +0800  Andreas Dilger =
<adilger@dilger.ca> wrote ---
>> On Feb 19, 2026, at 04:46, Li Chen <me@linux.beauty> wrote:
>>>=20
>>> jbd2_inode fields are updated under journal->j_list_lock, but some =
paths
>>> read them without holding the lock (e.g. fast commit helpers and =
ordered
>>> truncate helpers).
>>>=20
>>> READ_ONCE() alone is not sufficient for i_dirty_start/end as they =
are
>>> loff_t and 32-bit platforms can observe torn loads. Store the dirty =
range
>>> in PAGE_SIZE units as pgoff_t so lockless readers can take non-torn
>>> snapshots.
>>=20
>> When making semantic changes like this, it is best to change the =
variable
>> names as well, so that breaks compilation if bisection happens to =
land
>> between these patches.  Otherwise, that could cause some random =
behavior
>> if jbd2 is treating these as pages, but ext4/ocfs2 are treating them =
as
>> bytes or vice versa.
>>=20
>> Something like i_dirty_{start,end} -> i_dirty_{start,end}_page would =
make
>> this very clear what the units are.
>=20
> Agreed. I=E2=80=99ll make the units explicit in the field names (e.g. =
*_page).
>=20
>> To avoid breakage between the patches (which is desirable to avoid =
problems
>> with automated bisection) you should make an initial patch with =
wrappers to
>> access these values and convert ext4/ocfs2 to use them:
>>=20
>> static inline loff_t jbd2_jinode_dirty_start(struct jbd2_inode =
*jinode)
>> {
>>    return jinode->i_dirty_start;
>> }
>>=20
>> static inline loff_t jbd2_jinode_dirty_end(struct jbd2_inode *jinode)
>> {
>>    return jinode->i_dirty_end;
>> }
>>=20
>> then change this in the jbd2 patch at the end, which would then be =
self-contained:
>>=20
>> static inline loff_t jbd2_jinode_dirty_start(struct jbd2_inode =
*jinode)
>> {
>>    return (loff_t)jinode->i_dirty_start_page << PAGE_SHIFT;
>> }
>>=20
>> static inline loff_t jbd2_jinode_dirty_end(struct jbd2_inode *jinode)
>> {
>>    return ((loff_t)jinode->i_dirty_end_page << PAGE_SHIFT) + =
~PAGE_MASK;
>> }
>=20
>=20
> Agreed as well. I=E2=80=99ll add an accessor and switch ext4/ocfs2 =
over to it first,
> Then do the internal representation change later.
>=20
> I plan to use a single helper that returns the (start,end) pair in
> bytes:
>=20
> static inline bool jbd2_jinode_get_dirty_range(const struct jbd2_inode =
*jinode,
> loff_t *start, loff_t *end)
> {
>    pgoff_t start_page =3D READ_ONCE(jinode->i_dirty_start_page);
>    pgoff_t end_page =3D READ_ONCE(jinode->i_dirty_end_page);
>=20
>    if (end_page =3D=3D JBD2_INODE_DIRTY_RANGE_NONE)
>      return false;
>=20
>    *start =3D (loff_t)start_page << PAGE_SHIFT;
>    *end =3D ((loff_t)end_page << PAGE_SHIFT) + PAGE_SIZE - 1;
>    return true;
>=20
> }
>=20
> I think this is a bit easier to use correctly than separate start/end =
helpers
> (keeps start/end together, and the end-of-page conversion lives in one =
place).
>=20
> Does that sound OK, or would you rather see separate
> jbd2_jinode_dirty_start()/jbd2_jinode_dirty_end() helpers?

This is fine with me.  I had only proposed the other option as a =
"typical"
interface for such fields.  If start/end are always used together then =
it
is fine that there is only one function to get these fields, and one to
set them.

Cheers, Andreas




