Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D1F15C147
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 03:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729051104; cv=none; b=ndazuuVFeu2FFXY4w0Vr1JedZCkgbObZqmLrXf3/cgKVHn502jeFbXYTgbvZFIXvwyErIYTYtej9CJbq+ahMU4l3D8Agakv1AAQJbdib1m3atF/xQMlHg/l+5WtLM4BNo5gqpFKDThblMgdIBcWRuakTlE8H9qWV8aPssx7TpA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729051104; c=relaxed/simple;
	bh=ddcPAMOhauFbTosK03eLk2C7PjG9TXIoiVAqKTyH2a0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=j/ihiCcxmVSEAcRae1zNUqGGMtC22+3WUHg8liMDcHU5k0rsc/eDsAEzEjJtj4KNX6YzCO9sDp5PSaG5TdshJDrQRVHquxHgD6RCRf5zBBxTTAnJMwXinJpJvGeO4wcMrd9s7PIRYW1FJUGtyFtO0nCsZtcO3GlR2j+8y6BjvqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=niHzL3mD; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="niHzL3mD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1729051098; bh=RuMoHt6kpoDSUfCbf5yhdUamiOaStOUgGPzXLNZwr1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niHzL3mDZ/V5eNHTQ2tYTWHb6iGDV8GwfOXFcXri22ZCfZTKEsLCTS2oP3c4H72xv
	 hpQcCjJAp1LzjxjetyXpqNXEPLWaIOsD+/tB23kW/v10ZN7bPkQqpFY7JO8+KhdKHk
	 8wNHlIYr+kZcolwZ7A8+Ntk/kOxLfXLVYisjnQeA=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id D013648B; Wed, 16 Oct 2024 11:52:01 +0800
X-QQ-mid: xmsmtpt1729050721tuuj4205k
Message-ID: <tencent_D0CBD2F8C64B09A0EEDA2EFF0C8367DB0606@qq.com>
X-QQ-XMAILINFO: M0yQCYO1Pk4Brlrp4c+bnLAZGdVRkprwaojPl/ktyo1syLNQUbly1usBVHvvwv
	 k+bC1rAJ76gJUscPUNiodhN5f0eEMHs2K/KlyBKIHG8samJA9bodrBva4YTq/D+hvcLNKpBKGgtR
	 1M6xrnYwL8W0JLBr8ZIDl6tP+dVVqg2OUJ9YWMu1UL/hS3QkdYuJHEUdw/aG+1tn6BHb2QNLrgFf
	 c2KG8RZKou0SP4q/G7EWyXiHqE5C/n3GcScTkoCp6QNFwmEQLoZff+53m/C1slu2UTeeQhWtrPH7
	 m8tZuGIQIjPnXWQ3nyr+/PM9gYh/1Ct9qrSdL8VIctGjszJGcp52gHEKGv5+/t3CWIG+Fd5g4rww
	 /x9Kxa5lD0QgFbSCWiYdm1WBQUwoijyO+uy04L2p/1u8RKpRlhQ40kPzfx55F2bhvdgY7/4jQml/
	 57C5NpPK+mFt8qEm6zbVaKYaF3LSwRsTA80cy+J4hJxIQkxIWi9sFysufgIKPLkMpHTtQN8PK8oU
	 3Z5OS9gNrax5PDbjJrYWeF3YJpqkWGSYPUyEr1FqZwwNLLAEuMOmvMVeoVC6BEa+2K64PvfLXvBs
	 GMLV8Ezyx4rNi/sTMDoUBbFq3C0PI6s27DohG5yE5ftreFOeKMmO9PpPgEEIz5syEXmz6ZlHX3lD
	 2CIuXp5L1B23IWDzC5Uxl1711Zd3x/7pRpdeern6pOVx5u4b1zaK+41MpDsjjsP7VzxY2oBM2F8B
	 GZL3oUh/BEEt+OagayF2HF4xgYcjble1bRUCVoekCAYA89C+b8hhi5rYzHQjC8aoDAihJmMW6vYM
	 J9UuPoq0m3SKCdXT4LfpThNPY0rlxb7evser+od5EHkC2FDclPSa6mf3t8K3eXevL60mmt3m/NSH
	 Jxeq/br8Vj/QH7lbqZZlE06/PuON1aYsO8qC3UUP7O0pkOKFX20x+fdW3NSO2+GnJZeR5rk9I6zW
	 WMBZWQi8MzD/eHebW18EzXPc/qFQDkc7gUgSv4ZXi+aKZ65MVzxqJZ6U9aP4Jv
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: joseph.qi@linux.alibaba.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V3] ocfs2: add a sanity check for i_size
Date: Wed, 16 Oct 2024 11:52:01 +0800
X-OQ-MSGID: <20241016035200.451531-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <8947c80d-9fed-4269-8a56-080d4afa782b@linux.alibaba.com>
References: <8947c80d-9fed-4269-8a56-080d4afa782b@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 16 Oct 2024 10:06:27 +0800, Joseph Qi wrote:
> > Reported-and-tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> > V1 -> V2: keep rc to 0 when falgs contains READHEAD
> > V2 -> V3: check i_size only and alert subject and comments
> > 
> >  fs/ocfs2/extent_map.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > #syz test
> > 
> > diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> > index f7672472fa82..29d27a70dbdd 100644
> > --- a/fs/ocfs2/extent_map.c
> > +++ b/fs/ocfs2/extent_map.c
> > @@ -961,13 +961,17 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
> >  	int rc = 0;
> >  	u64 p_block, p_count;
> >  	int i, count, done = 0;
> > +	loff_t i_size = i_size_read(inode);
> >  
> >  	trace_ocfs2_read_virt_blocks(
> >  	     inode, (unsigned long long)v_block, nr, bhs, flags,
> >  	     validate);
> >  
> > +	if (!i_size)
> > +		return -EINVAL;
> > +
> 
> Take a more consideration, inode size 0 doesn't mean it has no blocks,
> since we have a case that fallocate with KEEP_SIZE.
> Could you please check inode->i_blocks in above coredump?
I have previously verified the value of inode->i_blocks in my testing environment, which is 0.

BR,
Edward

