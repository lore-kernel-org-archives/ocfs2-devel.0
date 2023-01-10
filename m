Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339E8C54EBE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 08:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kDrRxnV/5Jy0BSBJOJ6HoE/8q5r9E7CreVCl+29NV+g=;
 b=ywklalIvDmOeIBt/qv0BTWoCmoEBIwDV6xG3K+ZnvMKGzor40zJVOMoz93LRtB9Fr+ygVEeAOu0/
   v9pcNtQGu4+6wFTfEQlF9nLqNn6V0sQHJirFti0L4040LYgMZgphAQSMibMCS7GVqY/FI0hQzeVF
   s7LrwxnSqGuRItr47LG9TBlqr3iMMj/yGS0ml2rUX2UL7dKSF492jUPekRTgx9fQ7is5xJo6m4C9
   WLF9DDJ6Zg/c6PJ2I/9u1VlcGgwg9+8Sj2xuWFt8LXRAXSh15dwRKXUhiqTkPdd9fgOtRHcS38Uj
   j2K86OcAi74RLa7bM6KTEgaWLPLxl9PSVtz+Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kDrRxnV/5Jy0BSBJOJ6HoE/8q5r9E7CreVCl+29NV+g=;
 b=J83vF6tGfZvITGP/czaw2Ie9AlxQrv6LxdFEvEYFeBhxiRNCLPwYv7Dny6Nkwa+GTEMdIKDzEu98
   80Ye5A4GH0JtNOmHeUPV8KK28dZw0Aya91HwKFIfSFbPwk6WV8I+ahUtCSoCphE1X48tdPUDJ9l5
   yLRkOZAD71WhuzM5N00KmllKvLDIAgGLg65GLi+1TuK4p0H7FgfRndw+mHuTvNjljJQe0lG//9AV
   0mIeHdz/onyJT5iYc2lJ3Q0gBaTYbSGCAGrMftDrUmWwM8MDRCw3g2tRQY7Me7aa50ZJXOau4dTd
   zHEsUx8K4BxFrkTf+3bhtax2YVqdo5OxIeLe7Q==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO90042PI79IH40@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 08:57:09 +0000 (GMT)
Message-id: <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 10 Jan 2023 09:55:50 +0100
In-reply-to: <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 bulkscore=0 clxscore=141 suspectscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 mlxscore=0 malwarescore=0 priorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100053
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 2/6] ocfs2: Switch to
	security_inode_init_security()
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: GxC2BwAH3GIwKL1jw9uDAA--.1874S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr1UGFWUKw43CFyruw18Grg_yoW7Zw4fpa
 yftFnxKr1rJFyUuryftw45ua1I9rWrGrZrGrs3K34UZF1DGr1ftryrAr15ua45XrWDJa97
 tr4Yyrsxuan8J37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgANBF1jj4Nm3gAAsB
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: _LaNgA0TeL8CiTcFb5aFn8tGQM9vJiB6
X-Proofpoint-ORIG-GUID: _LaNgA0TeL8CiTcFb5aFn8tGQM9vJiB6
Reporting-Meta:
 AAE5u2LHjiXUT896q352D28lQTTRS5DLc6zC01MwpZoPJJhJMSql6kpxvAOQTmM/
 cGSAn/NB/OYCALRqQq8lE2MNKLjROeVTh32/b3NcowFx8dacNfw4FXFG5r1wR1SR
 wIZs6f0LGeOuJ/lbOgJ4u3SjmBgfjlp5tRwqxlyvZjOPpXXmF8lc50x6WAHtAg15
 rML/Yhneh9QcglqyaO0s299AnQdcBxi1cWWVB59XqnKe+b0MNrHY4vY6Tx1mlD6k
 82i8FDmqv4m1KmdNCUtGzKM1gydAcMUrLJ/Z6tvmLh35bEwZDrAADIFAI4kOnVgQ
 vBYYzaEtZSrDWYHKr7ICCV7cwthK77hSxraa7ikhvfbb6du1vyNaEeoIa2gzzsrz
 dGdjdGizL3BG8w2xcoPd96dTGpVaj8Qr7ndQEoPrVl1IncQRNRYOgyNm5a70nEkx
 o4sJ7XRpYPM2NvnRyjykfGfzmrNe0kZ2QBtc75G+4SuU2vIM1kW/XVx5ELnrHsRt
 K0Se4Hw546+lsr0fO5DtXjRz8DRHVYH5HeGU8i/1RoOr

On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> In preparation for removing security_old_inode_init_security(), switch to
> security_inode_init_security().
> 
> Extend the existing ocfs2_initxattrs() to take the
> ocfs2_security_xattr_info structure from fs_info, and populate the
> name/value/len triple with the first xattr provided by LSMs.

Hi Mark, Joel, Joseph

some time ago I sent this patch set to switch to the newer
function security_inode_init_security(). Almost all the other parts of
this patch set have been reviewed, and the patch set itself should be
ready to be merged.

I kindly ask if you could have a look at this patch and give your
Reviewed-by, so that Paul could take the patch set.

Thanks a lot!

Roberto

> As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> of replicating the behavior of security_old_inode_init_security(), i.e.
> just obtaining the xattr, in addition to setting all xattrs provided by
> LSMs.
> 
> Supporting multiple xattrs is not currently supported where
> security_old_inode_init_security() was called (mknod, symlink), as it
> requires non-trivial changes that can be done at a later time. Like for
> reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
> not the first to set it, its xattr will be discarded; if it is the first,
> it does not have xattrs to calculate the HMAC on).
> 
> Finally, modify the handling of the return value from
> ocfs2_init_security_get(). As security_inode_init_security() does not
> return -EOPNOTSUPP, remove this case and directly handle the error if the
> return value is not zero.
> 
> However, the previous case of receiving -EOPNOTSUPP should be still
> taken into account, as security_inode_init_security() could return zero
> without setting xattrs and ocfs2 would consider it as if the xattr was set.
> 
> Instead, if security_inode_init_security() returned zero, look at the xattr
> if it was set, and behave accordingly, i.e. set si->enable to zero to
> notify to the functions following ocfs2_init_security_get() that the xattr
> is not available (same as if security_old_inode_init_security() returned
> -EOPNOTSUPP).
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>  fs/ocfs2/namei.c | 18 ++++++------------
>  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
>  2 files changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 05f32989bad6..55fba81cd2d1 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
>  	int want_meta = 0;
>  	int xattr_credits = 0;
>  	struct ocfs2_security_xattr_info si = {
> +		.name = NULL,
>  		.enable = 1,
>  	};
>  	int did_quota_inode = 0;
> @@ -315,12 +316,8 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
>  	/* get security xattr */
>  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
>  	if (status) {
> -		if (status == -EOPNOTSUPP)
> -			si.enable = 0;
> -		else {
> -			mlog_errno(status);
> -			goto leave;
> -		}
> +		mlog_errno(status);
> +		goto leave;
>  	}
>  
>  	/* calculate meta data/clusters for setting security and acl xattr */
> @@ -1805,6 +1802,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
>  	int want_clusters = 0;
>  	int xattr_credits = 0;
>  	struct ocfs2_security_xattr_info si = {
> +		.name = NULL,
>  		.enable = 1,
>  	};
>  	int did_quota = 0, did_quota_inode = 0;
> @@ -1875,12 +1873,8 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
>  	/* get security xattr */
>  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
>  	if (status) {
> -		if (status == -EOPNOTSUPP)
> -			si.enable = 0;
> -		else {
> -			mlog_errno(status);
> -			goto bail;
> -		}
> +		mlog_errno(status);
> +		goto bail;
>  	}
>  
>  	/* calculate meta data/clusters for setting security xattr */
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 95d0611c5fc7..55699c573541 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
>  static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		     void *fs_info)
>  {
> +	struct ocfs2_security_xattr_info *si = fs_info;
>  	const struct xattr *xattr;
>  	int err = 0;
>  
> +	if (si) {
> +		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
> +				    GFP_KERNEL);
> +		if (!si->value)
> +			return -ENOMEM;
> +
> +		si->name = xattr_array->name;
> +		si->value_len = xattr_array->value_len;
> +		return 0;
> +	}
> +
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>  		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
>  				      xattr->name, xattr->value,
> @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
>  			    const struct qstr *qstr,
>  			    struct ocfs2_security_xattr_info *si)
>  {
> +	int ret;
> +
>  	/* check whether ocfs2 support feature xattr */
>  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
>  		return -EOPNOTSUPP;
> -	if (si)
> -		return security_old_inode_init_security(inode, dir, qstr,
> -							&si->name, &si->value,
> -							&si->value_len);
> +	if (si) {
> +		ret = security_inode_init_security(inode, dir, qstr,
> +						   &ocfs2_initxattrs, si);
> +		/*
> +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> +		 * we have to check the xattr ourselves.
> +		 */
> +		if (!ret && !si->name)
> +			si->enable = 0;
> +
> +		return ret;
> +	}
>  
>  	return security_inode_init_security(inode, dir, qstr,
>  					    &ocfs2_initxattrs, NULL);


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
