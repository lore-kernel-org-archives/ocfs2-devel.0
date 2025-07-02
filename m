Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED7C32C85
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Jul 2025 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751438445; cv=none; b=u7ZszvuyXPFXaKqNAqesAGHaG3fM+K8aazJzqEVPVFjPmP2gTckF6dUlsnRnMGh91MhRD1zG/suzPMcFd+Cz+I3P/wwlgWdizSOLk8KR5cDp3OCobYC2b8QUHJhTO8lexERwvQhnCO2BcfMAGEijI4iQR2uDWcNhuLoySFsXQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751438445; c=relaxed/simple;
	bh=bRiDy+kpjWYFtsLteguVU4jbf92JSaFORJagCk/UiLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rqeceNg6w9usrLEFedZQsQ4X7EJf/0YvRReAa4BOgF/xX4dnqMnvlkqEi37eFoAahiqZViE0gaML51BCpJi+ALR36LAjQqt1aopbVpFn298xrhrPnottOiERo3ec+EFYFX0fpYcpSXCK1REuEFMOcxdmslCvRyrb99qc9qrdffU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=K1em/Zzp; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="K1em/Zzp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751438439; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Mtwga8alWATFGMm3mmqQBzFiogF71cRoVuSv9dHV5Bs=;
	b=K1em/Zzp/W10pefGyt1CChFNmkkg/MNlZFej6rUTZENkUZnKVMiduAvvIjfRVD4IZr1c6QpUSkhZxHGRNoD/pD6DJIFXAgwVnwefN1W0GVA2/a3BbquIMbboM2hyUOPTzSqikONqecDmyv3qxVwrjzc3HViPESfumY4eT3UidEA=
Received: from 30.221.128.110(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WgayU1d_1751438437 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Jul 2025 14:40:37 +0800
Message-ID: <203f104b-40b5-4513-bd86-0dfa2bd24de4@linux.alibaba.com>
Date: Wed, 2 Jul 2025 14:40:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: Avoid NULL pointer dereference in
 dx_dir_lookup_rec()
To: Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
References: <20250701023717.543972-1-ipravdin.official@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250701023717.543972-1-ipravdin.official@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/7/1 10:37, Ivan Pravdin wrote:
> When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
> error message that unconditionally dereferences the 'rec' pointer.
> However, if 'rec' is NULL, this leads to a NULL pointer dereference and
> a kernel panic.
> 
> Add an explicit check for a NULL 'rec' and use an alternate error
> message in that case to avoid unsafe access.
> 
> Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67cd7e29.050a0220.e1a89.0007.GAE@google.com/
> Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
> ---
> v1 -> v2: Changed 'Closes:' tag to point to the correct bug report.
> 
>  fs/ocfs2/dir.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 7799f4d16ce9..dccf0349e523 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -809,11 +809,17 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	}
>  
>  	if (!found) {
> -		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> -				  inode->i_ino,
> -				  le32_to_cpu(rec->e_cpos),
> -				  ocfs2_rec_clusters(el, rec));
> +		if (rec) {
> +			ret = ocfs2_error(inode->i_sb,
> +					"Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> +					inode->i_ino,
> +					le32_to_cpu(rec->e_cpos),
> +					ocfs2_rec_clusters(el, rec));
> +		} else {
> +			ret = ocfs2_error(inode->i_sb,
> +					"Inode %lu has no extent records in btree\n",
> +					inode->i_ino);
> +		}
>  		goto out;
>  	}
>  

'rec' is NULL can only if 'el->l_next_free_rec' is 0.
So how about check el->l_next_free_rec before. Something like:

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7799f4d16ce9..8c9c4825f984 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -798,6 +798,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
		}
	}

+	if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has empty extent list at depth %u\n",
+				  inode->i_ino,
+				  le16_to_cpu(el->l_tree_depth));
+		goto out;
+	}
+
	found = 0;
	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
		rec = &el->l_recs[i];

Thanks,
Joseph


