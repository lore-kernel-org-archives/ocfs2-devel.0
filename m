Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCED8C7618E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Apr 2023 08:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PY4r0GjTiG4iS0v3WheXsFPgj+QH9SOi2yS9ddzmtQk=;
 b=m5yx1ESCbdqqqOTaKNZZsPmRQFpkYZDB99BSiQSVEsOjE+inh6tJOwYi4E2uI+ISTdzYJVsgKORa
   3ZlGI3jIVjvmupiTnTHno0yuGNFissVTUVPzYxi1ywVLAzCr4AOvqn9LnrIJ+x1mSCTj8K/omvWc
   RsQkxfEIQVY9Re454ZPwgV6ly9/oGrzWoANDD7x3263CzfM7pCrQl7oFApXM8loGNfeHDA0JndMS
   wNPHyqTjwjJd2nph9YiNAxK9pTWyKPn9EQVfFB3B2ZyutspVfjpkoCSt6BC9q+IyCke5b+V4Ggbd
   QXRUDE2xN4/Pmi1NLFF57M2CfP6LY4kj+KaOqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PY4r0GjTiG4iS0v3WheXsFPgj+QH9SOi2yS9ddzmtQk=;
 b=sX2ttuWcagphEIsoji5TRV6vL+lBN31zamx35J69eLiumIijIUoGxeFGxHg+I8QM0tp6Zfr3IwG9
   ooT3+iD2HhC6AWziWdpOEcOpYxi70iEEg7NnFamOPTPZ9F599cdlWRSruRzMEYYS+krVseMjDKbh
   C1OhFQ5keu/A/nLViVBt5r9+KBGMF0pFnFf6MV6Occ/ps/bCYUc66utK4EgGxsWFMXj8cbWwThcz
   WGuvfJ3j0oo+AndRfNwVmsKZRjVhCR9SJ8mQa5iufDcAOGfz/fZ7qK2YZU6NjrLM6Pv9o1LCCnEG
   8SLc9xsoULScho4h6T30eUddSwB7M9FUxWHsXg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTM00DHJ1DY6YC0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Apr 2023 08:10:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1682323831; bh=yuhc7dyZM5udx3a4xN75Z1cqoTpgyOnSoTcZeWOAnes=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MaxQPxcDWg1c8JHKHYNt130+r9ASw65dFAxtQf0LOqn5oxzHEGeXzNWt7+Vasds+2
 z+/fU68ViORlxgOXuMt58p1ed6USiUfftN9V5+HestEB62JVLfowNYPB2thJEDg4dW
 QUPH/pw3RR9KSeogrbHVRRZ9nPwLLC15/FQ/weBJSRFnGe/I6VHArzMC6vODMLZ5V0
 M5PMtEtsxAAJR15IM/l+cUlY7HRFc4QBuqSjFmG/3TCo+WAwal/bLh+y5oUurVadDZ
 940PKQqP5d/GM2OpFKx50hUTclFUMxUGEZVRkOnXE5JuY9eTPohE9mJwuNk4RzeOyI
 4rpsN6NScNKrA==
Date: Mon, 24 Apr 2023 10:10:25 +0200
To: Al Viro <viro@zeniv.linux.org.uk>
Message-id: <20230424-unser-erden-693a29d7a388@brauner>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
 <20230420204801.GO3390869@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230420204801.GO3390869@ZenIV>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10689
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
X-Proofpoint-GUID: POvnOD5QN4gVtM9ghBWrkE6nd8-MDzA2
X-Proofpoint-ORIG-GUID: POvnOD5QN4gVtM9ghBWrkE6nd8-MDzA2
Reporting-Meta:
 AAFUctrcPkkIhrx+5GfcHoIZQnrsGmFiBMky7YVBA98/IWtnFRzRxnbuK1eXmVmn
 7GNd3GSw1RX/vSsfb4URDy/dz15qo2K6YOrzYLdv93CjcwkDfav0IShH9A9xYnLH
 8HeVtdUITVSuQUcP5e/k9T+ciMrste23/YXqZ+GuLfas2Y7XuCIc3dddL99f3MRy
 M8Jn60TtHChfMI8cIftfL38JteK+bZkCSHoIxEJeiAIHIYClqyGo6oYMha37VWPc
 i7Gozd0VmA+g+2SQdLo8yUh4Pkf6xoa9GRcPxbni1KbVPGwk7UUGMo9JfzkRGDxj
 ORdxN+QhNuzfy9XU1Qdmkqz5IGgWbOpybS3P6ZG7BJmE9BquBORcHIujDuYL3twV
 k2CGWiag/zDLpAVWO5d8BAI6My0tXwN2XH1GeT0gA9i5g9QVSlL1JlIYLNQY0VAY
 AChzVviKlE846Ig1YYg09aeVztd1MwSikGYGhYsXqEW7AorJM10wo2gg0TX4vtFX
 U4KbG0jCYnIXCGTdIImEtNmCIH2Tmbi7Y2IWvwD0/Xw=

On Thu, Apr 20, 2023 at 09:48:01PM +0100, Al Viro wrote:
> On Tue, Apr 18, 2023 at 02:56:38PM +0200, Christian Brauner wrote:
> > On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
> > > Andrew picked ocfs2 patches into -mm tree before.
> > 
> > Yup and that's fine obviously, but this belongs to fs/ and we're aiming
> > to take fs/ stuff through the dedicated fs trees going forward.
> 
> Er...  Assuming that there *is* an active fs tree for filesystem
> in question.  Do you really want dedicated e.g. affs, adfs, etc.
> git trees - one for each filesystem in there?

No, that's not meant or want. What I meant is that when a filesystem
doesn't have a dedicated tree (and/or active maintainers) mentioned in
the maintainer's file then we pick up those patches just like we already
do today and have done.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
