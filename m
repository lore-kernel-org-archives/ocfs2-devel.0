Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED0368D45
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789460958; cv=none; b=MMu9y2NPPugv95NkZeCFftnWRkWZxcy66OzrbS8bqSjdxNDE8pMgVx35rDoIXET8JszaKDc+3bjLCOFC+bPeDe0tnqaIGsWE3PCagKj0CZO9LNU1b72KrHHK0n+5UyLI+0hJbFUoOCCKG3vNofT/BnxaiMfr1ix34nFIbNoYgyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789460958; c=relaxed/simple;
	bh=GZN2Gf/Mkslg88zoYNsYAHbRp8SgaHTjwhLMDN7KZng=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oULFqGFNulcQPl/tsikVwqZDJSIV6AAHK7cpMmmEaFyYNst6gebc6YvOGiGx/GtxAbjmAJkn/r7dsUjaNK922hVJdJYMJzkwv+liuV75DUSmLPQ0i/cNoHklMYXtuUTyVmSlvdlMBkltT+soULCFIG5INBzXZzvkVCrzRvkYoYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=go4tR3Al; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="go4tR3Al"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso23437385e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789460954; x=1790065754; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QQqTR7eaNOBZboxAnkgxJv8kBYSdGJq6ndYnKckYxNA=;
        b=go4tR3AlptJjUOMm7w2DaGyt/BCxv+BLtWj07x+5ZtUeDAkIAbHYm3FDWpq3y3yECA
         PwYP6j0ziPaVw9Kk+vWEpDm+pTsI42Ko8SQ52rxsAi+mDpKzwylm2X+wacFMMFTO0tKj
         0rEkaF9AX3naSsKx02ADT73d74mHKHMPU+hTSOGORgCfUksGe8hm7lMD5qWBDNon71IV
         lipUSfgRV0OX8qt4xwO+MGd9Yrf19ym9HWQU8Ypw+f01eQ1bXr8RXFlMyd40zpLtNibM
         iup7huhMmHrxduqnxa/gSFW0Ji3RlQcOgaYWszMPGKl4Q0QIRwnt/1rRAhvOWOOf7+Ah
         Gv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789460954; x=1790065754;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QQqTR7eaNOBZboxAnkgxJv8kBYSdGJq6ndYnKckYxNA=;
        b=Fyo3FKBD6KvW/HUWFcQ+leCqz38Nwww0DmuMA/oOQhcwbNh17zA5XDtoLyolc9Uxw/
         VM6adils/qMMsngx5Aa7vK78uw031kzIlVfn0nMyLBw+GRcprWVke2vQugZuma+uH2th
         mqHUsW/Im6ZpGaHh+2BPqULuRGDEshiF07ubDPgX0xsTR9sLuq7t7gv/4j5O0TENF5Mn
         AJzoybf9PQ7LO+OXMmaKR0mQ4z+wEwAVaRhkU5mXAcVbF0koACps6I28WEetGWYX3mwN
         qeP19r4+UNC7XRJ8q/f8Sx77rQFS/mHoozUwScWUYcfDRO4stfEv1GklEpMUdbdVDZZd
         rj5g==
X-Forwarded-Encrypted: i=1; AKwUvByvXiKeid+q/oaSz0/iznobFPl5u0Z++WzDJw/sILDWcpl+I5Pef8eg2/plXnZKMbo4eKOhmMOKneWV5g==@lists.linux.dev
X-Gm-Message-State: AFuF++lPFsFK4EazeG1DFLmeUZQVor/ArvVm51f0KhpnqjqGjQbahibl
	U3ucZQ7wtWgqsWsyNnrATdWzXR5gwOLQykYpSSdiBKMSlVivf4y8kTy0+sfOZzRrhN0=
X-Gm-Gg: AYBFou2rCAM6Ox5Nut2fMcKmRIxqI4en8TKG6D3bHqSDp5+xq0j4lZkfwXT0597b0Zb
	7d8LxyCPwzF6p6F8xxM3lEwngDng0IQTURZLU840LY1IttoT2oL/Kqv51o4dpt/cdsw/nkvbSwh
	ycRSAHQGgIGuCt2obY1UQz4X3ozQwEoJAnprp8xfeNQVLlrEPZZl5vY4Kw/JaeDXXDr4KTItoxn
	EWroazfG5WUDCbfbxdL87IsKQ4Mv4PHEerW6SDywaTk1RHSKjh+bktecopYLe9jbfQTgIBQZRPP
	mQJFhEstLmzN4nAaWb+92vkNCwBv33SU3Ddi2KXtIPawwpnZh83FGnazdZ5nBJi4GQH5CmTUqLk
	TRZ6VE9x9qpliZFIUrcGDwwqk5EqIpx46ytfEXM4hCquMXaMmmVUSsCmt+C4OxqE3xOVVk4qY3k
	kj7ZZPzDTgaLgmLvQlWH8V0ReOilRPrzEBHUjqIgpu4VGaLkue3pYZUPs4MGJL11ydkQwi060GB
	A==
X-Received: by 2002:a05:600c:138f:b0:49c:f617:7cf with SMTP id 5b1f17b1804b1-49e7a5ede89mr112507105e9.0.1789460953640;
        Tue, 15 Sep 2026 01:29:13 -0700 (PDT)
Received: from smtpclient.apple ([154.26.180.185])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bbeb053a5sm17597753eec.27.2026.09.15.01.29.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 01:29:12 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH] ocfs2: update xattr count before moving bucket entries
From: Su Yue <glass.su@suse.com>
In-Reply-To: <aqj05U-1FXW3293I@p15>
Date: Tue, 15 Sep 2026 16:28:59 +0800
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <C0FCFF37-0F21-44B7-8992-6E8C21E8B51B@suse.com>
References: <20260915041633.93575-1-glass.su@suse.com> <aqj05U-1FXW3293I@p15>
To: Heming Zhao <heming.zhao@suse.com>
X-Mailer: Apple Mail (2.3901.100.1.1.11)



> On Sep 15, 2026, at 15:42, Heming Zhao <heming.zhao@suse.com> wrote:
>=20
> On Tue, Sep 15, 2026 at 12:16:33PM +0800, Su Yue wrote:
>> The xh_entries array is annotated with __counted_by_le(xh_count), so
>> FORTIFY uses xh_count to determine its bounds. When inserting an =
entry
>> into a bucket, ocfs2_xa_bucket_add_entry() shifts existing entries =
before
>> incrementing xh_count. The destination therefore extends one entry =
past
>> the bounds described by the old count.
>>=20
>> With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
>> ocfs2-test: single_run-WIP.sh -t reflink triggers the following =
failure while
>> adding an extended attribute:
>>=20
>> [  150.156484] memmove: detected buffer overflow: 352 byte write of =
buffer size 336
>> [  150.156487] WARNING: lib/string_helpers.c:1036 at =
__fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
>> [  150.160496] RIP: 0010:__fortify_report+0x40/0x50
>> [  150.164031] Call Trace:
>> [  150.164141]  <TASK>
>> [  150.164232]  __fortify_panic+0x9/0xb
>> [  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
>> [  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]
>>=20
>> Increment xh_count before memmove() so the destination bounds include
>> the new entry. Keep the local count unchanged to calculate the =
insertion
>> position and move length from the original number of entries. The =
caller
>> has already checked that there is enough space for the new entry.
>>=20
>> Fixes: 2f26f58df041b ("ocfs2: annotate flexible array members with =
__counted_by_le()")
>=20
> The code looks good to me. Just one note:
> commit 2f26f58df041b introduced stricter bounds checking rather than =
fixing a bug.
> This reference should go into the commit log instead of a Fixes tag.

IIUC, fixes tag can be used whatever the referenced commit is a bug fix, =
 code refactor or strict checker.
I think it=E2=80=99s proper here.=20
Let=E2=80=99s wait for Joseph=E2=80=99s opinion.

=E2=80=94=20
Su

>=20
> Thanks,
> Heming
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>> fs/ocfs2/xattr.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 35bcbb0ff607b..49d82ea5a1271 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -2076,12 +2076,17 @@ static void ocfs2_xa_bucket_add_entry(struct =
ocfs2_xa_loc *loc, u32 name_hash)
>> }
>> }
>>=20
>> + /*
>> +  * Increment xh_count before memmove() so __counted_by_le(xh_count)
>> +  * includes the new entry in the destination bounds.
>> +  */
>> + le16_add_cpu(&xh->xh_count, 1);
>> +
>> if (low !=3D count)
>> memmove(&xh->xh_entries[low + 1],
>> &xh->xh_entries[low],
>> ((count - low) * sizeof(struct ocfs2_xattr_entry)));
>>=20
>> - le16_add_cpu(&xh->xh_count, 1);
>> loc->xl_entry =3D &xh->xh_entries[low];
>> memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
>> }
>> --=20
>> 2.55.0


