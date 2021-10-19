Return-Path: <SRS0=T5gl=PH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A216C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 16:00:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D75E76128B
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 16:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D75E76128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JFJ0xp010389;
	Tue, 19 Oct 2021 16:00:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsr453f3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 16:00:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFjWxm036788;
	Tue, 19 Oct 2021 16:00:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkuxjd7e-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 19 Oct 2021 16:00:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mcrXr-0000fx-97; Tue, 19 Oct 2021 09:00:55 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <rpeterso@redhat.com>) id 1mcrXo-0000eJ-OU
	for ocfs2-devel@oss.oracle.com; Tue, 19 Oct 2021 09:00:52 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFl87x057238
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 16:00:52 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bqpj5nmbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 16:00:52 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19JFmp0Q014702
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 16:00:51 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bsd7kexdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 16:00:51 +0000
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
	[209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-188-88KhoOuZMbS1Zjcwg-aMgQ-1; Tue, 19 Oct 2021 12:00:49 -0400
X-MC-Unique: 88KhoOuZMbS1Zjcwg-aMgQ-1
Received: by mail-io1-f71.google.com with SMTP id
	k9-20020a5d91c9000000b005dc4a740599so13623473ior.12
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 09:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=+/pkobYQmFSVPtB7/1zAAgkGIOuOGumz0nqsWSm3uLo=;
	b=6gP8hm5gH87JdUEX45jx/ec3jUCp64AFmVEhlA/vEsCLnPrcCo6atvt2AyKsBGkQRl
	YNWfPPqrPQ5d22YLye7j7D9DMfwO7nE6gtitAV6pvXaHsI0aJail6Z/fu04gTchJgCpQ
	OSIMepVSjQDU+Qs5hHgz497GPuCN4A1VUHVGyCbILfWonTgJUPlXaSl9CyIFNF0M8qmJ
	/8bJbZe0pCR6qscNTkhYZ9dk9Y/pJCtGpxjGx6wswKnVUjF2J1xNzi2s3wazhJ6NVMYq
	fvG5BbnMCtP0SuTmeYiptlKh7FgNUovbw+vUZ2s6Vlne+SvJXf4S2M54OJwo5rK+HZU3
	hchw==
X-Gm-Message-State: AOAM532Xy4PWQS+QVLV93Yh5StefY03WwYNp7vbzbYOaT0TrvyCPv6O/
	lPv67u6FYbDN+dCHZ+cSsTap34n5xh7H58n/RaNIR05B76cM1YxTqf5wE0CMmaR8nlaqs9TIvFi
	GVvDpkCEYKVsBdZVHVCrsGg==
X-Received: by 2002:a92:ad07:: with SMTP id w7mr964697ilh.162.1634659248222;
	Tue, 19 Oct 2021 09:00:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAZfB7m5Nwi7iGOdqLp7ZjGTVP9iLTlfNdmkJjBBh89jyJbqtVZTUIyhlFM83/SHsC93WNcw==
X-Received: by 2002:a92:ad07:: with SMTP id w7mr964668ilh.162.1634659248043;
	Tue, 19 Oct 2021 09:00:48 -0700 (PDT)
Received: from [172.16.0.19] ([205.214.171.149])
	by smtp.gmail.com with ESMTPSA id
	i18sm9324101ila.32.2021.10.19.09.00.46
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 19 Oct 2021 09:00:47 -0700 (PDT)
Message-ID: <d28b1ea4-6834-816e-a01a-f1bd0862e84e@redhat.com>
Date: Tue, 19 Oct 2021 11:00:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
From: Bob Peterson <rpeterso@redhat.com>
In-Reply-To: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=rpeterso@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190094
X-Proofpoint-ORIG-GUID: 11vzGGCG3FVebpNgS829zpvBeWI0PXfx
X-Proofpoint-GUID: 11vzGGCG3FVebpNgS829zpvBeWI0PXfx

On 10/19/21 10:40 AM, Linus Torvalds wrote:
> On Tue, Oct 19, 2021 at 3:42 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>>
>>  From my point of view, the following questions remain:
>>
>>   * I hope these patches will be merged for v5.16, but what process
>>     should I follow for that?  The patch queue contains mm and iomap
>>     changes, so a pull request from the gfs2 tree would be unusual.
> 
> Oh, I'd much rather get these as one pull request from the author and
> from the person that actually ended up testing this.

Hi Linus,

FWIW, I've been working with Andreas on this and have tested it quite
extensively, although only with gfs2. I've tested it with numerous
scenarios, both stand-alone (xfstests as well as several other test
programs I have in my collection) and in a cluster with some very heavy
duty cluster coherency tests. My testing is nearly complete, but not
quite.

Regards,

Bob Peterson
GFS2 File System


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
