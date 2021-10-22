Return-Path: <SRS0=RLPq=PK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0F7C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 02:42:10 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BD4CB60D07
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 02:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BD4CB60D07
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LNiZ1t016484;
	Fri, 22 Oct 2021 02:42:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm8e55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 02:42:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M2ffWW093134;
	Fri, 22 Oct 2021 02:42:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkv2ysny-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 22 Oct 2021 02:42:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdkSO-0000zE-Ty; Thu, 21 Oct 2021 19:38:56 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mdkSN-0000yw-L9
	for ocfs2-devel@oss.oracle.com; Thu, 21 Oct 2021 19:38:55 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M2VHPe110429
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:55 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bqpj9v0fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:55 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19M0Rnmb012273
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:54 GMT
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
	[209.85.167.52])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bujseh6rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:54 +0000
Received: by mail-lf1-f52.google.com with SMTP id bq11so2063242lfb.10
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 19:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=cbgzVLDCT8DipeBdsMkDowoxxylwz2da/ifUpbOh8z0=;
	b=QekRDuA9lw2ZId3o1jlzEnVNwrdzyWkp4tPK7noDnjpbnUiV9BkmUJaGgRll2cUF6Y
	h/JNPCuUqj1MQth+9ZpdUEKbryNBQCKtQtz6r3ddl9tRe0TOjbU3IR0r3GYL7Ye0rwVK
	G7B9tk7oa0hDUoWWggSgmpxZEp0luqlk6PCIsBZgt+RdIwLB7AL5g7vvxazQVCKE9NLt
	4MQk6oE97A59PbIDWo2HQb1yVXtz1nCmRjX+DlabTyrKl4liHnIEm4nw231Ijx3Ho54d
	jWvX6csHsBuBwO0cQgqTYfPtsP1Ko8HZ6zy8SqUAlv2FgdVW9SqYWZLCjNTCeEo+jKN0
	Qz0w==
X-Gm-Message-State: AOAM532Fqz8YU40V8c9FMT3unW2MI7HTBlX4zhHSQi4du0+h39YXyu/W
	ZjwZI78XZJQUjTHeRrhtGQyAT/KAwKnyR8Hk
X-Google-Smtp-Source: ABdhPJyF21XGwfkHnJPZ2S/Q2je/n7ajYgtI/SRveieT1kaBY3yvbfV96swksQ3hWlJogYULnhsOoA==
X-Received: by 2002:a05:6512:150c:: with SMTP id
	bq12mr6252467lfb.628.1634870331253; 
	Thu, 21 Oct 2021 19:38:51 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com.
	[209.85.208.179])
	by smtp.gmail.com with ESMTPSA id v3sm748316ljv.7.2021.10.21.19.38.50
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 21 Oct 2021 19:38:51 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id r6so1701724ljg.6
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 19:38:50 -0700 (PDT)
X-Received: by 2002:a2e:a407:: with SMTP id p7mr10376944ljn.68.1634869846779; 
	Thu, 21 Oct 2021 19:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
	<YXE7fhDkqJbfDk6e@arm.com>
	<CAHc6FU5xTMOxuiEDyc9VO_V98=bvoDc-0OFi4jsGPgWJWjRJWQ@mail.gmail.com>
In-Reply-To: <CAHc6FU5xTMOxuiEDyc9VO_V98=bvoDc-0OFi4jsGPgWJWjRJWQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Oct 2021 16:30:30 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgvnU2PXFMpsNErdwE=tXGymLHe275jWkBhCbGiixWU5g@mail.gmail.com>
Message-ID: <CAHk-=wgvnU2PXFMpsNErdwE=tXGymLHe275jWkBhCbGiixWU5g@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.52
X-ServerName: mail-lf1-f52.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	lowpriorityscore=0
	bulkscore=0 mlxscore=0 mlxlogscore=920 spamscore=0 adultscore=0
	suspectscore=0 malwarescore=0 phishscore=0 impostorscore=0 clxscore=368
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110220013 domainage_hfrom=5421
X-Spam: Clean
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220013
X-Proofpoint-GUID: _KIUhksYBsSqbzBNCbXhCczH450VtP1d
X-Proofpoint-ORIG-GUID: _KIUhksYBsSqbzBNCbXhCczH450VtP1d

On Thu, Oct 21, 2021 at 4:42 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> But probing the entire memory range in fault domain granularity in the
> page fault-in functions still doesn't actually make sense. Those
> functions really only need to guarantee that we'll be able to make
> progress eventually. From that point of view, it should be enough to
> probe the first byte of the requested memory range

That's probably fine.

Although it should be more than one byte - "copy_from_user()" might do
word-at-a-time optimizations, so you could have an infinite loop of

 (a) copy_from_user() fails because the chunk it tried to get failed partly

 (b) fault_in() probing succeeds, because the beginning part is fine

so I agree that the fault-in code doesn't need to do the whole area,
but it needs to at least do some <N bytes, up to length> thing, to
handle the situation where the copy_to/from_user requires more than a
single byte.

                 Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
