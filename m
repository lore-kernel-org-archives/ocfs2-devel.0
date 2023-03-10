Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBCBC6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 03:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=43ySHb+8wumc+82wQhjqIh5MqW8Q5mkMSMEdQRgkdaY=;
 b=0UTM1XFFnpw7vbo/3KdYg7RV0gube8YNNM12FwLM3nb1AcDQl8tqTIeD6fIeDQa7mj7BzDq82oYX
   HuZHPNtomUHAM7bo1fwwmtMYeEfx6OtgDS/n+EOvOjeHQSrm21lPIHgwI9NvXIdnVpS1RE14iE/r
   FULm8MC/XbUoJw4B4XauMRleXg457DcLxXBjMSUD9sH19gdJHczZ1FJwYRvlA6AA0egeDxrx0JBq
   kyMVhIA8FP62hgNvU9WNWgYtENsihDYo5bSb9lVAnkmA3yJjCeQECa8L0sNte6p7TFa8KCmQ3jUB
   8ZDJVMUyZ2tA+c3lKqjus0ZjmyBHImnmvGzcZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=43ySHb+8wumc+82wQhjqIh5MqW8Q5mkMSMEdQRgkdaY=;
 b=qw+kTz3BFX/0uslwtR2PRNTeQ2Sbp6q1LDKVObfkMoAzmfjHjEelupLgqXIHfGiLTHSOthCpkLLZ
   UZt8fnFuXAq8vcHfwA0JYWohOTu4unDzIV1RGa07PFtdumrl1evFWPHwazvZjvyZAh3Hh84DgcT5
   tFVpyR8XjJdImoSyIMVqvjUeZJUO7UKjDyJE4tmY5HAK3oo6VCoRy+TUqUE25X99sn2snYWmq44o
   SdIgdDW7QT+2plyc7K7C/l7OU03upqFhsMklkJxaMz0qxTIVzV3NBkH2Dfr5h/bKx3RNZ1YA5kXz
   Xk1ZOOfiWuSTbSJeipl0lBClxsAB+xQ35Am8eQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00JIFBRSJ180@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 03:16:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=11AJMu/0cs/HvqxMiNs1sKMgouvxxTSuRzL9iqx/214=; b=b3pgLg2BGWVTYim4F7KQAXgPuh
 tvBvaspI+ZuT6n1dLXX0xe2CfyfmScno/rVPwocMA8nAysYzCglC41V3TUPJUjcvIvMYWMgbcWsqA
 mNb7CSDVKPDqEj9FhBJ3BlqtTv2rfZ3lApjmVElaxCebclvKldUPhAJs11i/u4Rq7Yp36tiJrOEj4
 Md5bov/9vJTU9iQSlhFi31jlZEUol6H70DxfbHVTEk7oeZGF6OI/AiRPNpvQTL4/P+kXsBTDJm/bm
 ojuazI9oWqv2bmVjTzwhBLB9gBk6dOhlqYyB/hAillxfNGe/u82JeojkeXAlQWl4Eq3y/so5OQ8Wj
 4Bsb00ww==;
Date: Fri, 10 Mar 2023 03:15:47 +0000
To: Yangtao Li <frank.li@vivo.com>
Message-id: <20230310031547.GD3390869@ZenIV>
References: <20230309152127.41427-1-frank.li@vivo.com>
 <20230309152127.41427-2-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230309152127.41427-2-frank.li@vivo.com>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0
 phishscore=0 mlxlogscore=960 lowpriorityscore=0 clxscore=164 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100023
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 2/6] erofs: convert to use i_blockmask()
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: kJwcULdRU2qFx2E17WxR_fvlnDpXcwGm
X-Proofpoint-ORIG-GUID: kJwcULdRU2qFx2E17WxR_fvlnDpXcwGm
Reporting-Meta:
 AAFy9lusXfMj5t++Ea4IcNuN54N50XfB7KVnwIws9BSO30buw8Kk+9+3DnK4rfxr
 gQQEaeLv/mZNpAB/iD1nNCFN0TK3TnhgqTU2LC6U8VJo2nAGAGhAgHLoO1MlrgrJ
 EYJykpF+e7SPvJ8NbZCGACJEiWb7btuE961za5ybhQAsvifX3De9/kwN8kIfnoXS
 By27S9cGVCsqvcKoCg9vVt/9YPod2V9hH9Z5ojfnF9HBe1Rtd2LVrA7NLjw3m62g
 C8oClSC9fkxyBmqOckzy0ch5afMU1Jdu5ZptwJq3AuZCyDBhKtgd+TzwuhM9CQjO
 jB0ZUxywCYCUQgzb2k5TWjH/7XR4ZanXT/0UHbem2hbMg/NP1Uz+1nRa0OBCTwT0
 +KEJIsEYthnMq5TON8jW5bzR7kh3pX1fON9IxZy4MJsOzTlG80KnIHn0MPFJ1Ifs
 fvDHobsJeprjS+4rCKe2RMpJ+adlL42QVgpLeOq53D0IxigUz9rhyH2adpl/eBEG
 gouT2L4ecmDilocDF1t3pHPG+fcJljE6ZPpLf3NMAUAG

On Thu, Mar 09, 2023 at 11:21:23PM +0800, Yangtao Li wrote:
> Use i_blockmask() to simplify code.

Umm...  What's the branchpoint for that series?  Not the mainline -
there we have i_blocksize() open-coded...

> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v3:
> -none
> v2:
> -convert to i_blockmask()
>  fs/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 7e8baf56faa5..e9d1869cd4b3 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -380,7 +380,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		if (bdev)
>  			blksize_mask = bdev_logical_block_size(bdev) - 1;
>  		else
> -			blksize_mask = i_blocksize(inode) - 1;
> +			blksize_mask = i_blockmask(inode);
>  
>  		if ((iocb->ki_pos | iov_iter_count(to) |
>  		     iov_iter_alignment(to)) & blksize_mask)
> -- 
> 2.25.1
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
