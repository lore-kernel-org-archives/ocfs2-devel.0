Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E39328B63
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845456; cv=none; b=dRW1RExQLTacshbnp1qsXGEIpaMhrE+zsKqiW01DIe4EY4IWFZNKrdvZThzg235mWHNLefUx/HYiZTP9WOQM/2pzxX3oF0Qypcffz3nBkFoPX1aW5XYZ9sQXwI/e2ssdkDrEoygLuSus2ALxZJnCDnZvQqzdReWWO7BJm3lb7uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845456; c=relaxed/simple;
	bh=cpKTHoVU6rxq8ro6IVZyVowYOJaQNQAyFfEqHXJQyFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oIe9WlqeHN5Z0N9NDotZRe9NFNV1U0jHbgf8Ck8N9pOsvfpTaRZNCUDtD9WGaM0hreZrH3VZIOJKUfX1zrc/HTDR4KKkwxhgFVf7Gv1pyHKUhmb1u6t636MvXn9+T1le+9fShNZWuw3qseqB87ejx7zUIK1RztLTM+3rq2y6CvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmzMGwnZ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmzMGwnZ"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6610e72112bso2107135eaf.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 09:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768845454; x=1769450254; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LdOCSHF7WzjxbGwyP2+q0DqDBTdH7rLJK6gj6eHKSiE=;
        b=fmzMGwnZZcrvxc4vBA9TBWRFapcL99xzBbGZjmpDSRvnS8vG7fzP3S2D/jHLK/ke8r
         WDRFci4u9TM8686J0XV0xz+UwhB2DNcoCbfQH8R+14guv9VdO4y4j8b3VqJQgwPaXpMu
         HhwcERaVAtT/M+uZbSUOduN8GXLw+kYSzMLTR0RRAF7ymut5Lk1VciQcz3z9XScvlwVz
         BRtp2tjBtDI+EWs30MWoLEC1HUVnVWzGOqP4nvqgCpkVSSUYcyucjgYRE5bLn9WL2lax
         Zk2o+c4XOxxnOSEWbauS/G1yicgpArWmRWE/F+Q8yCiuDhJm5egYbDSIGJJ602uTuWqq
         fc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768845454; x=1769450254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LdOCSHF7WzjxbGwyP2+q0DqDBTdH7rLJK6gj6eHKSiE=;
        b=s420b7ryX5ggnQczEjoGT/yhV2TfhJYc/eOeXShOu1EJaQZ57HWEuNT7Hv/VXeHtuL
         djIINhbgrqs0GakZFBXGdz1De0Q0OBytDzNfD/qxlIqtSMEf5xNUClN/hMitI8F98xEB
         AvjhrHTQVsih75l+Xg3OGDsexJPRLY5FZNn0R+THVh7Qa5M1YCdMRinbWq0ozGjQ9+RS
         6CTsKYANExTNcvzR0sL5eEOGXGzpy+WXpX4iK22xksm+Ah5qT/GkG7MbiWKqinAjNfU9
         5tkYZl+YApHFqzHMmFvoFAj9pBxx+Edq9lPQ1+rSfCoogbeqP1IXCNu4JKG/uyclYjMH
         haqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr9LY7Lj4lmKd3RQnKKGsPVWtiwTgazNJCp6OLoYktSZH0U+a7/YcjnjvJoLf3KIdMZUQOyn4wbTxe4A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwDVVD1IvhLqDgy9IYVK2QUpci1PZ/hdZePUS/U5ILEOT50dUOG
	sWyOPLLIsT25MshmcnDoKM7vasImosg8hi0mfK6ytWrY1Y6BWd7POEq/MGpCDw==
X-Gm-Gg: AY/fxX6f/eisV4YFysc1euPI9gE3JMaGdmfxN7tvekmX6sgsUyRnK73svsgKzyGHpRD
	hsjHYS8/n7LIMuotIS8N/+3lzI8HUuE5JZA5Azvqa9rWxurw8UCWrin7Jtkr0MQZ6m5Ovv2vl7o
	Uw0+DeqDCHYPs2/egTgELqAyjMkv2BBAxRoqBzcGnerNl8GfWL8F6fNup0n5kr8AAmHzIPjdLpG
	bhQQsMQzA9DWrA7kAOOJojymh3Zm+370ZF52AVa0QLVOwO14wCdms1bGJyeo3eZn+4u/O3hT9Zt
	MO/zDSo8tdFcponETdTmPPSB8nfP76ohtlziwA9TLtatwgdFwHPkkeIOp7qwDs2H7+u748yfPN3
	VKrbjyOhubOkJw90OKKFMB6CSnTCJUXrahLDlr6ypzcHEAwcFkRK7/Zh/ehnQd3DcVAjc/O9F5b
	B668cAlIiHzNzBPNc8hUEAGXxQM/B4rk2k
X-Received: by 2002:a05:6820:1898:b0:65f:6cda:d429 with SMTP id 006d021491bc7-661188caae3mr5032368eaf.4.1768845454290;
        Mon, 19 Jan 2026 09:57:34 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66118781fedsm4886179eaf.11.2026.01.19.09.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 09:57:33 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: heming.zhao@suse.com
Cc: jiashengjiangcool@gmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix NULL pointer dereference in ocfs2_xattr_get_rec
Date: Mon, 19 Jan 2026 17:57:32 +0000
Message-Id: <20260119175732.1444-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ywzkg5c3z5bwugddfhsqcybzj3mw2yys3al53pjfede4rjp7qk@gzfcpu4etohi>
References: <ywzkg5c3z5bwugddfhsqcybzj3mw2yys3al53pjfede4rjp7qk@gzfcpu4etohi>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 19 Jan 2026 22:49:16 +0800, Heming Zhao wrote:
> On Sat, Jan 17, 2026 at 05:35:56PM +0000, Jiasheng Jiang wrote:
>> In ocfs2_xattr_get_rec, the variable 'rec' is initialized to NULL.
>> If the extent list 'el' is empty (l_next_free_rec == 0), the loop
>> iterating over the records is skipped, leaving 'rec' as NULL.
>> 
>> Since 'e_blkno' is initialized to 0, the function enters the error
>> handling block 'if (!e_blkno)'. Inside this block, the function calls
>> ocfs2_error() and attempts to dereference 'rec' via
>> 'le32_to_cpu(rec->e_cpos)' and 'ocfs2_rec_clusters(el, rec)'. This
>> results in a NULL pointer dereference and a kernel panic.
> 
> Do you have reproduction steps to support your analysis?
> 
> - Heming

Regarding the reproduction steps, we detected this issue through static
analysis. We do not have a specific script to reproduce this as it
requires a corrupted filesystem image.

However, if the filesystem metadata is corrupted (e.g., due to bit rot
or software bugs), it is possible that l_next_free_rec reads as 0. In
the current implementation, such inconsistency leads to a NULL pointer
dereference and panics the system.

This patch is intended as a hardening measure. Instead of crashing the
kernel when encountering such invalid on-disk data, it is safer to report
a filesystem error via ocfs2_error and abort the operation gracefully.

This approach aligns with recent fixes in OCFS2. For example, Commit
44acc46d182f ("ocfs2: avoid NULL pointer dereference in
dx_dir_lookup_rec()") addressed an identical issue where an empty extent
list left the 'rec' pointer NULL.

I will update the commit message in the next version to explicitly state
that this is a hardening measure against on-disk corruption, ensuring the
rationale is accurate.

- Jiasheng

>> 
>> Fix this by ensuring 'rec' is not NULL before accessing its members
>> within the error handling path, or by checking for an empty list
>> explicitly.
>> 
>> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
>> ---
>>  fs/ocfs2/xattr.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 1b21fbc16d73..b018c84dbc05 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -3757,10 +3757,16 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
>>  	}
>>  
>>  	if (!e_blkno) {
>> -		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
>> -				  inode->i_ino,
>> -				  le32_to_cpu(rec->e_cpos),
>> -				  ocfs2_rec_clusters(el, rec));
>> +		if (rec)
>> +			ret = ocfs2_error(inode->i_sb,
>> +					  "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
>> +					  inode->i_ino,
>> +					  le32_to_cpu(rec->e_cpos),
>> +					  ocfs2_rec_clusters(el, rec));
>> +		else
>> +			ret = ocfs2_error(inode->i_sb,
>> +					  "Inode %lu has bad extent record (NULL) in xattr\n",
>> +					  inode->i_ino);
>>  		goto out;
>>  	}
>>  
>> -- 
>> 2.25.1
>> 
>> 
