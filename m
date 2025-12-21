Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307F327FD71
	for <ocfs2-devel@lists.linux.dev>; Sun, 21 Dec 2025 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766316361; cv=none; b=WW/6iYbmpnYjWOdNF766eFxRXMDo2QQRXwwIijw9K177/Mn2SvLHcL0rUPU9sk1OZSLhZdOdCK8A1jW8VFF49HVevEeYI+0Sj7rDSDZGdeIUpUv8afRMwmLx4yJNWsB8HEh5YU9epQSYYYdjJUBQHnkN21jIjz0c/JmrOoUzTOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766316361; c=relaxed/simple;
	bh=Pl3L/iYStqADtYbqQj+rW26cq4qgINpm5Xm7v2pGpvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cpO8NwgQEGF4XpA9s+EOYfP0akJge/AChHU+3Fz1YMU8Sur4oeLbiu33TbKIaLeEhf40XUUtBtkLvtdha82+CqKT3GTIscTqVWpbJrwliBO18+xSA6f4bbGCQXN37YPvtU8BELf8wSocRfFdrjtuKleouqx4C9QKUAIRqvenmew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HrmfjBvb; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HrmfjBvb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766316349; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jlnOinxV0hU70dSI+0Hpl0Zst97d6HfeNUIxfGlixA4=;
	b=HrmfjBvb15CpV9oone8FLISGw9lP92/8vmKRleOgRAuK7gKqmAgBdSnO6QEekHEn64+sOD7ExjPEeph8p6FE5WEv0NdH404eGxDAZAb7uLqcI4ZHBYt5UV71cUQAouC0p3kIyfLTd+T2v2xzIaD7MRyiNllPCRhy90v0Ssb/QRE=
Received: from 30.41.143.132(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WvIhz1V_1766316348 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 21 Dec 2025 19:25:48 +0800
Message-ID: <18466382-29d3-4896-8297-bead3baa8c5e@linux.alibaba.com>
Date: Sun, 21 Dec 2025 19:25:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: fix oob in __ocfs2_find_path
To: Heming Zhao <heming.zhao@suse.com>, Edward Adam Davis <eadavis@qq.com>,
 akpm <akpm@linux-foundation.org>
Cc: eadavis@qq.org, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
 mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <rwy27v6h3su6i7osrb5aelexurlg7ggbzeedv7bghuwhe54uvl@nfwl3p5xugwh>
 <tencent_4D99464FA28D9225BE0DBA923F5DF6DD8C07@qq.com>
 <2v5rwkwevjoy2i3kwcb6s3zvyutp5zdcwwdnqbgukxn35aeu2z@abmakzczn45z>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <2v5rwkwevjoy2i3kwcb6s3zvyutp5zdcwwdnqbgukxn35aeu2z@abmakzczn45z>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/19 18:07, Heming Zhao wrote:
> On Fri, Dec 19, 2025 at 04:31:52PM +0800, Edward Adam Davis wrote:
>> syzbot constructed a corrupted image, which resulted in el->l_count
>> from the b-tree extent block being 0. Since the length of the l_recs
>> array depends on l_count, reading its member e_blkno triggered the
>> out-of-bounds access reported by syzbot in [1].
>>
>> The loop terminates when l_count is 0, similar to when next_free is 0.
>>
>> [1]
>> UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1838:11
>> index 0 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
>> Call Trace:
>>  __ocfs2_find_path+0x606/0xa40 fs/ocfs2/alloc.c:1838
>>  ocfs2_find_leaf+0xab/0x1c0 fs/ocfs2/alloc.c:1946
>>  ocfs2_get_clusters_nocache+0x172/0xc60 fs/ocfs2/extent_map.c:418
>>  ocfs2_get_clusters+0x505/0xa70 fs/ocfs2/extent_map.c:631
>>  ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
>>  ocfs2_read_virt_blocks+0x286/0x930 fs/ocfs2/extent_map.c:1001
>>  ocfs2_read_dir_block fs/ocfs2/dir.c:521 [inline]
>>  ocfs2_find_entry_el fs/ocfs2/dir.c:728 [inline]
>>  ocfs2_find_entry+0x3e4/0x2090 fs/ocfs2/dir.c:1120
>>  ocfs2_find_files_on_disk+0xdf/0x310 fs/ocfs2/dir.c:2023
>>  ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2045
>>  _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
>>  ocfs2_get_system_file_inode+0x326/0x770 fs/ocfs2/sysfile.c:112
>>  ocfs2_init_global_system_inodes+0x319/0x660 fs/ocfs2/super.c:461
>>  ocfs2_initialize_super fs/ocfs2/super.c:2196 [inline]
>>  ocfs2_fill_super+0x4432/0x65b0 fs/ocfs2/super.c:993
>>  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
>>  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
>>  fc_mount fs/namespace.c:1199 [inline]
>>
>> Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>> v3 -> v4: update comments
>> v2 -> v3: remove le16 and Fix tag and update comments
>> v1 -> v2: check l_count and update comments
>>
>>  fs/ocfs2/alloc.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 58bf58b68955..b7db177d17d6 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -1812,14 +1812,15 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>>  			ret = -EROFS;
>>  			goto out;
>>  		}
>> -		if (le16_to_cpu(el->l_next_free_rec) == 0) {
>> +		if (!el->l_next_free_rec || !el->l_count) {
>>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
>> -				    "Owner %llu has empty extent list at depth %u\n",
>> +				    "Owner %llu has empty extent list at depth %u\n"
>> +				    "(next free=%u count=%u)\n",
>>  				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
>> -				    le16_to_cpu(el->l_tree_depth));
>> +				    le16_to_cpu(el->l_tree_depth),
>> +				    le16_to_cpu(el->l_next_free_rec), le16_to_cpu(el->l_count));
>>  			ret = -EROFS;
>>  			goto out;
>> -
>>  		}
>>  
>>  		for(i = 0; i < le16_to_cpu(el->l_next_free_rec) - 1; i++) {
>> -- 
>> 2.43.0
>>

