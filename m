Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0E2C636D3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Feb 2023 21:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sH4E1UWOKe69raQnxa45gg9FUeV/dK5UwfuG1C//DNQ=;
 b=zQuVPH5AZ2XdYQZy/31tOTn0DUd/bwuZe2GAq0StoImyTOva5DaWBk8YWGCZJ+7K4bT9t92eNrnH
   0/Km6TJ+x2ynZBaFpTwUgmKb92f+EyUc/0rd1MugomFDl3iNgLFlXElC8pZHYmw5rBP2b2hCY2Ll
   uQjxTOTyqeUx9+W6/1HYb8DFrEn0Grsz0b/lmKwHvDxkubdvsqBeXNh02tyWhZ+bUjRtKhSEue0t
   vr2yo4/2DINlL722xOjltAIM5XIT3kvKkiR4LyKX3+zCCuC7WsaVTQaVKXhZttehxP11LBDXAzdq
   K9wnXeJf5vJdjAeQ7FW7wDBRG2ESDW5MXUvsNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sH4E1UWOKe69raQnxa45gg9FUeV/dK5UwfuG1C//DNQ=;
 b=LtIKA+DupD6nuvLRZhqMQUMOJFdwAlBq8l5F91uNU/Uwo/naR/7F/pnIqnr4OsSpWWXRGtd4nesU
   Bete7k9ymmsSNwGGp1yB3PRHDWISUkDjUvlwJQ3cIlS47PT5eiPjR6iuwioHMhn/oAzguwpxWBhh
   5phWRzSxa+E9XuZCiOdb9/k1uca4h+aK7LG3O192emUTjU62vQmxN5IjoJGRL8ZUfItTFTptImFu
   dDUSJV4rGBMJ/0y9slLCA8bYGAh5zu3wR8C5I9YBBpBz5IoAVdsb+nNeHAx6FuQRr2rvMpY4UquL
   ucJuB15wIcREoj+5X1/pRsvRdxyVjFHgX1Ax4Q==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPT002YWZYEUR90@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Feb 2023 21:06:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1675976759;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=CAVkyD8Nx/y2ynXnSDseAghmgwxLpM4z5TAXS1lVdl4=;
 b=fsToE02Ydbw9AM0LhMk4fOKIsHvVkm870EKJvtvUsHlgdxofGdKjWtExVXrQcwqyOD
 SaJHwxPVUhVv+Zb8PdG9Cl7AkSweZegmZgJovsF60EdVp7XWUSfeDyRdOdh1BqrRM5N2
 Vi4N/kTKjg/T3MKWf9zptDhGtRkG3SMgQxag1fqnQPXX8xl2CMLbs3PoA2hsrFrGc/Ny
 03aku/22aS9evBeXGC+9QqOFU0n1VQzmcMeerqis2tI7xZt9hTTp8vbKnPNrpR0nwUEH
 m1og74/72VCF/OpMF8luJl9jkO5kXYh1wuIMTBwX+PKBuUN4pLSyfeTfeph7UYAu0/ty tIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1675976759;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id :reply-to;
 bh=CAVkyD8Nx/y2ynXnSDseAghmgwxLpM4z5TAXS1lVdl4=;
 b=R5JFJpD765BGnY8pkEINxz/FN/TGtoa6OBJtl797VLmXyjOXHOWGCM8T7COhh/HiPC
 q4YyPGPhuPxfmp2LCz5z/GLzfbbv0/MY+FKSINVkSekDUx5ClbLdY584zm7dfUuu0pP4
 Fni8zQ8wMLN7XN/3/7HK5riXeSZ7uAN7XX1OjAtucAYa8IHyJVjCehkjRCN+n4uLtxbd
 NubeujLBglqC6Ey25QD9WemHvhaND6Oo/SQtAdUc1NMa378IKybXLn+2ugoeYLPM4WGp
 ummzSN3S7j90DCg52FNROgy7HHXVHR3M5cYNrr0ED6p7FNruAwzVnSdOfIJox6Rlqq38 W9Rw==
X-Gm-Message-State: AO0yUKXWjY8Jv7/B0Yn1XwIBdV/x9VJ1AvbEFiB/kD7sgliFYfWQH8Dy
 b2Z8HoYP5zWpNGfBeGMBnft/iuYWJVuBjmSjjz0N
X-Received: by 2002:a62:5f02:0:b0:5a8:5247:2589 with SMTP id
 t2-20020a625f02000000b005a852472589mr832403pfb.7.1675976759040; Thu,
 09 Feb 2023 13:05:59 -0800 (PST)
MIME-version: 1.0
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
 <CAHC9VhRu_pdEur4XDkwMETAQEd-8=13k+qvpMEgW=hiYMCKw2A@mail.gmail.com>
 <dc973294e5ad2d05705954b433bb550b04a86325.camel@huaweicloud.com>
In-reply-to: <dc973294e5ad2d05705954b433bb550b04a86325.camel@huaweicloud.com>
Date: Thu, 9 Feb 2023 16:05:47 -0500
Message-id: <CAHC9VhQoGNWDOvLU8U3dEvdCa8-23O0JpaeVbUOAa2udEpcVqw@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.210.175
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10616
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 clxscore=89 spamscore=0
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090194
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
From: Paul Moore via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paul Moore <paul@paul-moore.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AK7set/gyzwIbVdcBNq34ovXolGAJFru/qdEdGqxzqLnB8dNXT0qLl/7mTz9ti+D2+MdSQqLp43XM5PhpV37m725smk=
X-ServerName: mail-pf1-f175.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: YfUU86EUJ5ovJI4PC5klj9RhSXa4LI5Z
X-Proofpoint-GUID: YfUU86EUJ5ovJI4PC5klj9RhSXa4LI5Z
Reporting-Meta:
 AAF0vlK/c30CIWpIoqzKrUdsPIfaHw5wVZmhv1LYp8qrt86O5+ttgn2qlDCdyxTY
 k1c2Dium6mtGZbNMt+SxIdLuxh3ICSkSIi/pymcs37EKOs7uNFoKpEpM0yt1BTkE
 MB/+LCNp5DgiEkaDNKNihW7D4FxffH1TDjeyaOJ1Xw0DBH5OMSQXaw2R0kJlwkXZ
 7yetsI4miwnZY64Pan3PmRkiyVCwB29GwAqYhMTUTKy4rbBy9Aq5Lf0Upv4pgh0R
 OIbUkZNaNkBYVV6e7SDNu8nRdT6hDlgFVRljSKXCv4RzpnWhblV3/DnVjnj9997Q
 auExwAdXN7DOWT/+0fYv+FgH4YV6Nz+CSdoLLwjAaRwXDCUiSvVUkLSWog1HX/vF
 vzV3jFc1rCTYNoGE7ct7IHkyeABUDFyvk3VKwcCYfgFqvKspGK+YUYKh/vz8yfcM
 eNylHNZToFYVJp2SsPehDTKIGgvIitVmu4E0eydGIMCFT9S2MkuVsKav4mLSSZ+F
 Zd9KtHgUyMAasUEi/sDU24f6L0dtJZtqdlx+pGNrfqY=

On Wed, Feb 8, 2023 at 9:33 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> On Thu, 2023-01-12 at 12:21 -0500, Paul Moore wrote:
> > On Tue, Jan 10, 2023 at 3:56 AM Roberto Sassu
> > <roberto.sassu@huaweicloud.com> wrote:
> > > On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > >
> > > > In preparation for removing security_old_inode_init_security(), switch to
> > > > security_inode_init_security().
> > > >
> > > > Extend the existing ocfs2_initxattrs() to take the
> > > > ocfs2_security_xattr_info structure from fs_info, and populate the
> > > > name/value/len triple with the first xattr provided by LSMs.
> > >
> > > Hi Mark, Joel, Joseph
> > >
> > > some time ago I sent this patch set to switch to the newer
> > > function security_inode_init_security(). Almost all the other parts of
> > > this patch set have been reviewed, and the patch set itself should be
> > > ready to be merged.
> > >
> > > I kindly ask if you could have a look at this patch and give your
> > > Reviewed-by, so that Paul could take the patch set.
> >
> > I've been pushing to clean up some of the LSM interfaces to try and
> > simplify things and remove as many special cases as possible,
> > Roberto's work in this patchset is part of that.  I would really
> > appreciate it if the vfs/ocfs2 folks could give patch 2/6 a quick look
> > to make sure you are okay with the changes.
> >
> > I realize that the various end-of-year holidays tend to slow things
> > down a bit, but this patchset has been on the lists for over a month
> > now; if I don't hear anything in the next week or two I'll assume you
> > folks are okay with these patches ...
>
> Hi Paul
>
> is this patch set going to land in 6.3?

Hi Roberto,

I had really hoped the vfs/ocfs2 folks would have commented on this by
now, but it's been over two months now with no comments that I can see
so I think we have to do it ourselves via the LSM tree.  It's
obviously too late for the upcoming merge window, so no v6.3, but I
think we can merge it *after* the upcoming merge window closes,
assuming we get ACKs from Mimi on the EVM bits (I still need to review
it too, but I'm not expecting anything too bad).

-- 
paul-moore.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
