Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C711C4320A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:11:49 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3BA2610CC
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E3BA2610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KDAnXH019878;
	Fri, 20 Aug 2021 13:11:47 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahsxd29dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 13:11:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KDBD2R187861;
	Fri, 20 Aug 2021 13:11:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ae2y6kg82-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 13:11:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH4JF-0001ZF-E1; Fri, 20 Aug 2021 06:11:45 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <rpeterso@redhat.com>) id 1mH4JC-0001Yt-SM
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 06:11:42 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KDB2Iw172176
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:11:42 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3ae5ndjv03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:11:42 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KD3HPO008210
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:11:41 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahhask13d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:11:40 +0000
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
	[209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-347--vvRvZBNPam5fJLoLbHuZg-1; Fri, 20 Aug 2021 09:11:38 -0400
X-MC-Unique: -vvRvZBNPam5fJLoLbHuZg-1
Received: by mail-il1-f197.google.com with SMTP id
	j17-20020a926e11000000b0022487646515so1901048ilc.14
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 06:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=bqh06A4IsUEWpw6rhzLKw/iWZwAPu+rG9dT74f0JO44=;
	b=RFW6/0ZGvCu4WP++gc59nwI2wCYd/yjaxzafpGM+Z6tt17PfSlGJDSTFxDASRNTuWI
	rRXqAIfXruh7Gqj44FsxsvqcT3LHsQQf8ziWVynjnVCvQREA4Jh15qUKTg2OEW3UphlO
	22QnJF2ja5J31i4EB2M2lAzbvY7qIujDD94foNpZffWHJcAVe1AGH2yJSQFRMOOZFqIh
	TZXtkDn31bLNQha1dcCfQfA1sfkYyY2q6BUivxHQ7QtfAYkJCaatqaKoPnqn66dtNQ0G
	L3DjQPMILOCJQCOhJXZVCKf9NDHrgP5nm6PZSS0CMrKriO23JyEhFoCGpawGfoLaFmAi
	9a6Q==
X-Gm-Message-State: AOAM531nABJnTqTyNhV4cB6bF3JvCNgDLRtPzESHYI+ympm3i85tA52j
	8bsFgANEDecPv//J1b862SUPWaYMsHhXC4jqs3/EDEXyV4TlUPEpr1ONU/j9wwvS6HAxaOFovVf
	PONuPcbjapTiNHk1ucJ9Z00Akf7a459bsJBVcoLBJghbIt7k/A3p3G2JSfLqDuSZR5T6mO3xrPA
	==
X-Received: by 2002:a05:6638:1905:: with SMTP id
	p5mr17720513jal.25.1629465096983; 
	Fri, 20 Aug 2021 06:11:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwn2FwXIDsFpu5O60lFgWVHR+E5ie3a+l6OotzkonnnUZdMfF8XP6FuEiuSEv0LvgDyL5UuiQ==
X-Received: by 2002:a05:6638:1905:: with SMTP id
	p5mr17720468jal.25.1629465096680; 
	Fri, 20 Aug 2021 06:11:36 -0700 (PDT)
Received: from [172.16.0.19] (209-212-39-192.brainerd.net. [209.212.39.192])
	by smtp.gmail.com with ESMTPSA id k9sm3452624ilo.49.2021.08.20.06.11.35
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 20 Aug 2021 06:11:36 -0700 (PDT)
To: Steven Whitehouse <swhiteho@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
Date: Fri, 20 Aug 2021 08:11:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
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
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200075
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH v6 10/19] gfs2: Introduce
 flag for glock holder auto-demotion
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200075
X-Proofpoint-GUID: lztzF0x4ppTz5mAx54CzNnusZ_fgtu8w
X-Proofpoint-ORIG-GUID: lztzF0x4ppTz5mAx54CzNnusZ_fgtu8w

On 8/20/21 4:35 AM, Steven Whitehouse wrote:
> Hi,
> 
> On Thu, 2021-08-19 at 21:40 +0200, Andreas Gruenbacher wrote:
>> From: Bob Peterson <rpeterso@redhat.com>
>>
>> This patch introduces a new HIF_MAY_DEMOTE flag and infrastructure
>> that
>> will allow glocks to be demoted automatically on locking conflicts.
>> When a locking request comes in that isn't compatible with the
>> locking
>> state of a holder and that holder has the HIF_MAY_DEMOTE flag set,
>> the
>> holder will be demoted automatically before the incoming locking
>> request
>> is granted.
>>
> I'm not sure I understand what is going on here. When there are locking
> conflicts we generate call backs and those result in glock demotion.
> There is no need for a flag to indicate that I think, since it is the
> default behaviour anyway. Or perhaps the explanation is just a bit
> confusing...

I agree that the whole concept and explanation are confusing. Andreas 
and I went through several heated arguments about the symantics, 
comments, patch descriptions, etc. We played around with many different 
flag name ideas, etc. We did not agree on the best way to describe the 
whole concept. He didn't like my explanation and I didn't like his. So 
yes, it is confusing.

My preferred terminology was "DOD" or "Dequeue On Demand" which makes 
the concept more understandable to me. So basically a process can say
"I need to hold this glock, but for an unknown and possibly lengthy 
period of time, but please feel free to dequeue it if it's in your way."
And bear in mind that several processes may do the same, simultaneously.

You can almost think of this as a performance enhancement. This concept 
allows a process to hold a glock for much longer periods of time, at a 
lower priority, for example, when gfs2_file_read_iter needs to hold the 
glock for very long-running iterative reads.

The process requesting a holder with "Demote On Demand" must then 
determine if its holder has been stolen away (dequeued on demand) after 
its lengthy operation, and therefore needs to pick up the pieces of 
where it left off in its process.

Meanwhile, another process may need to hold the glock. If its requested 
mode is compatible, say SH and SH, the lock is simply granted with no 
further delay. If the mode is incompatible, regardless of whether it's 
on the local node or a different node in the cluster, these 
longer-term/lower-priority holders may be dequeued or prempted by 
another request to hold the glock. Note that although these holders are 
dequeued-on-demand, they are never "uninitted" as part of the process. 
Nor must they ever be, since they may be on another process's heap.

This differs from the normal glock demote process in which the demote 
bit is set on ("requesting" the glock be demoted) but still needs to 
block until the holder does its actual dequeue.

>> Processes that allow a glock holder to be taken away indicate this by
>> calling gfs2_holder_allow_demote().  When they need the glock again,
>> they call gfs2_holder_disallow_demote() and then they check if the
>> holder is still queued: if it is, they're still holding the glock; if
>> it
>> isn't, they need to re-acquire the glock.
>>
>> This allows processes to hang on to locks that could become part of a
>> cyclic locking dependency.  The locks will be given up when a (rare)
>> conflicting locking request occurs, and don't need to be given up
>> prematurely.
> This seems backwards to me. We already have the glock layer cache the
> locks until they are required by another node. We also have the min
> hold time to make sure that we don't bounce locks too much. So what is
> the problem that you are trying to solve here I wonder?

Again, this is simply allowing premption of lenghy/low-priority holders 
whereas the normal demote process will only demote when the glock is 
dequeued after this potentially very-long period of time.

The minimum hold time solves a different problem, and Andreas and I 
talked just yesterday about possibly revisiting how that all works. The 
problem with minimum hold time is that in many cases the glock state 
machine does not want to grant new holders if the demote bit is on, so 
it ends up wasting more time than solving the actual problem.
But that's another problem for another day.

Regards,

Bob Peterson


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
