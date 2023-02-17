Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806F5C05027
	for <ocfs2-devel@archiver.kernel.org>; Fri, 17 Feb 2023 19:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=orMDMGHwhKCScLrGB3kbpH8vnQcFvWdKqp220FnIdhc=;
 b=ScDypheyT1NMaylDmLwrVBWD5gFWr83Wfzoz7BU9xQLcPLX0Cu6BlfIKMm4prQZqo+Z94u1x5nKI
   7a7Tf5BNo0U+PM2nSE6TG0+8oGLCXCyqN/uZyVI9Fjt7YBTKgQhcQB63KY00HpH/TCfFtKz6E+c0
   QUvK6rajXR4gaS4jj2himZcxwpklUbsx9r1ow0qYUq0KS/mAjEb0HKBEmE/H8DOoT6Rd5K5d6FqS
   +EBGxyxzMoq2+cIX81qP69UAem5ABO0EKpjsh2OF5JXqWSQeK5vCBYcgb4gvw6e5JNCnMfwtI7mH
   HyVJY15IDdbj74BaPQSXRmMs+wC/cBqS7kGVNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=orMDMGHwhKCScLrGB3kbpH8vnQcFvWdKqp220FnIdhc=;
 b=T/kT2PZCW6t02CYn+uqg1h1SAsRArqRikEBK95OZs5ul954cEgXzOHGg4dHb59HA+JmJ0KAOJT9o
   aXBTOmvO+Sg3xA32WWLeH3Je2kPioGU7QX1s5A2KI2TcyNk0r7KcFoIMg9NG0XJcT74RlA7HYetw
   whx7NWBiDvMgmN/z6caTjB0fMQNhdsVYKrywiUwewgQwdEY22j4nIzsiU7kNB8RfhH7YKQFkTH4c
   3Gxa1iaRdtbkzllix2uG12MVGHI0YasGIZEDAY+wdyxDH6GoOG45lmdRkwHqlCxL8QTYnBUh29GE
   q8FU3Iy9LLGgD8mJ6K3uMpCP3dbQGuGyi1GzjQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ800HT0POOJJ00@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 17 Feb 2023 19:48:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Ovg0+EZ8YSVib5FriRwZoVL/giHj0F5GZrikLe08tak=;
 b=cfo23bYl/GTyrJozFIEWHsUWIyF0xDJ9/LKidbByToRVxAw71iyh5dQku0myFBt14jeJ
 urSYlBY63+u+uOdLKPnzGEr3ulk3DdHP+wcCt78nJuYRoRbEW8l8OuOWGnTlLJNC6wsX
 LxVGjOQ0NHLudVR49Al6pyrydzTOeD/ic+9cB5r55eR14RbDjmKHqUA2ImHXCgCwKyBe
 pbGDD+oxPnUQ3nzVn6WmF6B5JZjOYfZLhcCGvMO9jCr9u2FlPjEfzYNsDqzLDYwlKdMi
 H4zDFnMpGiKSq7udyPXI5S+lxAux5MKU7cpP6JY05OkHYgfV0LNTICDR4Xu8YT3q2PMe lQ==
Message-id: <53d2f07fd19f4ab74c66d4f4f07c62d163708ecd.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Fri, 17 Feb 2023 14:47:35 -0500
In-reply-to: <20221201104125.919483-2-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-2-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_14,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302170171
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10624
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 clxscore=173 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=231 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170173
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 1/6] reiserfs: Switch to
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
X-Proofpoint-GUID: YlYxBARtf1LDyNMSXgdXRVU1F_-ulGue
X-Proofpoint-ORIG-GUID: YlYxBARtf1LDyNMSXgdXRVU1F_-ulGue
Reporting-Meta:
 AAHGZPu57LDnlOzkkY0WbvzuRchTiVt90rfayCsvwnLyMz4UuCK1jm8ObGG9E30M
 ybm3itJZaj4dcAXVcUJOUV2AJ+3FtMc5T+R+sgf1eqeMuGXulOf9SypeMrj/hQzD
 paBijob7+sdIKhMfj+20GUQ0Zvr9i7R4c7no08zbHJa4dVIyIH0XAHeSH8aZ5/VV
 Ldg8T3HJ7VfNpjlyaBg+60zgBPvaVM7mR/05A1NYQz74o1ivz8LvEvQ8K6PETEXI
 DuD4yQS1cFskD98/Feb9jD8Q5ewBDVn+8VgvmnDH7FIf0ikoXuPKyjyaQwp9Lgp5
 uLsCIRDFgtuuu0H+78yzzD9A3yM3hViu2P+Bog/+DYJ3oIxWQlBq6oWru/BEdw6h
 KTP2S/3iX8+8QqROLf+iAkRn5fpEpPFlVuSF9AK/ezdWpAe05JxdFHZ1FN1tz4hi
 jPtNuX3aMDLUoB5AyHSQMoqSDztuSfIGXG1GXq2Ic0T5o6lX1Sb71IAq7R4hkQai
 GapSLL67mXKXqikBLUPGMINXHfEsjLFhZcNNhGrh6i4=

On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> In preparation for removing security_old_inode_init_security(), switch to
> security_inode_init_security().
> 
> Define the initxattrs callback reiserfs_initxattrs(), to populate the
> name/value/len triple in the reiserfs_security_handle() with the first
> xattr provided by LSMs. Make a copy of the xattr value, as
> security_inode_init_security() frees it.
> 
> After the call to security_inode_init_security(), remove the check for
> returning -EOPNOTSUPP, as security_inode_init_security() changes it to
> zero.
> 
> Multiple xattrs are currently not supported, as the
> reiserfs_security_handle structure is exported to user space. As a
> consequence, even if EVM is invoked, it will not provide an xattr (if it
> is not the first to set it, its xattr will be discarded; if it is the
> first, it does not have xattrs to calculate the HMAC on).
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Now that commit 572302af1258 ("reiserfs: Add missing calls to
reiserfs_security_free()") is upstreamed, please include a dependency
comment.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

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
