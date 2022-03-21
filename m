Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF41CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Mar 2022 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JUk321u2vV8RJ1HZFWQNnXUnKHlQwlXxDBZ+csRryw4=;
 b=yJ8Krg1cTwQqbU4DSe/vF9AVwibIyAfmg7F4A1CZ6DS0NrCLWY5yG+OjWvPkqAAextdJf2J+ShY/
   sPOdfaAl5oN6KGLHi/5DjVhbiwn4lXfto9YJSEvfPI3Lp624YO5+cL9nuc0SUsu50jIinrT/Lr2N
   TZZnFUfizgXEIWNSwro33kVb/STm50ajLqpGMSx1Izlww2bQ2gNB8x26pp/MgsXCfCzaJQ9fs6ld
   sTyWbT/RG2Dnf3qUliQK3FvUBSmYodK+e8SXQeyX5KbFvS+FO6rjrKhoR96k1VD4erKwWtQ3AkgN
   JB4dNbLAK7njy5CzkhmaGZXrY3Jv8KOrZtFohw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JUk321u2vV8RJ1HZFWQNnXUnKHlQwlXxDBZ+csRryw4=;
 b=s7GTWXjiJibvV39n3ncg2725T1pROYtPRucUB8wN+6mm5LTQVHN32L8nZNgLqQ1BJv0Dgsa7G8te
   0ttuIXyl6mtsJV9NtbrBMW1f2qQKbLsAV4V7GUmPGndHTfRD5zXxhPT4hahHgNnEO2i9ncTfBnU0
   he+VF+kFLYunnrDRfT1Jl8FGAmOjT7WXhBnt5MO2Pcnj5LX0UMuUWk7x7zgFyyRKzQMFujoGpOBF
   n3pf3tTVi6Bnl2JTRHSakn3mcb63hTsVKRHxDC3abdTec/i+okpV0DWZZA8WBA++oxlWij8nicAf
   QrH3NzE013OrA3cMjMIWESGAMRvs/C8YnvGpow==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R93002LBR5YN320@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Mar 2022 16:01:10 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=david.laight@aculab.com; dmarc=none header.from=aculab.com
To: 'Dan Carpenter' <dan.carpenter@oracle.com>,
 Jakob Koschel <jakobkoschel@gmail.com>
Thread-topic: [PATCH] ocfs2: fix check if list iterator did find an element
Thread-index: AQHYPSvRVnhy0IZf6EGgy069JPLEqKzJ/HWg
Date: Mon, 21 Mar 2022 16:00:10 +0000
Message-id: <75180dd18a3f460891cd93f7fcb3aa1c@AcuMS.aculab.com>
References: <20220319203106.2541700-1-jakobkoschel@gmail.com>
 <abcbf5d2-c348-7dc0-cfd3-9bcc6431bc64@linux.alibaba.com>
 <A7AA04AA-6B4C-4211-99A6-0D3C04ED7B26@gmail.com> <20220321135435.GL336@kadam>
In-reply-to: <20220321135435.GL336@kadam>
Accept-Language: en-GB, en-US
X-MS-Has-Attach:
X-Originating-IP: [10.202.205.107]
MIME-version: 1.0
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=C51A453
 smtp.mailfrom=david.laight@aculab.com
Content-language: en-US
X-Source-IP: 185.58.86.151
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0
 clxscore=-112 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210102
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix check if list iterator did	find
 an element
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
X-MC-Unique: DZcqY6ZCNM-Zxa3ztE6Iiw-1
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
X-ServerName: eu-smtp-delivery-151.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:eu._netblocks.mimecast.com
 include:servers.mcsv.net include:_spf.act-on.net include:aculabcloud.net -all
X-Spam: Clean
X-Proofpoint-GUID: c1xrPQUTdc_xxdDXpAt2NwHbYcd056DU
X-Proofpoint-ORIG-GUID: c1xrPQUTdc_xxdDXpAt2NwHbYcd056DU
Reporting-Meta:
 AAFhE0+hcnUjF7lsmJeVj0wIKHHr37iJI76yKkEOBtSoqp5DDN7mJhMS/j4yttX7
 2A5wo3HA4x41cq/oop21kcaXVTe+8TA0GSc4lWoenHIH+YGvuqaJ492AzaObBOY0
 dikYtul4iMmxa5+OGcGUCrryEh5LGkggD7D+j1Q6pJIRJm8RQhw5UEP3wDzrx+SD
 cPEXfaSQsD62i2iL0i5eVe/U9Yjqg1ZMHWD7k2XUYB+2ef3vjCCSlly84B2djZdU
 J2uW/OrHDN+YKV//WBbAydLvXg7cx+XL3WD4R57xUxjOwUcnm1IzuSSoLKK7KCc8
 7U1dlrPzGMiI+92XhRQnzOxCh2IBA1JYkhOxdJHWTZwGnk2ItbvRFU24vhpnN3oY
 JgpDcJLfWGkdbhUXtxo8GVGY6Q7xXvh/n+c1R1P1hORJBlZWwK9+cD7D9/rHJCj2
 +TX7HId9WuDDTy41atoVrc8/FOpPI1S3B9Qj3rXR3dRItcAPikA55jzMZrh4FWMV
 rTH9PtAen1EF+Sevfw9h4tQ5Z55ltfJ9rXnPkWDLg0g=

From: Dan Carpenter
> Sent: 21 March 2022 13:55
> On Mon, Mar 21, 2022 at 02:34:34PM +0100, Jakob Koschel wrote:
> > >> @@ -556,11 +556,11 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
> > >> 		}
> > >> 	}
> > >>
> > >> -	list_for_each_entry(res, track_list, tracking) {
> > >> -		if (&res->tracking == &dlm->tracking_list)
> > >> -			res = NULL;
> > >> -		else
> > >> -			dlm_lockres_get(res);
> > >> +	list_for_each_entry(iter, track_list, tracking) {
> > >> +		if (&iter->tracking != &dlm->tracking_list) {
> 
> This is an open coded version of:
> 
> 	if (!list_entry_is_head(iter, &dlm->tracking_list, tracking)) {

Doesn't list_for_each_entry() terminate before that happens?
So this code is probably still horribly broken.

My worry about bugs with these lists isn't really the code
that uses list_for_each_entry() - they are fairly easy to
locate, read and fix.
The problem is all the other code that is scanning these
list in other more obscure ways.

It really isn't a list structure that is easy to use at all.
It's only slight advantage is that you can unlink an item
without knowing the list head.
(Which can stop buggy code generating cross-linked lists.)

Unless you actually need to traverse backwards the 'back
pointer points to forwards pointer' list is much better.
Even if you have to maintain a 'pointer to last' to get
FIFO operation.

The other option is to double-link the items into a loop and
have a 'head' that points to the first item.

Both these loops have 'pointer to items' to don't need
container_of() and get better type checking from the compiler.

	David

> 
> Ideally someone would come through with enough confidence to just delete
> it but the second best option is to just make it readable...
> 
> regards,
> dan carpenter
> 
> > >> +			dlm_lockres_get(iter);
> > >> +			res = iter;
> > >> +		}
> > >> 		break;
> > >> 	}

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
