Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBD7C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Jul 2022 10:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iTWaMRRw2fLs6jXFlhlSsoadseiTJGpI/DFSFAXCWoI=;
 b=MIDi0sdICMPdTYL9c7KvPNRGv3O9GJT8/jVE1dfbd5IKUf176RkmcutGCnFoW21Wov/wBUI/sq6u
   ejMp7Zb8MnIHKI13AC/S22yafpiWHgzL0rq2STHv10klRVZrBqmtKeofZLtXMuzWbfEpW265saF5
   luCYq/ohBpUBybbphlJRUUjcI7uoHoNxMvfBraPU7NW1RzR9D/Of2/3pLsWeb7dKdZILpAc/I7S1
   oZVqrxmP2M5YpltyOPJx+mO213wBxdGVlOnbeC3NP+nnNipR1Nta8lhTjF5FqsZYWBoIsxqGLWLa
   fTOeobogdkj7dqvfcz+OoiyZ8Rr2+oe+E35KyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iTWaMRRw2fLs6jXFlhlSsoadseiTJGpI/DFSFAXCWoI=;
 b=Uv4GjIx2AwapR0XNqjUv7V6SdRl43BfdBq2pu/Ip/JUpyztifEQaCDlmv+J+W+sEBLheOf7wg7+0
   9EvBSONZ7Xk9eoIP9+5RTx19sb8KcaQA9wzqqAGN+s/bqc4rrBLEQGYXOaOCtW7KvDmP3YADaJ1r
   3RgSyyFmoAXfprlihoSPrrFThNjVflUiN84wrSOutwhOLkiH3lnQ2ITLynFnbbCr/JFSQdnkL4xE
   3oQKeHihlXNh2ppbgB+1ciQvoaQeB+8NPhxc6wUiX5fwYWwRPGwbfwHBjx4narjUOetaG9TH64xF
   /4H+V7CdxkP5qDYyPJXTpyd0+u8S49Gcc4O2/A==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF900EXMJLNJ330@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 19 Jul 2022 10:24:59 +0000 (GMT)
To: 'Christophe JAILLET' <christophe.jaillet@wanadoo.fr>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Thread-topic: [PATCH 2/3] ocfs2: Remove a useless spinlock
Thread-index: AQHYm1a23J7AKlhcsUK1MlCgSmBBPK2Fe4Yg
Date: Tue, 19 Jul 2022 10:24:41 +0000
Message-id: <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
In-reply-to:
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
X-MS-Has-Attach:
X-Originating-IP: [10.202.205.107]
MIME-version: 1.0
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=C51A453
 smtp.mailfrom=david.laight@aculab.com
Content-language: en-US
X-Source-IP: 185.58.86.151
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10412
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 clxscore=30 impostorscore=0 priorityscore=48
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190044
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/3] ocfs2: Remove a useless spinlock
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
From: David Laight via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Laight <David.Laight@ACULAB.COM>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 3JDAf-T3MjuitJ0ZtV96nw-1
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
X-ServerName: eu-smtp-delivery-151.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:eu._netblocks.mimecast.com
 include:servers.mcsv.net include:_spf.act-on.net include:aculabcloud.net -all
X-Spam: Clean
X-Proofpoint-GUID: WVGEeMtOJ690H6Sa1VYiyVG9AnLUyaX6
X-Proofpoint-ORIG-GUID: WVGEeMtOJ690H6Sa1VYiyVG9AnLUyaX6
Reporting-Meta:
 AAHAUz55sJEt6YHPSthJ6zCAG//+awkQE0KY09+9ddvBATA5g3Ea9MUa3K7bWjR9
 nrWLdY7n7fOF29eoYUXzT38KtdoSP0xR5I5emeaulYaDZpycX4X87v+XRcXSBNk0
 wOPN3XOapbxaOrZmwGyhPmf7WNI59srLdYGCP4y949wxsNrLBqcK1arwxB2lrDZG
 l3G88m8n8yl0PrBGWpVFaBs4qvPDvcbwDf9oRah3Db0KF/S4OwiKlKUEMYBWV3fl
 V1aFz09Fm6Gcr0l2zUuwGj9Cm79a/JKCSlX/x0NyLFZfftEm/YOrPEkBtjdMueJm
 UPKQMD0djIl5pkczgqXp++Koebf7DvRXG0174fGd72vS7MHqnBgS0eLfbhxcxDkV
 dUcPu7amTSG+OfvB8uqr0rvnKfbVdOEAsX2mWg4CFuyuH4+y6SkWCfDBL8JfOTvp
 FnFA3EoSz1zG3XsZO54G34+RscXcCgntmxuABcv1aOGpLJjZqdCThSVSl64+TOKz
 xKTpb/IzmqjuyWy+bH2xwcJd6YR7CX9b3Aa53lvHvMvm

From: Christophe JAILLET
> Sent: 19 July 2022 11:02
> 
> 'node_map_lock' is a spinlock only used to protect calls to set_bit(),
> clear_bit() and test_bit().
> 
> {set|clear}_bit() are already atomic and don't need this extra spinlock.
> test_bit() only reads the bitmap for a given bit.
> 
> Remove this useless spinlock.

It looks to me like the calling code is racy
unless there is another lock in the callers.
While map->map is protected, the result of test_bit()
is stale - so can't be used for much.

	David

> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> test_bit() is NOT documented as an atomic function. However, I can't see
> how it could return a wrong result here.
> 
> So review with care. There is maybe something I don't think about that is
> lurking here.
> ---
>  fs/ocfs2/heartbeat.c | 11 ++++-------
>  fs/ocfs2/ocfs2.h     |  2 --
>  2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
> index 1d72e0788943..4863ad35c242 100644
> --- a/fs/ocfs2/heartbeat.c
> +++ b/fs/ocfs2/heartbeat.c
> @@ -35,7 +35,6 @@ static void ocfs2_node_map_init(struct ocfs2_node_map *map)
> 
>  void ocfs2_init_node_maps(struct ocfs2_super *osb)
>  {
> -	spin_lock_init(&osb->node_map_lock);
>  	ocfs2_node_map_init(&osb->osb_recovering_orphan_dirs);
>  }
> 
> @@ -67,9 +66,8 @@ void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
>  	if (bit==-1)
>  		return;
>  	BUG_ON(bit >= map->num_nodes);
> -	spin_lock(&osb->node_map_lock);
> +
>  	set_bit(bit, map->map);
> -	spin_unlock(&osb->node_map_lock);
>  }
> 
>  void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
> @@ -79,9 +77,8 @@ void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
>  	if (bit==-1)
>  		return;
>  	BUG_ON(bit >= map->num_nodes);
> -	spin_lock(&osb->node_map_lock);
> +
>  	clear_bit(bit, map->map);
> -	spin_unlock(&osb->node_map_lock);
>  }
> 
>  int ocfs2_node_map_test_bit(struct ocfs2_super *osb,
> @@ -89,13 +86,13 @@ int ocfs2_node_map_test_bit(struct ocfs2_super *osb,
>  			    int bit)
>  {
>  	int ret;
> +
>  	if (bit >= map->num_nodes) {
>  		mlog(ML_ERROR, "bit=%d map->num_nodes=%d\n", bit, map->num_nodes);
>  		BUG();
>  	}
> -	spin_lock(&osb->node_map_lock);
> +
>  	ret = test_bit(bit, map->map);
> -	spin_unlock(&osb->node_map_lock);
>  	return ret;
>  }
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 740b64238312..1df193b97c30 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -302,8 +302,6 @@ struct ocfs2_super
> 
>  	u32 *slot_recovery_generations;
> 
> -	spinlock_t node_map_lock;
> -
>  	u64 root_blkno;
>  	u64 system_dir_blkno;
>  	u64 bitmap_blkno;
> --
> 2.34.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
