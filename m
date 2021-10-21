Return-Path: <SRS0=N2wx=PJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BADC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 06:20:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BDF3961205
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 06:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BDF3961205
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L4pYw7019145;
	Thu, 21 Oct 2021 06:20:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqypk2hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 06:20:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L6Fc6J048815;
	Thu, 21 Oct 2021 06:20:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkv198u4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 21 Oct 2021 06:20:34 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdRRJ-0006lH-E3; Wed, 20 Oct 2021 23:20:33 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mdRQp-0006kL-K2
	for ocfs2-devel@oss.oracle.com; Wed, 20 Oct 2021 23:20:03 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L6FbZC194840
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 06:20:03 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3br8gvd9x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 06:20:03 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19KNeIkO031956
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 06:20:01 GMT
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
	[209.85.208.176])
	by mx0b-00069f01.pphosted.com with ESMTP id 3btw05uuf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 06:20:01 +0000
Received: by mail-lj1-f176.google.com with SMTP id r6so1196231ljg.6
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 23:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ySym1S+xM/vLmh5qD50mQk6IKKZnZMjSymPhRc8AKZU=;
	b=buM6sVV9Bzmr7Nz5Jis65WgZHDvrUC3gzHPnefE/WtnnWMoeOC6FwZ7XbgK5kt3v6g
	Vetkji+HBbx38fizM1uyDuzrGJ7vhIlJWBJLJWa2c+kT11rjB6tVTiLoHQDZGC+H3I0O
	U4CbQSUaWv0lR/fyaq/mTG5OpMQwyeomEEzwfZxyVVLi+8WAcLqSYeKZSY299FEdJJAt
	08l3s1/sFuy/6nPHhOztrIxx0Uf3V7Exbln/GOSyflRxHbZAWI7x/FtQElyOEEVMiv2C
	ENqa5eTSyv50DeoOseriEgshHafN53iBackrIhnTyNqAKawtuSIs2DI9Z5yhbuG4A3xc
	lqJQ==
X-Gm-Message-State: AOAM530g5n/XAubXe8nQwPr2AMhIv/TQimAwpLTdUT6v9B6yN6/uXpg6
	xQU6Jpy53Odl7IGplGGaX+W3/y3NY7BGx4x/
X-Google-Smtp-Source: ABdhPJyFn8LqVW6Kwsv4BrW62cb68BpD2s+NthE73o48MyKnnRYe3xIch856+nginHethlsgfouS1A==
X-Received: by 2002:a05:651c:603:: with SMTP id
	k3mr3847273lje.401.1634797198610; 
	Wed, 20 Oct 2021 23:19:58 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com.
	[209.85.167.41])
	by smtp.gmail.com with ESMTPSA id s4sm370662lfs.235.2021.10.20.23.19.56
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 20 Oct 2021 23:19:57 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id x27so320906lfu.5
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 23:19:56 -0700 (PDT)
X-Received: by 2002:a19:ad0c:: with SMTP id t12mr3576075lfc.173.1634797196615; 
	Wed, 20 Oct 2021 23:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
In-Reply-To: <YXCbv5gdfEEtAYo8@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Oct 2021 20:19:40 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
Message-ID: <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.208.176
X-ServerName: mail-lj1-f176.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	bulkscore=0
	impostorscore=0 adultscore=0 priorityscore=78 malwarescore=0
	mlxlogscore=611 spamscore=0 mlxscore=0 lowpriorityscore=0 clxscore=410
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110210028
	domainage_hfrom=5420
X-Spam: Clean
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210028
X-Proofpoint-ORIG-GUID: vURk3MNZZJLXeSoA7vgTWqDjN-DAI-V6
X-Proofpoint-GUID: vURk3MNZZJLXeSoA7vgTWqDjN-DAI-V6

On Wed, Oct 20, 2021 at 12:44 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> However, with MTE doing both get_user() every 16 bytes and
> gup can get pretty expensive.

So I really think that anything that is performance-critical had
better only do the "fault_in_write()" code path in the cold error path
where you took a page fault.

IOW, the loop structure should be


     repeat:
                take_locks();
                pagefault_disable();
                ret = do_things_with_locks();
                pagefault_enable();
                release_locks();

                // Failure path?
                if (unlikely(ret == -EFAULT)) {
                        if (fault_in_writable(..))
                                goto repeat;
                        return -EFAULT;
                }

rather than have it be some kind of "first do fault_in_writable(),
then do the work" model.

So I wouldn't worry too much about the performance concerns. It simply
shouldn't be a common or hot path.

And yes, I've seen code that does that "fault_in_xyz()" before the
critical operation that cannot take page faults, and does it
unconditionally.

But then it isn't the "fault_in_xyz()" that should be blamed if it is
slow, but the caller that does things the wrong way around.

            Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
