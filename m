Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE5EC77B73
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Apr 2023 09:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5V+zZukpiz1JOQdv1r8MRQMjOup1MJDO/bphwT38IzA=;
 b=T7K+czVKUeNpjzIPekXL6bkZX+LKYrNelsOQ4iIPaYmxwmnS6WFp0rCBNhT+VIDMu8CTzyujjf1t
   JqRO/m0Gp62xLNUWyFtOgf8mxlUBC6EFeCG7+HpobWgZlYfQHXLGDhPxh5WdVx8jD1vOGAfHMa8E
   Q0XBy4mTHoQPYd45goJ4M6M0jhfDaOrLdhTig0IOm9YjkQJznq7SjYSR/dNX7ceQ9BOmzwifz8Tp
   Bu4AXd3dayMtdZ6RQeAslfxq30diSvx+HMEjCei3/tXzJPAzQ1JyrlbrRRPMn6tN1Tt3jT5578p2
   /HhPFEq2+EjH8haVyCauXGPi8q7yoOIFl2VdIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5V+zZukpiz1JOQdv1r8MRQMjOup1MJDO/bphwT38IzA=;
 b=Z08O8Sng27Y02byJGSL4YrLtsbRHd7trAJXqLPle+dqljvA41SHQg1zMncbEGu49vvlVlnvmn+zw
   HaD1mnRpNkTKI0MgLX2F5nggPXmK5ZtnGbGIwdz2mFe1ZG+0qUy5LXIImX4T376YMISBUOYZFRQH
   6v6DqfvSbgVwuDh151jop8MTMDzxZAijEsw2uTEHVJS07XUVSPSnRDhbP9uBMFWO1eeNmSnO56zp
   0buu/2DTrvICaOU48jZZamFcCLk1o5/kVHG8jdsCkxM2kjOEQ70nKoTk3d56A/9vMgdFpx83wLl1
   DzaxG1zLl0/8PLvPZPBQeP/NaA8cF92aGw0Y5w==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTE00MQFQLNOR80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Apr 2023 09:34:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1681983258; bh=oBd1jiFHxIfJOSd/MLajoRXe8BBSyCbVPO9SoZQLpHU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=E0CwMjy1/D/gpKk1NALCWP7VOPf5oYDzx2eZJQZIQXtV8uw8hhemG+mbt/MmLfpA+
 J4rnI8vUhEM3pF4lJUvsz2BghNd2/OkIBCI8feNxliX7cIOq992BIS2GE6oP/dHd9/
 yTV1vLJq/XYh5gdr7yFXoaUo+kdAXOvqaEIyrliyKo9Y3uLOGpQ5VD/b40CHJE4vBp
 i6V94PrPsKoP7/1vm8BFcNZws13u6n2fqMQV7bpQ6kOXlnEko+UQZYTRIuVw6UT6uF
 XCQYhYHkD7GtC/H5stjxqsB+KGyRD7UlJ7wcd8Pm7IVSlyVmbwekw/2Q1MbEr3WRbk
 Gue7bJ8c5pVBg==
Date: Thu, 20 Apr 2023 11:34:13 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Message-id: <20230420-wetten-aneignen-8324959e629d@brauner>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
 <d1e719ea-95bf-bb96-62db-e550cefe0a80@linux.alibaba.com>
 <20230419142159.fd5ca2e91658fe304e317a72@linux-foundation.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230419142159.fd5ca2e91658fe304e317a72@linux-foundation.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10685
 signatures=596816
Cc: Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: yuoQgiAAqggGW15NjxTDdQcQFe-fzUjU
X-Proofpoint-ORIG-GUID: yuoQgiAAqggGW15NjxTDdQcQFe-fzUjU
Reporting-Meta:
 AAFufDvcffkFs98gtp6W8wl0J27Q2CoCvWH4npAZrD0meyssI2wlk0gq8helVdeP
 TsSFtTcRYvzz62RnVs1IX/WutNu7gXeyqPOpWVYlGrmssHuMv4t8VP+i4pAyyAtB
 qzQT2FKR87l7INPMutFKYvEsfDD3H6uLHb9HA9ndn4vfAR8xUMSF8FZP/LCXmpzy
 G3bJyjR+0fHOId/yQ5Iqsaa9//MRmuBoWTJ2z2yd1lkW5TeSWYYFswYQqherZyl5
 ooI2WwwPdDPEls/5XDJtSij7obQyzLJR/osqR84F+ApnPvLi2sah3sRLgnAY+rHH
 dQFxoNVLvAmD/214J3E7UNyg18ynfVIRxwqDDZ90OADacy4FpIJui+GmikusWVk5
 FGTtKcftxRae4ujnlZFI357KihA5qS+STXxJq1Wa6MIG+/4LK0hp8SNdfJaND4W6
 qrm5kljCDIo0uCqOmSQDoeYTZdyzfsJztpXDDD0N/83Cgl0IYVvmkyqPiAcFrhkf
 e/fOFVzwN9dIVegGs7sJRK16VZd7M73eXI/9saVD/1rf

On Wed, Apr 19, 2023 at 02:21:59PM -0700, Andrew Morton wrote:
> On Wed, 19 Apr 2023 10:00:15 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
> > 
> > 
> > On 4/18/23 8:56 PM, Christian Brauner wrote:
> > > On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
> > >> Andrew picked ocfs2 patches into -mm tree before.
> > > Yup and that's fine obviously, but this belongs to fs/ and we're aiming
> > > to take fs/ stuff through the dedicated fs trees going forward.
> > 
> > Either is fine for me.
> > Hi Andrew, what's your opinion?
> 
> I've been wrangling ocfs2 for over a decade and this is the first I've
> heard of this proposal.
> 
> Who is "we", above?  What was their reasoning?
> 
> Who will be responsible for ocfs2 patches?  What will be their workflow
> and review and test processes?
> 
> Overall, what benefit does this proposal offer the ocfs2 project?

I think I might not have communicated as clearly as I should have.
Simply because I naively assumed that this is unproblematic.

By "we" I mean people responsible for "fs/" which now happens to also
include me. So the goal of this is for patches falling under fs/ to get
picked up more quickly and broadly and share the maintenance burden.

Since ocfs2 falls under fs/ it felt pretty straightforward that it
should go via one of the fs/ trees and thus I picked it up and didn't
bat an eye that it might somehow bother you.

For us as in "fs/" it's nicer because it means if we do fs wide changes
we'll reduce chances of merge conflicts.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
