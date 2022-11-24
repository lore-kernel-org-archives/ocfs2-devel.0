Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62348C433FE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 24 Nov 2022 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IApSB+hHb6tLIR84PuQ5O5Wp467ouyCwkRjsHmwsJA0=;
 b=UxRRh7L3ogLtQrQqP8tXz2BXmypnzRiI7jMU8baxeQI68EGNSH71mC4fhTJ1NMUVimh5OVy1r19b
   CtTCavJUdsV5mmubbmksAU+stAlNTnNl4w72xmhFklZkihVEwiyjgWRHb0iWMROLKVO+IhJr/ZgW
   nnM8x/booB7rPddmymgJNfmJ9KuMG5UC4MVmr556ddy06qkCPtU8QMJDj54ou2fwHYQb2oNbWJJk
   b5s6MsHArzQ54qsQ/Dyw0qiMu4awJ9QrwzObjK4cGcebG0Of9bAxdVUjT2p1UFRWSyubZyPfL1bc
   IaaGyfoNWDVGoSoPpxLwbIKRdrXYjU34qd9HWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IApSB+hHb6tLIR84PuQ5O5Wp467ouyCwkRjsHmwsJA0=;
 b=dYxSu0IVz5gjo85BjkJx0IZYWuDjRcPTWjWfTiE00ZNSDgkzQ9bGqbsnam/eB5VMX2acaiakIxMi
   OfVk+L65uNi8IWphdd6/w0/7UobwEzDhXTXNYNiL9E+q0ruZBCd/LVE2qrRukEQMkN22M1KOvPGZ
   JBeoV4cnaG+8xofgi7VJwoAPW1ScFirq8XuBW/GVTU3L5WgTudtpTHpUM0BZ2olvoNhkzuoQsYVE
   jOEfmJ0Wy7g5snjCiCFWq3tGB81wEednuh0P77OB3CCew05RNlToIgqw5oANs16Eq+gVJLNfBAk/
   Mmb11v+owJ2jhXbf2TLIV+N0ZoFq4AQUlP7DDQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLU00CUWF3BZY40@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 24 Nov 2022 08:18:47 +0000 (GMT)
Message-id: <bb63eba9a9f24558f4a1acd9bf012b59b5c6e98e.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Thu, 24 Nov 2022 09:17:51 +0100
In-reply-to: <13350b79f708cb089e2ff2ee5cead52bafb10982.camel@linux.ibm.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
 <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
 <13350b79f708cb089e2ff2ee5cead52bafb10982.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=0 mlxlogscore=965 impostorscore=0
 mlxscore=0 clxscore=111 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240065
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
X-CM-TRANSID: LxC2BwB3Y3CzKH9jAWuOAA--.29469S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4rKw17Ar4UKF18JryxXwb_yoW5AF1rpF
 W8t3WDuF15JFyUWryFvr4Y9w4SkFy5GrWDG3srGFy2yFyDCrn3tryavF1Yka98ZrWkJr1v
 vayjyr1DWwn8J37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUo0eHDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAGBF1jj4XQZgABsA
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 9hDeFthCwfoRA6PqPQP-FxoR0Uwy0Lfv
X-Proofpoint-ORIG-GUID: 9hDeFthCwfoRA6PqPQP-FxoR0Uwy0Lfv
Reporting-Meta:
 AAGK/i6eOMAJ+8TosB9YvEkhyjyLxWdAYG0jqaEUODBzaKGTCCVqbvegZS179Ghh
 Cy/f+8BdZ7NgqQgyky8njh+VkIzRIpV1b1xBKutQm6Fpt4thVhR+PsZa1c2DfEqz
 Y9ACvaO0MLa3qlsXhgj070fRCCWyWUipBkCSOp8z5HT1E4nTm2O6FxoNnP2MSKKr
 tiAUBDA9qpm15QiaewvvJ5ckOLSritgLEehwO+6BG8lf6jxcSlfI9Wk9MpWKPl/l
 +bfNyKB3vNUBSramglRgppJa16eezeoSdqCk5LyxyjzhzvG7W5O8iOpsNLdYdmh4
 pa7PUxtqerQI1zC7mTGMEoJ5T4qJ/wz3CMF0a5W0FIn7+h1NntyEBmukRrCf0Y+Z
 O5OVkq0+f6T4Id9pDMCWJ/mRUsDqyMM7QnCnixlkIBL0JPhcv7YLJH5BXvK+6Arf
 ZZ5HVJa8/03+RBkcSrk9E7JBC5bJ8jetGmwQuV2V6T47ZXPhyKN6jAsPZHb/E561
 cgTpFqZOSgeRJnFQGy4o1O5Zqc1JfnfVwZUR9JmuZ4Q=

On Wed, 2022-11-23 at 20:14 -0500, Mimi Zohar wrote:
> Hi Roberto,
> 
> On Wed, 2022-11-23 at 16:47 +0100, Roberto Sassu wrote:
> >  int security_inode_init_security(struct inode *inode, struct inode *dir,
> >                                  const struct qstr *qstr,
> >                                  const initxattrs initxattrs, void *fs_data)
> >  {
> > -       struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
> > -       struct xattr *lsm_xattr, *evm_xattr, *xattr;
> > -       int ret;
> > +       struct security_hook_list *P;
> > +       struct xattr *new_xattrs;
> > +       struct xattr *xattr;
> > +       int ret = -EOPNOTSUPP, num_filled_xattrs = 0;
> >  
> >         if (unlikely(IS_PRIVATE(inode)))
> >                 return 0;
> >  
> > +       if (!blob_sizes.lbs_xattr)
> > +               return 0;
> > +
> >         if (!initxattrs)
> >                 return call_int_hook(inode_init_security, -EOPNOTSUPP, inode,
> > -                                    dir, qstr, NULL, NULL, NULL);
> > -       memset(new_xattrs, 0, sizeof(new_xattrs));
> > -       lsm_xattr = new_xattrs;
> > -       ret = call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir, qstr,
> > -                                               &lsm_xattr->name,
> > -                                               &lsm_xattr->value,
> > -                                               &lsm_xattr->value_len);
> > -       if (ret)
> > +                                   dir, qstr, NULL);
> > +       /* Allocate +1 for EVM and +1 as terminator. */
> > +       new_xattrs = kcalloc(blob_sizes.lbs_xattr + 2, sizeof(*new_xattrs),
> > +                            GFP_NOFS);
> > +       if (!new_xattrs)
> > +               return -ENOMEM;
> > +
> > +       hlist_for_each_entry(P, &security_hook_heads.inode_init_security,
> > +                            list) {
> > +               ret = P->hook.inode_init_security(inode, dir, qstr, new_xattrs);
> > +               if (ret && ret != -EOPNOTSUPP)
> > +                       goto out;
> > +               if (ret == -EOPNOTSUPP)
> > +                       continue;
> 
> In this context, -EOPNOTSUPP originally signified that the filesystem
> does not support writing xattrs.  Writing any xattr would fail. 
> Returning -ENODATA for no LSM xattr(s) data would seem to be more
> appropriate than -EOPNOTSUPP.

Hi Mimi

I thought about adding new return values. Currently only -EOPNOTSUPP
and -ENOMEM are expected as errors.

However, changing the conventions would mean revisiting the LSMs code
and ensuring that they follow the new conventions.

I would be more in favor of not touching it.

Thanks

Roberto

> thanks,
> 
> Mimi
> 
> > +               /*
> > +                * As the number of xattrs reserved by LSMs is not directly
> > +                * available, directly use the total number blob_sizes.lbs_xattr
> > +                * to keep the code simple, while being not the most efficient
> > +                * way.
> > +                */
> > +               ret = security_check_compact_filled_xattrs(new_xattrs,
> > +                                                          blob_sizes.lbs_xattr,
> > +                                                          &num_filled_xattrs);
> > +               if (ret < 0) {
> > +                       ret = -ENOMEM;
> > +                       goto out;
> > +               }
> > +       }
> > +
> > +       if (!num_filled_xattrs)
> >                 goto out;
> >  
> > -       evm_xattr = lsm_xattr + 1;
> > -       ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
> > +       ret = evm_inode_init_security(inode, new_xattrs,
> > +                                     new_xattrs + num_filled_xattrs);
> >         if (ret)
> >                 goto out;
> >         ret = initxattrs(inode, new_xattrs, fs_data);
> >  out:
> >         for (xattr = new_xattrs; xattr->value != NULL; xattr++)
> >                 kfree(xattr->value);
> > +       kfree(new_xattrs);
> >         return (ret == -EOPNOTSUPP) ? 0 : ret;
> >  }
> b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
