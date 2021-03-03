Return-Path: <SRS0=eIKw=IB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17FCC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:24:05 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 78D2A6023B
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:24:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D2A6023B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1238KrgP042406;
	Wed, 3 Mar 2021 08:24:03 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 36yeqn2dre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Mar 2021 08:24:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1238Ka3M163138;
	Wed, 3 Mar 2021 08:24:02 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyut4vg3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 03 Mar 2021 08:24:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lHMkV-0002rK-UJ; Wed, 03 Mar 2021 00:20:51 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joe@perches.com>) id 1lHMk1-0002qO-Ta
	for ocfs2-devel@oss.oracle.com; Wed, 03 Mar 2021 00:20:21 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1238F4C8043142
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 08:20:21 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 370000ysak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 08:20:21 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1238Dcaw006791
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 08:20:20 GMT
Received: from smtprelay.hostedemail.com (smtprelay0248.hostedemail.com
	[216.40.44.248]) by userp2030.oracle.com with ESMTP id 36yc4jey45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 08:20:20 +0000
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
	[216.40.38.60])
	by smtprelay06.hostedemail.com (Postfix) with ESMTP id 3F59F180CE5FF;
	Wed,  3 Mar 2021 08:20:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: snake87_191524c276c3
X-Filterd-Recvd-Size: 3585
Received: from [192.168.1.159] (unknown [47.151.137.21])
	(Authenticated sender: joe@perches.com)
	by omf04.hostedemail.com (Postfix) with ESMTPA;
	Wed,  3 Mar 2021 08:20:15 +0000 (UTC)
Message-ID: <aed5d2b78c4ac121ca0cf46107334673a3c9a586.camel@perches.com>
From: Joe Perches <joe@perches.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org
Date: Wed, 03 Mar 2021 00:20:14 -0800
In-Reply-To: <20210226002030.653855-9-ruansy.fnst@fujitsu.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-9-ruansy.fnst@fujitsu.com>
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
X-PDR: PASS
X-Source-IP: 216.40.44.248
X-ServerName: smtprelay0248.hostedemail.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=291 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=48 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103030062
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3020.oracle.com id
	1238F4C8043142
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 08/10] fsdax: Dedup file range to use a
 compare function
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030063
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1034
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030063

On Fri, 2021-02-26 at 08:20 +0800, Shiyang Ruan wrote:
> With dax we cannot deal with readpage() etc. So, we create a dax
> comparison funciton which is similar with
> vfs_dedupe_file_range_compare().
> And introduce dax_remap_file_range_prep() for filesystem use.
[]
> diff --git a/fs/dax.c b/fs/dax.c
[]
> @@ -1856,3 +1856,54 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *=
vmf,l
> =A0	return dax_insert_pfn_mkwrite(vmf, pfn, order);
> =A0}
> =A0EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
> +
> +static loff_t dax_range_compare_actor(struct inode *ino1, loff_t pos1,
> +		struct inode *ino2, loff_t pos2, loff_t len, void *data,
> +		struct iomap *smap, struct iomap *dmap)
> +{
> +	void *saddr, *daddr;
> +	bool *same =3D data;
> +	int ret;
> +
> +	while (len) {
> +		if (smap->type =3D=3D IOMAP_HOLE && dmap->type =3D=3D IOMAP_HOLE)
> +			goto next;
> +
> +		if (smap->type =3D=3D IOMAP_HOLE || dmap->type =3D=3D IOMAP_HOLE) {
> +			*same =3D false;
> +			break;
> +		}
> +
> +		ret =3D dax_iomap_direct_access(smap, pos1,
> +			ALIGN(pos1 + len, PAGE_SIZE), &saddr, NULL);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		ret =3D dax_iomap_direct_access(dmap, pos2,
> +			ALIGN(pos2 + len, PAGE_SIZE), &daddr, NULL);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		*same =3D !memcmp(saddr, daddr, len);
> +		if (!*same)
> +			break;
> +next:
> +		len -=3D len;
> +	}
> +
> +	return 0;
> +}

This code looks needlessly complex.

len is never decremented inside the while loop so the while loop
itself looks unnecessary.  Is there some missing decrement of len
or some other reason to use a while loop?

Is dax_iomap_direct_access some ugly macro that modifies a hidden len?

Why not remove the while loop and use straightforward code without
unnecessary indentatation?

{
	void *saddr;
	void *daddr;
	bool *same =3D data;
	int ret;

	if (!len ||
	    (smap->type =3D=3D IOMAP_HOLE && dmap->type =3D=3D IOMAP_HOLE))
		return 0;

	if (smap->type =3D=3D IOMAP_HOLE || dmap->type =3D=3D IOMAP_HOLE) {
		*same =3D false;
		return 0;
	}

	ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
				      &saddr, NULL);
	if (ret < 0)
		return -EIO;

	ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
				      &daddr, NULL);
	if (ret < 0)
		return -EIO;

	*same =3D !memcmp(saddr, daddr, len);

	return 0;
}	=


I didn't look at the rest.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
