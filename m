Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5318BC64ED9
	for <ocfs2-devel@archiver.kernel.org>; Sun, 19 Feb 2023 19:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=n3RzOOTSwBb7YRk5vunB71PfYB5VlFDWoKyNWuvqvJk=;
 b=Ri59ORj3AoednUSvzp+NWv+J7jZNggv4e3UuiMZt4wYT7gM0U3Pu/84z2ib6HKxbIB/EQKiYhFBg
   YXV1l5aW528ZjHyt4i+HPoneahEOf+W75gcGXf4SBb/MyAPm4PKT4gfSc3eCr0GYgWrwvyT+qPi7
   oUOJ0nNhkoV9Q6PecjBPn2NAMRfyTfT3apwku8Q4bKE5zI1xc2/C1ST4MKGzVnCT2Fd/GyQoDZhQ
   RtLlW42yR3MyynX7Yx52EAlydN/clCpkW6w9HhqfZNomdY15kjq3Gua/aN7k94QWZ3SSoiiF4yFF
   tVQVK9V1DWn/fWcuASWz2zaeqnVndRPXoBuIDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=n3RzOOTSwBb7YRk5vunB71PfYB5VlFDWoKyNWuvqvJk=;
 b=r5X51irI6dnD92AzVhp+3JL1KqezGIh/79L1C9M6htZVwC8nyeNAFXgfOM2GN3Z4hes3AtJRfu9D
   O+nKtLfYc2gouMG4R12NGzMmrC0nBNXUsROUohL3tKlONbB/GGeP1xHEW3q8dtWzgBATB0przRyh
   fPwXWSMpTN86ZS1chn3RSn32awXvMgjmBjCutnQQyjdguSCZhS9HcyFlhO3krA/b3esDkk6T8Tnp
   n4Uf4b4/U37pnaYllRfP5tuNFENkyAfDknDKRZWRK3AjAP4UcJgNVwSpe0jTaRROS4zPdIt29oVS
   9RvYpSUHHxkaIB58wiJN46BGHwOE8FkilWPoOg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQC006R9ERO7TD0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 19 Feb 2023 19:43:00 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=s63DfqR4NiC3QZGz8yhFyKSMoul9bYlY7/ahn77RpF4=;
 b=LbScWa+/jpKBo4XSMLSlaXfty+s6n+EDSLfluGUo9+gnmcsIlrU60INox9/lcZY2PA0Y
 hLUj2vm/woxrkwlXp9aPJyZcZLhHCe47gKAnzahmfx+2llFIMZQg/xWAAYljYpqXzIrT
 +s4CyusDNGasMpUZhNdevGPBnkjLMu+uZb4hg0iWwMgW6+FfMZVy2/DA6Xvrsql2vXHf
 /q+69TaoJ2Zwff4Mq2xQ7lYYPndr/6dzTThx2p3UCW5fVIS55gkIxwOkYUaIojQdToQ1
 GvT/pl9rfqLZBqfElAXk5BI6+RUM6FeLNE1iDfgE3m2ysyPmmE5WAsBqCekdw1U8RskP /w==
Message-id: <b7b4eeb060d1f662f990b3ebb3848fa4ab7e8c97.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Sun, 19 Feb 2023 14:41:47 -0500
In-reply-to: <20221201104125.919483-6-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-6-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-19_12,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302190186
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 priorityscore=181 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 clxscore=125 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302190188
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 5/6] evm: Align evm_inode_init_security()
 definition with LSM infrastructure
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
X-ServerName: mx0a-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: jnfVGh3obHkrQkr0sFEZHhiaf_Qj1pyC
X-Proofpoint-ORIG-GUID: jnfVGh3obHkrQkr0sFEZHhiaf_Qj1pyC
Reporting-Meta:
 AAGDInTrdbL8wci0mLvCjdyPKpFgYiF5iviQnjd1tXlze3slXixe5W2X/Trpg2Ng
 aBuyDnBZbR/uA9ETNWpCVX1XMWdPOOXoD4lqsT7ksDoLf/a0yFnnKl56rNIPRzuv
 RvkukrCpROLQqGkWwoGrUTe94bhkYmTxwz+aGQGJaxe/+vKLqz7fqxflD3iNNxYd
 lo3Vs4yb7URQ+rGNS4mHgDKNzE6nkmQpi1dJvGAFJGt988RSPRJdPN9cyM7wKMiX
 GJTbRNnywTB4BKU2sGqLewh9OyIauFIh6/y9ktUrvKt1Aa9eEF3FbQt+IBvXNY3H
 sf2qF+MGBerL1VK1K4kuWwCmDlrvxkPuoukjERe1enunu9rinX1wcOnfLa/STyzk
 CnR2DLrhHkIOaJ0AvLqPG/cgfN4h+XIOgIFKzq9EkG6xkyDYQcG8s1odpYGZLdUt
 Mz9tCWZrc8PxsJXtfLEM5ViQTr34v2jqEsMdi9znUrMyj0r3AVOopjyqtGfaqpMB
 aLf3Fgx/0wWAW0ASU/6jZM0eRBTuXScqh/B2nyGWFGyG

On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Change the evm_inode_init_security() definition to align with the LSM
> infrastructure. Keep the existing behavior of including in the HMAC
> calculation only the first xattr provided by LSMs.
> 
> Changing the evm_inode_init_security() definition requires passing only the
> xattr array allocated by security_inode_init_security(), instead of the
> first LSM xattr and the place where the EVM xattr should be filled. In lieu
> of passing the EVM xattr, EVM must position itself after the last filled
> xattr (by checking the xattr name), since only the beginning of the xattr
> array is given.
> 
> Finally, make evm_inode_init_security() return value compatible with the
> inode_init_security hook conventions, i.e. return -EOPNOTSUPP if it is not
> setting an xattr.
> 
> EVM is a bit tricky, because xattrs is both an input and an output. If it
> was just output, EVM should have returned zero if xattrs is NULL. But,
> since xattrs is also input, EVM is unable to do its calculations, so return
> -EOPNOTSUPP and handle this error in security_inode_init_security().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

One comment below, otherwise,
Reviewed-by: Mimi  Zohar <zohar@linux.ibm.com>


> ---
>  include/linux/evm.h               | 12 ++++++------
>  security/integrity/evm/evm_main.c | 20 +++++++++++++-------
>  security/security.c               |  5 ++---
>  3 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/evm.h b/include/linux/evm.h
> index aa63e0b3c0a2..3bb2ae9fe098 100644
> --- a/include/linux/evm.h
> +++ b/include/linux/evm.h
> @@ -35,9 +35,9 @@ extern int evm_inode_removexattr(struct user_namespace *mnt_userns,
>  				 struct dentry *dentry, const char *xattr_name);
>  extern void evm_inode_post_removexattr(struct dentry *dentry,
>  				       const char *xattr_name);
> -extern int evm_inode_init_security(struct inode *inode,
> -				   const struct xattr *xattr_array,
> -				   struct xattr *evm);
> +extern int evm_inode_init_security(struct inode *inode, struct inode *dir,
> +				   const struct qstr *qstr,
> +				   struct xattr *xattrs);
>  extern bool evm_revalidate_status(const char *xattr_name);
>  extern int evm_protected_xattr_if_enabled(const char *req_xattr_name);
>  extern int evm_read_protected_xattrs(struct dentry *dentry, u8 *buffer,
> @@ -108,9 +108,9 @@ static inline void evm_inode_post_removexattr(struct dentry *dentry,
>  	return;
>  }
>  
> -static inline int evm_inode_init_security(struct inode *inode,
> -					  const struct xattr *xattr_array,
> -					  struct xattr *evm)
> +static inline int evm_inode_init_security(struct inode *inode, struct inode *dir,
> +					  const struct qstr *qstr,
> +					  struct xattr *xattrs)
>  {
>  	return 0;
>  }
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 23d484e05e6f..0a312cafb7de 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -845,23 +845,29 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
>  /*
>   * evm_inode_init_security - initializes security.evm HMAC value
>   */
> -int evm_inode_init_security(struct inode *inode,
> -				 const struct xattr *lsm_xattr,
> -				 struct xattr *evm_xattr)
> +int evm_inode_init_security(struct inode *inode, struct inode *dir,
> +			    const struct qstr *qstr,
> +			    struct xattr *xattrs)
>  {
>  	struct evm_xattr *xattr_data;
> +	struct xattr *xattr, *evm_xattr;
>  	int rc;
>  
> -	if (!(evm_initialized & EVM_INIT_HMAC) ||
> -	    !evm_protected_xattr(lsm_xattr->name))
> -		return 0;
> +	if (!(evm_initialized & EVM_INIT_HMAC) || !xattrs ||
> +	    !evm_protected_xattr(xattrs->name))
> +		return -EOPNOTSUPP;
> +
> +	for (xattr = xattrs; xattr->value != NULL; xattr++)
> +		;

security_inode_init_security() already contains a comment for
allocating +2 extra space.   Adding a similar comment here to explain
why walking the xattrs like this is safe would be nice.

> +
> +	evm_xattr = xattr;
>  
>  	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
>  	if (!xattr_data)
>  		return -ENOMEM;
>  
>  	xattr_data->data.type = EVM_XATTR_HMAC;
> -	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
> +	rc = evm_init_hmac(inode, xattrs, xattr_data->digest);
>  	if (rc < 0)
>  		goto out;
>  
> diff --git a/security/security.c b/security/security.c
> index 36804609caaa..44ce579daec1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1190,9 +1190,8 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
>  	if (!num_filled_xattrs)
>  		goto out;
>  
> -	ret = evm_inode_init_security(inode, new_xattrs,
> -				      new_xattrs + num_filled_xattrs);
> -	if (ret)
> +	ret = evm_inode_init_security(inode, dir, qstr, new_xattrs);
> +	if (ret && ret != -EOPNOTSUPP)
>  		goto out;
>  	ret = initxattrs(inode, new_xattrs, fs_data);
>  out:



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
