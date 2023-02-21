Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5217BC61DA3
	for <ocfs2-devel@archiver.kernel.org>; Tue, 21 Feb 2023 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vGGIKWPoO4C2azeiX+QdD2R8FBlCM5hrHx2X+6q3G9Q=;
 b=fvGutqDD2tnrCaeqeuxkVF07zRJ2huNjZhWT3Ck8R+e4eoZIIXdBozkPAOhPH6CyGGDLaJ0wsK4X
   sSGI2bjKEXNG2iXZdW+skFlJuc47eN01MEe7QwM1ALVCj/ZX0GB30amEFfSceJawZLYKXdkuQdVv
   aYigqIQU0+vIwe041cug9s/T2bABxg2B6N6KEJl2OfzhkkMedWtURszuKsbAip9npEx1yHdkZvN/
   bHZ/5VzhhuMZAcwS9ycB4affgQKvY0G7GVQ0vFN0i8lWhZH2p8NFW0k5UjjbFONq1SiODj5GZobV
   8TAd8Io8BKXKXybmJOHZFL9t3mfiThINeDSQ0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vGGIKWPoO4C2azeiX+QdD2R8FBlCM5hrHx2X+6q3G9Q=;
 b=snKJQ4VEf6tGrP/kBZHGaz0rmHh/s8PJJMndY38R9Y45QlRYb5NNbpaFS5VGDQx9+vwH26ggKLdz
   wsGBUcd89xavzSwWUyp53mWwoHhQESUzb7TxIF3Io2gn8dA7HlY8M8nBerT8VOQfRPEIrL8YfNXi
   au709Qf5NhJN7j4futThp/8tqGjGddJ0yaKRK0de01c3u3fmFW8/XrracTPaz5pY2JQk6kpoEcqc
   pjfwVQ1Od3AnK4u6+C2h03HsQhRUwVSNDlbyuYgrdIG9xH9EVgBNuc3mwkDP1jxPauBjGDi0L8UX
   YcLgYoqraGW3i80Lx01hvxSBe5DfBaNkv+tIaQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQG004AZ30VFI50@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 21 Feb 2023 19:19:43 +0000 (GMT)
Message-id: <76f8e98bd89d19545ff84ebcac4c41853455d22b.camel@huaweicloud.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
 jlbec@evilplan.org, zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 21 Feb 2023 08:51:56 +0100
In-reply-to: <d5180ef2-70dc-0a43-3e1b-c04d9e14ab23@linux.alibaba.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
 <d5180ef2-70dc-0a43-3e1b-c04d9e14ab23@linux.alibaba.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10627
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 clxscore=184 bulkscore=0 suspectscore=0 priorityscore=48 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210067
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
X-CM-TRANSID: GxC2BwD3wlkhePRj0Cc7AQ--.55243S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKry7Aw1kCFW3ury5ZF1fJFb_yoWxAw4UpF
 WrtF1akF4rJFyUuryaq3WY9a1I9rWfGrZrGrs3J347ZF1q9r1ftry8Ar15ua45ZrW8JFy8
 tr4UCFsxu3Z8Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAPBF1jj4WkAQADsb
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: F_zsOUKy6h-3ZxB6KK320xJczRPlgYI6
X-Proofpoint-GUID: F_zsOUKy6h-3ZxB6KK320xJczRPlgYI6
Reporting-Meta:
 AAE1kYWeAikcpRPYFbVFZlzaAonIzJ/welqP/Xj/DuN1sqcxzBVgR73BtqnB8CE/
 9hnXNxZQd0X7FpfXEznLVvUHUSR5FL2wEAhEBa1oH0TKNuz/3/zh8x41WXk38Mcc
 r4eWMzIXwFjkaz4AV6Pv/hbwZc5p28LPp1AOJ4EVKPwvuohereMK4HIFB9/yfu6W
 SvklX6/LwJQTw6dn1aDC72/1v9IHSO8zWcBUTVEpbp4BFD8/UP8zb6gchIP0nG+r
 3p5N1mxORu7UlrjT6g82pcPnFyEEp8tB02/AEg71EeNm3ySXrgOTrI/hkOLlv72t
 1wdSbRaBIz2r7woKwKvWHN6XxnFIuGy5TPTskDNPC+2ub/pU7y8ARURlIhNAMv7N
 Spkl3P89gKYPD122Kl0jjBg8VUaFwm1MhtSODwFO87ESknd/ao4bmIVbHQqV+d/J
 9J86VaWLzWWm2SYVwZg45Trx7NxgF4SiwxR8pMJAcSSh80M4UealHzKFNlOrTYBR
 7U7bLHjigFX927yOk1b3r1H+3w2UbciHygV/NXTLaes=

On Tue, 2023-02-21 at 14:45 +0800, Joseph Qi wrote:
> Hi,
> 
> Sorry for the late reply.
> 
> I don't have much background on this thread. It seems that we have to
> check EOPNOTSUPP since ocfs2_init_security_get() may return EOPNOTSUPP
> if it doesn't support extended attribute feature for backward
> compatibility.

Hi Joseph

yes, I already reintroduced the check. Thanks for having a look.

Roberto

> Other looks good. So with above comments addressed, you can add:
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> On 1/10/23 4:55 PM, Roberto Sassu wrote:
> > On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > 
> > > In preparation for removing security_old_inode_init_security(), switch to
> > > security_inode_init_security().
> > > 
> > > Extend the existing ocfs2_initxattrs() to take the
> > > ocfs2_security_xattr_info structure from fs_info, and populate the
> > > name/value/len triple with the first xattr provided by LSMs.
> > 
> > Hi Mark, Joel, Joseph
> > 
> > some time ago I sent this patch set to switch to the newer
> > function security_inode_init_security(). Almost all the other parts of
> > this patch set have been reviewed, and the patch set itself should be
> > ready to be merged.
> > 
> > I kindly ask if you could have a look at this patch and give your
> > Reviewed-by, so that Paul could take the patch set.
> > 
> > Thanks a lot!
> > 
> > Roberto
> > 
> > > As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> > > of replicating the behavior of security_old_inode_init_security(), i.e.
> > > just obtaining the xattr, in addition to setting all xattrs provided by
> > > LSMs.
> > > 
> > > Supporting multiple xattrs is not currently supported where
> > > security_old_inode_init_security() was called (mknod, symlink), as it
> > > requires non-trivial changes that can be done at a later time. Like for
> > > reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
> > > not the first to set it, its xattr will be discarded; if it is the first,
> > > it does not have xattrs to calculate the HMAC on).
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
> > > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
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


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
