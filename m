Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A6BC77B62
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R09/0ZaM2WfgB4wa7oYbW9UAbCFh1AzUM7zlnQGZqwk=;
 b=CYjmMYfnIJVPdG0qJ16VIDzQJ0NRrKF4XfpBX+JCs/vHHT7vSy/pRrpSSS0YlaGc8NLRBxyrdhBV
   A94hKFYAJKM5H0LRDWM9DWBZrOsPEUlNQV+Bxq+JsP0M8HRzOOKq+2uGgVWLjvz2vuTbpenV1O7G
   FKCByUbQJR3RN/PrDTm4r2jQbq1D6wU0DRGG6Q4k+w1eiLLoXE0dkNLQYmgSNiPU/DCWuYqRrpyO
   i07Wr1oS6jRnQJnd8Mtw1+8f2MgH3/g0TGGZ15+JJmbcqtjLyYl4IES/Tj7ffGWH8BYhn541pkaY
   /yfg0TzhSr7JNItAK7uwsF98BBagvJY+bUpzFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R09/0ZaM2WfgB4wa7oYbW9UAbCFh1AzUM7zlnQGZqwk=;
 b=UURSDKC0BsGJXXv8e5pwJo3cM6vHfWu005pgHZg+6DGIVYvpc7UWFzFkm0ggzzFKFwWBpGpoTDMV
   4bu2/K+QnXWA2m9WQHi5DbOgeYkbVj1KQBYPs5K99WvFz9dKin5LfK+M42T5RI11oqzYU15mS12m
   AcY1+IJ4qjO6losTXhoBgQl3wh5NjlAqqfW5disdGfrB+lHxdRspvt4cDkO2Q+q6yKsAJXEG+g1U
   wRc+FUm1XVsI6ZccJdVW5ZKdaUPHsJrcFgp6XCBDUHyco31YeGodAUqZ20k60pIoEhFnTI+Ac+5t
   SXX9K+CVDw5nSpsOv+Bk9sPhjNlq4jVabaKnvg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00KGWM1A1T20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1679285333; x=1710821333;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=f0RzrlZk36B8QlnIxOLMByV1TWNDOIMn6+7Rb8kJGp8=;
 b=KsZlxUiwQDGjdkTmkrvrtHm2Ac0w4A4LNzQA44pooXLWcm9ARvBUBWqz
 68sfFVtLwouMNESIN1vNmngFHuGjk4olW/axnULgu/ijkt5sYoKiDoue1
 k/iTBy+2kNUDrE9i+470oodAE23l+OzMBSQY9Vcd0ElT+GLhKJdJwO1H0
 UD8x6Jw3iE5PZ9kyX4anOKzd9QbBbguJ5SCP20tPiczkFhyr5JsWmeRZm
 +OKMkJk/MkWWmnpu1uujUQdupU2K8ZPi2oq0w0ZYaVtOh7t0Om6d6LoGE
 +Da2A3nzIljvi5Ab0nLw7yiiRswIlj114UaQ8uIiridmxVrSGBtCYBQCn g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d= opensource.wdc.com;
 h=content-transfer-encoding:content-type
 :in-reply-to:organization:from:references:to:content-language
 :subject:user-agent:mime-version:date:message-id; s=dkim; t= 1679285331;
 x=1681877332; bh=f0RzrlZk36B8QlnIxOLMByV1TWNDOIMn6+7 Rb8kJGp8=;
 b=esT6TiIT+uoup3kWnY3xrSB3cYopIRmWLNhiVbZ6b5Myup6B95z
 p61YIXMydR7cv+BOtazS96fyHYNv37OnHrWVo6KCl4jC5ieFCwmxLpn12eg4/ysM
 pS91jjTlyfK5IAAj0Q5zaqAOyizcA9mGTXR4Q9eq3vYIamyUJ8etCo+vOy9sjk7l
 p6COnj+QZSprV+wuLiGHG6enDxDehZbJdOfQd1HClGCeQ2lGXZdLd/Qb+7pT/ebA
 Y3GEWaET42Y/8pV3BDj2JZueEuXtNYDsemmR9wfaJ23SwWvVQpUoQVjpDABRoBk6
 y7rjMU3wwH/4BD2261pJ4P51bH/Uqaj+DNg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Message-id: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
Date: Mon, 20 Mar 2023 13:08:43 +0900
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-language: en-US
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
 trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
References: <20230320033436.71982-1-frank.li@vivo.com>
Organization: Western Digital Research
In-reply-to: <20230320033436.71982-1-frank.li@vivo.com>
X-Source-IP: 216.71.153.141
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=166
 impostorscore=0 malwarescore=0 mlxlogscore=632 adultscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200035 domainage_hfrom=11266
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2,
	RESEND 01/10] kobject: introduce kobject_del_and_put()
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
From: Damien Le Moal via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.98,274,1673884800"; d="scan'208";a="230974290"
X-ServerName: esa3.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 exists:%{i}.spf.hgst.iphmx.com
 ip4:199.255.45.14/32 ip4:199.255.45.15/32 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: wmaCD0rJvapVvOkQq8SyKux7E8Okll0r
X-Proofpoint-GUID: wmaCD0rJvapVvOkQq8SyKux7E8Okll0r
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAF02BGhImLHMNZIAH1nTrGkmS6CHrEI/3yXJeVzsrKABtCSSCFaeTgZ4+445iKS
 Yca9mnK3PNLatfOtotNIJiU47C5TaC+2oc5Npv5BWYIePkeoSkzraBYKOnH97Vh5
 5u/UnVQDoge6lf2E0vtFqYlyISSSJkBaXDgK5KDuJVF04BKpd6mbK9xTC5M3v1sV
 5hjAQmG/IUSrsySAFkgGa9sUwfBAhOxoGQ2i2g/kja/E2OTeNGrqyc7xaXcqvyiF
 AUj6+7qDlo3m0JhZlCmkKTxUm/ag6L/vZQIGlyhikWTO9VGYwcbFr3at0w86fzXX
 T0PwQXRbeEd73sZX5dweeHd4qpEV+hF34ZZeAAu7f7RlNK5WpkGtTATQwqZ4XV2I
 7qOt7MlD91OZwC0E30z99LMYt+1BEc+seX/2uW7LipVJ3+5n39FE1H4l3O/RPdyX
 jIfzSyZUsuZ84US1MXWRHxlIH3khY7triRNni/gbSCgZsbnohbUAsBA9t8iF2kEQ
 oUsO2p0Mqp2wofoXMQmSC+Xyi+7rO9r5f13qa/QbNDMm
IronPort-SDR:
 pbFC2GKWOG4BxDw6aD9ttWM4MqqkueGCqtsNKE9oL1xINFaVEHVwZdptbyXFnVZRuwCAiLf2so
 Q4KhC+J6kRJXHVDvg8NbhKrjPw+eD3IVp0tqgNYSiUnfPXCdkX0VWYYfzfSN4FpZknTPr74DtE
 fvUprh2NV8TnEfXziRFWxmpK7LASW/5o9WFe0ClE+0koXb9RHo9KH27SXJZ1nnUPx4KL6xrw2s
 n+Y0wrqc+lPtjydatdeLFnxbuvfkvpFYTHb8Jw7in1zsIQ4tXbfWFvjde8YrqJy7uT4JikS7xk 9f8=
IronPort-SDR:
 LQBN5EhwrNeVmZzraq6E1ZTDAFxxT6PjwBninnGmtZL9h0u+ejrOg7/llPMtJsTyW1c09Ogrtv
 WFxiRSyinZ5YwpLT+PevUsPaEi1sBcRlcBQl1eOuszgyPKwpEAuW7D4P6XUbhOW1LxmNkjBVwB
 LVBw2ys548wyehCDpL2fFxHs+mXWaJW3C4McRqg4Vej3eRs0SWL1ncjye9FTKYDU1TLm9ruFln
 MpBneCVvRGAnnP3sonP3XT5jUBsAeN9qIBBkDcC1BbzWQNDspZUoJs3EvTcoO3YyI7rTKCFGlC TAA=
WDCIronportException: Internal

On 3/20/23 12:34, Yangtao Li wrote:
> Hi all,
> 
> Out of consideration for minimizing disruption, I did not send the
> patchset to everyone. However, it seems that my consideration was
> unnecessary, so I CC'd everyone on the first patch. If you would
> like to see the entire patchset, you can access it at this address.
> 
> https://lore.kernel.org/lkml/20230319092641.41917-1-frank.li@vivo.com/

Hard to comment on patches with this. It is only 10 patches. So send everything
please.

> 
> Thx,
> Yangtao

-- 
Damien Le Moal
Western Digital Research


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
