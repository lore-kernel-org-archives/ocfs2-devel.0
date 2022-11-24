Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C991C4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 24 Nov 2022 01:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UD0Cnhv9bk0VI5W3y089ol+gGb602U4cV4lxUC7zv8w=;
 b=g9abV0s4eow+cASWgmHafQ9ctyirmzHCJMfPHBJd/6cfpE5/gbbp+7KfBitC8q+2pDjx72/wPZ9g
   GGx4EvX9WRqjJHfd65DeOQZh+ikDR/J5YCTz9vuSPEQIljC+8IN4u9LGBeDRYxbdUSGRwaAG2aH/
   g0L9yRJgMJgQcgElfCPY0vlKxGlNZ+ThheLIcubaTLQSazLHX7glChyP6SSdLL+zybP3P7LgnxiC
   VuKql4CFMZ6CbS/55N+szM4EEeeWV16iSMcYWlWCiv2/2BanmZpMS/5Ay/F058vj6+MHD4I9KWa3
   z3yxUivIUdiUokKPUyQxBQlLMQU8DUzRsqd2LA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UD0Cnhv9bk0VI5W3y089ol+gGb602U4cV4lxUC7zv8w=;
 b=NbS1EHONAnhEDME5t2ktsv8EAy4z6APcooYMRC4z9TA7pjv5Jen0JW/BF5XGMJUIIoeudGw+YBpH
   R81+hBrfOUyllvQ5q5ULldGPna2Mi4sUxWOSCnakfByJnV2whodfh2JIVT7MKR4wNswrwwsRIGU5
   yEBx7ZHBRlOLttggBXZ6cA8EdprQdMUKQh/DpnWk2qHqwQtbQEcOE/LqnQv9/99dfGJSSXYNA7UV
   4N9AuJUtqSxERVH8OQCWRbD4EXYjJ098Z7Z6HnMsKlJ6RRRqOv0sxrSabUJpFTN5KNloFEMTpEnb
   H5vmJf9bvQMS5H5/DrTklRyLIsg38y3YYf2Uog==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLT00DM2VGOJ120@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 24 Nov 2022 01:14:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KNq219/5AVdZrleS+HirjEBdvGLdqbdgtgWzIWGXyCk=;
 b=Uj3CEeSyH9PbA/ailDEEdrVjqprldCjGRbSvnLejn7XsSbLCT1pWWu2LHwuUqLq0lfiy
 7xzqseFXrouvygarEDI2CVuckpDJ+Y+ISFXAWIjMrAM0FQWCfzcwouzrfBirQsNjC0Mh
 6Dw6n+XoSf0iyai1DEb5kbTj2HAtjqtltRG9HG0Ar1+/6e5TG04N+T4f2cOkKjpJiCpC
 +0Zwsl55eFpfoOUlIhHGdSCkUGiGwYkNPrpY/pFzuSWProxIme9MAAB14Rxng/EPUMS2
 5Wzl7ydcPK47hh5WqtlH/RGemLRIwN5/gb5MKXzK3N2KblIdoGc+SHjV8Rvq2o5X6Eys Ag==
Message-id: <13350b79f708cb089e2ff2ee5cead52bafb10982.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 20:14:01 -0500
In-reply-to: <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
 <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_13,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211240006
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=249 clxscore=91
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240008 domainage_hfrom=13399
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
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: ZXjctO4w0x0qrNfovFkl9hMnNDUzpnNH
X-Proofpoint-ORIG-GUID: ZXjctO4w0x0qrNfovFkl9hMnNDUzpnNH
Reporting-Meta:
 AAFPys4dOzKWA8hfr0udtWpy34b2JYiHnFaQdBM3rAZ1RHleDhGW37dIpkjhxldK
 nSf8xI4BrPyJBRytHVHevoaL84LgseFS5tycpxI2JvwEoWcCgsNZBBXttImrnz2l
 rojLwda9GhEVVyl+E+vtL1tfo4d99RnfpDFvJ4L9b8bwpIX1uO8dZG7MAFeqXyBR
 En3o0SdOtdLUBTy5KdbTgGwYnGugC7O/H0WFazGjajeOMOm4oLNPLdsekr1xeopD
 URd6rV+wrtO29KxZsCrfmbV7K4cdEMGmjEWGVKFr8X8yZm3WkCINhoFhQZ2Haouq
 wUoTESI7XCUkM/LfVfQWGDTTkh70FbEXshQiGMioucrPjP9qReqjSXqPbvY8SXQj
 hALgzK+mt2o457bn5u3BC85o7wWdpmq3WJMKWhKfM3+rSe2gtBMijrZwFAj63vUl
 vZC+c66K1dM0DBPoishNxuUGs6lGG7Vr4oJwbLy4mRb+J9cjmIJxKYjyYl1pBXzz
 rY0OIZYqXSFoXTSlbzi5NRnxuIUi2DcGWd9n55NZDYuK

Hi Roberto,

On Wed, 2022-11-23 at 16:47 +0100, Roberto Sassu wrote:
>  int security_inode_init_security(struct inode *inode, struct inode *dir,
>                                  const struct qstr *qstr,
>                                  const initxattrs initxattrs, void *fs_data)
>  {
> -       struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
> -       struct xattr *lsm_xattr, *evm_xattr, *xattr;
> -       int ret;
> +       struct security_hook_list *P;
> +       struct xattr *new_xattrs;
> +       struct xattr *xattr;
> +       int ret = -EOPNOTSUPP, num_filled_xattrs = 0;
>  
>         if (unlikely(IS_PRIVATE(inode)))
>                 return 0;
>  
> +       if (!blob_sizes.lbs_xattr)
> +               return 0;
> +
>         if (!initxattrs)
>                 return call_int_hook(inode_init_security, -EOPNOTSUPP, inode,
> -                                    dir, qstr, NULL, NULL, NULL);
> -       memset(new_xattrs, 0, sizeof(new_xattrs));
> -       lsm_xattr = new_xattrs;
> -       ret = call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir, qstr,
> -                                               &lsm_xattr->name,
> -                                               &lsm_xattr->value,
> -                                               &lsm_xattr->value_len);
> -       if (ret)
> +                                   dir, qstr, NULL);
> +       /* Allocate +1 for EVM and +1 as terminator. */
> +       new_xattrs = kcalloc(blob_sizes.lbs_xattr + 2, sizeof(*new_xattrs),
> +                            GFP_NOFS);
> +       if (!new_xattrs)
> +               return -ENOMEM;
> +
> +       hlist_for_each_entry(P, &security_hook_heads.inode_init_security,
> +                            list) {
> +               ret = P->hook.inode_init_security(inode, dir, qstr, new_xattrs);
> +               if (ret && ret != -EOPNOTSUPP)
> +                       goto out;
> +               if (ret == -EOPNOTSUPP)
> +                       continue;

In this context, -EOPNOTSUPP originally signified that the filesystem
does not support writing xattrs.  Writing any xattr would fail. 
Returning -ENODATA for no LSM xattr(s) data would seem to be more
appropriate than -EOPNOTSUPP.

thanks,

Mimi

> +               /*
> +                * As the number of xattrs reserved by LSMs is not directly
> +                * available, directly use the total number blob_sizes.lbs_xattr
> +                * to keep the code simple, while being not the most efficient
> +                * way.
> +                */
> +               ret = security_check_compact_filled_xattrs(new_xattrs,
> +                                                          blob_sizes.lbs_xattr,
> +                                                          &num_filled_xattrs);
> +               if (ret < 0) {
> +                       ret = -ENOMEM;
> +                       goto out;
> +               }
> +       }
> +
> +       if (!num_filled_xattrs)
>                 goto out;
>  
> -       evm_xattr = lsm_xattr + 1;
> -       ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
> +       ret = evm_inode_init_security(inode, new_xattrs,
> +                                     new_xattrs + num_filled_xattrs);
>         if (ret)
>                 goto out;
>         ret = initxattrs(inode, new_xattrs, fs_data);
>  out:
>         for (xattr = new_xattrs; xattr->value != NULL; xattr++)
>                 kfree(xattr->value);
> +       kfree(new_xattrs);
>         return (ret == -EOPNOTSUPP) ? 0 : ret;
>  }
b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
