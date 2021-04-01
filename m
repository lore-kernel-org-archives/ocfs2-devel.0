Return-Path: <SRS0=Mr1z=JJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F18C433ED
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:49 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D0FA61287
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D0FA61287
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFFhNF092705;
	Mon, 12 Apr 2021 15:20:47 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 37u3ymc1yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Apr 2021 15:20:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFGIVa156906;
	Mon, 12 Apr 2021 15:20:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37unxvhcn5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 12 Apr 2021 15:20:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lVyMn-0003Sa-LE; Mon, 12 Apr 2021 08:20:45 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ritesh.list@gmail.com>) id 1lRrVL-0003F8-KW
	for ocfs2-devel@oss.oracle.com; Thu, 01 Apr 2021 00:12:35 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1317AvCO168441
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 07:12:35 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 37n2aav4vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 07:12:35 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1316tKgI048823
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 07:12:34 GMT
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
	[209.85.216.44]) by userp2040.oracle.com with ESMTP id 37n2a6pw59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 07:12:34 +0000
Received: by mail-pj1-f44.google.com with SMTP id
	x7-20020a17090a2b07b02900c0ea793940so2599551pjc.2
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 00:12:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=nxMNAPqfEecVrR9nsQ3IMQjDvIPPMionqLgGG/C5wWA=;
	b=IK6Q4tYSBci7ikyQ63fKi/+mUxBZ85snmlMvuAGP/V4LxJhdMGImcLGFAQVGIrjA6f
	45Or221B6+wG5EAP6ZnHKqv3VUEgzP75i1adgHJMxtli1p5aRwopBO58sP5ySuJahC/r
	NpgkWI5sMQK854YdQPMLK4aiQTjwjJl9q046nZRoJuzIsECZyu24KXRsHF/oLBukx/wP
	WnrP/i9VLSwMpt0Lc54a4o2QbnSwhoCoZY2Iq8+DXNzYW24Mmfofe3F0nIFf2jusyXAD
	Aw4F9CKcbTcouCBjtqVirROXOacMUJ7fwuYlGxSWFCFpoaxekLUTfhsAGPHd3U2jMGc7
	lRyA==
X-Gm-Message-State: AOAM5315qz7cFSp34qaZJwbkNSPkfnX9e0zYXfFYcMKXX/D65lwUtp4t
	7lnZnEhDkqV1vfEPYvD8GJ8=
X-Google-Smtp-Source: ABdhPJx54GLu44ceRw1VOt4nY0MtGnri8a1v/wQ/JC9/nOhtBatQ1/YNYXNfg6t3Zm5Ef8q/zt/jjA==
X-Received: by 2002:a17:90a:fa89:: with SMTP id
	cu9mr7702778pjb.204.1617261152822; 
	Thu, 01 Apr 2021 00:12:32 -0700 (PDT)
Received: from localhost ([122.182.250.63])
	by smtp.gmail.com with ESMTPSA id v2sm4292271pjg.34.2021.04.01.00.12.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 01 Apr 2021 00:12:32 -0700 (PDT)
Date: Thu, 1 Apr 2021 12:42:30 +0530
From: Ritesh Harjani <ritesh.list@gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210401071230.wbrawpzk3opzmntv@riteshh-domain>
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
	<20210319015237.993880-8-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319015237.993880-8-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 209.85.216.44
X-ServerName: mail-pj1-f44.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=282
	impostorscore=0
	suspectscore=0 lowpriorityscore=0 adultscore=0 priorityscore=411
	malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
	mlxlogscore=900 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2103310000 definitions=main-2104010047
X-Spam: Clean
X-Mailman-Approved-At: Mon, 12 Apr 2021 08:20:43 -0700
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 07/10] iomap: Introduce iomap_apply2()
 for operations on two files
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120100
X-Proofpoint-GUID: YmXofpsa6ztWeQeu8TCAgxovVRgmxyUT
X-Proofpoint-ORIG-GUID: YmXofpsa6ztWeQeu8TCAgxovVRgmxyUT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120100

On 21/03/19 09:52AM, Shiyang Ruan wrote:
> Some operations, such as comparing a range of data in two files under
> fsdax mode, requires nested iomap_open()/iomap_end() on two file.  Thus,
> we introduce iomap_apply2() to accept arguments from two files and
> iomap_actor2_t for actions on two files.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/iomap/apply.c      | 56 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  7 +++++-
>  2 files changed, 62 insertions(+), 1 deletion(-)
>
> diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
> index 26ab6563181f..fbc38ce3d5b6 100644
> --- a/fs/iomap/apply.c
> +++ b/fs/iomap/apply.c
> @@ -97,3 +97,59 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>
>  	return written ? written : ret;
>  }
> +
> +loff_t
> +iomap_apply2(struct inode *ino1, loff_t pos1, struct inode *ino2, loff_t pos2,
> +		loff_t length, unsigned int flags, const struct iomap_ops *ops,
> +		void *data, iomap_actor2_t actor)
> +{
> +	struct iomap smap = { .type = IOMAP_HOLE };
> +	struct iomap dmap = { .type = IOMAP_HOLE };
> +	loff_t written = 0, ret, ret2 = 0;
> +	loff_t len1 = length, len2, min_len;
> +
> +	ret = ops->iomap_begin(ino1, pos1, len1, flags, &smap, NULL);
> +	if (ret)
> +		goto out_src;

if above call fails we need not call ->iomap_end() on smap.

> +	if (WARN_ON(smap.offset > pos1)) {
> +		written = -EIO;
> +		goto out_src;
> +	}
> +	if (WARN_ON(smap.length == 0)) {
> +		written = -EIO;
> +		goto out_src;
> +	}
> +	len2 = min_t(loff_t, len1, smap.length);
> +
> +	ret = ops->iomap_begin(ino2, pos2, len2, flags, &dmap, NULL);
> +	if (ret)
> +		goto out_dest;

ditto

> +	if (WARN_ON(dmap.offset > pos2)) {
> +		written = -EIO;
> +		goto out_dest;
> +	}
> +	if (WARN_ON(dmap.length == 0)) {
> +		written = -EIO;
> +		goto out_dest;
> +	}
> +	min_len = min_t(loff_t, len2, dmap.length);
> +
> +	written = actor(ino1, pos1, ino2, pos2, min_len, data, &smap, &dmap);
> +
> +out_dest:
> +	if (ops->iomap_end)
> +		ret2 = ops->iomap_end(ino2, pos2, len2,
> +				      written > 0 ? written : 0, flags, &dmap);
> +out_src:
> +	if (ops->iomap_end)
> +		ret = ops->iomap_end(ino1, pos1, len1,
> +				     written > 0 ? written : 0, flags, &smap);
> +

I guess, this maynot be a problem, but I still think we should be
consistent w.r.t len argument we are passing in ->iomap_end() for both type of
iomap_apply* family of functions.
IIUC, we used to call ->iomap_end() with the length argument filled by the
filesystem from ->iomap_begin() call.

whereas above breaks that behavior. Although I don't think this is FATAL, but
still it is better to be consistent with the APIs.
Thoughts?


> +	if (ret)
> +		return written ? written : ret;
> +
> +	if (ret2)
> +		return written ? written : ret2;
> +
> +	return written;
> +}

	if (written)
		return written;

	return ret ? ret : ret2;

Is above a simpler version?

-ritesh

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
