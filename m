Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3B8C4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 22:07:09 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D9BE608FE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 22:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D9BE608FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16OM0dYY026302;
	Sat, 24 Jul 2021 22:07:08 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a099c0uag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 22:07:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16OM4hmw104418;
	Sat, 24 Jul 2021 22:07:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07ysufc3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 22:07:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7PnU-0000hv-VO; Sat, 24 Jul 2021 15:07:04 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1m7PnP-0000hb-7A
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 15:06:59 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16OM5NM5178852
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 22:06:59 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3a0n2dnawg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 22:06:56 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16OLvw3Y009208
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 22:06:56 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0a2swcd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 22:06:55 +0000
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
	[209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-433-JyYal3H8MaC5xLxOVvsnLg-1; Sat, 24 Jul 2021 18:06:53 -0400
X-MC-Unique: JyYal3H8MaC5xLxOVvsnLg-1
Received: by mail-wm1-f71.google.com with SMTP id
	r2-20020a05600c35c2b029023a3f081487so2127586wmq.4
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 15:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=977uLZZ1MP2YWJkQk/8ziIBF22i/BGM3rYPV0nl730Y=;
	b=kFfWKDg8o7KIfneZZB19QlchUF0ZeFZwStbChYbTnd8lQh1kl8ie0ImOyMv9dQjJb7
	Z2D3vwqsibP18ziATNLk0svY7YDTHpmdq771bDPvCsMKaAH1e6iUmjmW/xd6m/dOaoXw
	zMKQpFMwV2dR9d7/wAXiazw8tTDcXIh5v4EmUyw0aqy/gYcDtMfriTXek9GOn+Q1DtUi
	sWaOV2QorzTCQ8BsONpniMjynwl3T+IiE94+FU3Xg8kI7LKAbXi9XF7qLnVf1ncFJtTJ
	l5B7z2ruQcl8B4YI7Q8cLxPzkottcJ84LHVg7K704F6rPN1+cM6ru1UUOIQs3qpU8dlQ
	S6PA==
X-Gm-Message-State: AOAM532gMXxKBckSxfUHqOKO0ePxP4k+oFvdNZBfomjZh421jaP+0HZ5
	uMTEjgRKLmBP56J7vdiYn/DgHgamGO1CugMPBwpRMw4q4gC9hv2Z1nh3InlB0hsO5RebvNVzFZ3
	b9sb0u1pRR+G+4X0SxOozEipSxKPc2AKXonBtiA==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr3472776wrv.329.1627164412499; 
	Sat, 24 Jul 2021 15:06:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw98aCqVjWxX38oeHKCaIaIHxY0Om7RKidPStZZN7z95eN6USQN5AiyYEGvql/V+hxUp7+bvK5ucN6W9nHcicg=
X-Received: by 2002:a5d:540d:: with SMTP id g13mr3472762wrv.329.1627164412331; 
	Sat, 24 Jul 2021 15:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
	<YPx28cEvrVl6YrDk@zeniv-ca.linux.org.uk>
	<CAHc6FU5nGRn1_oc-8rSOCPfkasWknH1Wb3FeeQYP29zb_5fFGQ@mail.gmail.com>
	<YPyMyPCpZKGlfAGk@zeniv-ca.linux.org.uk>
In-Reply-To: <YPyMyPCpZKGlfAGk@zeniv-ca.linux.org.uk>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sun, 25 Jul 2021 00:06:41 +0200
Message-ID: <CAHc6FU4aVL_g3LHEWng1fr8j3jJt+QVK3wAda2q6pfi+xRJcwg@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=926
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240134
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 1/8] iov_iter: Introduce
	iov_iter_fault_in_writeable helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240134
X-Proofpoint-GUID: F3HvmV5xBq5CZh_8nMZq09lPdX7ljhOH
X-Proofpoint-ORIG-GUID: F3HvmV5xBq5CZh_8nMZq09lPdX7ljhOH

On Sat, Jul 24, 2021 at 11:57 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Jul 24, 2021 at 11:38:20PM +0200, Andreas Gruenbacher wrote:
>
> > Hmm, how could we have sub-page failure areas when this is about if
> > and how pages are mapped? If we return the number of bytes that are
> > accessible, then users will know if they got nothing, something, or
> > everything, and they can act accordingly.
>
> What I'm saying is that in situation when you have cacheline-sized
> poisoned areas, there's no way to get an accurate count of readable
> area other than try and copy it out.
>
> What's more, "something" is essentially useless information - the
> pages might get unmapped right as your function returns; the caller
> still needs to deal with partial copies.  And that's a slow path
> by definition, so informing them of a partial fault-in is not
> going to be useful.
>
> As far as callers are concerned, it's "nothing suitable in the
> beginning of the area" vs. "something might be accessible".

Yes, and the third case would be "something might be accessible, but
not all of it". There probably are callers that give up when they
don't have it all.

Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
