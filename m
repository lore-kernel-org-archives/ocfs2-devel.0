Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C8DC4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=slh0SNIjrWJQ1JzaVtsgPws6bQ9njMlv9UTzc7/xfCw=;
 b=rJQ0g5SWfZz/JEBI5v7otjEiVjQ5jdj32VxpOPos0O0Q6xSiRvb4MljU/hvUtSyXPswp2iOZBwSA
   RT4EotOexXkGVRDdTe2qNlKnt6V6SmB/GB7T3vRfufCHL1HoH90kjns2lfJrf38jBdayiHf/H3vl
   /kG7brtkWwp48FXr3ljJCmjljP7pCAuFKtJIhT6Pop/4/j0TA0jxI5LXDIp+2VsKyzKL7JII+Bol
   dc0WmniQ9l/Hl9ZzSwZ5Iu9jWY4zpdU5DgMF9EIz8OxX3gmbRwspFNlCNQPY4TOaLCW20CGS7ze/
   pmdyY/sa8/Wce2We4s+3ai6OonHg9QCh7EUoLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=slh0SNIjrWJQ1JzaVtsgPws6bQ9njMlv9UTzc7/xfCw=;
 b=Gi14KqJzWaB4TCSUmsPzgEVsc+wQGO46ViyYsslPG8gW6MBkeYsw1N+lfbm0EbCi56LtnIAumxJl
   ZkvYh8emzH/fS4CC9HYTK4BEpXhMsEKirNgegPRNEzlkl4BbPQBrjL71hJ1JQr+quMfJHsIwhTHy
   DXPmLRtQMMSX0nA6BJIhQT4hAzExZJXoyBR2RYR+n88pZXgrGGI69nY+sxjV1uU06EfEQDzOl6GT
   ohnFTjZVKznxhETcsTgt8ymkGgc82I9VUhGIjpX4Mj9wlv6Xb2XJi+mLlFj5WgXYfdrMU4T9sZUs
   cwGClE/nMzDQ+kOYoMVtc5SMZ0pknZG00gg/fQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00J7GY23WZA0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 13:13:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=9PXQukpxuogl+8l31b8WwhvCbvp+U7J+XqCX2qkFTGE=;
 b=ieoJPpTfsIcCtPXvKSpUqs6UfKHqFjLGBdXPXTWDX9kLITBSJQkI4eRL/YTgUx19nMG0
 7IYmKhlPfE4sk2o655ekHeTIY2y+rO2ctE5x6TTSJwzN2cOjMzhD+w17h7wZvS+naXgu
 /i+CRkTTazmTk+kVp4j3A8srGQsMSirQVZ3JWj14Zouvh67riSn+ZBFCgNW5510Wzt09
 a1HuV8vZlRlg2fyXyq2EI8RgJ0V/p37IKFRUL3xmAUxOdDkG7APYRuD+dq2TzV2Mhl1l
 x6ZB8GXBgIWfrB9hQQRG/KfqEj0P+1Un1P1nJQRZGzw6QlXcLGtioBIccPxENfZIgxDR yw==
Message-id: <c5cea3cad1eaf79c29e91e9ecf8e8b7dcee2ce2c.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 08:12:27 -0500
In-reply-to: <20221123095202.599252-2-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
 <20221123095202.599252-2-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_07,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 clxscore=111 mlxscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=259 impostorscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230098 domainage_hfrom=13398
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 1/6] reiserfs: Switch to
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
X-ServerName: mx0a-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: RWfy1SXFnDDbSLzXPhRQXcseFIjvrgmn
X-Proofpoint-GUID: RWfy1SXFnDDbSLzXPhRQXcseFIjvrgmn
Reporting-Meta:
 AAEjfNfxmAyO/DtV5vI9gPVeibIxXI/WgDi11VmaHesMNropXIvvs6wSOerP1PvC
 Em9WkQfXiHtjm8qEV6I/wjQmUb5CPOriODoHlKqrsQ4aIxJWs7VNH5PdYcEmuk0e
 4nFgiBmIPjomaS6XSmNlYDlU67TaDgSMEBi4FXBq8+QZrr2x9er1VIvCJjjk9+oj
 u65iQPWlo275s+L0i0R7VTmaXApZj84KrUHHWZVNujbbOfrul/jm2Rx9WlWbv4wC
 eeKGMoD+i/0U2nbOb2KsXbe+Apno+s9W7Vi/qbFfwSetfuLJOcXK3eGl5UUdtWVD
 Nj0LUku+oFLF5hV2RSkMbkbncorq3yH0tfhzfdhrOUhNFpUy+BW7gs62C+htwGbX
 MhlbuGpxGgAT2xTTOYtI7Pl70Ib6q7SdShRsUW8iy/wGuC73b5F3/ab1rfao3Jfr
 neQldVMjbe0dVM0ySVlWcHjLqjehDEQZ0PG+6mSCvCPCx1y5UrgjkE30jz/yrLZK
 AcSkL6Py6R1wLi7fBLimVGfpl53GNjDRjge83L3jGFcd

On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> In preparation for removing security_old_inode_init_security(), switch to
> security_inode_init_security().
> 
> Define the initxattrs callback reiserfs_initxattrs(), to populate the
> name/value/len triple in the reiserfs_security_handle() with the first
> xattr provided by LSMs. Multiple xattrs are currently not supported, as the
> reiserfs_security_handle structure is exported to user space.

The security_old_inode_init_security() hook doesn't support EVM. 
Missing from this patch description is whether the move to the
security_inode_init_security() hook changes security.evm.  FYI, I'm not
suggesting it should.  Please update the patch description accordingly.

Mimi

> 
> In reiserfs_initxattrs(), make a copy of the first xattr value, as
> security_inode_init_security() frees it.
> 
> After the call to security_inode_init_security(), remove the check for
> returning -EOPNOTSUPP, as security_inode_init_security() changes it to
> zero.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  fs/reiserfs/xattr_security.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
> index 857a65b05726..0ba96757681d 100644
> --- a/fs/reiserfs/xattr_security.c
> +++ b/fs/reiserfs/xattr_security.c
> @@ -39,6 +39,22 @@ static bool security_list(struct dentry *dentry)
>  	return !IS_PRIVATE(d_inode(dentry));
>  }
>  
> +static int
> +reiserfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +		    void *fs_info)
> +{
> +	struct reiserfs_security_handle *sec = fs_info;
> +
> +	sec->value = kmemdup(xattr_array->value, xattr_array->value_len,
> +			     GFP_KERNEL);
> +	if (!sec->value)
> +		return -ENOMEM;
> +
> +	sec->name = xattr_array->name;
> +	sec->length = xattr_array->value_len;
> +	return 0;
> +}
> +
>  /* Initializes the security context for a new inode and returns the number
>   * of blocks needed for the transaction. If successful, reiserfs_security
>   * must be released using reiserfs_security_free when the caller is done. */
> @@ -56,12 +72,9 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
>  	if (IS_PRIVATE(dir))
>  		return 0;
>  
> -	error = security_old_inode_init_security(inode, dir, qstr, &sec->name,
> -						 &sec->value, &sec->length);
> +	error = security_inode_init_security(inode, dir, qstr,
> +					     &reiserfs_initxattrs, sec);
>  	if (error) {
> -		if (error == -EOPNOTSUPP)
> -			error = 0;
> -
>  		sec->name = NULL;
>  		sec->value = NULL;
>  		sec->length = 0;



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
