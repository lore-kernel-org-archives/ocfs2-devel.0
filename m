Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D16C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 18:59:45 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3691561506
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 18:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3691561506
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TIMOWC017406;
	Wed, 29 Sep 2021 18:59:44 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hqk9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 18:59:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TIuUaY044622;
	Wed, 29 Sep 2021 18:58:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bc3bke8yg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 18:58:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVemb-0002sP-JB; Wed, 29 Sep 2021 11:58:21 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <vvidic@valentin-vidic.from.hr>) id 1mVT1O-00068w-Or
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 23:24:50 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18T6AvJT177901
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 06:24:50 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bc4k8t4mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 06:24:47 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18T207ha018783
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 06:24:46 GMT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [109.200.23.17])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc5gs3kwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 06:24:45 +0000
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id E067570C2; Wed, 29 Sep 2021 08:24:34 +0200 (CEST)
Date: Wed, 29 Sep 2021 08:24:34 +0200
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <20210929062434.GN28341@valentin-vidic.from.hr>
References: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
	<00850aed-2027-a0ab-e801-c6498a5a49f8@linux.alibaba.com>
	<20210928131450.GM28341@valentin-vidic.from.hr>
	<212f878e-1bbe-347c-ba43-e4ffb9b4afbe@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <212f878e-1bbe-347c-ba43-e4ffb9b4afbe@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 109.200.23.17
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	impostorscore=0
	malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
	adultscore=0 clxscore=168 bulkscore=0 lowpriorityscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109290038
X-Spam: Clean
X-Mailman-Approved-At: Wed, 29 Sep 2021 11:58:19 -0700
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: mount fails with buffer overflow
	in strlen
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290110
X-Proofpoint-GUID: FeZv_-EmJi9s2Xo68UL_zw639dvnYK8c
X-Proofpoint-ORIG-GUID: FeZv_-EmJi9s2Xo68UL_zw639dvnYK8c

On Wed, Sep 29, 2021 at 10:38:59AM +0800, Joseph Qi wrote:
> Okay, you are right, strlen(src) is indeed wrong here.
> 
> But please note that in strlcpy():
> size_t ret = strlen(src);
> if (size) {
> 	size_t len = (ret >= size) ? size - 1 : ret;
> 	memcpy(dest, src, len);
> 	dest[len] = '\0';
> }
> 
> Take ci_stack "o2cb" for example, strlen("o2cb") may return wrong if the
> coming byte is not null, say it is 10.
> The input size is 5, so len will finally be 4.
> So dest is still correct ending with null byte. No overflow happens.
> So the problem here is the wrong return value, but it is discarded in
> ocfs2_initialize_super().

strlcpy starts with a call to strlen(src) and this is where the read overflow
happens. If the kernel is compiled with CONFIG_FORTIFY_SOURCE this gets
executed instead (include/linux/fortify-string.h):

__FORTIFY_INLINE __kernel_size_t strlen(const char *p)
{
        __kernel_size_t ret;
        size_t p_size = __builtin_object_size(p, 1);

        /* Work around gcc excess stack consumption issue */
        if (p_size == (size_t)-1 ||
                (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
                return __underlying_strlen(p);
        ret = strnlen(p, p_size);
        if (p_size <= ret)
                fortify_panic(__func__);
        return ret;
}

So while strlcpy did work before this fortify check, it is probably not the
best option anymore due to the missing null terminator in the source.

-- 
Valentin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
