Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB99C4321E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 29 Nov 2022 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=I90FamLzXcmqlupAyMQ5qx7xyody83TvV9zJqP3y2M0=;
 b=LnRXlp9HS+COsDodKwnkZ7g0N6O+Q7QZxuVUqz9HxVBVMOWKLo1ekaOflqk2K4Ect/wo4BBZywJX
   TuyQmnWLPA0jnaWMUV8UW4dUs3E8rDmIDX3H4FICRhSfkDK8xc/b1bDnOar6jp9e0uktyfhhS67U
   04YZwLKFHWnTytcXj9gB6W8QhZtuI4dnwrSVz5aLPAiSK+tyrQLbVieCT5zvNrmZYpyoWIXwLQRk
   KwNFjXUOvR+FcrpKagWzQonwKTM0hjz7Eyj9yNgYsMVkP8DKHO+tjG2ykeboMYCZ3YnNc6X7b7rd
   p+PbvFvinCt3sBDY7E2xu49p5tcZRh43oLzXlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=I90FamLzXcmqlupAyMQ5qx7xyody83TvV9zJqP3y2M0=;
 b=TAz9t/blF4hCwOKakJpAKF7iyAluWf9yIK6EE7XC84EfmQ3P2/HZrbiYaz8ba7mXvXwRjcpw+JBz
   MczTT2WhOb86NDP4aD8Us68ExVu8ns3zp3aQnoDuqBxy7kWhfBKS55GF36/uPCsRHN0B8p129Xy4
   dl70F6534/XFbRAzFJRNfNoJthENEISv5hcUHpMu18dCrz3nc0lVxxDl2axhr8WsQdRhs5aHTjWP
   hMDV7mXdHTuy/yCyYHf3DekxyAwS9JIPU8kGDa8lmAdLsWESlBmJOVuvcZuzJSUVmFpiK46BarrP
   XCKkW4NO0heqlpBcys6N58n1flwwEU2vMprlZA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM400O5U267CT20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 29 Nov 2022 13:15:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=y/kKapuMNDnSVXnnqDIkkqYme+g/37hqRusGVTeU+po=;
 b=FsyPM2c/w0ag8TufqpFvr7Qwa9h+oC8pufbt5LYRrEknaHXlSVnEyhXAC1C5PoU7WrZO
 PCO3tCJ+5pK/cZ1h6QI99DOyNXTuKQLPaSrKaSaQpPfgIoVQplUcm12A8HYDR5K0X5ru
 49uWnW3vWzc+MK3R3xIUGj8aX5FC/UxG3WGOFrNj/Sidrakbs1vfiweazquSZUsEwN5y
 OlK6Yq7YNyWPW94Xu6E6aG6heLpTQl9FLoNrPzHdvpA2XgwQBkfCfa2dNxkmk2jq7Bqs
 xIiEjGd30NxPu+8lOrBqjmGOgcAb2z2WcspX/LkfjGyXYszwE8oS1pi7al7FKwtVupCB vA==
Message-id: <8ca5be2f5ac0f5690a9025e5eec9fc93e8613842.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org,
 Casey Schaufler <casey@schaufler-ca.com>
Date: Tue, 29 Nov 2022 08:14:49 -0500
In-reply-to: <44de9254c7abf1c836142cf3262450de1912bbc0.camel@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
 <20221123095202.599252-3-roberto.sassu@huaweicloud.com>
 <052d91687e813110cc1e1d762ea086cc8085114a.camel@linux.ibm.com>
 <44de9254c7abf1c836142cf3262450de1912bbc0.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211290076
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10546
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 clxscore=-2 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290075 domainage_hfrom=13404
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
X-ServerName: mx0a-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: alYjw2QwNVtcMAyqRPhR5k4beYCfFywV
X-Proofpoint-GUID: alYjw2QwNVtcMAyqRPhR5k4beYCfFywV
Reporting-Meta:
 AAHO5oYhSVS0ffYgSfWr1k9Z860TcwvFUDOf83umEVYMRq/rcI8igy5+0+sVw1Tg
 qhse6DQFxfIdzju6/67puIj8JUjK0rIOQg224D4A/Y5RdVz2uGhhGKv6ss1rSxS9
 SitCRLSpcWclxzPsWiQZBmJ/gO9Yb5+IcfBgLrk+dNNCLfm+a7yT3+5eBkisrXcg
 RwwwwWvqoNBG9+BI6rOuJL85AJNdzIu7qVlI4E+DDu1MBTqwP0Gmx4Xei+euCH/V
 KyGujkvLpPa2AeiqhxaGh51k96E35m9B/5JPJYChO9JdQWPKJAipcwTLpkUyqvi8
 cK6YHUbUVfvmWji5j1P8ac+pJKo/UZRqmv4CpiR8g2GB+34au+dW9r3/iuX57JCz
 3TU66ZRYuteki2ubMVN8WAUZM9WyJeO4ZqxQYdoKwr5yKypx0yPQLZa9RfHuRahX
 TIRYCP/5C0R8poGDzyflqaEcL2dqtYSzKtKKFZ05NbOKl9UHleE8JTjfCkwi82oy
 UrEn8tKaglCbZTL9OwuUI4HiN25gGBX1+fcDpnB/Qvg=

On Thu, 2022-11-24 at 09:11 +0100, Roberto Sassu wrote:
> On Wed, 2022-11-23 at 12:46 -0500, Mimi Zohar wrote:
> > On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > 
> > > In preparation for removing security_old_inode_init_security(), switch to
> > > security_inode_init_security().
> > > 
> > > Extend the existing ocfs2_initxattrs() to take the
> > > ocfs2_security_xattr_info structure from fs_info, and populate the
> > > name/value/len triple with the first xattr provided by LSMs. Supporting
> > > multiple xattrs is not currently supported, as it requires non-trivial
> > > changes that can be done at a later time.
> > 
> > ocfs2 already defines ocfs2_init_security_get() as a wrapper around
> > calling either security_old_inode_init_security() or
> > security_inode_init_security().  Based on "si" one or the other hook is
> > called.  ocfs2_initxattrs is already defined.
> > 
> >         struct ocfs2_security_xattr_info si = {
> >                 .name = NULL,
> >                 .enable = 1,
> >         };
> > 
> > The main difference between calling security_old_inode_init_security or
> > security_inode_init_security() is whether or not security.evm is
> > calculated and written.
> 
> Uhm, it seems unfortunately more complicated.
> 
> Calling security_old_inode_init_security() allows filesystems to get
> the xattr, do some calculations (e.g. for reservation) and then write
> the xattr.
> 
> The initxattrs() callback to be passed to
> security_inode_init_security() is meant to let filesystems provide a
> filesystem-specific way of writing the xattrs, just after LSMs provided
> them. This seems incompatible with the old behavior, as a filesystem
> might need to do the calculations in the middle before writing the
> xattrs.
> 
> The initxattrs() callback, when security_old_inode_init_security() was
> used, is just a way of emulating the old behavior, i.e. returning the
> xattr to the caller.
> 
> It should be possible, I guess, to handle more xattrs but if the code
> was designed to handle one, it would be better if the filesystem
> maintainers add support for it.

Hi Mark, Joel, Joseph,

Commit 9d8f13ba3f48 ("security: new security_inode_init_security API
adds function callback") introduced security_old_inode_init_security()
to support reiserfs and ocfs2 a long time ago.  It was suppose to be a
temporary fix until they moved to the new
security_inode_init_security() hook.  ocsf2 partially migrated to
security_inode_init_security(), but not completely.

security_old_inode_init_security() is finally going away.  Instead of
migrating the remaining old usage to the new
security_inode_init_security() properly, this patch simulates the
existing usage.

Can we get some Reviewed-by, Tested-by tags or comments?

thanks,

Mimi

> 
> > Perhaps it is time to remove the call to
> > security_old_inode_init_security() in ocfs2_init_security_get().  We
> > need to hear back from the ocfs2 community.  Mark?  Joel?
> > 
> > As noted previously this change affects mknod and symlinks.
> > 
> > 
> > > As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> > > of replicating the behavior of security_old_inode_init_security(), i.e.
> > > just obtaining the xattr, in addition to setting all xattrs provided by
> > > LSMs.
> > > 
> > > Finally, modify the handling of the return value from
> > > ocfs2_init_security_get(). As security_inode_init_security() does not
> > > return -EOPNOTSUPP, remove this case and directly handle the error if the
> > > return value is not zero.
> > > 
> > > However, the previous case of receiving -EOPNOTSUPP should be still
> > > taken into account, as security_inode_init_security() could return zero
> > > without setting xattrs and ocfs2 would consider it as if the xattr was set.
> > > 
> > > Instead, if security_inode_init_security() returned zero, look at the xattr
> > > if it was set, and behave accordingly, i.e. set si->enable to zero to
> > > notify to the functions following ocfs2_init_security_get() that the xattr
> > > is not available (same as if security_old_inode_init_security() returned
> > > -EOPNOTSUPP).
> > > 
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---
> > >  fs/ocfs2/namei.c | 18 ++++++------------
> > >  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
> > >  2 files changed, 32 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > > index 05f32989bad6..55fba81cd2d1 100644
> > > --- a/fs/ocfs2/namei.c
> > > +++ b/fs/ocfs2/namei.c
> > > @@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
> > >  	int want_meta = 0;
> > >  	int xattr_credits = 0;
> > >  	struct ocfs2_security_xattr_info si = {
> > > +		.name = NULL,
> > >  		.enable = 1,
> > >  	};
> > >  	int did_quota_inode = 0;
> > > @@ -315,12 +316,8 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
> > >  	/* get security xattr */
> > >  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
> > >  	if (status) {
> > > -		if (status == -EOPNOTSUPP)
> > > -			si.enable = 0;
> > > -		else {
> > > -			mlog_errno(status);
> > > -			goto leave;
> > > -		}
> > > +		mlog_errno(status);
> > > +		goto leave;
> > >  	}
> > >  
> > >  	/* calculate meta data/clusters for setting security and acl xattr */
> > > @@ -1805,6 +1802,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
> > >  	int want_clusters = 0;
> > >  	int xattr_credits = 0;
> > >  	struct ocfs2_security_xattr_info si = {
> > > +		.name = NULL,
> > >  		.enable = 1,
> > >  	};
> > >  	int did_quota = 0, did_quota_inode = 0;
> > > @@ -1875,12 +1873,8 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
> > >  	/* get security xattr */
> > >  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
> > >  	if (status) {
> > > -		if (status == -EOPNOTSUPP)
> > > -			si.enable = 0;
> > > -		else {
> > > -			mlog_errno(status);
> > > -			goto bail;
> > > -		}
> > > +		mlog_errno(status);
> > > +		goto bail;
> > >  	}
> > >  
> > >  	/* calculate meta data/clusters for setting security xattr */
> > > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > > index 95d0611c5fc7..55699c573541 100644
> > > --- a/fs/ocfs2/xattr.c
> > > +++ b/fs/ocfs2/xattr.c
> > > @@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
> > >  static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> > >  		     void *fs_info)
> > >  {
> > > +	struct ocfs2_security_xattr_info *si = fs_info;
> > >  	const struct xattr *xattr;
> > >  	int err = 0;
> > >  
> > > +	if (si) {
> > > +		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
> > > +				    GFP_KERNEL);
> > > +		if (!si->value)
> > > +			return -ENOMEM;
> > > +
> > > +		si->name = xattr_array->name;
> > > +		si->value_len = xattr_array->value_len;
> > > +		return 0;
> > > +	}
> > > +
> > >  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> > >  		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
> > >  				      xattr->name, xattr->value,
> > > @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
> > >  			    const struct qstr *qstr,
> > >  			    struct ocfs2_security_xattr_info *si)
> > >  {
> > > +	int ret;
> > > +
> > >  	/* check whether ocfs2 support feature xattr */
> > >  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
> > >  		return -EOPNOTSUPP;
> > > -	if (si)
> > > -		return security_old_inode_init_security(inode, dir, qstr,
> > > -							&si->name, &si->value,
> > > -							&si->value_len);
> > > +	if (si) {
> > > +		ret = security_inode_init_security(inode, dir, qstr,
> > > +						   &ocfs2_initxattrs, si);
> > > +		/*
> > > +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> > > +		 * we have to check the xattr ourselves.
> > > +		 */
> > > +		if (!ret && !si->name)
> > > +			si->enable = 0;
> > > +
> > > +		return ret;
> > > +	}
> > >  
> > >  	return security_inode_init_security(inode, dir, qstr,
> > >  					    &ocfs2_initxattrs, NULL);
> 



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
