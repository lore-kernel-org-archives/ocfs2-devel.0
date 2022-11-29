Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77660C4321E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 29 Nov 2022 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qiz+xlzJk8xOZufcy5gc666Dfd5Ysueo0QFhzfPE1CA=;
 b=Px7K/BgqvroKU3uS/AH5vu/3T3rq6KJE+p6NpA5CTFG5HM0+1LpXP0PsGQfV8P1/0QPdAb8/NeL0
   KXaAfNgAgACVb/8TYUiRqWyfqjApt5Q/7rA7HvVWnL8FkpaKJfgYHSoJIqgXbs4CN8mhErbSS3gu
   pwYp2+2UrI/7YrghRzVn6n0iVZ63qhjtTBo85EYTrBfVuok5DIo5shmFTMTdggv1zls7VnNKDiqf
   J2hvrq06u1AVv83OpppkKxIW/h3VlFBU2/S9Zrc/c9JS0pVUcOrL7Yc1rC67VYohm/8jCa+20t7M
   p8vFgTTF7Wtsw2IlP4HfSbKle5sRMqnUj0w2rA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qiz+xlzJk8xOZufcy5gc666Dfd5Ysueo0QFhzfPE1CA=;
 b=DzSLSM+Hs8ghLhawqFOwyaxhuq3f6Al+act95gzA4+KRnYdtmD4u/C+Ke7+S44cbqP3zvFu6D94V
   ae1nMgRySVojQ7+C72p1A58zieXsLLzcCvFRsEpVRuvJjRSWWZbClTZp+F7UXp8AtD2OZRL+wJUp
   UdGVBnQB+6zbqssVgpVj2UsTyhruxCAp9ezorKbvtKycOIZFyytsv7Or+rxDtSGFMnmEf35L+A2Y
   jB3cirXiwhLmk9t+ZxcShBzpHFCWrVw4Vz5ss/SMMxmCjqpJV8tlvMzzc8b3YETvu4KerFl+KkYp
   pKUH6J08tKGYsClrLb+E6072Nzuo4jaZR/82mw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM300FL4WZTLK90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 29 Nov 2022 11:23:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=/smMidFxcLEK4Y856DjTwLSzF8Q3YTSpTIA5p2GvUGU=;
 b=eRi59DIx2C4Ca4cE0OnoZVdlifqtjwY/MWyqfRlVN84SfXsstwm2/oYjWLk6E2/9rVxI
 FP/N7i6JJpYFLNu2orGqZ/YR/9CJsQJg/OyJqh3WfQxCal8ifCZ3D95scAy0lAeWjwTI
 4bhO9BjLF0jUzoren5m/XzUzZUyjyBTL6BUkNA8vIkbB3EvJ0MaC5u+URFNIg6Kz5RiT
 +fk7gy/HKc9FAdI5uLzl15jCo4NJcjzmjP2AuCQhxEn8jsMS+lCUo/mKeG7qyNiioAuf
 XIIqHHo5vKeHejKR6nS8fNTGHajPCa2cLbOker9afRlgGqI2kd0wzM+cB5gjP0OJBD/0 YA==
Message-id: <9859294adb0a9b9587ea7fb70a836a312aaf3c69.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 29 Nov 2022 06:23:02 -0500
In-reply-to: <bb63eba9a9f24558f4a1acd9bf012b59b5c6e98e.camel@huaweicloud.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
 <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
 <13350b79f708cb089e2ff2ee5cead52bafb10982.camel@linux.ibm.com>
 <bb63eba9a9f24558f4a1acd9bf012b59b5c6e98e.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_07,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290067
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10545
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=223 clxscore=185 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290068 domainage_hfrom=13404
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
X-Proofpoint-ORIG-GUID: 4l7_Wdmf5l_beCPx8wQqu4nFAUEijcOz
X-Proofpoint-GUID: 4l7_Wdmf5l_beCPx8wQqu4nFAUEijcOz
Reporting-Meta:
 AAHJgoIJrLIJvSBlGSgaBeH19bEV0BMaYkli+1BDw8qsNw3WV7bdjM9muKEuCNW1
 28sQk9iGlnugUtzAQy9HR6TFMLvOSgZrzHAExzVQq1k1iOboPDSSc4sDaRh8cyCn
 mDYN/Jql6e2v6RFPH5UxqOFWwrSWYKtfVaOB8J1tSJa30n1nwKowsA9MRV0VvQYp
 9JQy1hgGwmyX5VvEU1fXWGE6eAQ6P2nPWMx2FWCQYuUx6qR1bjiqJ8S0Ktf5O3OQ
 0QPYOX7l/WwOFBGLDx1j3pQQiZ1k6ky/IlYCwd0wUtzM1eKxrY+zUweKl8kqWWtu
 gQ3fiSHTDFfSdWpQgWG/QAqRT2ZHeTVepdHPLt+POmD1d4lOemjhoMRpLYPyOK6D
 HPOmzRWSTAU4VXx1MNTNeiuiUEwrovD22XjfMSvTKrCaBrmD5YGNoRQKLv7HuiBe
 nO9LQassIQo6tDFqRegx5UBTPoquncIKINNsPu9WnaVmrIx0iqSnvRlKZlzneODq
 KPPBjUO3x0xiNZi0OCZpdfjdxnj4lKYSpkvUqGnqoQwo

On Thu, 2022-11-24 at 09:17 +0100, Roberto Sassu wrote:
> On Wed, 2022-11-23 at 20:14 -0500, Mimi Zohar wrote:
> > Hi Roberto,
> > 
> > On Wed, 2022-11-23 at 16:47 +0100, Roberto Sassu wrote:
> > >  int security_inode_init_security(struct inode *inode, struct inode *dir,
> > >                                  const struct qstr *qstr,
> > >                                  const initxattrs initxattrs, void *fs_data)
> > >  {
> > > -       struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
> > > -       struct xattr *lsm_xattr, *evm_xattr, *xattr;
> > > -       int ret;
> > > +       struct security_hook_list *P;
> > > +       struct xattr *new_xattrs;
> > > +       struct xattr *xattr;
> > > +       int ret = -EOPNOTSUPP, num_filled_xattrs = 0;
> > >  
> > >         if (unlikely(IS_PRIVATE(inode)))
> > >                 return 0;
> > >  
> > > +       if (!blob_sizes.lbs_xattr)
> > > +               return 0;
> > > +
> > >         if (!initxattrs)
> > >                 return call_int_hook(inode_init_security, -EOPNOTSUPP, inode,
> > > -                                    dir, qstr, NULL, NULL, NULL);
> > > -       memset(new_xattrs, 0, sizeof(new_xattrs));
> > > -       lsm_xattr = new_xattrs;
> > > -       ret = call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir, qstr,
> > > -                                               &lsm_xattr->name,
> > > -                                               &lsm_xattr->value,
> > > -                                               &lsm_xattr->value_len);
> > > -       if (ret)
> > > +                                   dir, qstr, NULL);
> > > +       /* Allocate +1 for EVM and +1 as terminator. */
> > > +       new_xattrs = kcalloc(blob_sizes.lbs_xattr + 2, sizeof(*new_xattrs),
> > > +                            GFP_NOFS);
> > > +       if (!new_xattrs)
> > > +               return -ENOMEM;
> > > +
> > > +       hlist_for_each_entry(P, &security_hook_heads.inode_init_security,
> > > +                            list) {
> > > +               ret = P->hook.inode_init_security(inode, dir, qstr, new_xattrs);
> > > +               if (ret && ret != -EOPNOTSUPP)
> > > +                       goto out;
> > > +               if (ret == -EOPNOTSUPP)
> > > +                       continue;
> > 
> > In this context, -EOPNOTSUPP originally signified that the filesystem
> > does not support writing xattrs.  Writing any xattr would fail. 
> > Returning -ENODATA for no LSM xattr(s) data would seem to be more
> > appropriate than -EOPNOTSUPP.
> 
> Hi Mimi
> 
> I thought about adding new return values. Currently only -EOPNOTSUPP
> and -ENOMEM are expected as errors.
> 
> However, changing the conventions would mean revisiting the LSMs code
> and ensuring that they follow the new conventions.
> 
> I would be more in favor of not touching it.

Casey, Paul, any comment?

> > 
> > > +               /*
> > > +                * As the number of xattrs reserved by LSMs is not directly
> > > +                * available, directly use the total number blob_sizes.lbs_xattr
> > > +                * to keep the code simple, while being not the most efficient
> > > +                * way.
> > > +                */
> > > +               ret = security_check_compact_filled_xattrs(new_xattrs,
> > > +                                                          blob_sizes.lbs_xattr,
> > > +                                                          &num_filled_xattrs);
> > > +               if (ret < 0) {
> > > +                       ret = -ENOMEM;
> > > +                       goto out;
> > > +               }
> > > +       }
> > > +
> > > +       if (!num_filled_xattrs)
> > >                 goto out;
> > >  
> > > -       evm_xattr = lsm_xattr + 1;
> > > -       ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
> > > +       ret = evm_inode_init_security(inode, new_xattrs,
> > > +                                     new_xattrs + num_filled_xattrs);
> > >         if (ret)
> > >                 goto out;
> > >         ret = initxattrs(inode, new_xattrs, fs_data);
> > >  out:
> > >         for (xattr = new_xattrs; xattr->value != NULL; xattr++)
> > >                 kfree(xattr->value);
> > > +       kfree(new_xattrs);
> > >         return (ret == -EOPNOTSUPP) ? 0 : ret;
> > >  }
> > b
> 



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
