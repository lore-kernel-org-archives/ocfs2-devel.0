Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92E4C3A59F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T3y8jzixZCkiDn0i8x3esZvLFglEoDgY3Fzq0chUKPk=;
 b=J6PjcQCFHmNnNY4AguJFUQ2gFHeMZDtV3+uDmewzpPvzGCryC42VqiebqaBY/NVGc9BhfGyn9P99
   pWhOoCZf0xlHSOMsWHjHWIj/U39tB69SpDIVP3NAdkgIXOjX0NNvXPKPvI8+R7tNlu46C5dJgoXu
   kk61kf9KXkynY8Iz96siRlSyeCR40kWGsVEOAJFnHKk/3z9y384BX78sA14c4zKHPeqK490f5Nti
   qCcNKpXv++4RibTpfCbP9q+rzUMLVImU4wYRTW+lRB8OthctNMJT5vgjvbImNT1Ep8/XPpD+QNYh
   IjrBb20q+fduS7i4wyjNP+oGeNtFjUtPK2peZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T3y8jzixZCkiDn0i8x3esZvLFglEoDgY3Fzq0chUKPk=;
 b=OUcDen6Z81oXdK3IELFx/lm94Pk+qwNsahj5nMF5wh5ubPuqwbjyjpBQd1SzgsZ53DoA/B5o2pJv
   +chURiikPYl10h7r28AYQcRm3MvqKVnn9NhACS7W1QYJTXVX+PhQUt1ZPY2jBh8PEjspR/B+6aKx
   8fQ6ZK34cae72MrJM1/T2vnlneTTc9RJpTMFfgMr+LZ3ZQsOfygL4MwioPCP8g0B2apxRN/o+mVN
   WR1hgPdtbS2h7O0Cyvcob3iVI5p3unp7YL3lxEi4Sj2MkdTgQsAu5xZvbytCsEG8ADMGNepTxgJq
   ya+MCZF/CjpCOLYaipetzq3mKGWUuHW7OsO1VA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00IC0XSUF730@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 13:07:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=vDySJw+RE1dcnmUvFnvraOg2YS5K9nq98jTHqlpHG18=;
 b=RczVDxgd1m7SeAvqgYnIhMYTied/i9m6YC+mlJUUMkN2R7PXui+VjLg8iYe06fhz515I
 OqGZrXAKGUKvZSfH4eRGeuL9BUr7vzUKvDPf7VLXmDGwxD/d7hDh8itl9rzs/V5VZBUY
 6xndXZOIMDiLX5xtX3up8kNWqtPJoFtkXjdw2ck5REJ5p5h3ovFUqtpk2ik/XFUfUkOI
 MsIEVYv/GJt6L3qSw1l+n3/uUBOjfoVuO/0XfaMfeeHDQn2Ae02cvsL7J9l+gXubmes1
 PrOli1HGa52SmNq7H4OIKo2oBqI62KMDF0OnwXbJSHjyoBP+Pa/i/kQUsabs8j8y5roN Pw==
Message-id: <bddfe0f41b05dd8efd6991487ff2525a8503dd84.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 08:06:38 -0500
In-reply-to: <22f47b9d2cade322f9037133b0940640423f9590.camel@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
 <ccf1937cfdcc5bb28dcc7a58785dd0c65d974597.camel@linux.ibm.com>
 <22f47b9d2cade322f9037133b0940640423f9590.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 suspectscore=0 mlxlogscore=802 adultscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=319 mlxlogscore=746 adultscore=0 clxscore=108 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097 domainage_hfrom=13398
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 0/6] evm: Prepare for moving to the LSM
	infrastructure
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
X-Proofpoint-GUID: b2xIEnD6klCRj92bxLOXx8raVH_w5Cv6
X-Proofpoint-ORIG-GUID: b2xIEnD6klCRj92bxLOXx8raVH_w5Cv6
Reporting-Meta:
 AAHdhGaMkF4A1JBm/W5kSjQyMVbDPUlgi6xhAcoqCJk/v9xE3wny6AWmwWi9qHdv
 6W5b/Oj1U+bjz+QYrSfVyR/Am0FkLDQP3woQAIzoQAo3NhDBQTtc2dPxyKjkJXlz
 KRD2dhYDab3ssE+4pu+U8Grvf7inFFEvz4NYF2yWdsfgzrWixrKTMem1GcNpe0LI
 78lL+VrxLtyyVrYJxx0U8Agf92ioI6mkCRKTubjpPW5RptDqRJ58UQ1lh/6bykz3
 fvlAqJkXgpVDKBJipRaR0Byg1OiB5HcSSHWr6ymtiEzwDCw2cxapFRpv5YaqdHwh
 INirNMGHT8o+kB/GCfA7JRPhA1RFvTerpGbjhCkDNTvksEzEXRmNkUeydRSHdOHe
 5gSuNz8JiEa2anFgKoCmKwjsVFC5simnqo+eFtyRZrN6Mg2mMYfBHxLKFMpW0KQS
 QMrEupEcydVubK1H+lxazG81HtN4mST+EyoS4UBDOSNuBazvZs6iSxQqQK3JeOSj
 ipr6Oacp47f7qxMoxNwfHxj+ZFpEde6g+TETFxTweyrY

On Wed, 2022-11-23 at 13:44 +0100, Roberto Sassu wrote:
> On Wed, 2022-11-23 at 07:28 -0500, Mimi Zohar wrote:
> > Hi Roberto,
> > 
> > On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > 
> > > One of the challenges that must be tackled to move IMA and EVM to the LSM
> > > infrastructure is to ensure that EVM is capable to correctly handle
> > > multiple stacked LSMs providing an xattr at file creation. At the moment,
> > > there are few issues that would prevent a correct integration. This patch
> > > set aims at solving them.
> > 
> > Let's take a step back and understand the purpose of this patch set. 
> > Regardless of whether IMA and EVM are moved to the "LSM
> > infrastructure", EVM needs to support per LSM xattrs.  A side affect is
> > the removal of the security_old_inode_init_security hook.  This patch
> > set cover letter and patch descriptions should be limited to EVM
> > support for per LSM (multiple) xattrs.  The motivation, concerns, and
> > problems of making IMA and EVM LSMs will be documented in the patch set
> > that actual makes them LSMs.  Please remove all references to "move IMA
> > and EVM to the LSM infrastructure".
> 
> Hi Mimi
> 
> ok, will do.
> 
> > When EVM was upstreamed, there were filesystem limitations on the
> > number and size of the extended attributes.  In addition there were
> > performance concerns, which resulted in staging the LSM, IMA and EVM
> > xattrs, before calling initxattrs to write them at the same time.  With
> > this patch set, not only are per LSM xattrs supported, but multiple per
> > LSM xattrs are supported as well.  Have the size limitation concerns
> > been addressed by the different filesystems?   If not, then at minimum
> > this patch set needs to at least mention it and the possible
> > ramifications.
> 
> With your patch, 9d8f13ba3f483 ("security: new
> security_inode_init_security API adds function callback") you made it
> possible to set multiple xattrs at inode creation time.

True, and even then there were concerns.

> This patch set pushes further to the limits, as there could be more
> xattrs to be added to the inode. I will mention that.

Thanks

> If there are too many xattrs, I guess the only solution would be to use
> less LSMs, or a different filesystem. The per filesystem limit could be
> increased separately case by case.

Agreed, but unless it is documented somewhere, nobody but us will know
there is a potential problem.  At least document it here in the cover
letter, which we'll include in the merge message.

FYI, the xattr.7 man page contains a section "Filesystem differences".

-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
