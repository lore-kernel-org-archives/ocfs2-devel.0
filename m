Return-Path: <SRS0=S1qZ=ML=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A8BC07E9B
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 19:31:38 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 631EA61107
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 19:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 631EA61107
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JJQTW9025553;
	Mon, 19 Jul 2021 19:31:35 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39w8p0s03r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jul 2021 19:31:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JJUQu8184254;
	Mon, 19 Jul 2021 19:31:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39umaxjush-1;
	Mon, 19 Jul 2021 19:31:34 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m5YzE-0007OD-SF; Mon, 19 Jul 2021 12:31:32 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m5YzB-0007Nv-5Y
	for ocfs2-devel@oss.oracle.com; Mon, 19 Jul 2021 12:31:29 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16JJUHoT194525
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:31:28 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 39v8yt9xkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:31:25 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16JJT2mb004358
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:31:24 GMT
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
	[209.85.167.45])
	by mx0b-00069f01.pphosted.com with ESMTP id 39w7phvfus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:31:24 +0000
Received: by mail-lf1-f45.google.com with SMTP id f30so25520432lfv.10
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 12:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=JRKNjK3HDiyg7MZUU6xzfGsB6oi9LOaFsq3T/zTDatI=;
	b=rSlWvM1ttl8iWWEuLQtlbbdlbHRN96qDzgiTj1Z65J3R5sGQRHHCBIQNXQHzdWKAbm
	CUXUzVJUnMJx5JtIFiEpEIqiA86eVOWXaMWm7mfpncyUim5GGldWoh2OCp0zX2iMAGEq
	A5BBFRT2TPrmAWQbDK0LfqcRS/8frONorsBhG3p7gTj2UtYkLXL6snRJD4qg4gZ9A6oD
	MqQpVIqVoBlJ8w5eisl78VMPzNsxbIyKXIYWa5ZWJlhCtc+PT/0xtNsxt+GZXIooYnJH
	yuArdorZSo3z+PkLY5lULTFOFCBw4CgkDWbnx8GjKaOAPy1qY2rYgz+eDlkJ/LcH8Cs4
	pj2g==
X-Gm-Message-State: AOAM532Meemglucx6tePs47ir/yTKjDqi1ngqHzPvKwqEMuJvDgR/rB0
	XpjfrG51YfIP3Iy0jl5qi19vdxIVD8c3s/iI
X-Google-Smtp-Source: ABdhPJxzFFPlGqvGiGzqHV2/VwfmqlQjpQaymQe4cUK/+6MI55W32Ih7dodH5HiDqv2wNvLbqWJgtg==
X-Received: by 2002:a05:6512:3053:: with SMTP id
	b19mr19677435lfb.167.1626723081195; 
	Mon, 19 Jul 2021 12:31:21 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com.
	[209.85.167.48]) by smtp.gmail.com with ESMTPSA id
	y22sm1355348lfh.154.2021.07.19.12.31.20
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 19 Jul 2021 12:31:20 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id v6so32102028lfp.6
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 12:31:20 -0700 (PDT)
X-Received: by 2002:a05:6512:3f82:: with SMTP id
	x2mr18099945lfa.421.1626723079907; 
	Mon, 19 Jul 2021 12:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210718223932.2703330-1-agruenba@redhat.com>
In-Reply-To: <20210718223932.2703330-1-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Jul 2021 12:31:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBKeA=obJOc5VRP38=ffm2dCfVmKmy5PLAgs3rysoEtw@mail.gmail.com>
Message-ID: <CAHk-=wjBKeA=obJOc5VRP38=ffm2dCfVmKmy5PLAgs3rysoEtw@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.45
X-ServerName: mail-lf1-f45.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	adultscore=0 clxscore=411 priorityscore=0 mlxscore=0 lowpriorityscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190111
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxscore=0 malwarescore=0
	adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190111
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 0/6] gfs2: Fix mmap + page fault
	deadlocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190111
X-Proofpoint-GUID: rHkwyvKXL0YWWuT9-lKT3OoOxX9xHXX2
X-Proofpoint-ORIG-GUID: rHkwyvKXL0YWWuT9-lKT3OoOxX9xHXX2

On Sun, Jul 18, 2021 at 3:39 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> here's an update to the gfs2 mmap + page faults fix that implements
> Linus's suggestion of disabling page faults while we're holding the
> inode glock.

Apart from some wording/naming issues, I think this looks a _lot_
better, and should fix the fundamental and underlying deadlock
properly.

So Ack from me with the trivial suggestions I sent to the individual patches.

            Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
