Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABA1C05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 03:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9yVTVrE7MmpKZ20KApsdzda8eXiLZk0cVbvIFRaMIoI=;
 b=ywwQaHsjqCzs6+4CxwrUhv3AoykIfaKt5PcDKz+D6e8vvMwBeIS3GzUNPGtb6KARQwqMpLRKcTah
   SMI6ZNl3HWvcon6C5WnSmuP4n7zukhvLPlVdWa1IdL7xWuhJBq6bQu4NEVUNbaPm5enT5VGnblLt
   Y60qR+rrMnrNd17a7Ze6UbgaU1wJPNz0U8wltqDMbVR2yu3vebYuKcEEb6n5ho/eZxWJHP/mvv0x
   4CpWtNrD5tJDKKH2H+BEI+ufoW+bfs3CNLOgL4QBUM9XtzKFHe9/mo8M5X1p6troiezsPgw71gqN
   Kx9O4ysQDqLhtHsC//1sYBNWA5XlHtIKnfBUVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9yVTVrE7MmpKZ20KApsdzda8eXiLZk0cVbvIFRaMIoI=;
 b=KzxngGsfT6CPo++RykzOZhv4RmA8MiBXTtZAlpV4p/vRH2dShWmIigcgl9tgaqFHqcbxdPOCN3CR
   2LFNZHoVUX9Dp5PhA7/EEt1cNl42XNG6VHUUM26OR3prKE78FU1KogOt6y+U54J89RB8tK4NbyIg
   NY6cv9fDlOm/KED1hc3BhUTv5vYRxd9UCUImYlC2RLoALueOwel8/3qFoSxg/ewaq4dprAKZivxE
   TDZqGOS1YGOdwtS75LEvm4Ud+uvA4xe7H2+mCu6dNaBBQ7m5Pc41ixIfKOO58/lSi7jbmLbTiJw1
   e5VNezkqjHMGPyFjyQNrk0FxE0awpqH2yRj28g==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQC00M3FZUNAJ50@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 03:18:23 +0000 (GMT)
Message-id: <650b3d8d-35cb-3385-f9ac-0ad31f9fcdc2@linux.alibaba.com>
Date: Mon, 20 Feb 2023 11:18:02 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20230217012000.5774-1-heming.zhao@suse.com>
In-reply-to: <20230217012000.5774-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.100
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=131
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=48 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200028 domainage_hfrom=8712
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix non-auto defrag path not	working
 issue
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0Vc-MPSD_1676863083;
X-ServerName: out30-100.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: XaAyRVN-otPpjA8-hNZBCfONuW5zuy2A
X-Proofpoint-ORIG-GUID: XaAyRVN-otPpjA8-hNZBCfONuW5zuy2A
Reporting-Meta:
 AAG8W/uUe1w7i5JcNKQwCt1+LuNuSXr5IFI3d4WlZzC8RkFGtJGM6lpoAuErshw/
 vdYPojT1cWezQtXr4/PWSbViEYD6ZWQeSHuXu5pKalXbztq8axtX48a7TCyJEHnE
 gaLD1N0TR9y9FQG+sfBPmZKIVSkav9NtWb91FAHYHE6/J/MCrx+qoCsf9zPR9rb+
 qI0CdLac9RAjWsAju/Z/GtZcXs8OFYDafV4ma9DnMIguUIEVThXHTav0rZzWdniv
 Uf6W5BC3tgz9RCAoCMzrbkoI2el9ItaD5wwdVpfk/1fIDmgNUff/JG5lvUBxh5ua
 gMxMJbY74qTrLV4Toci5Jo97xm+sMkHeDVQQcJyg4lBYGrQGeRH25J0hA+tiGVMb
 oZI83oQLbuKx/65/0C1IoI8N5OyYyOnCmHulgC/NhYYFFNkhrduwewsySJz7EcPA
 O8NP2pCVS3xaO4tTYNZ7V5jHtc21dNGXLRblBnmV863Hwu1EXpJcwutLI/VSvz4k
 HlW/BeK4A7TdOD8Xe8LTk2H8w8v8XSMhllSzgBLr+2dp



On 2/17/23 9:20 AM, Heming Zhao wrote:
> This commit fixes three issues on non-auto defrag path (defragfs.ocfs2
> doesn't set OCFS2_MOVE_EXT_FL_AUTO_DEFRAG on range.me_flags):
> - For ocfs2_find_victim_alloc_group(), old code forgot enlarge bitmap
>   range for global_bitmap case. Old code could generate negative
>   vict_bit.
> - For ocfs2_probe_alloc_group(), old code forgot back off move_len when
>   finding enough bitmap space. Old code has possibility to make data
>   corruption.
> - For ocfs2_ioctl_move_extents(), this func should set me_threshold for
>   both auto & non-auto path. Without setting me_threshold,
>   ocfs2_move_extent() will make 'move_max_hop = 0', then
>   ocfs2_probe_alloc_group() returns 'phys_cpos == 0' under max_hop is 0.
> 
> Another info is current defragfs.ocfs2 doesn't have ability to trigger
> non-auto defrag path. I modified defragfs.ocfs2 source code ".me_flags"
> and hardcode ".me_goal" for running test.
> 

I'm fine with the code changes. But the commit log needs improve.
How about the following?

This fixes three issues on move extents ioctl without auto defrag:

a) In ocfs2_find_victim_alloc_group(), we have to convert bits to block
first in case of global bitmap.
b) In ocfs2_probe_alloc_group(), when finding enough bits in block group
bitmap, we have to back off move_len to start pos as well, otherwise it
may corrupt filesystem.
c) In ocfs2_ioctl_move_extents(), set me_threshold both for non-auto and
auto defrag paths. Otherwise it will set move_max_hop to 0 and finally
cause unexpectedly ENOSPC error.

Currently there is no tools triggering the above issues since
defragfs.ocfs2 enables auto defrag by default. Test with manually
changing defragfs.ocfs2 to run non auto defrag path.

Thanks,
Joseph


> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/move_extents.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 6251748c695b..b1e32ec4a9d4 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -434,7 +434,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
>  
>  			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
> -						le16_to_cpu(bg->bg_bits))) {
> +						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
>  
>  				*ret_bh = gd_bh;
>  				*vict_bit = (vict_blkno - blkno) >>
> @@ -549,6 +549,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
>  			last_free_bits++;
>  
>  		if (last_free_bits == move_len) {
> +			i -= move_len;
>  			*goal_bit = i;
>  			*phys_cpos = base_cpos + i;
>  			break;
> @@ -1020,18 +1021,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  
>  	context->range = &range;
>  
> +	/*
> +	 * ok, the default theshold for the defragmentation
> +	 * is 1M, since our maximum clustersize was 1M also.
> +	 * any thought?
> +	 */
> +	if (!range.me_threshold)
> +		range.me_threshold = 1024 * 1024;
> +
> +	if (range.me_threshold > i_size_read(inode))
> +		range.me_threshold = i_size_read(inode);
> +
>  	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
>  		context->auto_defrag = 1;
> -		/*
> -		 * ok, the default theshold for the defragmentation
> -		 * is 1M, since our maximum clustersize was 1M also.
> -		 * any thought?
> -		 */
> -		if (!range.me_threshold)
> -			range.me_threshold = 1024 * 1024;
> -
> -		if (range.me_threshold > i_size_read(inode))
> -			range.me_threshold = i_size_read(inode);
>  
>  		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
>  			context->partial = 1;

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
