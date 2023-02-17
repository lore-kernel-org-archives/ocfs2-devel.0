Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDADAC636D6
	for <ocfs2-devel@archiver.kernel.org>; Fri, 17 Feb 2023 21:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hHCajSxkVzearIJZMcRuHeNSrSvpjl2scDl83YxuUVc=;
 b=lKGkYtdvLNgXA1U8WjaVx27ZDTr+ZowVtQD9GxUi0WbWERjPQkzRKuLEM8mdoYPT1mTFYdC8ourJ
   TJoO2XTY3EuS8zYqt3r2iH8hFy16zKbRRGmyKtfwNkc7F6sdjqCx/mw1Lf/+u3vQhtWLyM/nWQc+
   IBYCHq1EqA8lae7P7cG+mauEKffVELxcA9RA+SWKq4HBBaIOM2Df6pLkDKE5Eq3wAqtY5h/Amklk
   Q8wk10FyDxBTBCaN4C658ePnmiaIShmXQ1oo59dpvGkdGkBHl7/u+qKDAHkUQnuCRjdgOBSIJWMg
   TfmKPNB2/vvM8HEPAPuStyg5tK2C+PgNvRu71Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hHCajSxkVzearIJZMcRuHeNSrSvpjl2scDl83YxuUVc=;
 b=PBiVabwgLJztKhjQMF8Zb6IcXQtYdu7tYuRp4YQYdlcRIu/rZr+fVCukNVWItjSPA18SwHz8pgAO
   Crc/i1fN81BHmRz/Gz8gp9RIvJq7HqJBPSMOigCzO/oTnWf2fTAeU+5qCawOlgrUp7G1umh9xXft
   xya0VmRNfeXy+kJCW8SOPQUUMaGvejyEDipGrgcuBVtY9zI8D/BjiRhoLNy85aSbvRqd6HTWqcp7
   K0c8RGRoY2mewc9UTyKAUXu8njKM7b0XvhfHwxNNsUywNEej8fe+45IGscoNYMr2Hah1WEDS+lqt
   G4olhuvc9DVN6Z9SPxWfEhr3haa91Xfp4iB5vA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ800HYEUFRJJ20@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 17 Feb 2023 21:31:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=p/r/IgDm87Tg50qN8UcTg7CPY96iXbCv375Crz/M9t8=;
 b=hwsp6o0/xjemUyCbC8CTAJ7kd1mJfGycAfAEPeECkMijMai4WQNGrsyibonjkY+Re3JM
 lsaA8h2iummAqJOlzs4ESOPgy2VyHwqZBq2D1yFptWO/KErFEAexndt+tfFpLBVoB23F
 cQ2S2Wx/D9i9rfPlwt1SCer+mNf2cakL3lSz9/teqduzNAZWqL1p6a3a10P3ruE2P28c
 XNHr1V2bQUAy56K50OHTYndlDz6odQqYgrkRn7c1Yz0bwwUndfhrE62qIpGkabphWQOo
 l/KBDN1cCLyZJjNczAFz6rtYcAXcytShLc+rMx3AKHeUOgdZOV5o3ZYfcu/6arkMDIBe WA==
Message-id: <aaeee7490cfee1b2163a3c9c894294aaf13e100c.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Fri, 17 Feb 2023 16:30:15 -0500
In-reply-to: <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_14,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302170185
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10624
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=231 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 clxscore=137 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170188
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
X-Proofpoint-ORIG-GUID: DB38xGlZx1PLA6YYK1kXPMLm2b2U-rHI
X-Proofpoint-GUID: DB38xGlZx1PLA6YYK1kXPMLm2b2U-rHI
Reporting-Meta:
 AAEgkjA3uU25hATcvjhQ2d1C7riDPcuJH77sQcuT7Sx0WrezBkQm3/JQ4MnPXrYD
 JwJ8iw5Qy4kpC6kqmixLp8X4LCpio/7P9aIlLb0roX8xvItw34GxRD9qxTAauueD
 2WaB1t2npKiE2gZmhBkreLwz8FDeeHQ27NbzePjEx5s4ETD5UzR5jb5YOWkqr0u0
 0nHncU0Q2zeEvh8lET9xzd3rfMGeSuueRQwWVEZ2aEfQaYPo17SOr7esh/b/gYmX
 5woDOvqbqI5cxiY65FirThLZseQ4lqvRitHpnqNPWFHneNDbt93EPjA8mWJ/w0JI
 OAbgyBS/G51d5G30kHA21a9m8nZ46jN3xO+rYNKQ5gk5L4NpAMBAdQWLy1vtrX/c
 +BkSQJ+SgzsB+VacIG15SnfXYp8fmp1Cnf2loTChbAFt2QMZCnEvhLAPhz4ZWKbV
 SLrNlA/mUE1cAesmEvUT6jZZ4WFLYS92A99fMPh0JsOiOMQIg4FWxRjEDR4m3GTe
 H+UQPJq+mVlm+3aP/0sUlUKhHY2oV84Exx7Ygp7wSqMF

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
> 
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

Correction, previously when returning -EOPNOTSUPP for private inodes,
xattrs would not be wrriten.  By returning 0 without setting si->enable 
to 0, xattrs will be written.
 
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
> 

-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
