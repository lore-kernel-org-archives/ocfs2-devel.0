Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A51494DB
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Mar 2024 01:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711331748; cv=none; b=jAOAW3GLDnUGOJBkg+cokJOANC8/f4hmrLVjDaGJsIh+kx2xvINDM3DkC9rI+Oor47YNlEdNQEBQF8Ws6VYOAQzLf7PIioZWQVdrJVXL9CA7TneOcp3VnW6TFhzDMP5RyOmlmV5iQCdLjd9hOxpQTrLyVzsOIgKvaO/9JilygNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711331748; c=relaxed/simple;
	bh=rnlWOPeyKQO2bh9x8NRec8htmdKa9d2aLa96eOeEdes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEUVlapBLSH0i05seZtJqCTxywRlMU9+Ak5B2OO+E9LYlsN4rdNhW6j5111iZeEEoIw7yBSrtPG3ZBttAh4DoTNHKpLGG+SbRnl5ICJBccsivsZYJgWVM09kgmGLHe7TQj0BUd/8tt1yG8RrTd2nqQhyQtJQh8G1vV5ORfGQeBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jD/PSCxd; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jD/PSCxd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711331737; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sWzt0lWq7xUN6okxJEtNifbB1LJCkQdCE+KXncx+7wU=;
	b=jD/PSCxd0rch6gDDSw/2wFb+8L1sbxShV9XcOknYZHeXiWb1xKTRPvhVRkgwb/3xjs6h8ksNS+29ZkY7LY3vP5qkWxfBPtp2DRRauBYqKanjBAW13+PFCQychIcOdTu0XwXUPuhtGa1KmC2e/OCV4s2WD5KX6kWT9DWcYtvbpIs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W383BNv_1711331736;
Received: from 30.221.128.255(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W383BNv_1711331736)
          by smtp.aliyun-inc.com;
          Mon, 25 Mar 2024 09:55:36 +0800
Message-ID: <3ea2c39e-25b8-4fad-aba2-25c514c5ecfb@linux.alibaba.com>
Date: Mon, 25 Mar 2024 09:55:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-nonmm-unstable 38/38] fs/ocfs2/resize.c:127:46:
 sparse: sparse: incorrect type in argument 2 (different base types)
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 ocfs2-devel@lists.linux.dev
References: <202403231258.mU2k0fih-lkp@intel.com>
 <d6091c0d-c0ac-423e-a518-d8371f4b006a@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <d6091c0d-c0ac-423e-a518-d8371f4b006a@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/23/24 6:51 PM, Heming Zhao wrote:
> Hello Joseph,
> 
> Please see my comment, only one warning need to be fixed, others are harmless.
> Do I re-send v4 patch or send a new patch?
> 

To make sparse tool happy, we'd better fix all type conversion warnings
and then send v4 version.

Joseph

> On 3/23/24 12:17, kernel test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
>> head:   e393dbc9246c3ae0160a07c8666838056eafbc44
>> commit: e393dbc9246c3ae0160a07c8666838056eafbc44 [38/38] ocfs2: improve write IO performance when fragmentation is high
>> config: i386-randconfig-061-20240322 (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/config)
>> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202403231258.mU2k0fih-lkp@intel.com/
>>
>> sparse warnings: (new ones prefixed by >>)
>>>> fs/ocfs2/resize.c:127:46: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned short [usertype] total_bits @@     got restricted __le16 [usertype] bg_bits @@
>>     fs/ocfs2/resize.c:127:46: sparse:     expected unsigned short [usertype] total_bits
>>     fs/ocfs2/resize.c:127:46: sparse:     got restricted __le16 [usertype] bg_bits
> 
> This warning need to be modified, there should do endian converting.
> 
>>>> fs/ocfs2/resize.c:128:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>>     fs/ocfs2/resize.c:128:33: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>>     fs/ocfs2/resize.c:128:33: sparse:     got restricted __le16 [usertype] bg_contig_free_bits
> 
> This warning is harmless, the old_bg_contig_free_bits does backup job.
> later code logic just uses this value to do restore value job. So we
> don't need to do endian converting job.
> 
>>>> fs/ocfs2/resize.c:169:44: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le16 [usertype] bg_contig_free_bits @@     got unsigned short [usertype] old_bg_contig_free_bits @@
>>     fs/ocfs2/resize.c:169:44: sparse:     expected restricted __le16 [usertype] bg_contig_free_bits
>>     fs/ocfs2/resize.c:169:44: sparse:     got unsigned short [usertype] old_bg_contig_free_bits
> 
> see my above comment. just use backup value. no need to convert endian.
> 
>>     fs/ocfs2/resize.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
> 
> This warning belongs to mm part.
>> -- 
>>>> fs/ocfs2/suballoc.c:2566:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>>     fs/ocfs2/suballoc.c:2566:41: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>>     fs/ocfs2/suballoc.c:2566:41: sparse:     got restricted __le16 [usertype] bg_contig_free_bits
> 
> Like above, there code do backup job, no need to convert endian.
>>     fs/ocfs2/suballoc.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>     include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
> There belongs to mm.
> 
>>     fs/ocfs2/suballoc.c:2493:17: sparse: sparse: context imbalance in 'ocfs2_block_group_clear_bits' - different lock contexts for basic block
> 
> from [1], this warning is harmless.
> 
> [1]: https://lwn.net/Articles/109066/
> 
> Thanks,
> Heming
>>
>> vim +127 fs/ocfs2/resize.c
>>
>>      76   
>>      77    static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>      78                             struct inode *bm_inode,
>>      79                             struct buffer_head *bm_bh,
>>      80                             struct buffer_head *group_bh,
>>      81                             u32 first_new_cluster,
>>      82                             int new_clusters)
>>      83    {
>>      84        int ret = 0;
>>      85        struct ocfs2_super *osb = OCFS2_SB(bm_inode->i_sb);
>>      86        struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bm_bh->b_data;
>>      87        struct ocfs2_chain_list *cl = &fe->id2.i_chain;
>>      88        struct ocfs2_chain_rec *cr;
>>      89        struct ocfs2_group_desc *group;
>>      90        u16 chain, num_bits, backups = 0;
>>      91        u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
>>      92        u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
>>      93        u16 old_bg_clusters;
>>      94        u16 contig_bits, old_bg_contig_free_bits;
>>      95   
>>      96        trace_ocfs2_update_last_group_and_inode(new_clusters,
>>      97                            first_new_cluster);
>>      98   
>>      99        ret = ocfs2_journal_access_gd(handle, INODE_CACHE(bm_inode),
>>     100                          group_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>>     101        if (ret < 0) {
>>     102            mlog_errno(ret);
>>     103            goto out;
>>     104        }
>>     105   
>>     106        group = (struct ocfs2_group_desc *)group_bh->b_data;
>>     107   
>>     108        old_bg_clusters = le16_to_cpu(group->bg_bits) / cl_bpc;
>>     109        /* update the group first. */
>>     110        num_bits = new_clusters * cl_bpc;
>>     111        le16_add_cpu(&group->bg_bits, num_bits);
>>     112        le16_add_cpu(&group->bg_free_bits_count, num_bits);
>>     113   
>>     114        /*
>>     115         * check whether there are some new backup superblocks exist in
>>     116         * this group and update the group bitmap accordingly.
>>     117         */
>>     118        if (OCFS2_HAS_COMPAT_FEATURE(osb->sb,
>>     119                         OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
>>     120            backups = ocfs2_calc_new_backup_super(bm_inode,
>>     121                                 group,
>>     122                                 cl_cpg, old_bg_clusters, 1);
>>     123            le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
>>     124        }
>>     125   
>>     126        contig_bits = ocfs2_find_max_contig_free_bits(group->bg_bitmap,
>>   > 127                        group->bg_bits, 0);
>>   > 128        old_bg_contig_free_bits = group->bg_contig_free_bits;
>>     129        group->bg_contig_free_bits = cpu_to_le16(contig_bits);
>>     130   
>>     131        ocfs2_journal_dirty(handle, group_bh);
>>     132   
>>     133        /* update the inode accordingly. */
>>     134        ret = ocfs2_journal_access_di(handle, INODE_CACHE(bm_inode), bm_bh,
>>     135                          OCFS2_JOURNAL_ACCESS_WRITE);
>>     136        if (ret < 0) {
>>     137            mlog_errno(ret);
>>     138            goto out_rollback;
>>     139        }
>>     140   
>>     141        chain = le16_to_cpu(group->bg_chain);
>>     142        cr = (&cl->cl_recs[chain]);
>>     143        le32_add_cpu(&cr->c_total, num_bits);
>>     144        le32_add_cpu(&cr->c_free, num_bits);
>>     145        le32_add_cpu(&fe->id1.bitmap1.i_total, num_bits);
>>     146        le32_add_cpu(&fe->i_clusters, new_clusters);
>>     147   
>>     148        if (backups) {
>>     149            le32_add_cpu(&cr->c_free, -1 * backups);
>>     150            le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
>>     151        }
>>     152   
>>     153        spin_lock(&OCFS2_I(bm_inode)->ip_lock);
>>     154        OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>>     155        le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
>>     156        spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
>>     157        i_size_write(bm_inode, le64_to_cpu(fe->i_size));
>>     158   
>>     159        ocfs2_journal_dirty(handle, bm_bh);
>>     160   
>>     161    out_rollback:
>>     162        if (ret < 0) {
>>     163            ocfs2_calc_new_backup_super(bm_inode,
>>     164                            group,
>>     165                            cl_cpg, old_bg_clusters, 0);
>>     166            le16_add_cpu(&group->bg_free_bits_count, backups);
>>     167            le16_add_cpu(&group->bg_bits, -1 * num_bits);
>>     168            le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
>>   > 169            group->bg_contig_free_bits = old_bg_contig_free_bits;
>>     170        }
>>     171    out:
>>     172        if (ret)
>>     173            mlog_errno(ret);
>>     174        return ret;
>>     175    }
>>     176   
>>
