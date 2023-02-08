Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC7A7C05027
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Feb 2023 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/YHb2amrDTUzcXW5nF4jOnduJE5VLqNs+g6WtTcmQSo=;
 b=diq6h4tKC2tDEjYfqZUuB2BjWLTi9S1nX6Zv0HTz8cx2ywKTT8+ogbso67ISb1ps+ilk2wa9IqPi
   sZA3Qoo8tbZgCCmhxx76qUIMalp4f8pHNQcD4dxqFZOZCaNmy6Rmvpww/yq2hBxqfuniYfE2NnDk
   mN3T53yBu16L4wthZuPg8Way8SNuBh8ILnpAHpVhybMAdZ5RG5VbXEbWW362L+nn1ZAW/l/4XeD+
   tB5bq3X0nyP1SFVDLbAly7dnqBXsrrnnPuJod0M3jFiAZcGYzXK5c847cGPgFAyOZRXbxfHD+03n
   byQpeS1798VNCaQ0ieMJe7Kv0Vtxl7WiliJA1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/YHb2amrDTUzcXW5nF4jOnduJE5VLqNs+g6WtTcmQSo=;
 b=T03ASz6St65xYl6ldggBX5GHqqLrP8y8vE/KDTZOPQbG/rgaum26DDlYqKeh4+4M2dwyqCcJ8X+a
   9hnj5Krla48Y+iI2qige1ANboGNc/UPErOzQU9ziVszvU38Mr09/IL0OeIhh37c6iEPxjkYW7jWY
   dMD0r09rXg0YEi80HNf8iaNqxTIaIyjKa9KO+mdy56r41dbGY4Cd9GTXBDeXXxeV+4gTdcXe/oBk
   rb6TCwjqcJUaDTvzuWTRDhnahsJAUkejAW9NTRPb2+57NJoRZFqUSbxNN9CBGy9kIdrx8A4FY6Ux
   sY3plABhzQDBGaHiyqCcDEGlKaiD3KJNkva9+w==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPR00JR3N50YW30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Feb 2023 14:34:12 +0000 (GMT)
Message-id: <dc973294e5ad2d05705954b433bb550b04a86325.camel@huaweicloud.com>
To: Paul Moore <paul@paul-moore.com>
Date: Wed, 08 Feb 2023 15:33:12 +0100
In-reply-to:
 <CAHC9VhRu_pdEur4XDkwMETAQEd-8=13k+qvpMEgW=hiYMCKw2A@mail.gmail.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
 <CAHC9VhRu_pdEur4XDkwMETAQEd-8=13k+qvpMEgW=hiYMCKw2A@mail.gmail.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10615
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 spamscore=0 suspectscore=0 clxscore=206 impostorscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=974 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080128
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
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
X-CM-TRANSID: LxC2BwC3PQmssuNjUbIEAQ--.46196S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4fJF43Kr4fAr43Jr4fKrg_yoW8Wr45pF
 W3t3WakFsxJF18Kr1fKwsxWayIk3yxGws8Xws8GryUZwn8WFy3Kr4xtr409343WrZ7CFWS
 vw4fJFZ3X3WDA3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQACBF1jj4i4pgAAsg
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: zO4b4zKPQ3Ra-IjB8RUjfl_rUVu8ZVGG
X-Proofpoint-ORIG-GUID: zO4b4zKPQ3Ra-IjB8RUjfl_rUVu8ZVGG
Reporting-Meta:
 AAHz4elqr/pAkw4zuxInupA8BIa0HfU4Btq0o0hPAHvtV/GvQ1PuETeyPoqxmKwY
 rvI3ChGffxVFgvASkyIYQZnflKl+C4/H993zE3WrVK2R/2eXqEbFuIMomOpQlPKS
 r2nzGl7sFWz6FMO8Gp/d2jXD0wOjGdhBwGvLAq8PwgjNen3ynZv19BEIP9nfOuqU
 lHtCPt8QV3GbVqBhR3eJe+LYVTqUmxzM/Tv1M22G5e4XgrKio6JzeUfMHgsJ2cpD
 dzOjDrAQfv9TXmRUCnkyIF6p5iANYgaJpWRmfVNRCcrgJNTloxTOzFYmdlu4TukS
 QDMLL2x5KQ/TdcSAblWyrmbYlvTGMcvkPe1U0UjLZAt2cG42qD1Hqp6VkwDjUlw1
 F5PGekfS0x7dgL3AeQezenqwJd4cdDXaOodNsaBMmrbolwe2gpRkJs0SlXmFOUIy
 MkkztHkcjp5sCuVv5/hY3pOw95HoAS/5wHNtgWlo+6KlNm/5AYFK/p7Hs+6JZUJp
 EMbQkYn09Xa4ATvJE2lv0uZ8+MP4bl1S+kS+FZ7/Aeyu

On Thu, 2023-01-12 at 12:21 -0500, Paul Moore wrote:
> On Tue, Jan 10, 2023 at 3:56 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
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
> 
> I've been pushing to clean up some of the LSM interfaces to try and
> simplify things and remove as many special cases as possible,
> Roberto's work in this patchset is part of that.  I would really
> appreciate it if the vfs/ocfs2 folks could give patch 2/6 a quick look
> to make sure you are okay with the changes.
> 
> I realize that the various end-of-year holidays tend to slow things
> down a bit, but this patchset has been on the lists for over a month
> now; if I don't hear anything in the next week or two I'll assume you
> folks are okay with these patches ...

Hi Paul

is this patch set going to land in 6.3?

Thanks

Roberto


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
