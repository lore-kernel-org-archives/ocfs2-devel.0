Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FEAC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Mar 2022 02:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t1t3RxIwUkFcBbqvwPSzSGX9bXFpRini4Tm3fNujMvY=;
 b=x8YHWmHfaz7T8xYusbNwSnQ8uEfqySgJimW1b3UdQSz6ZXT94ECeqd66sf//wT9DqZI2OHwo/uUg
   WfxX5DgECdFHCZrg04Tq3doH71K0+a+fhGYpdvejDGuro3ivGXD4axmEnmZfvFMNdfnjjuRCw7RE
   kQeU+et2IegbFo9fzD4LfxoeNWRaPxwvb35U+mM/Ms9+gg7pFDfoFjg3KNF+p4yXMuE/1IBEPZW2
   98+H3UGT8Osf1VPgD1uVd3Fzr45YLRZnLsvflplt9uV7KzH5dFD1UmQ1Bk3z5tocVQNyqsnDomkN
   YkqRB96IRPowPTdUXK7HAasdoxGEBJoB4WPWMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t1t3RxIwUkFcBbqvwPSzSGX9bXFpRini4Tm3fNujMvY=;
 b=mTTQgooNksqY1+vGvOsFOtAI5hFT4zUBMTGwD1vvoSI0cCQLDHihhYpd51WezC4yVWRC4HJYxVaW
   aJGHFHCdSPlqmJxt3eSmPSb+v3ijvE0am8bl2NQuNYj4Js41T8T6zPAYGj5lBVotdiaWUBpXowDB
   xqN6bA7SRYAgpn+9qIORQX8DpHdpfe1V3u6TuwSjV3jddo+GTRjjpDYWWpSr+JsK/RnFqhZ0Htrr
   221YT22k/YUE8W8hVlEoQx7CLVJbzgp0vRVth4GPg752Kirh+01IAbgDtIT+EpR0TUS4iCQF5hrd
   Kg9BQSNU0RmHJDyCNVB+9sCWnHchIGYFR16xwg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9200IZIOOL1F70@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Mar 2022 02:09:57 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <abcbf5d2-c348-7dc0-cfd3-9bcc6431bc64@linux.alibaba.com>
Date: Mon, 21 Mar 2022 09:50:08 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Jakob Koschel <jakobkoschel@gmail.com>, Mark Fasheh <mark@fasheh.com>
References: <20220319203106.2541700-1-jakobkoschel@gmail.com>
In-reply-to: <20220319203106.2541700-1-jakobkoschel@gmail.com>
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=224 mlxscore=0 priorityscore=78
 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210010 domainage_hfrom=8376
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, ocfs2-devel@oss.oracle.com
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R231e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=13; SR=0;
 TI=SMTPD_---0V7h.VvQ_1647827408;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: cioytsB-0oysbs429aPi7nmWeQF33CFh
X-Proofpoint-ORIG-GUID: cioytsB-0oysbs429aPi7nmWeQF33CFh
Reporting-Meta:
 AAFW7mWW7o92Qg6clKBJAa9hZ1y8FHtqS6qFPZVLUSe9ZfVjjEz7UdL2S9ZLpu41
 O/tn1vMxDzjhZrKY0IPyP/lPo2lokMz/UqqCX2WG+wwk3LPXI4u4ZVM/sy9Pu+Z1
 XPsLtbrCg8evlgI1/mJTIfeVosQZ4dwL7tg98x/n9yb7yU0NV86S5iHRdeGfKAWf
 mb7OKg/zvkvhYOPYo0U+oSCYRFVBFE1lD9sRMC+eq8kQ0erB/cvg9E8DhfcZ4I8m
 YZG99O7KttQaS5xZJsa8vyM46APFuf7/OGvvMV9RLFhegOGn3+l2s7TmSj+o5Y+2
 UfsxxQgqCNqkvYuuZUpE8h/LAeOXy/2mikhmmEhxLd/YmYrSkoz0eihoi9S62djn
 ltyugWvD5Q5PspuJIc32WxsHWFJvW7Qp7tfG4nw72BfXnpi72bceH2wpDLGBK6Tk
 xnkBpdoVz9dbaDBB66OupK3S8ZlLkgrDriYaeeVFBij+F5x2ZZi57vH3LGzOIkta
 JRpSs9tn0bujsy6d0oFxD0Lt1Es7+VD94ajh9+jZqK+s



On 3/20/22 4:31 AM, Jakob Koschel wrote:
> Instead of setting 'res' to NULL, it should only be set if
> the suitable element was found.
> 
> In the original code 'res' would have been set to an incorrect pointer
> if the list is empty.
> 
The logic before iteration can make sure track_list won't be empty.
Please refer the discussion via:
https://lore.kernel.org/ocfs2-devel/bd0ec87e-b490-83dc-2363-5e5342c59fa4@linux.alibaba.com/T/#m96d4397930201d83d68677c33a9721ae8dbd8f15

Thanks,
Joseph

> In preparation to limit the scope of the list iterator to the list
> traversal loop, use a dedicated pointer pointing to the found element [1].
> 
> Link: https://lore.kernel.org/all/YhdfEIwI4EdtHdym@kroah.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
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
> base-commit: 34e047aa16c0123bbae8e2f6df33e5ecc1f56601
> --
> 2.25.1

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
