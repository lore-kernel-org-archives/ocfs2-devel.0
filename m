Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8927CC64EC4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 07:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HvxLPRD+9xB0TVK0wbTwMytbEpXFOvwgoJ7dxR5oukc=;
 b=ax7cCbMu4x0/U+FSEyAO9Z7ECLYoBE9dODaI4J8T6THkk+dwd2lRrUImRchGd69fGpYkssr5OYGd
   Aq/pBvZzFCHg1JzL4yB+5nNQFpAdhsx4YZTdm9+FMZBOZSLTf3JEfFU0WWqCPIgkgCZUSPqaj02S
   rhQt/d180knl/ejQBVyHRroTSXRpVoJn6IIzjKonwmqpQx7061oRkzSO8pqAF2QKiSEZzekPpPog
   8ofPMtatzezHJtWiJ+K9B4CD8nV2tPa4KBkyjJ7yidsEe0RSX/EvApW+IhLZpjg8k1n4vrRgvufo
   Bj5+1Gd+siNN/B34NtSVExRt1O/N+CxCP9Ls6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HvxLPRD+9xB0TVK0wbTwMytbEpXFOvwgoJ7dxR5oukc=;
 b=OmhxyrUP7SqImMIusTAE5Spu3WX1jP4fYHhNI4B/mMs6Cg61iTFfpq/V3xsqhM6lJR129XgOADdu
   MtzA+hY7lzVlpz6rsD9NFPP5Gy4iO9gcDlTLxH/UIH6MEy1WUdTS59TZ7KLafPA66vePWCcNmNaI
   GifE2CfAGJ2XCc1kWuL3nn1az8HL9blHSK2GyIykf0hZkyA2Gss9ASaE1w+qH9xxGF/VLbeD7iva
   FR2u02V6L04jshAy0/Ia2rIORzmx0YOrVjuUbrs35om7soNAUn4cyTGJV0ZFdWPSOBVh9W/9GwKK
   DrZMy9Qi8cQBMAS/HV/3cV3y3ltOeFf0MtlJsQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00ASLM5TT710@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 07:01:05 +0000 (GMT)
Date: Fri, 10 Mar 2023 08:00:47 +0100
To: Al Viro <viro@zeniv.linux.org.uk>
Message-id: <20230310070047.GB13563@lst.de>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-2-hch@lst.de> <20230310035353.GM3390869@ZenIV>
 <20230310063756.GA13484@lst.de> <20230310065235.GR3390869@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230310065235.GR3390869@ZenIV>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 mlxlogscore=439 clxscore=235 lowpriorityscore=0 priorityscore=203 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100053
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ufs: don't flush page immediately for
 DIRSYNC directories
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: elhbjuI_4y7Yq2VaWgbrG9J-1FBqP7vG
X-Proofpoint-ORIG-GUID: elhbjuI_4y7Yq2VaWgbrG9J-1FBqP7vG
Reporting-Meta:
 AAF46CqSep/JnaHEMtZ0RjDeUF/8V1Xk6MXd6ZxQnu1/q2aNlSJSidF6jJ+iYo4W
 1gvPI3NA0Wd9wPFWYmnB6ElUNn+eBZoFJP0+5SXxp0PUZ0JMN79MzdIkAy3oDUVS
 oWhrfRPk4+XYAtn2kTCIKv90SXcs6ulid68wBxIl/Xr8t3sO1M38hnnTgHbYUhlr
 7VXosJhjWNCortl0gx4TY0Flcqru6bFb9W7tJg76767QOUWPsIZOFHWNIP4Xzkbu
 66M7zzLaFnVjPS4XpXcbb3jda6t643R2iMOY3oXpf2szn03ffpNZf8v5epzTx4nD
 Xq1bHeyChjIHid4/gkZrzEf6V0DZNbuyE4e0IWVYL00j1LWxxvcbbcYQq44cvJh0
 ZUH2/AOZdZ9zL43sy9lAMWQOhUwukv2IVJ0kNEzq1n24LMcgre6NOCskoMt/UWC4
 CCGYrXUprgDGGQ1hHmcabXKLJmJmpPXQCAabqXmfS4fVK7Zf5isA6FwDdwqU1hzS
 ib6iQ00SdPyOru6f8bGh/Hsh6Tmm6mmUwfE9YSYogi0=

On Fri, Mar 10, 2023 at 06:52:35AM +0000, Al Viro wrote:
> > > Umm...  I'll throw it in ufs pile, I guess (tomorrow - I'll need to
> > > sort out Fabio's patches in the area as well; IIRC, the latest
> > > had been in late December).
> > 
> > Well, the three patches really should go together, otherwise we miss
> > yet another merge window.
> 
> Umm...  Do you need them in the same (never-rebased?) branch, or would
> it suffice to have all of them reach mainline by 6.4-rc1?

The latter.  But patch 3 depends on 1 and 2.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
