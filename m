Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B772C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=O4r20cHLZcLRbGMo00VUTRkwJcEivoVTslRttTAR2mg=;
 b=2+fXl7uF21mk7O5QafYbDVbARagyKbQ0nnhZT8w1qzVT+oOSkRjhKvoxqiMrTUrEvD/VU/rgaAAu
   oYvyUtcsvKRAfqSas2XFBBwj36yuMFYxM6O/ZfgB/fvPU1z9r4bzoC47T7qXwAO6TY5yMqAdWQ4G
   GgxCQ1zWVGjkDNkfDLMwe987zDC4E8phrlXeT26o3dEyXnB5AeiL/B2PhOHKPSen0XTQXSsZfJwc
   S4u3GXoz+kQPIIvTWzyjo3112aBf1Qvw4Qjm3WwYPOviAycoXhkpaIN21jQ4RGVwE9niqIgIvrwV
   CVkNAwsyoyH6+rVh/c7fS7gx9Pucv6l1aAkM7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=O4r20cHLZcLRbGMo00VUTRkwJcEivoVTslRttTAR2mg=;
 b=X6uYnzT9bBK4oSvLfISelqgrZF+VNP7mXTK81EciTr2lIu5mQyfrbEnSJnDX00Uu89JvKBfv/u0Y
   /yJ0Kn7eTP1buqqisMriAl6zVMH8ARMGZ+Di0bfGihorlepyq/2+hu+IbeYJ/SUIXHNhTXI0S6sy
   nurBNnbJdHIrNUmlw4gEhSXu3+8X8OvHWoYG13LsSTGpVLrOZRwVkoAvs4dJMUL2ikRISB9NLMn1
   NaxjEV7BN53cNtel5H1EMZOmdll7wRPgV7Y24UGwOFCDnLyvfHcxYBtiWrOaSBzVNTVRg87Z84E5
   hvlGMEC9OMye5YyWXaOlNPC8T/pMRcwNCyTmGQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLT00IVVAR1FC50@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 17:47:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=VOvq9Sif0jOsBGBmaU8mrfW2vyYy0h6JoSd/AjbT9Ks=;
 b=Kk+tU5NXDLYJ0DJR0jE+smWMyPHYav7Cq4zcJ1t2TeMgRij6GDXjVb5pP+IfHi9peMfU
 1025N6XWkyMOoi1EQuKNUbR0TpPV+M6nah8zC0taJ6qJjBvWZGPlpfwOb31rSYjlzuQn
 LMmmdPz7xRtLCy3AHWEOEQiDoxeqE+H9XuYtWuqPfb6npwNXbhNLOucRadqo5JiAASTW
 fZ9txdOic9kZmjoG713yjmUibP7lVnPQMyRrpxmQGYkabsxmqWBB4f+yWQ3Yxy7knwif
 3QcJnzr1pU5oxvLdgqPMobtuBgXArn8QlxKFPjS2ixuES+sDF0Rv1z/be6iupJ+uzBwo qQ==
Message-id: <052d91687e813110cc1e1d762ea086cc8085114a.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org,
 Casey Schaufler <casey@schaufler-ca.com>
Date: Wed, 23 Nov 2022 12:46:41 -0500
In-reply-to: <20221123095202.599252-3-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
 <20221123095202.599252-3-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_10,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211230129
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=246 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 clxscore=171 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230131 domainage_hfrom=13398
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 2/6] ocfs2: Switch to
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
From: Mimi Zohar via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mimi Zohar <zohar@linux.ibm.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-TM-AS-GCONF: 00
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: mjCTIGGksKSO252l3Uh2yRLZCB4HKKj6
X-Proofpoint-ORIG-GUID: mjCTIGGksKSO252l3Uh2yRLZCB4HKKj6
Reporting-Meta:
 AAED6ipOTUBuGY7l38Oh76j+1dJPQfoA8GcfzlbGLbW2PHbVt0y0Im/+Wjolivwo
 pTc/yTP9sC4xNmjqUcodrbK4wry/Md5jy4rGFZ2fu7OPc3FhKLFwUYStxi7kCBjk
 oCCTtQFerOinJAnmFWE+SLmDc0LfDQFq7mUKK5P7xsYJ/f/fKOYM2BDB0tdwTjL2
 7plKR1IghywhlGSvFBbvXh14US1JEc9PwCPxnTLgbNa56I5YCt8z9raSjipCnSXj
 U7pVWjDSgKgHajgbCaoHXQ1Zwz6fUpoP60bEptX8QBi1EPy/Gk+f3q5H8VW4BxqO
 HIXx0ECRJYiKaKsrCet+SQkaTv6GwoNZk6eGOZan/vgKbZ7TsUlddd/dCAfbQPEd
 5BXqenXJu2ma3gwRBaokhxoucD7W9Qqva7hC63eeRqC4+UQdZ0uY9jEQ5Jvl4GUQ
 LPJ5FxFvwOjg1za5zlvKuE0HB0aoJkAn9sIbyRyAMcT3+iu+2M5zTnE59waAZWdF
 lXKXT/j8sypVhFWfB3Z8r5OkCmwxty1fD8gttWUL6B7U

On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> In preparation for removing security_old_inode_init_security(), switch to
> security_inode_init_security().
> 
> Extend the existing ocfs2_initxattrs() to take the
> ocfs2_security_xattr_info structure from fs_info, and populate the
> name/value/len triple with the first xattr provided by LSMs. Supporting
> multiple xattrs is not currently supported, as it requires non-trivial
> changes that can be done at a later time.

ocfs2 already defines ocfs2_init_security_get() as a wrapper around
calling either security_old_inode_init_security() or
security_inode_init_security().  Based on "si" one or the other hook is
called.  ocfs2_initxattrs is already defined.

        struct ocfs2_security_xattr_info si = {
                .name = NULL,
                .enable = 1,
        };

The main difference between calling security_old_inode_init_security or
security_inode_init_security() is whether or not security.evm is
calculated and written.

Perhaps it is time to remove the call to
security_old_inode_init_security() in ocfs2_init_security_get().  We
need to hear back from the ocfs2 community.  Mark?  Joel?

As noted previously this change affects mknod and symlinks.

Mimi

> 
> As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> of replicating the behavior of security_old_inode_init_security(), i.e.
> just obtaining the xattr, in addition to setting all xattrs provided by
> LSMs.
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
