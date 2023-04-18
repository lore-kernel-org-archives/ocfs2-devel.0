Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA45C77B72
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Apr 2023 01:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=D7RBLjGtZSVQEN3uPVS3DSLd2hEiF5NGU1+GYUnjdp0=;
 b=HadJ9zoXCgSrwjQeIZDzl84jt3Ekul/VwMSHGUbimiDqbt175SlCfYwNwWlaFvxuOyCV1eBwz95H
   O5RAVRK6jd/fUDpwbzsZBsNioIc30ru3egw1hos10FR5fYw8ScE1WXUUcBJo16eLygkThH7Bsyu2
   TsntI/rcd+i98O4it4p4qfsJHK/VFc3mPorlmKcvP4VK+FXbtcXmcqbGMYjRzVtLZOpqR/eWVLj9
   eF1jt/RiDiKAfv+x5QIL7GdvGwiMqqrBnqq9IK0lBhFV7b+TUG+EsYzrtYkrmeS/WagBRUh0BEQQ
   Q9sEht8lo6FmetzVqXk17L/DrZ2Ydn8Rim9pQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=D7RBLjGtZSVQEN3uPVS3DSLd2hEiF5NGU1+GYUnjdp0=;
 b=hIM7QUZVk9NM+kPfZ76USotsOVrdFp65SyRaJ+hQn/YAwL4+rHtryn37vnOiPjqGt7vgWBimy5qH
   B1E2Y5sGSgcQ/7S+lsxUMJtj/7Dt69eT6rEpyOcZjVIaHiiLGm+U4mq+gkdy+LAxl8Yi8VYjK6Il
   ZP/7a3D40CQDRS3Gz6u+xhaI1wIjXjhfdsD+C2qJDJJkKaE85nJUm3aAiPrK7EX351djSbjpxzVw
   ss4YZsB7apYAtUgsL0Y30fGamni8qstxIfrZeVhyOWbDM/POh8Zb6CrRmkbsnrYFvxCh1vdHfDjO
   nB5a+GXTBKS9N1YKBypl31qQcUjVRjZ4jtpdsA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTA006HYFIR4320@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Apr 2023 01:44:51 +0000 (GMT)
Message-id: <1cd0f938-72b8-2686-1db9-d8c229700e14@linux.alibaba.com>
Date: Tue, 18 Apr 2023 09:44:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Arnd Bergmann <arnd@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
References: <20230417205631.1956027-1-arnd@kernel.org>
Content-language: en-US
In-reply-to: <20230417205631.1956027-1-arnd@kernel.org>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10683
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 priorityscore=0 suspectscore=0 clxscore=79 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180014 domainage_hfrom=8769
Cc: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org,
 =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>,
 David Sterba <dsterba@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=13; SR=0;
 TI=SMTPD_---0VgMyoZU_1681782265;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ndZnFWvIDAobZ4Irz4Hvmhlod1POAE7p
X-Proofpoint-GUID: ndZnFWvIDAobZ4Irz4Hvmhlod1POAE7p
Reporting-Meta:
 AAHaRe0SgGt9KfESwEAt9cZJJ6yY7idTPEWpEM4zAdrtkKYV9LH0P3kW4k1Jdg+/
 Z5uv0sRPPpaMctoqYZitUlgizS+qBTXxamBkDBd6fOkssAc75pw0F1el8ZXhHbVa
 I8Zea1vCCEVFG1IbLfj4Soa4Veso3NHpq5ziWAYy7mNd4/jFUqxMOKCLFSOl0peu
 UG3eS7anSYZm5FfULRtDtwhrZzJnHLU1+uEBBmSSlQypgdxZJE1MT8QTsJdbnXaa
 DopP8bfmeIkTh8LOMa9hYHDHq4hR9yJ0s5A5YCYtMD+6JiYRy2rFjzh4jAc5Ci2A
 GT34Wp/gY1+S5LnU/Fy00x1o1tIdmKtDGQ/DXOMpeXs+esmg5G+kYzXHDZRKW9S7
 FFYHN4UOQC/smUluEL+0EaqRRf8pJHxmntr4eXQy2kIVSLeOST8CrWCRlSRMx56N
 IVo+zpaF3FYo2ka015XAQL+nu73Z9H1sroi4/jH5XQC/by1j+e7rOM0Mo364CM6T
 ZFleeInuJfrTVkhJ8zetKq6TUstMH9F49dKfyUf7Uoju



On 4/18/23 4:56 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> On 32-bit architectures with KASAN_STACK enabled, the total stack usage
> of the ocfs2_ioctl function grows beyond the warning limit:
> 
> fs/ocfs2/ioctl.c: In function 'ocfs2_ioctl':
> fs/ocfs2/ioctl.c:934:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
> 
> Move each of the variables into a basic block, and mark ocfs2_info_handle()
> as noinline_for_stack, in order to have the variable share stack slots.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/ioctl.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 811a6ea374bb..b1550ba73f96 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -803,8 +803,8 @@ static int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
>   * a better backward&forward compatibility, since a small piece of
>   * request will be less likely to be broken if disk layout get changed.
>   */
> -static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
> -			     int compat_flag)
> +static noinline_for_stack int
> +ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info, int compat_flag)
>  {
>  	int i, status = 0;
>  	u64 req_addr;
> @@ -840,27 +840,26 @@ static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
>  long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
> -	int new_clusters;
> -	int status;
> -	struct ocfs2_space_resv sr;
> -	struct ocfs2_new_group_input input;
> -	struct reflink_arguments args;
> -	const char __user *old_path;
> -	const char __user *new_path;
> -	bool preserve;
> -	struct ocfs2_info info;
>  	void __user *argp = (void __user *)arg;
> +	int status;
>  
>  	switch (cmd) {
>  	case OCFS2_IOC_RESVSP:
>  	case OCFS2_IOC_RESVSP64:
>  	case OCFS2_IOC_UNRESVSP:
>  	case OCFS2_IOC_UNRESVSP64:
> +	{
> +		struct ocfs2_space_resv sr;
> +
>  		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
>  			return -EFAULT;
>  
>  		return ocfs2_change_file_space(filp, cmd, &sr);
> +	}
>  	case OCFS2_IOC_GROUP_EXTEND:
> +	{
> +		int new_clusters;
> +
>  		if (!capable(CAP_SYS_RESOURCE))
>  			return -EPERM;
>  
> @@ -873,8 +872,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		status = ocfs2_group_extend(inode, new_clusters);
>  		mnt_drop_write_file(filp);
>  		return status;
> +	}
>  	case OCFS2_IOC_GROUP_ADD:
>  	case OCFS2_IOC_GROUP_ADD64:
> +	{
> +		struct ocfs2_new_group_input input;
> +
>  		if (!capable(CAP_SYS_RESOURCE))
>  			return -EPERM;
>  
> @@ -887,7 +890,14 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		status = ocfs2_group_add(inode, &input);
>  		mnt_drop_write_file(filp);
>  		return status;
> +	}
>  	case OCFS2_IOC_REFLINK:
> +	{
> +		struct reflink_arguments args;
> +		const char __user *old_path;
> +		const char __user *new_path;
> +		bool preserve;
> +
>  		if (copy_from_user(&args, argp, sizeof(args)))
>  			return -EFAULT;
>  		old_path = (const char __user *)(unsigned long)args.old_path;
> @@ -895,11 +905,16 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		preserve = (args.preserve != 0);
>  
>  		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
> +	}
>  	case OCFS2_IOC_INFO:
> +	{
> +		struct ocfs2_info info;
> +
>  		if (copy_from_user(&info, argp, sizeof(struct ocfs2_info)))
>  			return -EFAULT;
>  
>  		return ocfs2_info_handle(inode, &info, 0);
> +	}
>  	case FITRIM:
>  	{
>  		struct super_block *sb = inode->i_sb;

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
