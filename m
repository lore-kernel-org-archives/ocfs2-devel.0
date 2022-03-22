Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 528BAC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Mar 2022 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s/OJYzn7PVdux8lZgZsDY5A06K9Y/jXCfvyGMXs+e9o=;
 b=SBSg/V4R7L8sMAeZV3TLV+EVxehQ3RIwX1KV2dGhkhIkUC6wEH85/Awk16NM64hsLgdu41k5kR12
   fL5TWFFwBQlM0KmFZ+Q5VbAdprlp3PE7g2tMD2eVCcM3ukhdqKFbAz5Cs+wveF3vZ6GvY2AtGu8e
   JYIhMGJmqtHNbTMea0xJAgc5hX9GY1xD8+UwTMmQxrlXc86yOH1QnfcF9N9zqTC6sdwoRvWpUGf/
   IHcUMEeBG5tI5h9aSFwH5QoKxoSxCHxnAWA5vcj9A3T0pLe7UTyLIQXwOQxOABz0S2ee8hMlDA5n
   V/NDhgsDgK2X07X1eVBIaqi+dGr+yq9mg71nJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s/OJYzn7PVdux8lZgZsDY5A06K9Y/jXCfvyGMXs+e9o=;
 b=M9mLA/5JXvxjmIAbIvi5erb/vIgSkLmUajmoCxDVWFA/+k/UxeRf5MKZXxFHlO6ihzebH0I80d7U
   yyuVwXlfWFtBtDoQOtqiGxXQoKfVvPxG2PIvGtjMLnDyUzpJ8kdNHndtDYRRSTSJE5ZoiCHUvXQX
   L3yV4K3DARZxqLHN7BrELpNO0nt7EWoQIlE+NoMw+XCuV9k04xUje2XjltkRXUey5mlA77O0U3/3
   D/xG+OwzT55MklS9zHrxKg0Y6QBHsWyV8u2nmThU8NcmeGbFd0dTPrpJlzdaZEI4xKkGKQH1HBz5
   eP3xkxdhWAZDXey+kDTcNqnMpEL0/CE+Rp72Hw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R95005SD7MSHX60@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Mar 2022 10:54:28 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <47807b41-566c-f0b6-831c-658abd60861c@linux.alibaba.com>
Date: Tue, 22 Mar 2022 18:54:07 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Jakob Koschel <jakobkoschel@gmail.com>, Mark Fasheh <mark@fasheh.com>
References: <20220322105014.3626194-1-jakobkoschel@gmail.com>
In-reply-to: <20220322105014.3626194-1-jakobkoschel@gmail.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=188
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=30
 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220064 domainage_hfrom=8377
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: remove usage of list iterator
 variable after the loop body
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R741e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=13; SR=0;
 TI=SMTPD_---0V7vuOEs_1647946447;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: I-08pQ6ZUHirVUSgKws2Xh4zDGK0vJwH
X-Proofpoint-ORIG-GUID: I-08pQ6ZUHirVUSgKws2Xh4zDGK0vJwH
Reporting-Meta:
 AAERUGvYH2rcqINUR2FGSWwEVjT6QObAxbpSi+lQukJGuJgl96bwc171+HtvNGEy
 ZtlKdKeMeLAFR6PK/h200yvAIfT+mo5KUuDNmZ6y13kVt+vOlFQLb2HSxlU17LJ0
 qOtlYnwUGTG9B3Kq5GqGGToUFv/i2tGvlhASF+kcCKDMfI5fb3L9JBzABOLSOYfs
 NaqW1+LpSYQKQmEJsBSQ+d4Hzw2yKFrrHMMxhi5+PNtMaT/wz6Zuvv/y9e79IYGo
 7/oCRN+I7VYoFWmWipl7lQ9IPn+IARMTy7+WHfGCtuYUc3lXc55xhSfEOrWsa8SP
 LtIdrFa89Udzo6vftMq0Kx2IwbSibKgzblqEqwnYsMoSLF620naEkshpb0i8XoX1
 aOvGSu/Hqt1CGDtBu15fbggKBjHU9cDDMExCeTmw3yeYwJWE6Sd48AfaiE2Ilieq
 llSV2GE1sehP0XsthN2kf+a0ZMlKJTcgofREOf6f2vd8Haj+xu0Wh5rwNTjdRc+S
 UjGo+VPQ2S+rmNflhhSgKFg20/CP52W0Q8FWzSnr51u9



On 3/22/22 6:50 PM, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable [1].
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Looks good to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmdebug.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index d442cf5dda8a..be5e9ed7da8d 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -541,7 +541,7 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>  	struct debug_lockres *dl = m->private;
>  	struct dlm_ctxt *dlm = dl->dl_ctxt;
>  	struct dlm_lock_resource *oldres = dl->dl_res;
> -	struct dlm_lock_resource *res = NULL;
> +	struct dlm_lock_resource *res = NULL, *iter;
>  	struct list_head *track_list;
>  
>  	spin_lock(&dlm->track_lock);
> @@ -556,11 +556,11 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>  		}
>  	}
>  
> -	list_for_each_entry(res, track_list, tracking) {
> -		if (&res->tracking == &dlm->tracking_list)
> -			res = NULL;
> -		else
> -			dlm_lockres_get(res);
> +	list_for_each_entry(iter, track_list, tracking) {
> +		if (&iter->tracking != &dlm->tracking_list) {
> +			dlm_lockres_get(iter);
> +			res = iter;
> +		}
>  		break;
>  	}
>  	spin_unlock(&dlm->track_lock);
> 
> base-commit: f443e374ae131c168a065ea1748feac6b2e76613

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
