Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2796C77B60
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1rdencxYloZpql3jsjt5EQqGI+p9+lm9vz4Sq9qjL/8=;
 b=iz1AzIdCdCYOdA+jxPLoaBB46BDgIdnKLJyecNvB2iyiBXKTmBGQ3CmBS+vKkhSfq9r1g3+vVpA6
   r0hYvFjQGICbTs+1rrtxPrgCBxLHMfZhUPXdpydHkCe5SSJ/5cvOFZIQ8VBdKFdWa1uEUejKKwN6
   KuwDcUgqb3iJmJAWFm1Jjb/rJH8QObol7OsRliE5imoMKcCx1F3N+pwvIt6rR34ghjJYwqR+9bU7
   NvRlivhgk3n41jht7SO+4Qq9JDQm/+Z4P3crUWjqNizk03mRbPtSFX5JYMpZN55vNMxHNMFmfvgt
   cAzfd8dYBBtvCo+W8jgekEjgdLkDDgtENAZ+6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1rdencxYloZpql3jsjt5EQqGI+p9+lm9vz4Sq9qjL/8=;
 b=m8VnFD3rMlRI6FzT8iWhiXbhql7vsZTitnqCrIYGNQAl38sYbzAws4jegFOqELWtdad23Vx9GujU
   x7Uo2AjtS8CxoDcamJL9sUs087NyYR9noweup6KrLDNbNOgXKWhCazSs1hz7JAN84EN5SH1E0ehL
   GDM9iJTNWvDvkDfaBV8H4BUoIVEZEPJahUZVSSGEtLEU/2q2yW++iN6m9fCUrI3JDZp9p9GwaijM
   sZcEbrydUfRVGk0S0btyFsRujQO7kad5wqo760BbAe1JuVJxg3JCYUGW3q0b8CCXjD/OPj1l9Aub
   iElLPgnA3Izp3/y39qlQYS2spT5I0Fxq/6KxNA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL003XUJ78MI00@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 15:04:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1680620643;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=JBdBtzyHFd6lc83YrQIneyeohpNPTJ/y3GLkeIJnfvo=;
 b=gkpaUlEImekGGm0xeTEjW/sQV7ex2AWGhlLK447E4ZfuKspHi6VwBheI3NIGcQxJRm
 wD2o1vYPxVT5hXvusr8G5O11sBeKOkAay9cpQIurpmU86sryhDrBYL17lkjWCguGZrtz
 emLFUqUlZcoDLML3HklU6z19yXOsrh74oN9O6QsqbhILv5Xv+kKxWgZsxgBSnsczwJuM
 pvXfOMmpwz3WbDCw2n2qfy40UD+zc3+Rv7XfNUX6kvHOvYCqMdDdgMsSH2oZqjrxyw9w
 7cdGd4UXjjkFQDmo11zUBb6SLI0ErWduKUWK2Ac5UK/VMiVEA6P1LpLiV9h0nAmzIOD0 7o8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1680620643;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to; bh=JBdBtzyHFd6lc83YrQIneyeohpNPTJ/y3GLkeIJnfvo=;
 b=YiCjwUR1Ko8Z1BBg4vORFv/RdPr0De8hzS1EHfrVI7fCsKO91Khr9Krx1z/qQXAt3H
 XCQ6+CRO57mfoU7I8z2EGfBw8Ljb3lutFee74Zr4RvdFt5Kv1vv1Bh9+1UhSw8nFKHO2
 xXDXL5LWHDPVRlb/pnQ4kHHBlrLV11DGC2KQRLTcCvYWT4O1Mic76g82qnPQCyus3u9f
 5cHS+NSDp6E72MS79c24urFJDag06GqMaKtQMKjOJ/HC+l+vhW7LT17fjxyx3IhnQwg+
 CV3EUwJAx+NZEqAeD/W06w9RvzbzW8id4Hg99htM/XN5E1vMGtg7RNGnuvnUrLhk6A6+ M/kQ==
X-Gm-Message-State: AAQBX9fI6FHAtrCvlHLZmAVVXIAKj9xnBxrTk6DGCtEgEHiDZjSpwSWH
 NuCk4xl4xIqp98VPaRmebBU=
X-Received: by 2002:a05:600c:3646:b0:3ed:9ed7:d676 with SMTP id
 y6-20020a05600c364600b003ed9ed7d676mr2446609wmq.13.1680620642903; Tue,
 04 Apr 2023 08:04:02 -0700 (PDT)
Date: Tue, 4 Apr 2023 18:03:58 +0300
To: Philip Li <philip.li@intel.com>
Message-id: <c6304335-9b5f-4082-b804-e754cf77ce0c@kili.mountain>
References: <9e1d6835-34fc-49cd-869e-d99d9b546d17@kili.mountain>
 <4154b815-3be4-53de-1bc0-ca87ecb925a4@linux.alibaba.com>
 <1e7d7076-ddd6-41b3-b824-673986c35477@kili.mountain>
 <ZCw5Ucw5CS6nXosr@rli9-mobl>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <ZCw5Ucw5CS6nXosr@rli9-mobl>
X-Source-IP: 209.85.128.54
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxscore=0 clxscore=97 malwarescore=0 priorityscore=360 phishscore=0
 spamscore=0 mlxlogscore=646 impostorscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040139 domainage_hfrom=10096
Cc: oe-kbuild@lists.linux.dev, linux-kernel@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>, lkp@intel.com
Subject: Re: [Ocfs2-devel] fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn:
 missing error code 'status'
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <error27@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350bNnmlpCILUHmdUFYCLAb/iqR3do08Nj32nLRxLYpqec4RmcscQRBFttmaJwosh4wJ7chwjog==
X-ServerName: mail-wm1-f54.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Ir_aMGZz83jCVp7gY8a9OvENKOWOiWJ-
X-Proofpoint-GUID: Ir_aMGZz83jCVp7gY8a9OvENKOWOiWJ-
Reporting-Meta:
 AAH+etZGcEVsnQFunJyW947VsIKfD55YbqumLHatvlbrQLwurn1NLNqiKZPCCGlr
 kApedruQYgyAbewdN7eJLoycQfJYXJVenqEbZYjeP4s+GL91bmNYt71ayVVFbE5h
 e/Xj3RSFkgoEEQ1WKYGFuVRfZikqKZvdmXMFJMnX3WHA0oaLyEBuXsefNENl5g2P
 vUsFZKvgXWdW4wN0cedQcUHK4j7N9vPyrWPR71Vl3y8D88bG1xFqfTi1v/s7JKk8
 ULAanRpSpLBjd47zk/NIDvpUberFIMiu6jcs/71BMWJR4n4xJq1ctpTAxWoYpOvd
 xb7qsPpT6WEBN89k4oylEPtrkxL3z/zDMklGibkOym0Gx+ib1UomfaM9vf9ZsJWL
 xYpPonCzuFX4iYKFGFzSY8+5vy2jSWMyJMm4J+oDA5u2edPhu1H5Km2r+wpoQZNm
 NG1TTsLpksiqpOXXcy67e6854OH6k1rfmrtcyisP8rypPS6G770FqMtiITJxLovs
 ScHzf9JUBd39uIx6M+cnu/sp5GYgQ4/kw07T6vG6nuj/

On Tue, Apr 04, 2023 at 10:50:57PM +0800, Philip Li wrote:
> On Mon, Apr 03, 2023 at 02:20:55PM +0300, Dan Carpenter wrote:
> > Sorry, the kbuild bot is not supposed to send duplicate warnings.  I
> > don't know why it was sent again...
> 
> Sorry about this, we should ignore this commit in the bot. Now it is configured
> to avoid the false positive report.
> 

Fantastic.  Thanks, Philip!

regards,
dan carpenter


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
