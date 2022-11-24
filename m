Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118F4C433FE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 24 Nov 2022 07:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8nC+3zQlXX7lfJLGnKvxkxsj/63bLIlMiGrIDf4zqwQ=;
 b=v4a0FIlR1cm4ULFIcpJCCUDt5+3ry4k+A+dJyYIYMLuOll96W5+9smI9x33ApvFqJqRRmN4kWPYw
   LKJfYsMBOiSoooPj4BxzqRmpKzIwyqa3vHG1254jDimYr8BGsh0z2qmBbWwMFqTfEkfVLyntGPSt
   EHfJCAX+EiI4OXMA0ac6vUWe19s2NgjFJ6XxWwiJuUtvavMluCSbyL+5qsMkiR4dHtPpKG4w8HlH
   f3s8xtYxldZ1CI/QCBZjSYDS67uSKPauphcfEguA9ignUXrv4MgLdKgKCAe1+bBxO9rYLWnxMD5L
   nC9EYQN0K1cg9kq73iAlMnK4VCGrkj97Xua+zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8nC+3zQlXX7lfJLGnKvxkxsj/63bLIlMiGrIDf4zqwQ=;
 b=hsEjaZyy7YnPu4uOeQpJE9vg9ydlJcM8+JeeDuwAwmgh2eMQ69MCi6pl1VS3W5lh7KO1vJvdcmSq
   1FD5xa7gr4nCjmQrrqpRxjhh10GttiDL8qRjQMhyJ9hOWohE2kpAXxyxLV6C/KVcvRzgBbk75eae
   wzRjuV2gTHJQlHfjMYt89AXEtDqoSfZZoHMxLEkxmzj/3BCbgWIzxVXEJGl3d92UrSRjpxYxkVg8
   epVr/XUePV3eQSRyMU5PzqJrpRlgMX9TvziiubYyfx84/ZjGMSn3Xd9d3+ex5CNc06K3ECYqhGae
   Sceg8HEBF+ztxk3QMw3Y4IzR4Vgeo03JFlA0CQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLU00KMEE34WM80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 24 Nov 2022 07:57:04 +0000 (GMT)
Message-id: <ccac75636e9c546df19d77f32f422db581cc07a1.camel@huaweicloud.com>
To: Casey Schaufler <casey@schaufler-ca.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, zohar@linux.ibm.com,
 dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, stephen.smalley.work@gmail.com, eparis@parisplace.org
Date: Thu, 24 Nov 2022 08:55:57 +0100
In-reply-to: <7eaacdff-521e-c30f-8ca0-3791a5dc4d45@schaufler-ca.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
 <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
 <7eaacdff-521e-c30f-8ca0-3791a5dc4d45@schaufler-ca.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 suspectscore=0
 priorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=108 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240062
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v6 4/6] security: Allow all LSMs to provide
 xattrs for inode_init_security hook
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
X-CM-TRANSID: GxC2BwDXC_iSI39jkWeNAA--.32310S2
X-Coremail-Antispam: 1UD129KBjvAXoW3uF18Zry5tw43Zw1DtF1kKrg_yoW8WF1rWo
 WfJwnrArW0qr13GrW5u3s7JFZrua95Wr48Ar4Yvr43A3W3ta4UCw13Way8XFZxWFyrKF48
 K34xJ34jvrWqqFn3n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
 AaLaJ3UjIYCTnIWjp_UUUYU7kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
 8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
 AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF
 7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
 7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
 Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
 6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
 AIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAGBF1jj4HQvQAAsd
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 8AmlT5tZ9YshokEFtTILWTvXVBfW6n3U
X-Proofpoint-GUID: 8AmlT5tZ9YshokEFtTILWTvXVBfW6n3U
Reporting-Meta:
 AAGeVcGF2cow/7mHn5ye2fMFYzOaWVjN8x3Afj8I3PbuVUtqJJUvFB7J/2/O1o+k
 pAroDeMQqg7RJOWttwsWGTRij6HZ085NO0Ya64xZCsuT8OAgbJvHBxTBK226DHpq
 YyQ3PckuGeRYedU7tmes30kG70w1uJeC0P/cxG6TGm2oTPBgmvxIO+6jN83Y9lXB
 c+uswPZAQhfXJABU6tIQWQ+r15EX6GvNyNCEI/QIREjlj0KRWraPfYmdwai5wPvk
 B6LrrwOGIvTu2H0fnfFx9mFSJkkLHIy2fh17HeILXExybUrC2mTTfqaNRWO7zG0W
 k7yp435EM1F+NJ+6fQGC8Vfvsnd3zuL2YsovvEM05UTu0WZjo4rcZUYwNQqx0Zse
 1SytEBgQowGnOxL7JE3PC4Ytbm9XPu8Mwr1U9OqiZHX19JmrndKHRRf/Ofn5dvEv
 MlH84qdchmYqeTFZuL7Cph0VWEYeuMt/pEg7uMuX2yCztIuY7b+mKK+QHOoK9Csx
 Hpo4x+1qmzq8TU+WslUCx0AbggprOrJBvTUoZY1YjgW4

On Wed, 2022-11-23 at 09:17 -0800, Casey Schaufler wrote:
> On 11/23/2022 7:47 AM, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Currently, security_inode_init_security() supports only one LSM providing
> > an xattr and EVM calculating the HMAC on that xattr, plus other inode
> > metadata.
> > 
> > Allow all LSMs to provide one or multiple xattrs, by extending the security
> > blob reservation mechanism. Introduce the new lbs_xattr field of the
> > lsm_blob_sizes structure, so that each LSM can specify how many xattrs it
> > needs, and the LSM infrastructure knows how many xattr slots it should
> > allocate.
> > 
> > Dynamically allocate the xattrs array to be populated by LSMs with the
> > inode_init_security hook, and pass it to the latter instead of the
> > name/value/len triple. Update the documentation accordingly, and fix the
> > description of the xattr name, as it is not allocated anymore.
> > 
> > Since the LSM infrastructure, at initialization time, updates the number of
> > the requested xattrs provided by each LSM with a corresponding offset in
> > the security blob (in this case the xattr array), it makes straightforward
> > for an LSM to access the right position in the xattr array.
> > 
> > There is still the issue that an LSM might not fill the xattr, even if it
> > requests it (legitimate case, for example it might have been loaded but not
> > initialized with a policy). Since users of the xattr array (e.g. the
> > initxattrs() callbacks) detect the end of the xattr array by checking if
> > the xattr name is NULL, not filling an xattr would cause those users to
> > stop scanning xattrs prematurely.
> > 
> > Solve that issue by introducing security_check_compact_filled_xattrs(),
> > which does a basic check of the xattr array (if the xattr name is filled,
> > the xattr value should be too, and viceversa), and compacts the xattr array
> > by removing the holes.
> > 
> > An alternative solution would be to let users of the xattr array know the
> > number of elements of that array, so that they don't have to check the
> > termination. However, this seems more invasive, compared to a simple move
> > of few array elements.
> > 
> > security_check_compact_filled_xattrs() also determines how many xattrs in
> > the xattr array have been filled. If there is none, skip
> > evm_inode_init_security() and initxattrs(). Skipping the former also avoids
> > EVM to crash the kernel, as it is expecting a filled xattr.
> > 
> > Finally, adapt both SELinux and Smack to use the new definition of the
> > inode_init_security hook, and to correctly fill the designated slots in the
> > xattr array. For Smack, reserve space for the other defined xattrs although
> > they are not set yet in smack_inode_init_security().
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  include/linux/lsm_hook_defs.h |   3 +-
> >  include/linux/lsm_hooks.h     |  17 ++++--
> >  security/security.c           | 103 +++++++++++++++++++++++++++++-----
> >  security/selinux/hooks.c      |  19 ++++---
> >  security/smack/smack_lsm.c    |  26 +++++----
> >  5 files changed, 127 insertions(+), 41 deletions(-)
> > 
> > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> > index ec119da1d89b..be344d0211f8 100644
> > --- a/include/linux/lsm_hook_defs.h
> > +++ b/include/linux/lsm_hook_defs.h
> > @@ -112,8 +112,7 @@ LSM_HOOK(int, 0, path_notify, const struct path *path, u64 mask,
> >  LSM_HOOK(int, 0, inode_alloc_security, struct inode *inode)
> >  LSM_HOOK(void, LSM_RET_VOID, inode_free_security, struct inode *inode)
> >  LSM_HOOK(int, 0, inode_init_security, struct inode *inode,
> > -	 struct inode *dir, const struct qstr *qstr, const char **name,
> > -	 void **value, size_t *len)
> > +	 struct inode *dir, const struct qstr *qstr, struct xattr *xattrs)
> >  LSM_HOOK(int, 0, inode_init_security_anon, struct inode *inode,
> >  	 const struct qstr *name, const struct inode *context_inode)
> >  LSM_HOOK(int, 0, inode_create, struct inode *dir, struct dentry *dentry,
> > diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> > index 4ec80b96c22e..ba1655370643 100644
> > --- a/include/linux/lsm_hooks.h
> > +++ b/include/linux/lsm_hooks.h
> > @@ -229,18 +229,22 @@
> >   *	This hook is called by the fs code as part of the inode creation
> >   *	transaction and provides for atomic labeling of the inode, unlike
> >   *	the post_create/mkdir/... hooks called by the VFS.  The hook function
> > - *	is expected to allocate the name and value via kmalloc, with the caller
> > - *	being responsible for calling kfree after using them.
> > + *	is expected to allocate the value via kmalloc, with the caller
> > + *	being responsible for calling kfree after using it.
> >   *	If the security module does not use security attributes or does
> >   *	not wish to put a security attribute on this particular inode,
> >   *	then it should return -EOPNOTSUPP to skip this processing.
> >   *	@inode contains the inode structure of the newly created inode.
> >   *	@dir contains the inode structure of the parent directory.
> >   *	@qstr contains the last path component of the new object
> > - *	@name will be set to the allocated name suffix (e.g. selinux).
> > - *	@value will be set to the allocated attribute value.
> > - *	@len will be set to the length of the value.
> > - *	Returns 0 if @name and @value have been successfully set,
> > + *	@xattrs contains the full array of xattrs provided by LSMs where
> > + *	->name will be set to the name suffix (e.g. selinux).
> > + *	->value will be set to the allocated attribute value.
> > + *	->value_len will be set to the length of the value.
> > + *	Slots in @xattrs need to be reserved by LSMs by providing the number of
> > + *	the desired xattrs in the lbs_xattr field of the lsm_blob_sizes
> > + *	structure.
> > + *	Returns 0 if the requested slots in @xattrs have been successfully set,
> >   *	-EOPNOTSUPP if no security attribute is needed, or
> >   *	-ENOMEM on memory allocation failure.
> >   * @inode_init_security_anon:
> > @@ -1624,6 +1628,7 @@ struct lsm_blob_sizes {
> >  	int	lbs_ipc;
> >  	int	lbs_msg_msg;
> >  	int	lbs_task;
> > +	int	lbs_xattr;
> >  };
> >  
> >  /*
> > diff --git a/security/security.c b/security/security.c
> > index e2857446fd32..26aaa5850867 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -30,8 +30,6 @@
> >  #include <linux/msg.h>
> >  #include <net/flow.h>
> >  
> > -#define MAX_LSM_EVM_XATTR	2
> > -
> >  /* How many LSMs were built into the kernel? */
> >  #define LSM_COUNT (__end_lsm_info - __start_lsm_info)
> >  
> > @@ -210,6 +208,7 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
> >  	lsm_set_blob_size(&needed->lbs_msg_msg, &blob_sizes.lbs_msg_msg);
> >  	lsm_set_blob_size(&needed->lbs_superblock, &blob_sizes.lbs_superblock);
> >  	lsm_set_blob_size(&needed->lbs_task, &blob_sizes.lbs_task);
> > +	lsm_set_blob_size(&needed->lbs_xattr, &blob_sizes.lbs_xattr);
> >  }
> >  
> >  /* Prepare LSM for initialization. */
> > @@ -346,6 +345,7 @@ static void __init ordered_lsm_init(void)
> >  	init_debug("msg_msg blob size    = %d\n", blob_sizes.lbs_msg_msg);
> >  	init_debug("superblock blob size = %d\n", blob_sizes.lbs_superblock);
> >  	init_debug("task blob size       = %d\n", blob_sizes.lbs_task);
> > +	init_debug("xattr slots          = %d\n", blob_sizes.lbs_xattr);
> >  
> >  	/*
> >  	 * Create any kmem_caches needed for blobs
> > @@ -1089,37 +1089,110 @@ int security_dentry_create_files_as(struct dentry *dentry, int mode,
> >  }
> >  EXPORT_SYMBOL(security_dentry_create_files_as);
> >  
> > +/**
> > + * security_check_compact_filled_xattrs - check xattrs and make array contiguous
> > + * @xattrs: xattr array filled by LSMs
> > + * @num_xattrs: length of xattr array
> > + * @num_filled_xattrs: number of already processed xattrs
> > + *
> > + * Ensure that each xattr slot is correctly filled and close the gaps in the
> > + * xattr array if an LSM didn't provide an xattr for which it asked space
> > + * (legitimate case, it might have been loaded but not initialized). An LSM
> > + * might request space in the xattr array for one or multiple xattrs. The LSM
> > + * infrastructure ensures that all requests by LSMs are satisfied.
> > + *
> > + * Track the number of filled xattrs in @num_filled_xattrs, so that it is easy
> > + * to determine whether the currently processed xattr is fine in its position
> > + * (if all previous xattrs were filled) or it should be moved after the last
> > + * filled xattr.
> > + *
> > + * Return: zero if all xattrs are valid, -EINVAL otherwise.
> > + */
> > +static int security_check_compact_filled_xattrs(struct xattr *xattrs,
> > +						int num_xattrs,
> > +						int *num_filled_xattrs)
> > +{
> > +	int i;
> > +
> > +	for (i = *num_filled_xattrs; i < num_xattrs; i++) {
> > +		if ((!xattrs[i].name && xattrs[i].value) ||
> > +		    (xattrs[i].name && !xattrs[i].value))
> > +			return -EINVAL;
> > +
> > +		if (!xattrs[i].name)
> > +			continue;
> > +
> > +		if (i == *num_filled_xattrs) {
> > +			(*num_filled_xattrs)++;
> > +			continue;
> > +		}
> > +
> > +		memcpy(xattrs + (*num_filled_xattrs)++, xattrs + i,
> > +		       sizeof(*xattrs));
> > +		memset(xattrs + i, 0, sizeof(*xattrs));
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int security_inode_init_security(struct inode *inode, struct inode *dir,
> >  				 const struct qstr *qstr,
> >  				 const initxattrs initxattrs, void *fs_data)
> >  {
> > -	struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
> > -	struct xattr *lsm_xattr, *evm_xattr, *xattr;
> > -	int ret;
> > +	struct security_hook_list *P;
> > +	struct xattr *new_xattrs;
> > +	struct xattr *xattr;
> > +	int ret = -EOPNOTSUPP, num_filled_xattrs = 0;
> >  
> >  	if (unlikely(IS_PRIVATE(inode)))
> >  		return 0;
> >  
> > +	if (!blob_sizes.lbs_xattr)
> > +		return 0;
> > +
> >  	if (!initxattrs)
> >  		return call_int_hook(inode_init_security, -EOPNOTSUPP, inode,
> > -				     dir, qstr, NULL, NULL, NULL);
> > -	memset(new_xattrs, 0, sizeof(new_xattrs));
> > -	lsm_xattr = new_xattrs;
> > -	ret = call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir, qstr,
> > -						&lsm_xattr->name,
> > -						&lsm_xattr->value,
> > -						&lsm_xattr->value_len);
> > -	if (ret)
> > +				    dir, qstr, NULL);
> > +	/* Allocate +1 for EVM and +1 as terminator. */
> > +	new_xattrs = kcalloc(blob_sizes.lbs_xattr + 2, sizeof(*new_xattrs),
> > +			     GFP_NOFS);
> > +	if (!new_xattrs)
> > +		return -ENOMEM;
> > +
> > +	hlist_for_each_entry(P, &security_hook_heads.inode_init_security,
> > +			     list) {
> > +		ret = P->hook.inode_init_security(inode, dir, qstr, new_xattrs);
> > +		if (ret && ret != -EOPNOTSUPP)
> > +			goto out;
> > +		if (ret == -EOPNOTSUPP)
> > +			continue;
> > +		/*
> > +		 * As the number of xattrs reserved by LSMs is not directly
> > +		 * available, directly use the total number blob_sizes.lbs_xattr
> > +		 * to keep the code simple, while being not the most efficient
> > +		 * way.
> > +		 */
> > +		ret = security_check_compact_filled_xattrs(new_xattrs,
> > +							   blob_sizes.lbs_xattr,
> > +							   &num_filled_xattrs);
> > +		if (ret < 0) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	if (!num_filled_xattrs)
> >  		goto out;
> >  
> > -	evm_xattr = lsm_xattr + 1;
> > -	ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
> > +	ret = evm_inode_init_security(inode, new_xattrs,
> > +				      new_xattrs + num_filled_xattrs);
> >  	if (ret)
> >  		goto out;
> >  	ret = initxattrs(inode, new_xattrs, fs_data);
> >  out:
> >  	for (xattr = new_xattrs; xattr->value != NULL; xattr++)
> >  		kfree(xattr->value);
> > +	kfree(new_xattrs);
> >  	return (ret == -EOPNOTSUPP) ? 0 : ret;
> >  }
> >  EXPORT_SYMBOL(security_inode_init_security);
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index f553c370397e..57e5bc7c9ed8 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -104,6 +104,8 @@
> >  #include "audit.h"
> >  #include "avc_ss.h"
> >  
> > +#define SELINUX_INODE_INIT_XATTRS 1
> > +
> >  struct selinux_state selinux_state;
> >  
> >  /* SECMARK reference count */
> > @@ -2868,11 +2870,11 @@ static int selinux_dentry_create_files_as(struct dentry *dentry, int mode,
> >  
> >  static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
> >  				       const struct qstr *qstr,
> > -				       const char **name,
> > -				       void **value, size_t *len)
> > +				       struct xattr *xattrs)
> >  {
> >  	const struct task_security_struct *tsec = selinux_cred(current_cred());
> >  	struct superblock_security_struct *sbsec;
> > +	struct xattr *xattr = NULL;
> >  	u32 newsid, clen;
> >  	int rc;
> >  	char *context;
> > @@ -2899,16 +2901,18 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
> >  	    !(sbsec->flags & SBLABEL_MNT))
> >  		return -EOPNOTSUPP;
> >  
> > -	if (name)
> > -		*name = XATTR_SELINUX_SUFFIX;
> > +	if (xattrs)
> > +		xattr = xattrs + selinux_blob_sizes.lbs_xattr;
> > +
> > +	if (xattr) {
> > +		xattr->name = XATTR_SELINUX_SUFFIX;
> >  
> > -	if (value && len) {
> >  		rc = security_sid_to_context_force(&selinux_state, newsid,
> >  						   &context, &clen);
> >  		if (rc)
> >  			return rc;
> > -		*value = context;
> > -		*len = clen;
> > +		xattr->value = context;
> > +		xattr->value_len = clen;
> >  	}
> >  
> >  	return 0;
> > @@ -6900,6 +6904,7 @@ struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
> >  	.lbs_ipc = sizeof(struct ipc_security_struct),
> >  	.lbs_msg_msg = sizeof(struct msg_security_struct),
> >  	.lbs_superblock = sizeof(struct superblock_security_struct),
> > +	.lbs_xattr = SELINUX_INODE_INIT_XATTRS,
> >  };
> >  
> >  #ifdef CONFIG_PERF_EVENTS
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index b6306d71c908..a7c3e4284754 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -52,6 +52,8 @@
> >  #define SMK_RECEIVING	1
> >  #define SMK_SENDING	2
> >  
> 
> How about a comment here to answer the inevitable "What 4 attributes?" question.
> 
> +/*
> + * Smack uses multiple xattrs.
> + * SMACK64 - for access control, SMACK64EXEC - label for the program,
> + * SMACK64MMAP - controls library loading, SMACK64TRANSMUTE - label initialization
> + * Not saved on files - SMACK64IPIN and SMACK64IPOUT
> + */

Ok, thanks!

Roberto

> > +#define SMACK_INODE_INIT_XATTRS 4
> > +
> >  #ifdef SMACK_IPV6_PORT_LABELING
> >  static DEFINE_MUTEX(smack_ipv6_lock);
> >  static LIST_HEAD(smk_ipv6_port_list);
> > @@ -939,26 +941,27 @@ static int smack_inode_alloc_security(struct inode *inode)
> >   * @inode: the newly created inode
> >   * @dir: containing directory object
> >   * @qstr: unused
> > - * @name: where to put the attribute name
> > - * @value: where to put the attribute value
> > - * @len: where to put the length of the attribute
> > + * @xattrs: where to put the attribute
> >   *
> >   * Returns 0 if it all works out, -ENOMEM if there's no memory
> >   */
> >  static int smack_inode_init_security(struct inode *inode, struct inode *dir,
> > -				     const struct qstr *qstr, const char **name,
> > -				     void **value, size_t *len)
> > +				     const struct qstr *qstr,
> > +				     struct xattr *xattrs)
> >  {
> >  	struct inode_smack *issp = smack_inode(inode);
> >  	struct smack_known *skp = smk_of_current();
> >  	struct smack_known *isp = smk_of_inode(inode);
> >  	struct smack_known *dsp = smk_of_inode(dir);
> > +	struct xattr *xattr = NULL;
> >  	int may;
> >  
> > -	if (name)
> > -		*name = XATTR_SMACK_SUFFIX;
> > +	if (xattrs)
> > +		xattr = xattrs + smack_blob_sizes.lbs_xattr;
> > +
> > +	if (xattr) {
> > +		xattr->name = XATTR_SMACK_SUFFIX;
> >  
> > -	if (value && len) {
> >  		rcu_read_lock();
> >  		may = smk_access_entry(skp->smk_known, dsp->smk_known,
> >  				       &skp->smk_rules);
> > @@ -976,11 +979,11 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
> >  			issp->smk_flags |= SMK_INODE_CHANGED;
> >  		}
> >  
> > -		*value = kstrdup(isp->smk_known, GFP_NOFS);
> > -		if (*value == NULL)
> > +		xattr->value = kstrdup(isp->smk_known, GFP_NOFS);
> > +		if (xattr->value == NULL)
> >  			return -ENOMEM;
> >  
> > -		*len = strlen(isp->smk_known);
> > +		xattr->value_len = strlen(isp->smk_known);
> >  	}
> >  
> >  	return 0;
> > @@ -4785,6 +4788,7 @@ struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
> >  	.lbs_ipc = sizeof(struct smack_known *),
> >  	.lbs_msg_msg = sizeof(struct smack_known *),
> >  	.lbs_superblock = sizeof(struct superblock_smack),
> > +	.lbs_xattr = SMACK_INODE_INIT_XATTRS,
> >  };
> >  
> >  static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
