Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FC3C636CC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 10:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4r+0j9CIg7QmazK5WM1nxbgvODd3Y1++51kDDfwA0uc=;
 b=pjqOc5oI3R/rtq3qsXJfWkDyrkJAtGaexgvYaCQxq4ZPPnARTs+Bqobp2Ra1KnRAqQT1UtgrCvjl
   a4pxZkA60x/qyYpsP1CDmVDGbrTJI+XPbHRqIKxQQbW0L+ccZXJ6lDj2H6mKpRQZsn4DtojQ2Tm2
   5X8cC1uKeGrFyKXzhuupC/ju5KaT+NqIMyxOKR/kIAWn8Nyi0HbSoJlIPGgZ+p8WbWCIvWLMsJiD
   zoQ0p86iQDruAZJ9misTJzHkksXFvV+QD4WMh/GKSA/1rToJ+6rg0KSu0iwqhM3p5cHp0rb0EIU4
   Lcak7ChhMgCX26XgA1F+Krgx83X4+SlL7wPbZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4r+0j9CIg7QmazK5WM1nxbgvODd3Y1++51kDDfwA0uc=;
 b=slkcuHHvIXFqF7u6b5JXEEZADamOIsapHDZFusOBsJwIiUrv/GNKIDGvJ1o1KgOFFkmZ5f4uJOlv
   dx6Jcz5FPg5/RNi4CtFYMUHxe5KxN2jqQNMizKUBvguvxz0un3T9VXLEZUqh++L3SdvsEaUHknxo
   8EsRISFiVXz1Gb7IesRzYjSMqJcVv3qvFlXyz+wIMVCoSjTgazdkXjSM9YyAUxVZ/NYGDI5aeKH3
   sjTTWUkm4s4S2bFdrR8JjmWFxGdhtblkQT8cLdUhQRAWXN9H/iAPD/RP6W277dw+J2wKWwb8VG7+
   7DSn5Zt87cufvMCaSLTUEeZreKot0j6kraghbw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD004WHL40ZVA0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 10:57:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=RuzZ1LW5t4JYUC60YV0IWi615mVUaWtO9PEMu1O1wdg=;
 b=ecqfE4SNr0Wg0hXNLh+6ZHNcFWlPtdeHf4BVtHEoDppk5NJSfiup/odQYO7Cm3P0b0eV
 h+lMgrztrCDCJMeqRDVkqF469WINMOV22NAfcJsplA9tXZ8wXJntHRusjalRGGfPGNQw
 sYv/uFheiKjGarQWmCNPPNEOgCw71qseA8zF7NtEYvvT8kPNshURsnE7xyL3VpAPu4+r
 IoEk4dd1Mnp1diHNr9kE13cjVrJNMhhKilGL7/gjoFXMNWt2a9mzAtm1o+ebumCcJafh
 uIuxZR0DwPiZMucrlo1ir5YfvkByErYgTTK8RxSdkkAsL62MfLXu2pTMmrdbO2WGYtB7 LA==
Message-id: <7bea1e47e85f8cb340a6ec4f7c04bc5e17c31b99.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 05:56:54 -0500
In-reply-to: <ab9245bfb43b96fd8eded8a4ca25f5cae20b9f04.camel@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-7-roberto.sassu@huaweicloud.com>
 <1f252850086a39e3c15736f252600d388f6b9c24.camel@linux.ibm.com>
 <ab9245bfb43b96fd8eded8a4ca25f5cae20b9f04.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_08,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 mlxscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302200095
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=138 lowpriorityscore=0 spamscore=0 priorityscore=148 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200099
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 6/6] evm: Support multiple LSMs	providing
 an xattr
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
X-Proofpoint-GUID: oPMYcKjbiDW4CVuun8zrMpjcefunYKac
X-Proofpoint-ORIG-GUID: oPMYcKjbiDW4CVuun8zrMpjcefunYKac
Reporting-Meta:
 AAE7un8q3k3BB6cXXYRGS83gsaSjsfeofUb8AZWd3OuAfCwHziOrm7X1h6PVzSsd
 aJYeAloahyb7bGXKjExwfC3W0H5ZfDFnmpDLfQn62tTA8d/b6zgmNfh9uiejx/A2
 m+OHAbn3r9k+AC6+5RCUHVZFf4hz87po8RuyEtW94tQhjSwnvu35LcAxi6z6okSk
 sNw/RcsrRxUGv8qfdaVfgNatQnsZqij0IvFDEXy8WSqrW4Vc1nQ/kmJWWLdUkIgh
 xL2sNPhL0Pv1Pf1Tv9xaolbZvJXL8KlDLdVR9X3ngY17Opg0lvTb/Svff4s/50DF
 n4f0jcrTIbtVaP7nyv2so3Jb4N7qDXYInML2KJCSSUFCErAeZ0KcVQFlD7GkfocU
 IUR0gTXD42W51MkhaqfjKU+LgTuifhvinEXqr088jbIosmnIA94HkeccEeLyzTOX
 q1t/cbIRicD9bXun2BaHRjFKq5nb6oQJpNH4Oo8JK+ZQIlSv3gBuTyk3sCn7yI4E
 JB1I4LfAoZJjsbaruNXzW5Gk32aObZPn7pbL3uSW1qiP

On Mon, 2023-02-20 at 10:49 +0100, Roberto Sassu wrote:
> On Sun, 2023-02-19 at 14:42 -0500, Mimi Zohar wrote:
> > On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > 
> > > Currently, evm_inode_init_security() processes a single LSM xattr from
> > > the array passed by security_inode_init_security(), and calculates the
> > > HMAC on it and other inode metadata.
> > > 
> > > Given that initxattrs() callbacks, called by
> > > security_inode_init_security(), expect that this array is terminated when
> > > the xattr name is set to NULL, reuse the same assumption to scan all xattrs
> > > and to calculate the HMAC on all of them.
> > > 
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > Normally changing the contents of the EVM HMAC calculation would break
> > existing systems.  Assuming for the time being this is safe, at what
> > point will it affect backwards compatability?  Should it be documented
> > now or then?
> 
> Actually, the current patch set continues to fullfill user space
> expectation on the EVM behavior. If the LSM infrastructure created more
> xattrs and EVM calculated the HMAC on just one, there would be a
> problem on subsequent xattr operations and on IMA verification.
> 
> By updating both the LSM infrastructure and EVM to support multiple
> xattrs, everything will continue to work.

Agreed.  Thank you for the reminder of the bug report being addressed
by this patch set.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
