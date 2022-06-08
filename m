Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9633C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 02:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0Cbs4ZYAuBsnLOjP5I07yg3Azk3efJ4g9LJa5YWOhDM=;
 b=XDUop3nNrfpcbMqPlasC8XwEBwsRgVi7yCv9evRT7oXcsnFf5OCf+IrLeIw8hyK3NgZxKLp0e13w
   1P/ICVz9wNKcVu019BvFeIsI33SIeQ0FiHlaBbEG8glXbfQTXanN1Nf2ZiupFE56T977nao59o/x
   OYanVEz3uiBHHRgf0Q94DSfvXmfgBgTk4l0E7DGWaQDWozDzD8mjvbqhL7Igzz23mZ0gwIXStGLA
   yLJ3D5NmOcaQ3vhEsCu4cZNHGg+dsBRT+ZFsGcSVBVLKiDOYDdrGvvIPkz1+IHjbGKZO+NL/bXJu
   4tan/AOv7z8O2r44mA+dI1xp4qgUd8Uj15hJrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0Cbs4ZYAuBsnLOjP5I07yg3Azk3efJ4g9LJa5YWOhDM=;
 b=K+LFerlHG/+6qp7z0BAkXzmCEm/k2iWKk2lTyEuR53DdkbwqJTB6VB+2pVNXkN9BFELSdKEDfKL0
   1md744ctZDJrupOIFttz0duhBi6UN0fr3AR3MBmYT3IuvJQU80/H5IPBq9DSIRYbu0CvE3DnyGwJ
   KGnhm6WdfgL/f9yHRBeCDiTwxXB3RpS8uIDXaquTDM1XVfpWeVr8XaNJ8g5nTgL/fDjKlnY2TSo6
   LEC3ljFm+Xtk+gb9aoDh1fr0th+YqPgBkc8G4shiCcqiSuAyX3HQaQO8BRVH6peDAkCb6MoFBS2d
   yIto86WqsNtri/8tr5EKrJAoFApICTIqhO0bGg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD400OH6ZVPR4B0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 02:21:25 +0000 (GMT)
Message-id: <485a3036-de9f-500b-633c-940f07f08e20@linux.alibaba.com>
Date: Wed, 8 Jun 2022 10:21:08 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220607171226.86672-1-junxiao.bi@oracle.com>
In-reply-to: <20220607171226.86672-1-junxiao.bi@oracle.com>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=84
 suspectscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 priorityscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080009 domainage_hfrom=8455
Subject: Re: [Ocfs2-devel] [PATCH V2] ocfs2: kill EBUSY from	dlmfs_evict_inode
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VFiPTDp_1654654868;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: zOqBPmhF0fpQKUYGyQ601FxhNTN3NvLP
X-Proofpoint-ORIG-GUID: zOqBPmhF0fpQKUYGyQ601FxhNTN3NvLP
Reporting-Meta:
 AAHgU+/9Hnk8Wtzw1fketmLQEAarLJgUlESJ2szaNVqnuUbSmajDfSPX+b1D18ro
 x6XRUOKw2pFucdH0rG2ksAeYsSyErpFjxIEVj4ZKcAt9Djm1rjoaPuwUluoncvFK
 ccMdlWEkPja/oVwsCyEj27fg8lpgiWzMfUuq6OiFK65qyxnzEwn8GyS8nEMq0ulH
 UeDaJouOWTT2fJGkYGxRM5KDqqN4F2hePotScY8loba78oBl1YX4PhCbd/5XbwnE
 6fQub2vDOHxwVIKA3cF6G560SYzGS7Z/WpzS05IxYOJuHMdWr3XkTs2+u/BDRY/y
 9AL1p3U6q9KB/TmeXcg/sKJXgpXWcbImX0FoG9o8qO0cfVaCBAs8yYmZZyt4l5RK
 nMwrlrzvaKjCdv1SooCr13zOg4VnzH5AGtbpBYYSCiyP4mMLKjfwN9STjRcgyLz4
 +OMnOZkX0q84dfyruKWY+GfHcrfLDQ9K+YFB7GUPwigZXz1yfJnxsGZR9yVPApZ0
 PMlCYur3owIFg6iw4izSmQYylX5tuBYLkOMESbIyNmSh



On 6/8/22 1:12 AM, Junxiao Bi wrote:
> When unlink a dlmfs, first it will invoke dlmfs_unlink(), and then invoke
> dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both places,
> the second one from dlmfs_evict_inode() will get EBUSY error because
> USER_LOCK_IN_TEARDOWN is already set in lockres. This doesn't affect
> any function, just the error log is annoying.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> V2 <- V1:
>  - s/anonying/annoying in patch log.
>  - s/destroyed/teardown in dlmfs_evict_inode()
> 
>  fs/ocfs2/dlmfs/dlmfs.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index e360543ad7e7..8b2020f92b5f 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct inode *inode)
>  {
>  	int status;
>  	struct dlmfs_inode_private *ip;
> +	struct user_lock_res *lockres;
> +	int teardown;
>  
>  	clear_inode(inode);
>  
>  	mlog(0, "inode %lu\n", inode->i_ino);
>  
>  	ip = DLMFS_I(inode);
> +	lockres = &ip->ip_lockres;
>  
>  	if (S_ISREG(inode->i_mode)) {
> -		status = user_dlm_destroy_lock(&ip->ip_lockres);
> -		if (status < 0)
> -			mlog_errno(status);
> +		spin_lock(&lockres->l_lock);
> +		teardown = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
> +		spin_unlock(&lockres->l_lock);
> +		if (!teardown) {
> +			status = user_dlm_destroy_lock(lockres);
> +			if (status < 0)
> +				mlog_errno(status);
> +		}
>  		iput(ip->ip_parent);
>  		goto clear_fields;
>  	}

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
