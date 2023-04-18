Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B079EC6FD18
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Apr 2023 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UumAVm5igOiQrL8NyYwbWAce6NNnjlT0ESaiA2yP5ag=;
 b=JWSdSWQjKfpiaqXC0CmjRSPBXsx/uQR4iDBP33dTkJmvCyOiEoJN6Xm2oLTVaiP6zY3UiMr1TvO1
   0hlLodo9VKk0zUqpDyL4ywllvSYrNSrxPod76ehViLJtHIWGquJb22rPdEqxBs0PioU9htCy/wJ2
   L2KsfdD2Av77NXvCPbvOepLV3+Y2PL1jyQvhJ/FQKhSLCKJSJAG7B/npEBuzd9Nt0czPUAanSwTt
   ivJwfJOl545gVIFLGCCPuhw45qWTFLhitsjOiKMqEVaqpnqgrsY8VMIzG3AmTYipe28mj5P0roa/
   I4rmwK7b7nhKjpB02yvgM0ClLzEVqMd2mF1Adw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UumAVm5igOiQrL8NyYwbWAce6NNnjlT0ESaiA2yP5ag=;
 b=GJByH6Vnc+ZRMnqW+aocOJPAHB5qZT5V6ZBHOzZPeIGBj1Bz6ES1/qFTypU3h3G42Uo7aItI1T01
   l63DrMnMUMBwLXU3s9GpSC0+x7k6l39v9s2fc02ZE3ZnkVXkssaXRCNtVRt1q/Oq8ye7fbcdAq+8
   ReEnFDkFgDt1l1iGXR2gCV56Us8bQaSriOKFUalosaNGNh7oUtxzFvRW4rLkkoDGTxbgvetEwiav
   6MMuNY4W11GlXRlDetcpdwl/g2TuKwsWt2sX28U9ifcHR4LKO1urfu8JZC3VOgA4vJfVRVHRxmBR
   SKVd6A6XDQgh5MQ7DftecrpOjo4GL9O/rK600g==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTB00B27AMZAP60@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Apr 2023 12:56:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1681822603; bh=bfiHJMtui8taHNlLbuqMhpjAZdV45d/VaQDs8aQUkk4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=sHH3P1X2laX/3Z5A9k4BzmLW+A6HOivA2dLhW18Di0VOWELJf+0eomVW7ATy2CGKH
 Pp/jbAaRhYLGf4+83Ktlv8ARJF8WWGrEvyhgYupLgGkrOcpW+q/1aCAeoLQ7LSnY/v
 zAjwHWJuACsJVNinG1ev0PFGUSGhVgMzs8OBmn7q6lyIXanusI3nYu0y33CVKNUVUP
 5MHRfoPgLzlz5MxhceyR+CtrO+4M0QoF2pMXmXlTwzlGC0AkkW3MeHdZIIUcEQl9fc
 QlLF0u4gtSk6T8PlxNjAxX3e9uxD4GlOVes4OaTjdNfacges6br5hmLvPz/rV/wOn5
 t3JECJ6Gg2MyA==
Date: Tue, 18 Apr 2023 14:56:38 +0200
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10684
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
X-Proofpoint-ORIG-GUID: PQDmax-kSAoqZ_-AM4r1S2aX8Z6ldidU
X-Proofpoint-GUID: PQDmax-kSAoqZ_-AM4r1S2aX8Z6ldidU
Reporting-Meta:
 AAH7uXz4gqiYlorIrHL17gFEnWQYLtXBJ2Sb3FY/ZqU120cbjt/U8QJKme/EnPr0
 fs75oyl6jrhVqcgDtGyHP0HjajtsJMZ0jsFDsVhvjFhbdA7ij4/mByJQ+bcKKnwK
 wLRHiZ8zkHT2UEAaBRhtzJjIQuxz+4wWaopFvihQqs70NxaIKm4B8L0SMyIfEbBk
 hwLqZ173YnUInBpU4jVYez1UQWSoohFCq8Jn+sBJupxufzJ2T/GFMMoa/gdtnJ2C
 C/uIHTFmA2/lEhQLmfUSjqIBtU1oFnQ81RhIA+odiQu8CmSusK7Jw9icGhHuKpC2
 bLHp0Kdh0bEbAcven5F/2gu6MAgiXGTaQje1juHH61H8Dl5TG0ojWySWXj9A0SAh
 ZZG6YRmJU7XZ3BFS/L6QzyHOyNQTx2mR/KUfFpfL3If5bY3X89cS/Gct/EI5aoic
 ACk51f+tt51tQUCFl2v7CkUl9v782XE6nnlZTlixodQQj/cY40NTCinlJCcyIeYr
 /541AALNgTI+lkvlhiRMywYxL5eLvsc6EM9yHgKOOIV6

On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
> Andrew picked ocfs2 patches into -mm tree before.

Yup and that's fine obviously, but this belongs to fs/ and we're aiming
to take fs/ stuff through the dedicated fs trees going forward.

Thanks!
Christian

> 
> Thanks,
> Joseph
> 
> On 4/18/23 5:17 PM, Christian Brauner wrote:
> > 
> > On Mon, 17 Apr 2023 22:56:24 +0200, Arnd Bergmann wrote:
> >> On 32-bit architectures with KASAN_STACK enabled, the total stack usage
> >> of the ocfs2_ioctl function grows beyond the warning limit:
> >>
> >> fs/ocfs2/ioctl.c: In function 'ocfs2_ioctl':
> >> fs/ocfs2/ioctl.c:934:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
> >>
> >> Move each of the variables into a basic block, and mark ocfs2_info_handle()
> >> as noinline_for_stack, in order to have the variable share stack slots.
> >>
> >> [...]
> > 
> > Going by git log, ocfs2 patches don't go through a separate tree.
> > So unless there are objections I'm taking this through fs.misc,
> > 
> > tree: git://git.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping.git
> > branch: fs.misc
> > [1/1] ocfs2: reduce ioctl stack usage
> >       commit: 85ef56bc2d65215f43ceb7377ca14a779468928d
> > 
> > Christian

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
