Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507B7C05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 08:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RbBIkwLwYHNqBwzCFgOtrjK1qBU8iVpwVv/0OrJIu3M=;
 b=tigP7ZoUBHjEa5TV4swtDUiZ8Rw4ANY0pZrHzuaTujUhDFWhHY/nl2Eyqw3s89+FrJ+jieffXaUX
   2uwc24gZox1WOpf4P0io6X309VIW+1RNAWYOP8DKase+hYSk3k4xHo36YbD0J3MonfTgKQMpUscR
   axCxnY9cXhQXaqN7ZH4/k/0Q4So93kJEoda71kF3BmItRo3zesKFO41dPstHY9OKnLOlVg3Kyhas
   MbdjGHemBoUxBIxQG6F18zHo5sYknG5j++EUvdQ+UwN4y2clOv1BLbXNj9plfFnVwFKK8xWHjVPw
   Y3t1HIgxGIKS/PpiJ9FCgQNwCeZKs25UYpgnzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RbBIkwLwYHNqBwzCFgOtrjK1qBU8iVpwVv/0OrJIu3M=;
 b=VFF97C+r5aQBA1QdVhau5N6BUTUmJB8prkp4dOEvz3Oh7gONKhGHmEq0ydvRzsw/fvNKNFhqow/Y
   gFaewDBdS9wgJLfS8l0vTghYjiwaV/IQBduHoOVN2TTmBq96MzUE711pCs/Cx5wrv/UITmuSVs6f
   zm0qeXTV5uB9QaBkwLQq0sw+FU3TJoR4oogcDl8f+2wbXFzAnNdPOw1Pss8ImjZK5ViUmlUMyPcI
   eIoBLurt4q2Wg9aplEZHoQegW6zb79XXDz4k1amFOWbjAuCtRNWwxhZZN7+3sLL+cf9N9gIQrmLI
   pQ31BBasxv7nEwAQfDv/GM5mTF7EF7ToIaZVhQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD00MOLEIPTL40@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 08:35:13 +0000 (GMT)
Message-id: <b8801e0112b246e774ed687e83469ffdc1148010.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 09:34:15 +0100
In-reply-to: <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=34
 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200076
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
X-CM-TRANSID: GxC2BwCHXGONMPNjbsw2AQ--.23590S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtw4kKF17Zw17WrWxJw1UKFg_yoWxAw13pa
 yrtFnxKr1rJFyUWryftFWY9w1S9FWrGrZrGrs3K347ZF1DCrn3tr10yr15ua45ArWUJFy8
 tw48Crsxuan8J3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAOBF1jj4ks-AAAsj
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: Ch3hOey4jGEYliaAeGkWNhB5DLVNEV5B
X-Proofpoint-ORIG-GUID: Ch3hOey4jGEYliaAeGkWNhB5DLVNEV5B
Reporting-Meta:
 AAEuZCyaLMq0LKFQXTWvWtJeaUEfauZ4AWnWOsDYXdB4tYT85iaKakvlYSl1MSys
 um3k6ZcsgYHqhOmZMjKyHirGUcJEI1aWBtllzOJZeo2l9JhR+3Rny1QeqtSj+2K4
 7qoURz+2cTTvTLu+t4Q4q31b16DysNlvYCrF6gKeoQWBnBce2asVKzCvbPfo2hv8
 zGEoKJIcaMRZCPbSLGVp8s4DY/v/7w01QKIFN7K0F/j/8TvT0L9aZy8ySR6D2/H2
 qjWLz5aMjke/MfB3ZW7YIKOuntqwDUiaMSVOOE0QnVrwMqB5pI2sLEKkayFJT1zD
 DbZDO/w+WIX2M3jSoZpzmaH+YDmtPhlDZqF3GvGJSYq5JOiEJ/CSWEYU2t5weizd
 TNYJkxvFMm+YkRKeeQMo02C40Og9UFHU7cR3Avn4cxIp7Tm3X0jbCGoGjE4zJ2V1
 pWh61FdCQjzIGypjDXuYsx+urhSuayHttwA6JdHKboWlFhl7atVUMMS9annMVzvH
 lYgVvCl1jLnqhh1fBtBlVjK+oBn8qzMKZArSwJJhnik=

On Fri, 2023-02-17 at 14:51 -0500, Mimi Zohar wrote:
> On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > In preparation for removing security_old_inode_init_security(), switch to
> > security_inode_init_security().
> > 
> > Extend the existing ocfs2_initxattrs() to take the
> > ocfs2_security_xattr_info structure from fs_info, and populate the
> > name/value/len triple with the first xattr provided by LSMs.
> > 
> > As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> > of replicating the behavior of security_old_inode_init_security(), i.e.
> > just obtaining the xattr, in addition to setting all xattrs provided by
> > LSMs.
> > 
> > Supporting multiple xattrs is not currently supported where
> > security_old_inode_init_security() was called (mknod, symlink), as it
> > requires non-trivial changes that can be done at a later time. Like for
> > reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
> > not the first to set it, its xattr will be discarded; if it is the first,
> > it does not have xattrs to calculate the HMAC on).
> > 
> > Finally, modify the handling of the return value from
> > ocfs2_init_security_get(). As security_inode_init_security() does not
> > return -EOPNOTSUPP, remove this case and directly handle the error if the
> > return value is not zero.
> > 
> > However, the previous case of receiving -EOPNOTSUPP should be still
> > taken into account, as security_inode_init_security() could return zero
> > without setting xattrs and ocfs2 would consider it as if the xattr was set.
> > 
> > Instead, if security_inode_init_security() returned zero, look at the xattr
> > if it was set, and behave accordingly, i.e. set si->enable to zero to
> > notify to the functions following ocfs2_init_security_get() that the xattr
> > is not available (same as if security_old_inode_init_security() returned
> > -EOPNOTSUPP).
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> My previous review missed a couple of concerns.
> 
> > ---
> >  fs/ocfs2/namei.c | 18 ++++++------------
> >  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
> >  2 files changed, 32 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > index 05f32989bad6..55fba81cd2d1 100644
> > --- a/fs/ocfs2/namei.c
> > +++ b/fs/ocfs2/namei.c
> > @@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
> >  	int want_meta = 0;
> >  	int xattr_credits = 0;
> >  	struct ocfs2_security_xattr_info si = {
> > +		.name = NULL,
> >  		.enable = 1,
> >  	};
> >  	int did_quota_inode = 0;
> > @@ -315,12 +316,8 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
> >  	/* get security xattr */
> >  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
> >  	if (status) {
> > -		if (status == -EOPNOTSUPP)
> > -			si.enable = 0;
> > -		else {
> > -			mlog_errno(status);
> > -			goto leave;
> > -		}
> 
> Although security_inode_init_security() does not return -EOPNOTSUPP, 
> ocfs2_init_security_get() could.  Refer to commit 8154da3d2114 ("ocfs2:
> Add incompatible flag for extended attribute").   It was added as a
> temporary solution back in 2008, so it is highly unlikely that it is
> still needed.
> 
> > +		mlog_errno(status);
> > +		goto leave;
> 
> Without the -EOPNOTSUPP test, ocfs2_mknod() would not create the inode;
> and similarly ocfs2_symlink(), below, would not create the symlink.  It
> would be safer not to remove the -EOPNOTSUPP test.

You are absolutely right. Will add it back.

Thanks

Roberto

> >  	}
> >  
> >  	/* calculate meta data/clusters for setting security and acl xattr */
> > @@ -1805,6 +1802,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
> >  	int want_clusters = 0;
> >  	int xattr_credits = 0;
> >  	struct ocfs2_security_xattr_info si = {
> > +		.name = NULL,
> >  		.enable = 1,
> >  	};
> >  	int did_quota = 0, did_quota_inode = 0;
> > @@ -1875,12 +1873,8 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
> >  	/* get security xattr */
> >  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
> >  	if (status) {
> > -		if (status == -EOPNOTSUPP)
> > -			si.enable = 0;
> > -		else {
> > -			mlog_errno(status);
> > -			goto bail;
> > -		}
> > +		mlog_errno(status);
> > +		goto bail;
> >  	}
> >  
> >  	/* calculate meta data/clusters for setting security xattr */
> > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > index 95d0611c5fc7..55699c573541 100644
> > --- a/fs/ocfs2/xattr.c
> > +++ b/fs/ocfs2/xattr.c
> > @@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
> >  static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> >  		     void *fs_info)
> >  {
> > +	struct ocfs2_security_xattr_info *si = fs_info;
> >  	const struct xattr *xattr;
> >  	int err = 0;
> >  
> > +	if (si) {
> > +		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
> > +				    GFP_KERNEL);
> > +		if (!si->value)
> > +			return -ENOMEM;
> > +
> > +		si->name = xattr_array->name;
> > +		si->value_len = xattr_array->value_len;
> > +		return 0;
> > +	}
> > +
> >  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> >  		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
> >  				      xattr->name, xattr->value,
> > @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
> >  			    const struct qstr *qstr,
> >  			    struct ocfs2_security_xattr_info *si)
> >  {
> > +	int ret;
> > +
> >  	/* check whether ocfs2 support feature xattr */
> >  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
> >  		return -EOPNOTSUPP;
> > -	if (si)
> > -		return security_old_inode_init_security(inode, dir, qstr,
> > -							&si->name, &si->value,
> > -							&si->value_len);
> > +	if (si) {
> > +		ret = security_inode_init_security(inode, dir, qstr,
> > +						   &ocfs2_initxattrs, si);
> 
> The "if (unlikely(IS_PRIVATE(inode))"  test exists in both
> security_old_inode_init_security() and security_inode_init_security(),
> but return different values.  In the former case, it returns
> -EOPNOTSUPP.  In the latter case, it returns 0.  The question is
> whether or not we need to be concerned about private inodes on ocfs2.  
> If private inodes on ocfs2 are possible, then ocsf2_mknod() or
> ocfs2_symlink() would fail to create the inode or symlink.
> 
> > +		/*
> > +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> > +		 * we have to check the xattr ourselves.
> > +		 */
> > +		if (!ret && !si->name)
> > +			si->enable = 0;
> > +
> > +		return ret;
> > +	}
> >  
> >  	return security_inode_init_security(inode, dir, qstr,
> >  					    &ocfs2_initxattrs, NULL);


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
