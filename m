Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2076C7EE29
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 May 2023 02:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E7Xo7h4fzZLhtY3Da+Kf5pP+boYAXdT2tVyjGt45rJ4=;
 b=W+AQL0/MFMkw1XX+OrrGLRjY+w1md4HJQ/UydzTeBRJdUY4b03fWoXS7ETVbOVwhdDKhFIJdY6l/
   tC9Lw94vfnwag+tfoNNDgTXiA2RtpgiKUKz/mSHSAP0N00NlmN/OCzqfiXyzoZ5EEFvAnO19JKA8
   nwYPMiLfRpdRPcn1JCJzrE4+GNCS6x5W2KcitehP0zCYEt8XsbQcPem9phtZaLb2321s4nAEb0xH
   9O6JYvPbinuoJn7lPzPJjD/HocHA8bzdOG89GA3DluDJqnMZnULfpYApDyV6/n/0M2PV0mpFCgjZ
   LMY0VWLVjYiy2gmztczHBO/2iAtXHa3IfawSyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E7Xo7h4fzZLhtY3Da+Kf5pP+boYAXdT2tVyjGt45rJ4=;
 b=BST8lRQaNfhNlImdH6Oeu/RJgv1tYFHOcE2cS2PbpqX3R2Yn59Ax+tlQJ6cDgfGtvYneB44BRKY3
   aYa0UtKKp9k1nVfwvpUN3wgeaOglYMxDQveL7CzjAqH+iF/j6M+fAfrR/Y7RhDtdOHTVsg5MKBEi
   N3H9SwjiX0wCsIwcLoAffBaALPHxEs0HWXg46LXM/GO6p1taGZcsUS9nWNP2R2w+oHNN68uhX71h
   p1lKZZXc0Ru0sOYLrynCdi+zrLuiTZNq7SWMU6quEWjUcmtxJiB3o1jNUYLH1AWbxNgRiM3TUzcN
   vwMzJZEEPxzSZ5DyXu1/7BKGP5MyawRohIVCiA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RV800KV9TU6NTA0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 26 May 2023 02:06:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1685066748; bh=CZVNMtCm5jpwGorIKHM6illuNcoGDGGaYsqfZ/1LGhk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=BrYVWe1MB95Ir3/gCbUm3NfEU9DuFhaAZkp+N4mXiGQe/whqg7SFqMStNaUuwKd4x
 s1VcpleE9PnchQe9/Pt8CneCI1V38CaemMd4dYW0edgXnEx9SFmedg9tp4zfe5XwIv
 ZpyOzc1Hu6tx1FMmdS43YWTMWHa2SFBwK0AI+xBU=
Date: Thu, 25 May 2023 19:05:47 -0700
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230525190547.9e8d1694ede16469b5899a04@linux-foundation.org>
In-reply-to: <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
References: <20230525205556.680DCC433EF@smtp.kernel.org>
 <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10721
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=873 lowpriorityscore=0
 spamscore=0 bulkscore=0 priorityscore=78 adultscore=0 phishscore=0
 clxscore=158 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260016
Cc: mm-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] +
 ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added to
 mm-hotfixes-unstable branch
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: VIw3F0KYB5W1iAxJRmy-C37IrM1d2kY3
X-Proofpoint-GUID: VIw3F0KYB5W1iAxJRmy-C37IrM1d2kY3
Reporting-Meta:
 AAG6H27KuvmTlV0srDk+lHw7Zq4h5BKMhCYuuTH0e5KAnGJ7fRylZo6AN9GRjz7c
 EpMh9HiXB/rG6r1h5XDifUrDhvrqHfk9cybRZaIQYRzfY5CYUz/48N3lyNQGvuG2
 mYFAOyTHSMY8tINRnuE/Q1Vdbjmmm8IdLhLu2WgT0OnmzY/5zw/Vx/S4UWroWj18
 45iVgKpGa72QiucduErqnoLsbcmDLiikjsyrNzxSaNF/bXdbJmjqZ0cv+HqslxFV
 dPOM/NXJcqFjenCO9cmXcxMn7GlB44Q3VOKBrW4NqneLHQvsW0WAU8wtf1+YwNNM
 TyOpCO0XX2ZcpfeiZm4upAyz6GdDk82BOK0sIEelWn7Ek+QJibCwDsatzk27tsAM
 HYwqKWPxzS26KMb8DOSG67qpLtsqBkSftPsvD6JNvy6vNjgc1kx6AD2TjAFatfXa
 907Z1i2tAKrxpazpMmmK4FrD7UyYUOAK6crZfetEISnHxKpQnfSWZJ8G4RaDM97Y
 A/QnBRzZ2TiWgjtWiOGXkyVpP7rKXdbjBIgZ9AHXHQ6T

On Fri, 26 May 2023 09:36:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Hi Andrew,
> 
> There is an updated version v2, which describe more clearly about the
> case:
> https://lore.kernel.org/ocfs2-devel/e9fc4b2f-1fcc-7c31-f346-59eccff50f9b@linux.alibaba.com/T/#u

Sigh.  Thanks.

As you can see from the above link, the email never hit ocfs2-devel and
never hit my inbox.  I'll piece it together from your reply.

The ocfs2-devel list is really bad.  Can we move to a vger list?  Or
get some maintenance work done on ocfs2-devel?



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
