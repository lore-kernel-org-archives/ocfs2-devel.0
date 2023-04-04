Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA59C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 23:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1fFBdtJ/onpsA4hUqJYtIHkYoctlKXMCzOisso3oIvc=;
 b=Ss9jROb3mIVmpxu7VAkl8FQj/demlmhIeVF7043rvPdpZhJj1Yw6aLyCa6mxw0vMgrS9Wbq+XHRG
   /LJtWZ5QszEC5ykw3aOSftVxQYQM++awiZjIvwpdZK76TGwF/yk9VJAi/QUEQi2hWX6WUvgV9/7j
   z3peLKlzTcn+CIpLAYlnAKB5oeQ5qkLbt/GpdD6QIEXq8PBJxFLOpsvBKnPdaRpep5hCWXEU5JWN
   XnY/bN6ufr3pA5GQt4Ww99QhGM3Ezoi1Km8ycP/5OEFY4gaUgxX1PwkSqlEiGs2gF99DaBrT2tFP
   a7Y1qn1P9Cn4GsSw2AJz/TYgqjKgC9MwcTH1Yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1fFBdtJ/onpsA4hUqJYtIHkYoctlKXMCzOisso3oIvc=;
 b=ThRRCB9f8df2rdQJn2513FYfzxcFt026jIpEpQs5ILImHGRklITz9UsdV9oSvkWb7QLxgujZcK1g
   XJ0XMTWtJgsx5+d/87FUDF9xcSN0GlwmdV0RsZw3hGqnLeq2Kc52vt12tZeudOLxa5a5fwdCmwj9
   KkzGIs0RYXxDI5emoc7YZDouhpS5GhvaP34V718KZTThc3r2IqvdOUdD4Wa98oZ0i8LhNApMkTrD
   kfPbtP8vyqJIaou1EEG5rK9yRGEg3eIXJFWlxiJY11/mwd6Z5cZ7ePZdK+0PXBBDoIh3xnC2yZbR
   kPWcFZf8qYyTcoE4PoHFBUixtIofV+pLm3S8hw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM00JL469EQK30@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 23:22:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680650535; bh=wmW6nn1dW0G7ZUK1nyoM03KcQYEFzLGdk68Km/BFqaQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZZj10jKRNecy8t8ufVTHZDF49qF6T32i58y3DEOIeipYODmpuNnsQ8Hzia4pi4LqH
 EE4sPsq93OOt1W3Hp5LhcSaKzWV3TVOzbejyLrSA2rc131GqbSgWb7jdyV1bgwsdW8
 2LMFo2UqiNnl8qsLV5eghGCe62GCRgrz1woC6uvYdx7dcNNrNOdbQNmEvqJj5688gZ
 hbnUNWYxq0r0Ci/4A8EPpqh4TgYzHIAq6HkkgeGEC9G82mP+E8k4y/36+dPM3sHY0g
 Qn5FjtYqObCRpIZuZQSEWIo1a4yk8azE0bLTEpuOKnXKGcjmuNM+Vfvvhw+axyzOPN
 8DRyUk06RKN2A==
Date: Tue, 4 Apr 2023 16:22:15 -0700
To: Eric Biggers <ebiggers@kernel.org>
Message-id: <20230404232215.GC109960@frogsfrogsfrogs>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
 <20230404221653.GC1893@sol.localdomain>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404221653.GC1893@sol.localdomain>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: linux-cifs@vger.kernel.org, brauner@kernel.org, linux-ext4@vger.kernel.org,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 amir73il@gmail.com, linux-nfs@vger.kernel.org, fstests@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, anand.jain@oracle.com, jack@suse.com,
 fdmanana@suse.com, ceph-devel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/5] fstests/MAINTAINERS: add supported
	mailing list
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
From: "Darrick J. Wong via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Darrick J. Wong" <djwong@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: WrrIvjqGisupQeCmahBfdotk6Y8LrfI9
X-Proofpoint-GUID: WrrIvjqGisupQeCmahBfdotk6Y8LrfI9
Reporting-Meta:
 AAFewRAaLZG4lh7jgX+DArhAAUFVkXqL5PpLXokaqVWy7XWHW+VIsnQ15h1fQqKe
 vuMIBOr0V9PtiKYaFos2Z/oBTs04QcZPHzUpPOzV4cN0rr6W+K4dTp9xgyYzm8Av
 HBPIhisMTxcmyNYrbtEiywLb/aVlpdOjKTLBbQXmYT9HGu2b0WiH+uCajvQCgmAp
 CygyAIRrv7AEfml5d08VPC/MFz4tThyUx7Xy5+EGF6WGM6cXlK1BvyDzjWX3Oxwp
 2gE77OGs6L3m1SiUBMrDYVR0BxT+912WZDAIr9/iHD88RtbRKMxw0cfNsgNqR9nh
 a3ad185EXJdEZpj8sGmcIGMkeg0sdpcQaNvcm5iwI/Y5CZVdfsGUi11/UVPRjtQj
 gXO920sBQVNWTGxh618M3nO5NBVoH7Z3kXFQhiStTEV8MhCkBAMMnlJRu7T7twYZ
 RF2UAtKuogVibB2Bz3itgpmFCOpELo4wTofqHarNkgqxQxMu+eFY9ZqjEKH/IzHi
 ilf8tpouV33FFIvBf0J6wJehHxGXk2r0mvd8BFyOISMp

On Tue, Apr 04, 2023 at 03:16:53PM -0700, Eric Biggers wrote:
> Hi Zorro,
> 
> On Wed, Apr 05, 2023 at 01:14:09AM +0800, Zorro Lang wrote:
> > +FSVERITY
> > +L:	fsverity@lists.linux.dev
> > +S:	Supported
> > +F:	common/verity
> > +
> > +FSCRYPT
> > +L:      linux-fscrypt@vger.kernel.org
> > +S:	Supported
> > +F:	common/encrypt
> 
> Most of the encrypt and verity tests are in tests/generic/ and are in the
> 'encrypt' or 'verity' test groups.
> 
> These file patterns only pick up the common files, not the actual tests.
> 
> Have you considered adding a way to specify maintainers for a test group?
> Something like:
> 
>     G:      encrypt
> 
> and
> 
>     G:      verity

Yes, good suggestion.

--D

> - Eric

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
