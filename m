Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0850FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 11 Feb 2022 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=py5ZN7bvn5frNl2hOLAyy032SPiReaR4mEMdI9suyZ0=;
 b=BDtN2ffmBaWzCPmhUSgDasGnAHqzV35bCLS/M4vaQPHXZ9xpsrWeeB5Un3DrLtfvtab+44xHssS0
   mWr4bS2H9PREwnaahAJS6L68A9DbZ/uaJLAQDdsJSkjeiz1ZtMMvWL3pCH+zd3/ZaVS9u2biSvYo
   Vd/rO5GVX5NGl4JBK2nroTXPRviBfD0nVINDkQJdjG1gfg4xhpLZqSAoTzfQo+FK9ihk286YfGdA
   SHzz7sD1njLZDkXXnjNwJhI03rz56n7xBQlx/PmvO4CLuTjVf7zjjyz1mlvh+bLTncRA2SJWYUl9
   s/rslrqCIyGy9Klxd7TN+h/bCp2S0DVH7fyNSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=py5ZN7bvn5frNl2hOLAyy032SPiReaR4mEMdI9suyZ0=;
 b=FETsA9QKEJ8JrlP7lgNcDai/yS2pv5duoCEGnArj2ZrAXYyj60cUuBAuCvwt0SOYj0UJG09QUHQX
   veuOtAe4dDmVz2UsCz6gkumBa8IA6oPqZxC+4mCIyNLfIY7yz6kb9Yos4GPxXHArVQWMyDXbG/NZ
   5C8wo862Ef5hvY9YOsQbsw9xMHgI6q/Q5XRgU5Od44kLR4fXtwgN/evT60oc4kVKj25vnabOuASm
   U58VmC8Ogsq/GYETLa/m3d9gJJqZ4ZIVdS09PYTsTuW/4cdmlAROQttfC7YjVB/Bcito/ufbEH3h
   SbPLngc7Sfu5v2dwpbeTWDuwNop/xAPH7AyDkg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220119 64bit (built Jan 19
 2022))
 with ESMTPS id <0R7500BI5J7JNA10@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 11 Feb 2022 17:57:19 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=akpm@linux-foundation.org; dkim=pass
 header.d=linux-foundation.org header.s=korg; dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1644602226; bh=vI6QZYhdRWPKJjdfHZaB/qFCLoM68gQcdNcEjFf14Vs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=1oIKcUyEEG5/byyjSB8nm8I2pMP7oVv9US2LEF/1ufOjpIFjC4HW4ZRYT18r6Ae0D
 5sp2CLjJiiFVWMQdwaCi2o4gN95Eh7y8XW4k708QkT5D6vrzHfzTWIPyjcshDb42WD
 MqXM6H0DxyzV36TVYEojSv3XAzZdWMir/tZuNF0g=
Date: Fri, 11 Feb 2022 09:57:05 -0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20220211095705.bf28866d6e046b930ae039d0@linux-foundation.org>
In-reply-to: <4791ccfd-ecf0-ed90-fc4c-b6effd56fbdd@linux.alibaba.com>
References: <20220211031146.106288-1-hongnan.li@linux.alibaba.com>
 <4791ccfd-ecf0-ed90-fc4c-b6effd56fbdd@linux.alibaba.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255
 signatures=673431
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 adultscore=0 spamscore=0 priorityscore=30 lowpriorityscore=0
 mlxlogscore=720 mlxscore=0 phishscore=0 suspectscore=0 clxscore=141
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110097
Cc: Hongnan Li <hongnan.li@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] fs/ocfs2: fix comments mentioning i_mutex
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
X-Proofpoint-GUID: aF1tBxQXIjKm5RD0ueFuktqa6yoCJj5k
X-Proofpoint-ORIG-GUID: aF1tBxQXIjKm5RD0ueFuktqa6yoCJj5k
Reporting-Meta:
 AAFJhV2jRbarKmJAorIHnoz3+24u1Xfl26eRg45b3U7dTRYdcFNqEokPcKG0Ab8t
 sy3xadtCvWYUoYVn+LRVoxp1YAW5Q9BvbiZgDV1v/kKYDszKKcPFlMN/Duly6JOv
 10dZB8sDlgtv6Mw6NntsQhNBmYzD2ktmH43z5jMQChrgthHPJrxwds9Rqnupu/Fp
 /NYSvffZmK+ujLIdUw/PZN5k60+fPhjZFT41SZdZjEguKxZcRSAn1NqIPM59CNaf
 WLhbEY7tlQo139Q4Xltcu02Tn7ZlxUfFbxqGp6FncRGRXeXKWZ08t8bUIYmz0mCC
 h7PY/AgTvdWLhjPw+VMrmjej27yFpsGi7mJmlo3Uz8d9L6vS/fUg+kfcdPUToOLl
 +bv2RKd3C22ASKAj8RuqbYrgyrScuxXlcPL4ALTlkL6zBa7m5km8QfKW6hI6PIjv
 SMMOA+y5pu4SGGhkQes2P0BwwCXHQo1pI115z8ws4nESyg4wwSp7lWtetjtjAGxf
 IuBhgOJhRSfM18SSutC2jT1G1JWDYYQsXHw/DL3IXJnZ

On Fri, 11 Feb 2022 12:01:52 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 2/11/22 11:11 AM, Hongnan Li wrote:
> > From: hongnanli <hongnan.li@linux.alibaba.com>
> > 
> > inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> > comments still mentioning i_mutex.
> > 
> > Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
> 
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

As happens so often, I can't find this patch of ocfs2-devel :(.

Can I please have a resed with a cc?

Thanks.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
