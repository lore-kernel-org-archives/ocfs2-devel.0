Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45F6C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 18 Jul 2022 22:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KecRI0mexQzfTYr6lw0+DNZspyDY1LZuC9PdDynGaDU=;
 b=m7RNdiAFCXyrrz5kj0NWQCkFSATHW3VwWyjbRAJNqzdTc6+dQAnHYMnE7WIbo95W+HkcHVnbmmJr
   9RUooroWM0xhTf0oA9zMBgvCiv52jzbqzy2mQu3nvt3ssowm1twPucr0rHK5g76NXiYyM42/E+7L
   C3gC9w1Q3rY6v12IW3qEAlYaXae3D6iR16RhJbfrktMIc/NRUQA37mEkvGxmLTpxpw70Y7rXKtnp
   tMG5O1OTJq+FWs/FFzTII+c1VbkncufZXQcm+LUp+ira4nr3waZNlEkhEfqgkj3w3ZzjiAgyM/CB
   twvq208oozT2ojWfX5X7wkX53e+MRFlmRtBCxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KecRI0mexQzfTYr6lw0+DNZspyDY1LZuC9PdDynGaDU=;
 b=E2bSEzywEZ11r7m9SVWiA+ygAouH1i9iIKEyme8I51+rOmbiFsOwcxBR99mf/YO6Vc+hcgzcuy5s
   DHRwJ3KqBben9SrVZ7Tg2KlbDX9dKmTmD6q4yJMrh0mq0DJP6HrL10aqPy4ssHFdiflM4zWC/QLP
   KXSmqtuhf/XK0Us5wd/j/By0y2QqdQE4qtlcSKQXOSdDrLs74fl2r6nQTcQrNjwiYvDmwcOHMpwF
   KWmRuTUeBy4sCsO13RL+Sg7tnj25lRkT/WUKFmWXmE9w9nnQgbsUFZCZR+lixGk45cQXLyrCdZaI
   VJcYXPAbY06tpgTExphXhVo4EJyQP9FhEK8XgA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF800G77LMRJ1A0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 18 Jul 2022 22:11:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1658182255; bh=wjCqlJb5mdLBg9S96HrZmUtZ7wJPBB2quUuE+28hv4g=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=vVK3HRZ6g311Y9K7idM8LHeZDynX8ZIuy0qmRe8eaWJsQ83NckueTCoPjiFVBamVH
 T5WJc3kGJnN1BebweB8lHyLOw+kGMd3TkzUrlhfMtI1DpPgTDPETHP2g75MVJZxQV/
 gMeNROIVBXfMIs/HoRGxh1XR0Mp7oOGrXKQ2VF3s=
Date: Mon, 18 Jul 2022 15:10:54 -0700
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-id: <20220718151054.26c12e2f2c846df400b3dda5@linux-foundation.org>
In-reply-to: <70bfaa1f-9a33-406f-3998-e185daea48b3@oracle.com>
References: <20220717043751.51CD1C341C0@smtp.kernel.org>
 <70bfaa1f-9a33-406f-3998-e185daea48b3@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10412
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 clxscore=183 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=85 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180093
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [merged mm-hotfixes-stable]
 revert-ocfs2-mount-shared-volume-without-ha-stack.patch removed from -mm tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: dlX2hXzfi1lTLCXX-5vm5bV9xB6keIm4
X-Proofpoint-GUID: dlX2hXzfi1lTLCXX-5vm5bV9xB6keIm4
Reporting-Meta:
 AAEsUFNKlZZAWuNilrusvgj2SIU7MoXZHUpeifkJFAWjQRljfJCiWLJpHhTPweyz
 jwIaKYBGvRh5fCAlAWqXBn4fwGNiGUdmFY1+KtyxQmxjdmFBSfKtfqL9OJsD4IcR
 p/URTrLoScYM2PlAondXhhUmcnKuagccx0u34Lc6qlzCajrXkKBl+A5zFmEdMcI4
 ONJLY2FWXcnLc9PgMFwMZpVKftdirN+0dyd6X29wHDU3BGoLACfF2HrRmQNM+QsN
 8Yc9pU/c15xStwzdwrAp+R4fALn6Y17utzBX9N1rm3Wo/iDdE3OOKMlMPgYwJSDQ
 nGmSvfSMawUo8wEB4Us+vLszAvwFVQZ+uWVO7EsfHTj8y0lyFaSSli8/3D1UwtHg
 sfTgWpkeqrNCw/myWiPJyC5IaYAMToecFN8YKrtD8hhVx1YPcvCixfjnISI+ZbEq
 zB22edZIgMKkIXh3ZphNgDOUZKZqHAoou0vl0KO1Qfs/cMGGuplPkEbevfpKUFoW
 hfiNeCrMyuCh6ZY/LKsvG84i61ngsdnTGpoHVCSLJoGv

On Mon, 18 Jul 2022 11:07:11 -0700 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Hi Andrew,
> 
> Can you help fix below "From:" to "From: Junxiao Bi <junxiao.bi@oracle.com>"
> 

OK, fixed.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
