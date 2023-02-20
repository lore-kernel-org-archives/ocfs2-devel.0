Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7EAC636CC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 06:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XF4WD109yOtGyZAjObbHTi++EWkitMEuSJ5spcZszDI=;
 b=0m0BzD9dIbUaP0RhcGi7aRBvEOj90suAqHwtr354llr34tZEX3ZlikFIEXpLvfW9sviv8bDjnG5p
   mshc7f81vmfB7Pn1TQVf1VOIBM1A0/fFT5xo60m5qg4mfo+/yZFNa0tImKj9FQzynBKvtrsp53oq
   /qhUTyZBme6EZEukV9mW16FQqVvKShc2QM6plD5hqxW1XRHHxieL9QhlJjsNZ9AoPXsgVCBUoJft
   bc58TMH11yR6O4x/Qd6/Z8ChK5/xyHcEPwgHHLGaBrAAiG1tEMbslB/q95OoTuIuAeIaTacJdmRq
   a4WQuMrLvEM1N+Pn5QhlELqc7h0AfqpTvM76Kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XF4WD109yOtGyZAjObbHTi++EWkitMEuSJ5spcZszDI=;
 b=T1+KL3Wdcfb3KP+4BL4Jw1zgmWJiUHUGjuxX5cjNOgT3Yw16jz0i4wfttxO95qPd+4ju6a+HzYX9
   9ey+Vw2LEl+rGrfA27zyuZGz5gzX9H5eH7E0YY6A/YCxoj3p5EaElVK3Q4FsYFSIyR/1yNSeH7az
   i2jxZpeYRCGCZ5M1I64P0sNOcQADjXZKq9///GvGyqqgkU8tr6dtpjk3qzrmD3TuU/Gsh8vNKwD+
   bCuIe2+ILazEpGX6+hXmy5QKvvcNyFIEZxTnG0WmP06JE6p+qcs6u0XWpsnr0guEqhYiC65EKYsD
   r2s9uGeZIKdUIeW7oEnpIBS5SuqqNyH36M2UyA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD00M9D8KKB180@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 06:26:44 +0000 (GMT)
Message-id: <ed8df998-b9d8-bfc0-e590-c54ada78cef8@linux.alibaba.com>
Date: Mon, 20 Feb 2023 14:26:19 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
References: <20230220050526.22020-1-heming.zhao@suse.com>
In-reply-to: <20230220050526.22020-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.97
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 clxscore=132 spamscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=48
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200058 domainage_hfrom=8712
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix non-auto defrag path not
	working issue
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0Vc0DtZd_1676874379;
X-ServerName: out30-97.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: Gd_GXEKinVLhqKY5bht0H75KA2KSozjy
X-Proofpoint-ORIG-GUID: Gd_GXEKinVLhqKY5bht0H75KA2KSozjy
Reporting-Meta:
 AAHO5ZRbJq3soM3xEdf9OTgskZKGBGagjvxa6a7cI2FY3yKenvNSIltUtntioJ6x
 42aEVngl4YqJfJb4WH1WlCNECLPJ++rQzGn3YEFRjMTOEur+XsermuBnT/v1vVyA
 wL+EviQG0+8uTBhmnXALtnhpGvLfgUyoGXDyC1Js1Rnb6cLqA6sPD0JzEV/Q1kTt
 80eujZ6V68DVhBlwpggyhvS1bqCG0xGdMISNRgKYIRUjcJhJ7GRyfB6ymiKK5qAk
 I2jGFIl1B9i7SVhYv3z3YiCvyCn4SnHlSTNWEPg9QXlmDTrX7HJh3jp3lpfJlfIQ
 wadFUtSbFpZwYt3IMu34tpDpTj9JkIS4lR8yMRJAHoxDArDSsycP8uZ7xh1QCWNH
 c/NwDOtthvQknNVVbl1pobXZQuj6mnASFNFCMfJwVOU6n/s+ym9obWeKK7x2kb46
 LpZqOwYz6ENBINQJ+B8KehDc2JNkwia2Y2DkRmxGQddQ/0R1kYz+SBYH/a4zcnYR
 2J/rQ61LnwoPmbn4N1YVpbGHk+3KE/u9PBWI18l/9rTQ



On 2/20/23 1:05 PM, Heming Zhao wrote:
> This fixes three issues on move extents ioctl without auto defrag:
> 
> a) In ocfs2_find_victim_alloc_group(), we have to convert bits to block
> first in case of global bitmap.
> b) In ocfs2_probe_alloc_group(), when finding enough bits in block group
> bitmap, we have to back off move_len to start pos as well, otherwise it
> may corrupt filesystem.
> c) In ocfs2_ioctl_move_extents(), set me_threshold both for non-auto and
> auto defrag paths. Otherwise it will set move_max_hop to 0 and finally
> cause unexpectedly ENOSPC error.
> 
> Currently there is no tools triggering the above issues since
> defragfs.ocfs2 enables auto defrag by default. Test with manually
> changing defragfs.ocfs2 to run non auto defrag path.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2: revise commit log under review comment
> 
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
