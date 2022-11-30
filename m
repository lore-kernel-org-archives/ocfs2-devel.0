Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBA1C352A1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 30 Nov 2022 21:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0BbfpDAno3/P/MkaW5hbLU0cKxvVfhkmCeSBXG7aqyY=;
 b=So+PSSeRKaO7Xdf2l0x2yDuyQbGEfYm8qd2ExeddqVR6C8iizbLPJFERT3ypQqGGQaaYGg33qfvF
   bkbt+rmAirFNd8PaTSbtybHUzZstsT+LaK6bySE6th8SohNwr//H6O+3t7PTdreWHamjeTLnCyEe
   APWD8lu9GJGX8AMtP6og3Fn5LVUkp1gQmD1HUxgoscodhIfgDFgDBJ0FU9rmcaGdnfavayk0L61M
   apsI/+CorTqTVg1oUT1dNyV1sclF8wa+u3TM2inGLqNtXBxT3ivgGbA7BNIJaXE4bEd8csaF3rQv
   2u7OiJrtmkZCNm91rMDZ22jAjWbJeQtas/sz3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0BbfpDAno3/P/MkaW5hbLU0cKxvVfhkmCeSBXG7aqyY=;
 b=XNI/y0yOQfl1Bu17hgBHiMKf0uTogvHLxKd3E8A73uf6QY/g5VqYSWV/Rczpk2SMVvxJWSB3FwlY
   oCKlKr3uX2CvPSDH7xvwWVvUc9yPi71hChb+Pl4sjVOCv/ruGCJ41g9brZDbWgttDRzMAnPm50OC
   Xns4kVCpdDqvz1ZeUK2ghRyOmxauvgQHcu417dbNIQAcOboCCK/IRSuPmJW8E1NF2x2AamlSo7F4
   hlmFXt6RwrOnnDOmUynY8xGhCiukIw9C41Tj9fv1+2wRtILFPEkd86DSNA8LMO3lDUtdvTOxUq1/
   SrfMxseAGczzwPpfIO2bHKKjfR/rCJwfs+zODA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM60023BJH0H530@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 30 Nov 2022 21:24:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=yifZRjcnME4KdiCrx4XAH30YdBt6VKv7hfRn0v4FRuc=;
 b=l1XUiN1rW6f+ee6TrpN9jk5ssoNSaDOiPcxMdZauO8mKygmAxvaRnHoG31vayk9PgxHr
 bnrusCji3tMF8gNxXVxyKptv/w6DBipSxA+jUHZPaKQlnX1VA6veuNfnO4T0U9hHUmjT
 Y8LtbWrLuqkjh12fLywGfGt8FtkeENfaXiLvCKlhTB3SHROi0j4psDHZlDj/cvAHjVuj
 NL1hijVMJJh4dHNqKg7eBrzLejruYTDP006FlqAY4ckD2FnyWxCDyzWIQDFmuEpogPXV
 5szbiEKjhNrPIFvt8pvIUWohtN6IFLNqUliTFjBXXkHzaJ4/+uucgc8gQi22pUqMQ2ZO ag==
Message-id: <b929e0c597161fd5be79c18163a11649dd7f237f.camel@linux.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
 Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org
Date: Wed, 30 Nov 2022 16:23:43 -0500
In-reply-to: <50232f2b-d5ce-1e5a-3f5b-8d3eb53fe1ec@schaufler-ca.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
 <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
 <13350b79f708cb089e2ff2ee5cead52bafb10982.camel@linux.ibm.com>
 <bb63eba9a9f24558f4a1acd9bf012b59b5c6e98e.camel@huaweicloud.com>
 <9859294adb0a9b9587ea7fb70a836a312aaf3c69.camel@linux.ibm.com>
 <50232f2b-d5ce-1e5a-3f5b-8d3eb53fe1ec@schaufler-ca.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0 phishscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300148
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10547
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 phishscore=0 mlxscore=0 impostorscore=0 clxscore=37 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=228 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300150 domainage_hfrom=13405
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
X-Proofpoint-ORIG-GUID: s4ywmegL19-jSQ2pqJSgkXzWmPHGPZ3i
X-Proofpoint-GUID: s4ywmegL19-jSQ2pqJSgkXzWmPHGPZ3i
Reporting-Meta:
 AAGUQo7HwPxxgOwre9wgPkeD1mTULRaMfAEL9YkNvHrpfCMjW3TWY6q+yIz2Ozyl
 bU9tYEdhIu9rUXzPhiVCCNUdKsPqEjmvnDPqTD20boAPbGbNv621LgwETEz2ddF9
 hCgTp4Fz1bT7bdVY5etFaTkCA+VhQCcTzF4p2N+NYbU9eZO809Tc5xmfOfGjeIkn
 FoZP38pNCIfiY6p0CYzeIa0c2xgEaid0HcFEaodg/qTK8K8vv0sFrlVTgnkLNNbQ
 DwEDPXBVQDQVp4Ke+m3D5e+t3Tr8ZvfrVkDuSjNPxWgxt7fr21JKki9t7M36ok/G
 7yX9Y6Al4Q+ueJiNEApK/EmMjCgXEmvdeEG0wE1ZwTkVlv8T06RKyrkSFdjbvuc5
 9WXDIKhrrqz3Ts0lQcoiGcVADC84mtppxIO1BCB0Fju2IKG3cltZJrCuDR4S0P/v
 zHDizLVazOlBdWvMFe9M6IJvc9368xehXu2j3wkkHVw0AeQjmmosO1c+nU0BJ0YR
 T2jM3lQjHhnn9sHiZO8M/ZnbrTpWSynmQ836PlvFSpg=

On Tue, 2022-11-29 at 07:39 -0800, Casey Schaufler wrote:
> On 11/29/2022 3:23 AM, Mimi Zohar wrote:
> > On Thu, 2022-11-24 at 09:17 +0100, Roberto Sassu wrote:
> >> On Wed, 2022-11-23 at 20:14 -0500, Mimi Zohar wrote:
> >>> Hi Roberto,
> >>>
> >>> On Wed, 2022-11-23 at 16:47 +0100, Roberto Sassu wrote:
> >>>>  int security_inode_init_security(struct inode *inode, struct inode *dir,
> >>>>                                  const struct qstr *qstr,
> >>>>                                  const initxattrs initxattrs, void *fs_data)
> >>>>  {
> >>>> -       struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
> >>>> -       struct xattr *lsm_xattr, *evm_xattr, *xattr;
> >>>> -       int ret;
> >>>> +       struct security_hook_list *P;
> >>>> +       struct xattr *new_xattrs;
> >>>> +       struct xattr *xattr;
> >>>> +       int ret = -EOPNOTSUPP, num_filled_xattrs = 0;
> >>>>  
> >>>>         if (unlikely(IS_PRIVATE(inode)))
> >>>>                 return 0;
> >>>>  
> >>>> +       if (!blob_sizes.lbs_xattr)
> >>>> +               return 0;
> >>>> +
> >>>>         if (!initxattrs)
> >>>>                 return call_int_hook(inode_init_security, -EOPNOTSUPP, inode,
> >>>> -                                    dir, qstr, NULL, NULL, NULL);
> >>>> -       memset(new_xattrs, 0, sizeof(new_xattrs));
> >>>> -       lsm_xattr = new_xattrs;
> >>>> -       ret = call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir, qstr,
> >>>> -                                               &lsm_xattr->name,
> >>>> -                                               &lsm_xattr->value,
> >>>> -                                               &lsm_xattr->value_len);
> >>>> -       if (ret)
> >>>> +                                   dir, qstr, NULL);
> >>>> +       /* Allocate +1 for EVM and +1 as terminator. */
> >>>> +       new_xattrs = kcalloc(blob_sizes.lbs_xattr + 2, sizeof(*new_xattrs),
> >>>> +                            GFP_NOFS);
> >>>> +       if (!new_xattrs)
> >>>> +               return -ENOMEM;
> >>>> +
> >>>> +       hlist_for_each_entry(P, &security_hook_heads.inode_init_security,
> >>>> +                            list) {
> >>>> +               ret = P->hook.inode_init_security(inode, dir, qstr, new_xattrs);
> >>>> +               if (ret && ret != -EOPNOTSUPP)
> >>>> +                       goto out;
> >>>> +               if (ret == -EOPNOTSUPP)
> >>>> +                       continue;
> >>> In this context, -EOPNOTSUPP originally signified that the filesystem
> >>> does not support writing xattrs.  Writing any xattr would fail. 
> >>> Returning -ENODATA for no LSM xattr(s) data would seem to be more
> >>> appropriate than -EOPNOTSUPP.
> >> Hi Mimi
> >>
> >> I thought about adding new return values. Currently only -EOPNOTSUPP
> >> and -ENOMEM are expected as errors.
> >>
> >> However, changing the conventions would mean revisiting the LSMs code
> >> and ensuring that they follow the new conventions.
> >>
> >> I would be more in favor of not touching it.
> > Casey, Paul, any comment?
> 
> I don't see value in adding -ENODATA as a value special to
> the infrastructure. What would the infrastructure do differently?
> The use of -EOPNOTSUPP isn't consistent throughout, and the amount
> of "correctness" you get by returning -ENODATA is really small.

Agreed, it isn't worthwhile for this case.  Roberto, to ease code
review, could you document the overloading of the -EOPNOTSUPP meaning,
which results in the loop continuing?

thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
