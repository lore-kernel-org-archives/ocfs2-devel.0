Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F70C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Dec 2022 08:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i8R57iZzzpYre/3Xslk5cA7KQI8bpJOfx59PI84Wub0=;
 b=M3cVkpl/EOEFmAW5I4r12LpAyCvvNUFxQ6oVfWKFAtqbII9Q3IakBrne0YivgYzLKexvsO88jSnz
   tJdAecrbg2vEOe+KLWJfQVQdTSqFrrSp4SYZz5AyzhdqaYBqwkMpdGTCnanP+RAZX6M6m57/7LCr
   oL7GYWYqJ9OUnxu8wAmRcPIURncZPuhJTN5Pdn8qd1QLlS+E/q2jwFJyoQpO9aCUFhBS+yfEkOAB
   JqALBAFjONNkpS3wBJtifWkC7Xfu/Q2YmErQUu1JrIJ6EKi6Yn78GKb/s/vagMWIhbc60sk5HStf
   dEjQeLHCD5ccu9lR4fk89rQCEBYEYafS+Ylalg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i8R57iZzzpYre/3Xslk5cA7KQI8bpJOfx59PI84Wub0=;
 b=MahzJ0z/po7Mg/UmfOgyW/tOJg0br94hOAtHTGQTb3w9jT7t3A2gbweKtEj56R7AXzuchWV8QnOX
   7lPHIAyw7dDVVxWTcJgpJNtUYfttIjLLw+2Tehtgs3bHA2/LD2TJEx9VKIzSDoEA4LK9JDFXtiCF
   8FfsZEQfIm83wvjQKgUZVhrrEZ8CAv3oS9PjINNTt/ZUKIKwnvYWP9r52hAoTFVy9Z49OPwS6J4K
   4ZdR8/qZFl67MRzOFsKDZtlql9xrzCR9vwHBqHDbOs6WlLUQx4CjiW9ZkB977+vO3UGYkUaql0fL
   Duusm/Bdn5b0MsDubCOlKyutQx35QJhRZ4X4hQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221201 64bit (built Dec  1
 2022))
 with ESMTPS id <0RMT00BUIL7GB0C0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 13 Dec 2022 08:06:52 +0000 (GMT)
Message-id: <bf05aa8c3161a799fae84a4acfc46dc54499b271.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, Casey Schaufler <casey@schaufler-ca.com>
Date: Tue, 13 Dec 2022 09:05:55 +0100
In-reply-to: <8ca5be2f5ac0f5690a9025e5eec9fc93e8613842.camel@linux.ibm.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
 <20221123095202.599252-3-roberto.sassu@huaweicloud.com>
 <052d91687e813110cc1e1d762ea086cc8085114a.camel@linux.ibm.com>
 <44de9254c7abf1c836142cf3262450de1912bbc0.camel@huaweicloud.com>
 <8ca5be2f5ac0f5690a9025e5eec9fc93e8613842.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10559
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=-44
 adultscore=0 impostorscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130074
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: LxC2BwBnog1oMphjjUcMAA--.22467S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww4xZF1UAr1rurWrtw1UWrg_yoW3ur48pF
 W8KF1jkr4rJFyUWrWSqanI9an29rWrGrZrXrs3G347ZF1qkrn7tr10yr15ua4rJrW8JF10
 qw4UArsxuwn8A37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAFBF1jj4KTJgAAsF
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: nmD-_p5npEENFKySzFDSxe1wHNtGVhqd
X-Proofpoint-GUID: nmD-_p5npEENFKySzFDSxe1wHNtGVhqd
Reporting-Meta:
 AAHHoI9dHjj+NWOcFWO9pbYe/COKHfAWLJQSptN2w7xij0UY9Sd5KAfhAuKL2afB
 9os8JnJolYwfCkJr2CjjN7V6SKGTEdEO4BGZNyYuEUM1GYjo26/tfMq+q5Bw0RCA
 xzL1YbG2cGV+2vNGCIHRN4uqQJCShWBKBrKg7f1P/KDhhdiXEkV2yEJywKGJvhjb
 MpqkcMTgamtPWKB2wyuS0bSvMqSqejPhqY9WQSBuVeAhnj4vI+D2J7z6gGf6dtqm
 HoZeEqHtSdYZoWiw6SWqzZNkcgWh1+ExGDavDRFa19cr7I7t88t4uV4MsiXlXUtN
 km9uDFsLZPzgob33HqmFVQsv9RhM+QI+vkzn+9d2J1RX4ogbiK9Z+Tx6FxKlS0yc
 6s+NUL7QxYyuHRJglNUvuNPwSAmGpS+rFg1gppbbwCODfHo0gO8IMKkkH702M8td
 IkrZu6bep0txRD05gkEYzFVSe8tBeCF+hf87uEnEjAKajHVB7PAHQ/PWAKGDELD/
 BlnA0o38KB3TVHYWF8QhWGvhY74EnfXLscPXGG6Jfd7d

On Tue, 2022-11-29 at 08:14 -0500, Mimi Zohar wrote:
> On Thu, 2022-11-24 at 09:11 +0100, Roberto Sassu wrote:
> > On Wed, 2022-11-23 at 12:46 -0500, Mimi Zohar wrote:
> > > On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > 
> > > > In preparation for removing security_old_inode_init_security(), switch to
> > > > security_inode_init_security().
> > > > 
> > > > Extend the existing ocfs2_initxattrs() to take the
> > > > ocfs2_security_xattr_info structure from fs_info, and populate the
> > > > name/value/len triple with the first xattr provided by LSMs. Supporting
> > > > multiple xattrs is not currently supported, as it requires non-trivial
> > > > changes that can be done at a later time.
> > > 
> > > ocfs2 already defines ocfs2_init_security_get() as a wrapper around
> > > calling either security_old_inode_init_security() or
> > > security_inode_init_security().  Based on "si" one or the other hook is
> > > called.  ocfs2_initxattrs is already defined.
> > > 
> > >         struct ocfs2_security_xattr_info si = {
> > >                 .name = NULL,
> > >                 .enable = 1,
> > >         };
> > > 
> > > The main difference between calling security_old_inode_init_security or
> > > security_inode_init_security() is whether or not security.evm is
> > > calculated and written.
> > 
> > Uhm, it seems unfortunately more complicated.
> > 
> > Calling security_old_inode_init_security() allows filesystems to get
> > the xattr, do some calculations (e.g. for reservation) and then write
> > the xattr.
> > 
> > The initxattrs() callback to be passed to
> > security_inode_init_security() is meant to let filesystems provide a
> > filesystem-specific way of writing the xattrs, just after LSMs provided
> > them. This seems incompatible with the old behavior, as a filesystem
> > might need to do the calculations in the middle before writing the
> > xattrs.
> > 
> > The initxattrs() callback, when security_old_inode_init_security() was
> > used, is just a way of emulating the old behavior, i.e. returning the
> > xattr to the caller.
> > 
> > It should be possible, I guess, to handle more xattrs but if the code
> > was designed to handle one, it would be better if the filesystem
> > maintainers add support for it.
> 
> Hi Mark, Joel, Joseph,
> 
> Commit 9d8f13ba3f48 ("security: new security_inode_init_security API
> adds function callback") introduced security_old_inode_init_security()
> to support reiserfs and ocfs2 a long time ago.  It was suppose to be a
> temporary fix until they moved to the new
> security_inode_init_security() hook.  ocsf2 partially migrated to
> security_inode_init_security(), but not completely.
> 
> security_old_inode_init_security() is finally going away.  Instead of
> migrating the remaining old usage to the new
> security_inode_init_security() properly, this patch simulates the
> existing usage.
> 
> Can we get some Reviewed-by, Tested-by tags or comments?

Ping.

Thanks

Roberto

> thanks,
> 
> Mimi
> 
> > > Perhaps it is time to remove the call to
> > > security_old_inode_init_security() in ocfs2_init_security_get().  We
> > > need to hear back from the ocfs2 community.  Mark?  Joel?
> > > 
> > > As noted previously this change affects mknod and symlinks.
> > > 
> > > 
> > > > As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> > > > of replicating the behavior of security_old_inode_init_security(), i.e.
> > > > just obtaining the xattr, in addition to setting all xattrs provided by
> > > > LSMs.
> > > > 
> > > > Finally, modify the handling of the return value from
> > > > ocfs2_init_security_get(). As security_inode_init_security() does not
> > > > return -EOPNOTSUPP, remove this case and directly handle the error if the
> > > > return value is not zero.
> > > > 
> > > > However, the previous case of receiving -EOPNOTSUPP should be still
> > > > taken into account, as security_inode_init_security() could return zero
> > > > without setting xattrs and ocfs2 would consider it as if the xattr was set.
> > > > 
> > > > Instead, if security_inode_init_security() returned zero, look at the xattr
> > > > if it was set, and behave accordingly, i.e. set si->enable to zero to
> > > > notify to the functions following ocfs2_init_security_get() that the xattr
> > > > is not available (same as if security_old_inode_init_security() returned
> > > > -EOPNOTSUPP).
> > > > 
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > ---
> > > >  fs/ocfs2/namei.c | 18 ++++++------------
> > > >  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
> > > >  2 files changed, 32 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > > > index 05f32989bad6..55fba81cd2d1 100644
> > > > --- a/fs/ocfs2/namei.c
> > > > +++ b/fs/ocfs2/namei.c
> > > > @@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
> > > >  	int want_meta = 0;
> > > >  	int xattr_credits = 0;
> > > >  	struct ocfs2_security_xattr_info si = {
> > > > +		.name = NULL,
> > > >  		.enable = 1,
> > > >  	};
> > > >  	int did_quota_inode = 0;
> > > > @@ -315,12 +316,8 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
> > > >  	/* get security xattr */
> > > >  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
> > > >  	if (status) {
> > > > -		if (status == -EOPNOTSUPP)
> > > > -			si.enable = 0;
> > > > -		else {
> > > > -			mlog_errno(status);
> > > > -			goto leave;
> > > > -		}
> > > > +		mlog_errno(status);
> > > > +		goto leave;
> > > >  	}
> > > >  
> > > >  	/* calculate meta data/clusters for setting security and acl xattr */
> > > > @@ -1805,6 +1802,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
> > > >  	int want_clusters = 0;
> > > >  	int xattr_credits = 0;
> > > >  	struct ocfs2_security_xattr_info si = {
> > > > +		.name = NULL,
> > > >  		.enable = 1,
> > > >  	};
> > > >  	int did_quota = 0, did_quota_inode = 0;
> > > > @@ -1875,12 +1873,8 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
> > > >  	/* get security xattr */
> > > >  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
> > > >  	if (status) {
> > > > -		if (status == -EOPNOTSUPP)
> > > > -			si.enable = 0;
> > > > -		else {
> > > > -			mlog_errno(status);
> > > > -			goto bail;
> > > > -		}
> > > > +		mlog_errno(status);
> > > > +		goto bail;
> > > >  	}
> > > >  
> > > >  	/* calculate meta data/clusters for setting security xattr */
> > > > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > > > index 95d0611c5fc7..55699c573541 100644
> > > > --- a/fs/ocfs2/xattr.c
> > > > +++ b/fs/ocfs2/xattr.c
> > > > @@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
> > > >  static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> > > >  		     void *fs_info)
> > > >  {
> > > > +	struct ocfs2_security_xattr_info *si = fs_info;
> > > >  	const struct xattr *xattr;
> > > >  	int err = 0;
> > > >  
> > > > +	if (si) {
> > > > +		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
> > > > +				    GFP_KERNEL);
> > > > +		if (!si->value)
> > > > +			return -ENOMEM;
> > > > +
> > > > +		si->name = xattr_array->name;
> > > > +		si->value_len = xattr_array->value_len;
> > > > +		return 0;
> > > > +	}
> > > > +
> > > >  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> > > >  		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
> > > >  				      xattr->name, xattr->value,
> > > > @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
> > > >  			    const struct qstr *qstr,
> > > >  			    struct ocfs2_security_xattr_info *si)
> > > >  {
> > > > +	int ret;
> > > > +
> > > >  	/* check whether ocfs2 support feature xattr */
> > > >  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
> > > >  		return -EOPNOTSUPP;
> > > > -	if (si)
> > > > -		return security_old_inode_init_security(inode, dir, qstr,
> > > > -							&si->name, &si->value,
> > > > -							&si->value_len);
> > > > +	if (si) {
> > > > +		ret = security_inode_init_security(inode, dir, qstr,
> > > > +						   &ocfs2_initxattrs, si);
> > > > +		/*
> > > > +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> > > > +		 * we have to check the xattr ourselves.
> > > > +		 */
> > > > +		if (!ret && !si->name)
> > > > +			si->enable = 0;
> > > > +
> > > > +		return ret;
> > > > +	}
> > > >  
> > > >  	return security_inode_init_security(inode, dir, qstr,
> > > >  					    &ocfs2_initxattrs, NULL);


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
