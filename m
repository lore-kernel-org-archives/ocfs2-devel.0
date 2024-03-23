Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA36C611A
	for <ocfs2-devel@lists.linux.dev>; Sat, 23 Mar 2024 10:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711191114; cv=none; b=BU0PMhfdtzqhYyIrjmlLBfH2FCcYRHgMz9RrpWbJNZ85MwfhLPy/5ywnbxJgJvqMbew5+8nb29w/3Ho+XYVcYqd56O+aoKw2+S6kUP0xCWwYMv+d9wftMPGu8Rzfq50ikrW48h4+2RnNZzKVnYrzhqDaYuQCoevC2uTJK9Xjk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711191114; c=relaxed/simple;
	bh=2A7AYHf6QF8yNkMoObkw8N+rc0vB5tQ+qdEVe8nz2rM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ej9ybD1wr/NFgGlJu/UEcDlA3OoSWc4XZxgv1FBjCX0aH8yBI4Z9RDOG0ihUCg9iX7alFD75tkSbgVUDuELi0cX8VLjU6F5MSg5wD3DFaG+jKUHlewUxTX1UXHBf4BbaYQ/eNvoxQ2yNGxIec3AxM4HeglCCUcYdJx2tkKAy2fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EWHTywMD; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EWHTywMD"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d687da75c4so35296351fa.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 23 Mar 2024 03:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711191110; x=1711795910; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0DGQzhBq4/pJje5Kffhd66YN8rN/H3f2TbEc/pwRWL0=;
        b=EWHTywMDZyxqb/szf1J2HM4hFBnpQjAmT0WyoOw5A8lVSZ0j1D0dGfcE6Kk4HDUWlz
         20mebb/8GFTacmUY/xxxraEphujJhoGG/8XTB1VXrSbj5/ulj2gTSTl3+SWA8XTJwiB/
         iisiJzJrSBNqOXGjHi/320EWISr3S8WShf1zKZOT3ppmfDYJVpJtHX6eU3CmTXXdusxj
         D6yhvej4T/pMG0nLSVYrtYbG26REwAJrVMehQ1TIOUzvWupHLdHWwkbRjxnVTPMLNS80
         oIFpnEEHNh3swA1BD0OO5K1E5ScWq1CyzWm3d/zsK/sqQ6UY94LNCEOHd0J4lid43jhZ
         YNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711191110; x=1711795910;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DGQzhBq4/pJje5Kffhd66YN8rN/H3f2TbEc/pwRWL0=;
        b=HF8vy8ho556WJOH63P5rEdcqCDpCNgAxpZ/zmTNh7AGNWA32qek3tpKpk95Mf6eiLK
         OjReoTdOkl3SjvxrRBcbdJ6EY8Pr0w2RCFDAsCXJ4k8hgLUkcPB53vCmLtOZjjZQOOWt
         quPK/kV7gDORd3KRDZZ+lYgoxMHVyvMwPjssZqt4C+Rct4A0l/x0PISDrOZGT1hcZIKe
         MoprxGp297IcVOTHZx20R/E2WyUSPVfAQoweJA635QPOKnVcuSTnJJfB4ar2fn+frvrz
         //I9nMboMub2VPFAoyqoy6GfSowC1sv+B8DOTHqM+CSVAgVMAMmJGRYbgIQy7KtGGl0M
         pHuA==
X-Forwarded-Encrypted: i=1; AJvYcCX8e/5r9ThTEUFmKUDNkW8a0MyvLl5DJRnXvlp2+ou5OkUjOifPHY6CbOA6gaocp2kiM8HyoGukr9TgQH2Tt9DGoq+ld2QbvG3pNcw=
X-Gm-Message-State: AOJu0YyExaLsiIxcj4WILl7n9zvaRljvmbzDvROEulHHSScCmzP2bfZG
	Iicn5cImiU4EuXcxqltQpf6UJCAar9PtQ8wxhuoa7lHvF/E2G4whpX0Rp1RmlRk=
X-Google-Smtp-Source: AGHT+IFTtqd28g25n0tPVnij6t4CGUBifHbYhZRpRiSCZvFDDa6JBhR+Ocg7kOBN3OO6qjAT5EUeLQ==
X-Received: by 2002:a05:651c:2c9:b0:2d4:a232:757 with SMTP id f9-20020a05651c02c900b002d4a2320757mr1084636ljo.7.1711191109736;
        Sat, 23 Mar 2024 03:51:49 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id t26-20020a056a00139a00b006e6c733bde9sm1157563pfg.155.2024.03.23.03.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Mar 2024 03:51:49 -0700 (PDT)
Message-ID: <d6091c0d-c0ac-423e-a518-d8371f4b006a@suse.com>
Date: Sat, 23 Mar 2024 18:51:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-nonmm-unstable 38/38] fs/ocfs2/resize.c:127:46:
 sparse: sparse: incorrect type in argument 2 (different base types)
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 ocfs2-devel@lists.linux.dev
References: <202403231258.mU2k0fih-lkp@intel.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <202403231258.mU2k0fih-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Joseph,

Please see my comment, only one warning need to be fixed, others are harmless.
Do I re-send v4 patch or send a new patch?

On 3/23/24 12:17, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   e393dbc9246c3ae0160a07c8666838056eafbc44
> commit: e393dbc9246c3ae0160a07c8666838056eafbc44 [38/38] ocfs2: improve write IO performance when fragmentation is high
> config: i386-randconfig-061-20240322 (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/config)
> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202403231258.mU2k0fih-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>>> fs/ocfs2/resize.c:127:46: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned short [usertype] total_bits @@     got restricted __le16 [usertype] bg_bits @@
>     fs/ocfs2/resize.c:127:46: sparse:     expected unsigned short [usertype] total_bits
>     fs/ocfs2/resize.c:127:46: sparse:     got restricted __le16 [usertype] bg_bits

This warning need to be modified, there should do endian converting.

>>> fs/ocfs2/resize.c:128:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>     fs/ocfs2/resize.c:128:33: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>     fs/ocfs2/resize.c:128:33: sparse:     got restricted __le16 [usertype] bg_contig_free_bits

This warning is harmless, the old_bg_contig_free_bits does backup job.
later code logic just uses this value to do restore value job. So we
don't need to do endian converting job.

>>> fs/ocfs2/resize.c:169:44: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le16 [usertype] bg_contig_free_bits @@     got unsigned short [usertype] old_bg_contig_free_bits @@
>     fs/ocfs2/resize.c:169:44: sparse:     expected restricted __le16 [usertype] bg_contig_free_bits
>     fs/ocfs2/resize.c:169:44: sparse:     got unsigned short [usertype] old_bg_contig_free_bits

see my above comment. just use backup value. no need to convert endian.

>     fs/ocfs2/resize.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false

This warning belongs to mm part.
> --
>>> fs/ocfs2/suballoc.c:2566:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>     fs/ocfs2/suballoc.c:2566:41: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>     fs/ocfs2/suballoc.c:2566:41: sparse:     got restricted __le16 [usertype] bg_contig_free_bits

Like above, there code do backup job, no need to convert endian.
>     fs/ocfs2/suballoc.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
There belongs to mm.

>     fs/ocfs2/suballoc.c:2493:17: sparse: sparse: context imbalance in 'ocfs2_block_group_clear_bits' - different lock contexts for basic block

from [1], this warning is harmless.

[1]: https://lwn.net/Articles/109066/

Thanks,
Heming
> 
> vim +127 fs/ocfs2/resize.c
> 
>      76	
>      77	static int ocfs2_update_last_group_and_inode(handle_t *handle,
>      78						     struct inode *bm_inode,
>      79						     struct buffer_head *bm_bh,
>      80						     struct buffer_head *group_bh,
>      81						     u32 first_new_cluster,
>      82						     int new_clusters)
>      83	{
>      84		int ret = 0;
>      85		struct ocfs2_super *osb = OCFS2_SB(bm_inode->i_sb);
>      86		struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bm_bh->b_data;
>      87		struct ocfs2_chain_list *cl = &fe->id2.i_chain;
>      88		struct ocfs2_chain_rec *cr;
>      89		struct ocfs2_group_desc *group;
>      90		u16 chain, num_bits, backups = 0;
>      91		u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
>      92		u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
>      93		u16 old_bg_clusters;
>      94		u16 contig_bits, old_bg_contig_free_bits;
>      95	
>      96		trace_ocfs2_update_last_group_and_inode(new_clusters,
>      97							first_new_cluster);
>      98	
>      99		ret = ocfs2_journal_access_gd(handle, INODE_CACHE(bm_inode),
>     100					      group_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>     101		if (ret < 0) {
>     102			mlog_errno(ret);
>     103			goto out;
>     104		}
>     105	
>     106		group = (struct ocfs2_group_desc *)group_bh->b_data;
>     107	
>     108		old_bg_clusters = le16_to_cpu(group->bg_bits) / cl_bpc;
>     109		/* update the group first. */
>     110		num_bits = new_clusters * cl_bpc;
>     111		le16_add_cpu(&group->bg_bits, num_bits);
>     112		le16_add_cpu(&group->bg_free_bits_count, num_bits);
>     113	
>     114		/*
>     115		 * check whether there are some new backup superblocks exist in
>     116		 * this group and update the group bitmap accordingly.
>     117		 */
>     118		if (OCFS2_HAS_COMPAT_FEATURE(osb->sb,
>     119					     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
>     120			backups = ocfs2_calc_new_backup_super(bm_inode,
>     121							     group,
>     122							     cl_cpg, old_bg_clusters, 1);
>     123			le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
>     124		}
>     125	
>     126		contig_bits = ocfs2_find_max_contig_free_bits(group->bg_bitmap,
>   > 127						group->bg_bits, 0);
>   > 128		old_bg_contig_free_bits = group->bg_contig_free_bits;
>     129		group->bg_contig_free_bits = cpu_to_le16(contig_bits);
>     130	
>     131		ocfs2_journal_dirty(handle, group_bh);
>     132	
>     133		/* update the inode accordingly. */
>     134		ret = ocfs2_journal_access_di(handle, INODE_CACHE(bm_inode), bm_bh,
>     135					      OCFS2_JOURNAL_ACCESS_WRITE);
>     136		if (ret < 0) {
>     137			mlog_errno(ret);
>     138			goto out_rollback;
>     139		}
>     140	
>     141		chain = le16_to_cpu(group->bg_chain);
>     142		cr = (&cl->cl_recs[chain]);
>     143		le32_add_cpu(&cr->c_total, num_bits);
>     144		le32_add_cpu(&cr->c_free, num_bits);
>     145		le32_add_cpu(&fe->id1.bitmap1.i_total, num_bits);
>     146		le32_add_cpu(&fe->i_clusters, new_clusters);
>     147	
>     148		if (backups) {
>     149			le32_add_cpu(&cr->c_free, -1 * backups);
>     150			le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
>     151		}
>     152	
>     153		spin_lock(&OCFS2_I(bm_inode)->ip_lock);
>     154		OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>     155		le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
>     156		spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
>     157		i_size_write(bm_inode, le64_to_cpu(fe->i_size));
>     158	
>     159		ocfs2_journal_dirty(handle, bm_bh);
>     160	
>     161	out_rollback:
>     162		if (ret < 0) {
>     163			ocfs2_calc_new_backup_super(bm_inode,
>     164						    group,
>     165						    cl_cpg, old_bg_clusters, 0);
>     166			le16_add_cpu(&group->bg_free_bits_count, backups);
>     167			le16_add_cpu(&group->bg_bits, -1 * num_bits);
>     168			le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
>   > 169			group->bg_contig_free_bits = old_bg_contig_free_bits;
>     170		}
>     171	out:
>     172		if (ret)
>     173			mlog_errno(ret);
>     174		return ret;
>     175	}
>     176	
> 

